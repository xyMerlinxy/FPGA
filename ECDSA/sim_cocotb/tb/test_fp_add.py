import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, RisingEdge, Timer
from asyncio import Queue


class FpAddTestbench:
    def __init__(self, dut):
        self.dut = dut
        self.expected_results = Queue()  # FIFO queue for expected values
        self.mod_p = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFF

    async def driver_push(self, a: int, b: int):
        """Push data into the module"""
        await RisingEdge(self.dut.clk)
        self.dut.i_data_a.value = a
        self.dut.i_data_b.value = b
        self.dut.i_data_wr.value = 1

        # Calculate expected result and put it in the queue
        expected = (a + b) % self.mod_p
        self.expected_results.put_nowait(expected)

        await RisingEdge(self.dut.clk)
        self.dut.i_data_wr.value = 0
        await FallingEdge(self.dut.clk)

        # while self.dut.o_valid.value != 0:
        #     await FallingEdge(self.dut.clk)
        while self.dut.o_valid.value != 1:
            await FallingEdge(self.dut.clk)

    async def monitor(self):
        while True:
            await FallingEdge(self.dut.clk)

            if self.dut.o_valid.value == 1:
                actual = int(self.dut.o_data.value)
                expected = await self.expected_results.get()

                assert actual == expected
                self.dut._log.info("Checked")
                await FallingEdge(self.dut.clk)
                await FallingEdge(self.dut.clk)

                if self.expected_results.empty():
                    break


@cocotb.test()
async def test_pipelined_addition(dut):
    """Send values asynchronously and check them as they arrive"""

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    tb = FpAddTestbench(dut)

    # Reset
    dut.rst_n.value = 0
    await Timer(20, "ns")
    dut.rst_n.value = 1
    await FallingEdge(dut.clk)

    monitor_task = cocotb.start_soon(tb.monitor())

    await tb.driver_push(0, 0)
    await tb.driver_push(1, 0)
    await tb.driver_push(1, 1)
    await tb.driver_push(tb.mod_p - 1, 1)
    await tb.driver_push(tb.mod_p - 1, tb.mod_p - 1)
    dut._log.info("All data pushed")

    await monitor_task
