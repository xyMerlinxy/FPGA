import subprocess
import sys
import os
import re
from pathlib import Path
from dataclasses import dataclass
from typing import Optional


# ─────────────────────────────────────────────
# CONFIGURATION
# ─────────────────────────────────────────────
CURRENT_PATH = Path(__file__).parent.resolve()
PROJECT_PATH = (CURRENT_PATH / "..").resolve()

UVM_HOME = os.environ.get("UVM_HOME", "")
RTL_DIR = PROJECT_PATH / "rtl"
TB_DIR = PROJECT_PATH / "sim_uvm"
TOP_DIR = TB_DIR / "top"
OUTPUT_DIR = (PROJECT_PATH / "work" / "uvm").resolve()


# ─────────────────────────────────────────────
# DATA STRUCTURES
# ─────────────────────────────────────────────
@dataclass
class TestSuite:
    """Groups a top-level module with its associated UVM tests."""

    top_file: str  # e.g. adder_tb_top
    tests: list[str]  # e.g. ["base_test", "rand_test"]


# ─────────────────────────────────────────────
# DISCOVERY
# ─────────────────────────────────────────────
def find_test_suites() -> list[TestSuite]:
    """
    Discover all test suites by pairing each subdirectory in tests/
    with a top-level file whose name starts with the same prefix.

    Convention:
        tests/adder/  ->  top/adder_tb_top.sv
        tests/uart/   ->  top/uart_tb_top.sv
    """
    tests_dir = TB_DIR / "tests"
    top_dir = TB_DIR / "top"

    suites: list[TestSuite] = []

    for module_dir in sorted(tests_dir.iterdir()):
        if not module_dir.is_dir():
            continue

        prefix = module_dir.name  # e.g. "adder"

        top_file = top_dir / f"tb_{prefix}.sv"
        # check top file exists
        if not top_file.exists():
            raise FileNotFoundError(f"Top file for tests {prefix} does not exists")

        # collect tests: all *.sv in the module dir, excluding *_pkg.sv
        tests = sorted(f.stem for f in module_dir.rglob("*.sv") if "_pkg" not in f.name)

        if not tests:
            print(f"[WARN] No tests found in '{module_dir}' — skipping")
            continue

        suites.append(
            TestSuite(
                top_file=top_file.stem,
                tests=tests,
            )
        )

    return suites


# ─────────────────────────────────────────────
# HELPERS
# ─────────────────────────────────────────────
def find_files(base: Path, pattern: str) -> list[Path]:
    """Recursively find all files matching the given glob pattern under base."""
    return sorted(base.rglob(pattern))


def find_packages() -> list[Path]:
    """
    Detect all SystemVerilog packages (*_pkg.sv) and sort them
    by compilation dependency order: agent -> sequence -> env -> test.
    Any package not matching a known hint is appended at the end.
    """
    order_hints = ["common", "agent", "seq", "env", "test"]
    all_pkgs = find_files(TB_DIR, "*_pkg.sv")

    def sort_key(p: Path) -> int:
        name = p.stem.lower()
        for i, hint in enumerate(order_hints):
            if hint in name:
                return i
        return len(order_hints)

    return sorted(all_pkgs, key=sort_key)


def find_interfaces() -> list[Path]:
    """Recursively find all SystemVerilog interface files (*_if.sv) under base."""
    return sorted(TB_DIR.rglob("*_if.sv"))


def find_rtl(path: Path = RTL_DIR) -> list[Path]:
    """
    Recursively find all RTL source files under base.
    Supported extensions: .v (Verilog), .sv (SystemVerilog), .vhd (VHDL).
    """
    files = []
    for ext in ("*.v", "*.sv", "*.vhd"):
        files.extend(sorted(path.rglob(ext)))
    return files


def find_incdirs(files: list[Path]) -> list[Path]:
    """
    Collect unique parent directories from the given file list.
    Used to build +incdir+ flags for the compiler.
    """
    seen = set()
    dirs = []
    for f in files:
        d = f.parent.resolve()
        if d not in seen:
            seen.add(d)
            dirs.append(d)
    return dirs


def run(cmd: list[str], step: str) -> int:
    """
    Execute a shell command and print its output.
    Returns the exit code (does NOT exit the script — callers decide).
    """
    print(f"\n{'=' * 60}")
    print(f"  {step}")
    print(f"{'=' * 60}")
    print("CMD:", " ".join(str(c) for c in cmd))
    print()

    result = subprocess.run(cmd, cwd=OUTPUT_DIR, text=True, capture_output=True)

    print(result.stdout)
    if result.stderr:
        print("STDERR:", result.stderr)

    if result.returncode != 0:
        print(f"\n[ERROR] Process '{step}' crashed with exit code {result.returncode}")
        return result.returncode

    if "vsim" in cmd:
        uvm_errors = re.findall(r"UVM_ERROR\s*:\s*([1-9]\d*)", result.stdout)
        uvm_fatals = re.findall(r"UVM_FATAL\s*:\s*([1-9]\d*)", result.stdout)

        if uvm_errors or uvm_fatals:
            print(f"\n[FAIL] UVM Errors/Fatals detected in logs for '{step}'!")
            return 1

    print(f"[OK] {step}")
    return 0


