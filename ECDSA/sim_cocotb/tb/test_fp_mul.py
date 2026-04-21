from typing import Tuple
import random

import cocotb
from cocotb.handle import HierarchyObject
from cocotb.queue import Queue

from submodules.simple_handshake import (
    Scoreboard,
    HandshakeSender,
    HandshakeReceiver,
    check_signal_type_array,
    reset_dut,
    start_clk,
)


def _tested_function(a, b, mod):
    return (a * b) % mod


def init_interfaces(
    dut: HierarchyObject,
) -> Tuple[HandshakeSender, HandshakeReceiver, Scoreboard]:
    sender = HandshakeSender(
        clk=dut.clk,
        valid=dut.i_i_valid,
        ready=dut.o_i_ready,
        data_a=dut.i_i_a,
        data_b=dut.i_i_b,
    )
    receiver = HandshakeReceiver(
        clk=dut.clk,
        valid=dut.o_o_valid,
        ready=dut.i_o_ready,
        data=dut.o_o_data,
    )
    scoreboard = Scoreboard()

    return sender, receiver, scoreboard


# --- TESTS ---


@cocotb.test()
async def test_simple_multiplication(dut: HierarchyObject):
    mod_p = int(str(check_signal_type_array(dut.MOD_P).value), 2)

    start_clk(dut.clk, 10)

    sender, receiver, scoreboard = init_interfaces(dut)

    # Reset
    await reset_dut(dut.clk, dut.rst_n, 20)

    test_data = [
        (10, 20),
        (1, mod_p - 1),
        (mod_p - 1, 55),
        (mod_p - 1, mod_p - 1),
        (0, 0),
    ]

    expected = Queue()
    for a, b in test_data:
        await sender.push_data(data_a=a, data_b=b)
        await expected.put({"data": _tested_function(a, b, mod_p)})

    cocotb.start_soon(sender.start())
    cocotb.start_soon(receiver.start())

    scoreboard_task = cocotb.start_soon(
        scoreboard.check(
            expected_queue=expected, actual_queue=receiver.data_queue, timeout=10**5
        )
    )
    await scoreboard_task


@cocotb.test()
async def test_random_data(dut):

    _random = random.Random(42)

    mod_p = int(str(check_signal_type_array(dut.MOD_P).value), 2)

    start_clk(dut.clk, 10)

    sender, receiver, scoreboard = init_interfaces(dut)

    # Reset
    await reset_dut(dut.clk, dut.rst_n, 20)

    test_data = []
    for _ in range(10):
        a = _random.randint(0, mod_p - 1)
        b = _random.randint(0, mod_p - 1)
        test_data.append([a, b])

    expected = Queue()
    for a, b in test_data:
        await sender.push_data(data_a=a, data_b=b)
        await expected.put({"data": _tested_function(a, b, mod_p)})

    cocotb.start_soon(sender.start())
    cocotb.start_soon(receiver.start())

    scoreboard_task = cocotb.start_soon(
        scoreboard.check(
            expected_queue=expected, actual_queue=receiver.data_queue, timeout=10**5
        )
    )
    await scoreboard_task
