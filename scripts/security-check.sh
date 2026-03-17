#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat || true)"

COMMAND=""
if command -v python3 >/dev/null 2>&1; then
    COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")
elif command -v python >/dev/null 2>&1; then
    COMMAND=$(echo "$INPUT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")
elif command -v node >/dev/null 2>&1; then
    COMMAND=$(echo "$INPUT" | node -e "let b='';process.stdin.on('data',c=>b+=c);process.stdin.on('end',()=>{try{console.log(JSON.parse(b).tool_input?.command||'')}catch{console.log('')}});" 2>/dev/null || echo "")
fi

if [ -z "$COMMAND" ]; then
    exit 0
fi

DANGEROUS_PATTERNS=(
    "rm -rf /"
    "rm -rf /\*"
    "git push .*--force"
    "mkfs"
    "dd if="
    "shutdown"
    "reboot"
    'curl .* \| *sh'
    'wget .* \| *sh'
    "DROP TABLE"
    "DROP DATABASE"
    "format c:"
    "> /dev/sda"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern" 2>/dev/null; then
        echo "Blocked potentially dangerous command by frontend-craft: matched pattern '$pattern'" >&2
        exit 2
    fi
done

exit 0
