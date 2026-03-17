#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "package.json" ]; then
    exit 0
fi

RUNNER="npm"
if command -v pnpm >/dev/null 2>&1; then
    RUNNER="pnpm"
fi

run_if_exists() {
    local script_name="$1"
    local check_cmd="import sys,json; p=json.load(open('package.json')); sys.exit(0 if p.get('scripts',{}).get('${script_name}') else 1)"

    if command -v python3 >/dev/null 2>&1; then
        python3 -c "$check_cmd" 2>/dev/null || return 1
    elif command -v python >/dev/null 2>&1; then
        python -c "$check_cmd" 2>/dev/null || return 1
    elif command -v node >/dev/null 2>&1; then
        node -e "const p=require('./package.json'); process.exit((p.scripts && p.scripts['${script_name}']) ? 0 : 1)" 2>/dev/null || return 1
    else
        return 1
    fi

    $RUNNER run "${script_name}" 2>&1 || true
    return 0
}

run_if_exists lint || true
run_if_exists type-check || run_if_exists typecheck || true
run_if_exists test || true
run_if_exists build || true

exit 0
