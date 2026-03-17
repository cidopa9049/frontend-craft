#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat || true)"

FILE_PATH=""
if command -v python3 >/dev/null 2>&1; then
    FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    fp = d.get('tool_input', {}).get('file_path', '') or d.get('tool_input', {}).get('filePath', '')
    print(fp)
except:
    print('')
" 2>/dev/null || echo "")
elif command -v python >/dev/null 2>&1; then
    FILE_PATH=$(echo "$INPUT" | python -c "
import sys, json
try:
    d = json.load(sys.stdin)
    fp = d.get('tool_input', {}).get('file_path', '') or d.get('tool_input', {}).get('filePath', '')
    print(fp)
except:
    print('')
" 2>/dev/null || echo "")
elif command -v node >/dev/null 2>&1; then
    FILE_PATH=$(echo "$INPUT" | node -e "
let buf = '';
process.stdin.on('data', c => buf += c);
process.stdin.on('end', () => {
    try {
        const d = JSON.parse(buf);
        console.log(d.tool_input?.file_path || d.tool_input?.filePath || '');
    } catch { console.log(''); }
});
" 2>/dev/null || echo "")
fi

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

case "$FILE_PATH" in
    *.js|*.jsx|*.ts|*.tsx|*.vue|*.css|*.scss|*.less|*.json|*.md|*.html)
        if command -v npx >/dev/null 2>&1; then
            npx prettier --write "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
esac

exit 0