# ─────────────────────────────────────────────
# COMPILATION
# ─────────────────────────────────────────────
def compile_project() -> None:
    """
    Compile the UVM project using vlog.

    Steps:
      1. Auto-detect RTL files, SV interfaces, SV packages, and the testbench top.
      2. Build +incdir+ flags from UVM_HOME and all detected source directories.
      3. Invoke vlog with the assembled flags and file list.

    Compilation order: RTL -> interfaces -> packages (sorted) -> tb_top.
    """
    if not UVM_HOME:
        print("[WARN] UVM_HOME environment variable is not set!")

    # --- auto-detect source files ---
    rtl_files = find_rtl()
    interfaces = find_interfaces()
    packages = find_packages()
    rtl_top = find_rtl(TOP_DIR)

    # final file list respects compilation order
    all_sv = interfaces + packages
    all_files = rtl_files + all_sv + rtl_top

    # --- build include directories ---
    inc_dirs: list[Path] = []
    if UVM_HOME:
        inc_dirs.append(Path(UVM_HOME) / "src")
    inc_dirs += find_incdirs(all_sv)

    # --- print summary of detected files ---
    print("\n[INFO] Detected RTL files:")
    for f in rtl_files:
        print(f"         {f}")

    print("\n[INFO] Detected top files:")
    for f in rtl_top:
        print(f"         {f}")

    print("\n[INFO] Detected interfaces:")
    for f in interfaces:
        print(f"         {f}")

    print("\n[INFO] Detected packages (compilation order):")
    for f in packages:
        print(f"         {f}")

    print("\n[INFO] Include directories:")
    for d in inc_dirs:
        print(f"         {d}")

    # --- assemble and run vlog command ---
    cmd = ["vlog"]
    for d in inc_dirs:
        cmd += [f"+incdir+{d}"]
    for f in all_files:
        cmd.append(str(f))

    rc = run(cmd, "COMPILATION (vlog)")
    if rc != 0:
        sys.exit(rc)


# ─────────────────────────────────────────────
# SIMULATION
# ─────────────────────────────────────────────
def simulate_all(test: Optional[str], stop_on_failure: bool = False, gui=False) -> None:
    """
    Run vsim in batch mode for every test in the provided list.
    Prints a summary table when all tests are done.

    Args:
        test:             Name of UVM test class names to run.
        stop_on_failure:  If True, abort immediately after the first failed test.
    """

    suites = find_test_suites()
    results: dict[str, str] = {}  # test_name -> "PASS" | "FAIL"

    for suit in suites:
        for test_name in suit.tests:
            # skip dont match test if test name provided
            if test is not None and test not in test_name:
                continue

            do_command = "add wave -r /*; run -all" if gui else "run -all; quit"

            cmd = [
                "vsim",
                "-voptargs=+acc" if gui else "-c",
                "-do",
                do_command,
                suit.top_file,
                f"+UVM_TESTNAME={test_name}",
            ]

            rc = run(cmd, f"SIMULATION — test: {test_name}")
            results[test_name] = "PASS" if rc == 0 else "FAIL"

            if rc != 0 and stop_on_failure:
                print(f"\n[ABORT] Stopping after first failure: {test_name}")
                break

    # --- print results summary ---
    print(f"\n{'=' * 60}")
    print("  RESULTS SUMMARY")
    print(f"{'=' * 60}")

    passed = sum(1 for r in results.values() if r == "PASS")
    failed = sum(1 for r in results.values() if r == "FAIL")

    for name, status in results.items():
        icon = "✓" if status == "PASS" else "✗"
        print(f"  {icon}  {status}  {name}")

    print(f"\n  Total: {len(results)}  |  Passed: {passed}  |  Failed: {failed}")
    print(f"{'=' * 60}\n")

    if failed > 0 and not gui:
        sys.exit(1)


# ─────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────
if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Automatic UVM build and simulation runner — runs ALL detected tests",
        formatter_class=argparse.RawTextHelpFormatter,
    )
    parser.add_argument(
        "--test",
        "-t",
        default=None,
        help=(
            "Run a specific test by name instead of all detected tests.\n"
            "Example: --test my_custom_test"
        ),
    )
    parser.add_argument(
        "--compile-only",
        "-c",
        action="store_true",
        help="Run compilation step only, skip simulation",
    )
    parser.add_argument(
        "--sim-only",
        "-s",
        action="store_true",
        help="Run simulation only (assumes project is already compiled)",
    )
    parser.add_argument(
        "--stop-on-failure",
        action="store_true",
        help="Abort the run after the first failing test",
    )
    parser.add_argument(
        "--gui",
        "-g",
        action="store_true",
        help="Run vsim in graphical mode (interactive)",
    )

    args = parser.parse_args()

    # create output dir
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # --- dispatch to the appropriate flow ---
    if args.compile_only:
        compile_project()
    elif args.sim_only:
        simulate_all(args.test, stop_on_failure=args.stop_on_failure, gui=args.gui)
    else:
        # default: full flow — compile then simulate all tests
        compile_project()
        simulate_all(args.test, stop_on_failure=args.stop_on_failure, gui=args.gui)
