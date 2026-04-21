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


def _tested_function(a, b, operation, mod):
    if operation:
        return (a - b) % mod
    else:
        return (a + b) % mod


def init_interfaces(
    dut: HierarchyObject,
) -> Tuple[HandshakeSender, HandshakeReceiver, Scoreboard]:
    sender = HandshakeSender(
        clk=dut.clk,
        valid=dut.i_i_valid,
        ready=dut.o_i_ready,
        data_a=dut.i_i_a,
        data_b=dut.i_i_b,
        operation=dut.i_i_operation,
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
async def test_simple_addition(dut: HierarchyObject):
    mod_p = int(str(check_signal_type_array(dut.MOD_P).value), 2)

    start_clk(dut.clk, 10)

    sender, receiver, scoreboard = init_interfaces(dut)

    # Reset
    await reset_dut(dut.clk, dut.rst_n, 20)

    test_data = [
        (10, 20, 0),
        (1, mod_p - 1, 0),
        (mod_p - 1, 55, 0),
        (mod_p - 1, mod_p - 1, 0),
        (0, 0, 0),
    ]

    expected = Queue()
    for a, b, operation in test_data:
        await sender.push_data(data_a=a, data_b=b, operation=operation)
        await expected.put({"data": _tested_function(a, b, operation, mod_p)})

    cocotb.start_soon(sender.start())
    cocotb.start_soon(receiver.start())

    scoreboard_task = cocotb.start_soon(
        scoreboard.check(expected_queue=expected, actual_queue=receiver.data_queue)
    )
    await scoreboard_task


@cocotb.test()
async def test_simple_subtraction(dut: HierarchyObject):
    mod_p = int(str(check_signal_type_array(dut.MOD_P).value), 2)

    start_clk(dut.clk, 10)

    sender, receiver, scoreboard = init_interfaces(dut)

    # Reset
    await reset_dut(dut.clk, dut.rst_n, 20)

    test_data = [
        (10, 20, 1),
        (1, mod_p - 1, 1),
        (mod_p - 1, 55, 1),
        (mod_p - 1, mod_p - 1, 1),
        (0, 0, 1),
    ]

    expected = Queue()
    for a, b, operation in test_data:
        await sender.push_data(data_a=a, data_b=b, operation=operation)
        await expected.put({"data": _tested_function(a, b, operation, mod_p)})

    cocotb.start_soon(sender.start())
    cocotb.start_soon(receiver.start())

    scoreboard_task = cocotb.start_soon(
        scoreboard.check(expected_queue=expected, actual_queue=receiver.data_queue)
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
    for _ in range(100):
        a = _random.randint(0, mod_p - 1)
        b = _random.randint(0, mod_p - 1)
        operation = _random.randint(0, 1)
        test_data.append([a, b, operation])

    expected = Queue()
    for a, b, operation in test_data:
        await sender.push_data(data_a=a, data_b=b, operation=operation)
        await expected.put({"data": _tested_function(a, b, operation, mod_p)})

    cocotb.start_soon(sender.start())
    cocotb.start_soon(receiver.start())

    scoreboard_task = cocotb.start_soon(
        scoreboard.check(expected_queue=expected, actual_queue=receiver.data_queue)
    )
    await scoreboard_task
