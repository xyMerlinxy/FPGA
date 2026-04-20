import logging
from typing import Any, Dict, Optional, Union
import cocotb
from cocotb.handle import SimHandleBase, LogicObject, LogicArrayObject
from cocotb.triggers import RisingEdge, ReadOnly
import random
from cocotb.queue import Queue

from .common import check_signal_type, check_signal_type_logic


class HandshakeReceiver:
    """
    Universal receiver for interfaces with optional handshake signals.

    Minimal usage (data only, no handshake):
        src = HandshakeReceiver(dut.clk, data=dut.data)

    Full interface with handshake and packetization:
        src = HandshakeSender(
            dut.clk,
            valid         = dut.i_i_valid,
            ready         = dut.o_i_ready,
            ready_prob    = 0.7,
            seed           : seed for internal signal generator for ready signal
            data_a        = dut.i_i_a,
            data_b        = dut.i_i_b,
        )

    ready_prob controls how often ready is asserted each cycle.
    1.0 means ready is always high (back-to-back transfers).
    0.5 means ready is randomly withheld ~half the cycles before being driven.
    """

    def __init__(
        self,
        clk: SimHandleBase,
        valid: Optional[SimHandleBase] = None,
        ready: Optional[SimHandleBase] = None,
        ready_prob: float = 1.0,
        seed: Any = "",
        name: str = "Receiver",
        **data_signals: SimHandleBase,
    ) -> None:
        """
        Parameters
        ----------
        clk           : clock signal (required)
        valid         : valid input read by the testbench (optional)
        ready         : ready output driven by the testbench (optional)
        ready_prob     : probability [0.0 – 1.0] that ready is asserted on any
                        given cycle; 1.0 = always asserted (default),
                        0.0 = never asserted (deadlock, avoid in practice)
        seed           : seed for internal signal generator for valid and data signals values
        name           : module name in logs

        **data_signals: cocotb signal(example sop, epo, data_a, data_b)
        """
        if not (0.0 < ready_prob <= 1.0):
            raise ValueError(
                f"HandshakeSender: ready_prob must be in range (0.0, 1.0], got {ready_prob}"
            )

        self._clk = check_signal_type_logic(clk)
        self._valid = check_signal_type_logic(valid) if valid is not None else valid
        self._ready = check_signal_type_logic(ready) if ready is not None else ready
        self._ready_prob = ready_prob

        self._data_signals: dict[str, Union[LogicObject, LogicArrayObject]] = {}
        for key, signal in data_signals.items():
            self._data_signals[key] = check_signal_type(signal)

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
        if self._ready is not None:
            self._ready.value = 0

    def _read_signals(self) -> Dict[str, Any]:
        """Read all signals."""
        data = {}
        for name, signal in self._data_signals.items():
            data[name] = int(str(signal.value), 2)
        self.log.info(f"{self.name}: SET: {data}")

        return data

    async def ready_coroutine(self):
        if self._ready is not None:
            while True:
                if self._random.random() <= self._ready_prob:
                    await RisingEdge(self._clk)
                    self._ready.value = 1
                else:
                    await RisingEdge(self._clk)
                    self._ready.value = 0

    async def read_coroutine(self):
        while True:
            await RisingEdge(self._clk)
            await ReadOnly()
            # without ready
            if self._ready is None:
                if self._valid is None or self._valid == 1:
                    await self.data_queue.put(self._read_signals())
                continue

            if self._ready.value == 1:
                if self._valid is None or self._valid.value == 1:
                    await self.data_queue.put(self._read_signals())

    async def start(self):
        self.log.info(f"{self.name}: Receiver started")
        cocotb.start_soon(self.ready_coroutine())
        cocotb.start_soon(self.read_coroutine())
