from cocotb.triggers import with_timeout
from typing import Any, Dict
from cocotb.queue import Queue

import logging


class Scoreboard:
    """
    Universal data integrity checker for comparing expected and actual results.

    Minimal usage (basic logging):
        sb = Scoreboard(name="ALU_Scoreboard")

    """

    def __init__(self, name: str = "Scoreboard"):
        self.log = logging.getLogger("cocotb")
        self.name = name

    async def check(
        self,
        expected_queue: Queue[Dict[str, Any]],
        actual_queue: Queue[Dict[str, Any]],
        timeout: int = 10000,
    ):
        """Main loop that continuously compares incoming data."""
        self.log.info(f"{self.name}: Scoreboard started")
        counter = 0
        while not expected_queue.empty():
            # Wait for data to be available in both queues
            expected = await expected_queue.get()
            actual = await with_timeout(actual_queue.get(), timeout, "ns")

            assert actual.keys() == expected.keys(), (
                f"Key mismatch Expected: {expected.keys()} Actual: {actual.keys()}"
            )

            for key in actual.keys():
                assert actual[key] == expected[key], (
                    f"MISMATCH #{counter}!  Expected: {hex(expected[key])}  Actual:   {hex(actual[key])}"
                )
            self.log.info(f"{self.name}: Match #{counter} OK")
            counter += 1
