import logging
import random
from typing import Any, Dict, Optional, Union

from cocotb.handle import SimHandleBase, LogicObject, LogicArrayObject
from cocotb.triggers import RisingEdge, ReadOnly, NextTimeStep
from cocotb.queue import Queue

from .common import check_signal_type, check_signal_type_logic


class HandshakeSender:
    """
    Universal sender for interfaces with optional handshake signals.

    Minimal usage (data only, no handshake):
        src = HandshakeSender(dut.clk, data=dut.data)

    Full interface with handshake and packetization:
        src = HandshakeSender(
            dut.clk,
            valid         = dut.i_i_valid,
            ready         = dut.o_i_ready,
            valid_prob    = 0.7,
            data_a        = dut.i_i_a,
            data_b        = dut.i_i_b,
        )

    valid_prob controls how often valid is asserted each cycle.
    1.0 means valid is always high (back-to-back transfers).
    0.5 means valid is randomly withheld ~half the cycles before being driven.
    """

    def __init__(
        self,
        clk: SimHandleBase,
        valid: Optional[SimHandleBase] = None,
        ready: Optional[SimHandleBase] = None,
        valid_prob: float = 1.0,
        seed: Any = "",
        randomize_idle: bool = False,
        name: str = "Sender",
        **data_signals: SimHandleBase,
    ) -> None:
        """
        Parameters
        ----------
        clk            : clock signal (required)
        valid          : valid output driven by the testbench (optional)
        ready          : ready input read by the testbench (optional)
        valid_prob     : probability [0.0 – 1.0] that valid is asserted on any
                         given cycle; 1.0 = always asserted (default),
                         0.0 = never asserted (deadlock, avoid in practice)
        seed           : seed for internal signal generator for valid and data signals values
        randomize_idle : if True and valid == 0 send random data on data_signals
        name           : module name in logs

        **data_signals: cocotb signal(example sop, eop, data_a, data_b)
        """
        if not (0.0 < valid_prob <= 1.0):
            raise ValueError(
                f"HandshakeSender: valid_prob must be in range (0.0, 1.0], got {valid_prob}"
            )

        self._clk = check_signal_type_logic(clk)

        self._valid = check_signal_type_logic(valid) if valid is not None else valid
        self._ready = check_signal_type_logic(ready) if ready is not None else ready
        self._valid_prob = valid_prob

        self._data_signals: dict[str, Union[LogicObject, LogicArrayObject]] = {}
        for key, signal in data_signals.items():
            self._data_signals[key] = check_signal_type(signal)

        self._randomize_idle = randomize_idle
        self.data_queue: Queue[Dict[str, Any]] = Queue()
        self._random = random.Random(seed)

        self._init_signals()

        self.log = logging.getLogger("cocotb")
        self.name = name

    @property
    def is_empty(self):
        return self.data_queue.empty()

    # ── idle state ────────────────────────────────────────────────────────────

    def _init_signals(self) -> None:
        """Drive all signals to their inactive (idle) state."""
        if self._valid is not None:
            self._valid.value = 0
        for signal in self._data_signals.values():
            signal.value = 0

    def _set_signals(self, data: Dict[str, Any]) -> None:
        """Drive all signals."""
        self.log.info(f"{self.name}: SET: {data}")
        for name, value in data.items():
            self._data_signals[name].value = value

    def _set_signals_random(self) -> None:
        """Drive all signals to random value."""
        for signal in self._data_signals.values():
            random_data = self._random.getrandbits(len(signal))
            signal.value = random_data

    ####### push data ############
    async def push_data(self, **data: Any):
        if data.keys() == self._data_signals.keys():
            await self.data_queue.put(data)
        else:
            raise ValueError(
                f"HandshakeSender: unknown data signal '{data.keys() - self._data_signals.keys()}'. "
                f"Available: {list(self._data_signals)}"
            )

    async def push_packet(self):
        raise NotImplementedError()

    async def start(self):
        self.log.info(f"{self.name}: Sender started")

        if self._valid is not None:
            while not self.data_queue.empty():
                await ReadOnly()
                # new valid value
                if self._valid.value == 0 or (
                    self._ready is not None and self._ready.value == 1
                ):
                    await NextTimeStep()
                    if self._random.random() <= self._valid_prob:
                        self._valid.value = 1
                        data = await self.data_queue.get()
                        self._set_signals(data)
                    else:
                        self._valid.value = 0
                        if self._randomize_idle:
                            self._set_signals_random()
                await RisingEdge(self._clk)

        else:
            await RisingEdge(self._clk)
            data = await self.data_queue.get()
            self._set_signals(data)

            while not self.data_queue.empty():
                await RisingEdge(self._clk)
                await ReadOnly()
                if self._ready is not None and self._ready.value == 0:
                    await NextTimeStep()
                    data = await self.data_queue.get()
                    self._set_signals(data)
        self.log.info(f"{self.name}: Sender ended")
