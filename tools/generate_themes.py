#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

COLORS = ROOT / "design" / "tokens" / "colors.json"
OUT_DWL = ROOT / "generated" / "dwl" / "design_tokens.h"


def main() -> None:
    tokens = json.loads(COLORS.read_text())

    lines = [
        "/* Auto-generated from design/tokens/colors.json */",
        "/* Do not edit by hand. */",
        "",
        "#ifndef DESIGN_TOKENS_H",
        "#define DESIGN_TOKENS_H",
        "",
    ]

    for name, value in tokens.items():
        lines.append(f"#define {name:<20} {value}")

    lines += [
        "",
        "#endif /* DESIGN_TOKENS_H */",
        "",
    ]

    OUT_DWL.parent.mkdir(parents=True, exist_ok=True)
    OUT_DWL.write_text("\n".join(lines))

    print(f"generated {OUT_DWL}")


if __name__ == "__main__":
    main()
