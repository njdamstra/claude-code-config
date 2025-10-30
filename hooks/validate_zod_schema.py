#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = []
# ///

import json
import sys
import subprocess
from pathlib import Path

def main():
    input_data = json.load(sys.stdin)

    tool_name = input_data.get('tool_name')
    tool_input = input_data.get('tool_input', {})
    file_path = tool_input.get('file_path', '')

    # Only validate Appwrite schema files
    if 'src/.appwrite/schemas' not in file_path:
        sys.exit(0)

    # Check if file exists and is TypeScript
    if not file_path.endswith('.ts'):
        sys.exit(0)

    # Run TypeScript check on the schema file
    try:
        # First check if the file has basic syntax errors
        result = subprocess.run(
            ['tsc', '--noEmit', '--skipLibCheck', file_path],
            cwd=str(Path.home() / 'socialaize'),
            capture_output=True,
            timeout=10,
            text=True
        )

        if result.returncode != 0:
            print(f"⚠️  Zod schema validation warning: {file_path}", file=sys.stderr)
            stderr_lines = result.stderr.strip().split('\n')[:10]  # Limit to 10 lines
            for line in stderr_lines:
                print(f"  {line}", file=sys.stderr)
            # Don't block, just warn

    except subprocess.TimeoutExpired:
        print(f"⚠️  Schema validation timed out: {file_path}", file=sys.stderr)
    except FileNotFoundError:
        # tsc not found, skip validation
        pass
    except Exception as e:
        print(f"⚠️  Could not validate schema: {e}", file=sys.stderr)

    sys.exit(0)

if __name__ == '__main__':
    main()
