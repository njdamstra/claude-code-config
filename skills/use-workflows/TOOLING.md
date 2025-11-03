# Tooling Requirements

## Required Dependencies

### jq
**Purpose:** JSON parsing and manipulation in bash.
**Version:** 1.6+

**Installation:**
```bash
# macOS
brew install jq

# Ubuntu/Debian
apt-get install jq

# Arch
pacman -S jq
```

**Usage:**
```bash
# Extract value
name=$(echo "$json" | jq -r '.name')

# Set value
json=$(echo "$json" | jq '.phases.current = "phase_2"')
```

---

### yq
**Purpose:** YAML parsing and conversion to JSON.
**Version:** 4.0+

**Installation:**
```bash
# macOS
brew install yq

# Ubuntu/Debian
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq

# Arch
pacman -S yq
```

**Usage:**
```bash
# YAML to JSON
json=$(yq eval -o=json workflow.yaml)

# Extract YAML value
name=$(yq eval '.name' workflow.yaml)
```

---

### Node.js
**Purpose:** JavaScript execution for scripts.
**Version:** 16+

**Installation:**
```bash
# macOS
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Arch
pacman -S nodejs npm
```

**Usage:**
```bash
# Execute script with context
result=$(node -e "
  const context = ${context_json};
  ${user_script}
")
```

---

## Optional Dependencies

### mustache
**Purpose:** Advanced template rendering (with fallback).
**Version:** Any

**Installation:**
```bash
npm install -g mustache
```

**Fallback:** Simple `{{variable}}` substitution in bash if not available.

**Usage:**
```bash
# With mustache
mustache context.json template.md > output.md

# Fallback
sed "s/{{name}}/${name}/g" template.md > output.md
```

---

## Dependency Checker Script

### tools/check-deps.sh
```bash
#!/usr/bin/env bash

set -euo pipefail

EXIT_CODE=0

echo "Checking workflow engine dependencies..."

# Check jq
if command -v jq &> /dev/null; then
  JQ_VERSION=$(jq --version | cut -d'-' -f2)
  echo "✓ jq $JQ_VERSION"
else
  echo "✗ jq not found (required)"
  echo "  Install: brew install jq"
  EXIT_CODE=1
fi

# Check yq
if command -v yq &> /dev/null; then
  YQ_VERSION=$(yq --version | cut -d' ' -f3)
  echo "✓ yq $YQ_VERSION"
else
  echo "✗ yq not found (required)"
  echo "  Install: brew install yq"
  EXIT_CODE=1
fi

# Check Node.js
if command -v node &> /dev/null; then
  NODE_VERSION=$(node --version)
  echo "✓ node $NODE_VERSION"
else
  echo "✗ node not found (required)"
  echo "  Install: brew install node"
  EXIT_CODE=1
fi

# Check mustache (optional)
if command -v mustache &> /dev/null; then
  echo "✓ mustache (optional)"
else
  echo "⚠ mustache not found (optional, will use fallback)"
fi

if [ $EXIT_CODE -eq 0 ]; then
  echo ""
  echo "All required dependencies present ✓"
else
  echo ""
  echo "Missing required dependencies ✗"
fi

exit $EXIT_CODE
```

---

## Invocation Patterns

### YAML Parsing
```bash
# Load workflow YAML to JSON
workflow_json=$(yq eval -o=json workflows/new-feature.workflow.yaml)

# Extract phase array
phases=$(echo "$workflow_json" | jq -c '.phases[]')

# Get specific field
execution_mode=$(echo "$workflow_json" | jq -r '.execution_mode')
```

### JSON Manipulation
```bash
# Initialize context
context=$(jq -n \
  --arg name "user-profile" \
  --arg mode "adaptive" \
  '{
    workflow: {name: $name, execution_mode: $mode},
    phases: {current: null, completed: [], iteration_counts: {}},
    deliverables: []
  }')

# Update field
context=$(echo "$context" | jq '.phases.current = "discovery"')

# Append to array
context=$(echo "$context" | jq '.phases.completed += ["discovery"]')

# Increment counter
context=$(echo "$context" | jq '.phases.iteration_counts.discovery += 1')
```

### Template Rendering
```bash
# With mustache (preferred)
if command -v mustache &> /dev/null; then
  mustache context.json template.md > output.md
else
  # Fallback: Simple substitution
  template=$(cat template.md)

  # Replace {{variable}} patterns
  for key in $(echo "$context" | jq -r 'keys[]'); do
    value=$(echo "$context" | jq -r ".$key")
    template="${template//\{\{$key\}\}/$value}"
  done

  echo "$template" > output.md
fi
```

### Script Execution
```bash
# Prepare context JSON
context_json=$(echo "$context" | jq -c .)
phase_json=$(echo "$phase" | jq -c .)

# Execute script with helpers
result=$(node -e "
  const context = $context_json;
  const phase = $phase_json;
  const output_dir = '$output_dir';

  // Inject helper stubs
  const thinkHard = (prompt) => Promise.resolve('Mock');
  const readFile = (path) => require('fs').readFileSync(path, 'utf-8');
  const writeFile = (path, content) => require('fs').writeFileSync(path, content);

  // Execute user script
  (async function() {
    $user_script
  })().then(result => console.log(JSON.stringify(result)));
")

# Parse result
status=$(echo "$result" | jq -r '.status')
```

---

## Common Shell Utilities

### Read JSON File
```bash
context=$(cat .temp/feature/context.json)
```

### Write JSON File
```bash
echo "$context" | jq . > .temp/feature/context.json
```

### Iterate JSON Array
```bash
echo "$workflow_json" | jq -c '.phases[]' | while read -r phase; do
  phase_id=$(echo "$phase" | jq -r '.id')
  echo "Processing phase: $phase_id"
done
```

### Check File Exists
```bash
if [ -f "$file_path" ]; then
  echo "File exists"
fi
```

### Ensure Directory
```bash
mkdir -p "$output_dir/deliverables"
```

### Log with Timestamp
```bash
log_info() {
  echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] INFO: $*"
}
```

---

## Platform-Specific Notes

### macOS
- Use `brew` for all dependencies
- `date -u` format: `date -u +"%Y-%m-%dT%H:%M:%SZ"`

### Linux
- Use `apt-get` (Debian/Ubuntu) or `pacman` (Arch)
- `date -u` format same as macOS

### Windows (WSL/Git Bash)
- Use WSL2 with Ubuntu for best compatibility
- All bash scripts work unmodified

---

## Version Requirements

| Tool | Minimum | Recommended | Purpose |
|------|---------|-------------|---------|
| bash | 4.0 | 5.0+ | Shell scripting |
| jq | 1.5 | 1.6+ | JSON manipulation |
| yq | 4.0 | 4.30+ | YAML parsing |
| Node.js | 14 | 18+ | Script execution |
| mustache | any | latest | Template rendering (optional) |

---

## Verification Command

```bash
# Run dependency checker
bash tools/check-deps.sh

# Expected output:
# ✓ jq 1.6
# ✓ yq 4.30.6
# ✓ node v18.16.0
# ⚠ mustache not found (optional, will use fallback)
#
# All required dependencies present ✓
```
