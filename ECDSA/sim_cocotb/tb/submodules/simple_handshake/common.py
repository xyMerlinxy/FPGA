from typing import Union
from cocotb.handle import SimHandleBase, LogicObject, LogicArrayObject
from cocotb.triggers import RisingEdge, Timer


def check_signal_type(signal: SimHandleBase) -> Union[LogicObject, LogicArrayObject]:
    if not isinstance(signal, (LogicObject, LogicArrayObject)):
        raise TypeError(f"Invalid signal '{signal}' type: {type(signal)}")
    return signal


def check_signal_type_logic(signal: SimHandleBase) -> LogicObject:
    if not isinstance(signal, LogicObject):
        raise TypeError(f"Invalid signal '{signal}' type: {type(signal)}")
    return signal


def check_signal_type_array(signal: SimHandleBase) -> LogicArrayObject:
    if not isinstance(signal, LogicArrayObject):
        raise TypeError(f"Invalid signal '{signal}' type: {type(signal)}")
    return signal


async def reset_dut(
    clk: SimHandleBase, rst: SimHandleBase, period: int = 20, reset_enable: int = 0
):
    _rst = check_signal_type_logic(rst)
    _rst.value = reset_enable
    await Timer(period, "ns")
    await RisingEdge(check_signal_type_logic(clk))
    _rst.value = (reset_enable + 1) % 2
    await RisingEdge(check_signal_type_logic(clk))
