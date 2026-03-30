import subprocess
import sys
import os
from pathlib import Path
from typing import Optional, Union


CURRENT_PATH = Path(__file__).parent.resolve()
PROJECT_PATH = CURRENT_PATH / ".." / "work" / "quartus"


def run_quartus_tcl(
    tcl_script_path: Union[str, Path],
    project_path: Union[str, Path],
    quartus_sh: str = "quartus_sh",
) -> int:
    """
    Run TCL script in quartus_sh.

    Args:
        tcl_script_path: Absolute path to .tcl file
        quartus_sh: path to quartus bin catalog quartus_sh(default in PATH)

    Returns:
        Process return code
    """

    tcl_path = Path(tcl_script_path).resolve()

    if not tcl_path.exists():
        print(f"[ERROR] Cant find TCL file: {tcl_path}")
        return 1

    project_path = Path(project_path)
    project_path.mkdir(parents=True, exist_ok=True)

    print(f"[INFO] TCL Script: {tcl_path}")
    print(f"[INFO] Project catalogue: {project_path}")
    print(f"[INFO] quartus_sh  : {quartus_sh}")
    print("-" * 50)

    cmd = [quartus_sh, "-t", str(tcl_path)]

    try:
        result = subprocess.run(
            cmd,
            cwd=str(project_path),
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
    except FileNotFoundError:
        print(f"[ERROR] can't find '{quartus_sh}'.")
        print(
            "        Add Quartus to your PATH or specify the full path as the argument."
        )
        return 127

    print(result.stdout)

    if result.returncode == 0:
        print("[OK] Project correctly created.")
    else:
        print(f"[ERROR] quartus_sh ended with code: {result.returncode}")

    return result.returncode


if __name__ == "__main__":
    qs = sys.argv[1] if len(sys.argv) > 1 else "quartus_sh"

    tcl_file = CURRENT_PATH / "quartus_create_project.tcl"

    sys.exit(run_quartus_tcl(tcl_file, PROJECT_PATH, qs))
