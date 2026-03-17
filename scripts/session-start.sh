#!/usr/bin/env bash

FRAMEWORK=""
PACKAGE_MANAGER=""

if [ -f "package.json" ]; then
    if command -v node >/dev/null 2>&1; then
        FRAMEWORK=$(node -e "
const p = require('./package.json');
const deps = { ...p.dependencies, ...p.devDependencies };
const fw = [];
if (deps['vue'] || deps['nuxt']) fw.push('Vue ' + (deps['vue'] || deps['nuxt']));
if (deps['react'] || deps['next']) fw.push('React ' + (deps['react'] || deps['next']));
if (deps['@angular/core']) fw.push('Angular ' + deps['@angular/core']);
console.log(fw.join(', ') || 'unknown');
" 2>/dev/null || echo "unknown")
    fi

    if [ -f "pnpm-lock.yaml" ]; then
        PACKAGE_MANAGER="pnpm"
    elif [ -f "yarn.lock" ]; then
        PACKAGE_MANAGER="yarn"
    elif [ -f "package-lock.json" ]; then
        PACKAGE_MANAGER="npm"
    else
        PACKAGE_MANAGER="npm"
    fi
fi

if [ -n "$FRAMEWORK" ] && [ "$FRAMEWORK" != "unknown" ]; then
    echo "[frontend-craft] Framework: ${FRAMEWORK} | Package manager: ${PACKAGE_MANAGER}"
fi

exit 0
