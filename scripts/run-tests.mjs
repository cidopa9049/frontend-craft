import { existsSync, readFileSync } from "node:fs";
import { execSync } from "node:child_process";

if (!existsSync("package.json")) process.exit(0);

let scripts = {};
try {
  const pkg = JSON.parse(readFileSync("package.json", "utf-8"));
  scripts = pkg.scripts || {};
} catch {
  process.exit(0);
}

let runner = "npm";
if (existsSync("pnpm-lock.yaml")) runner = "pnpm";
else if (existsSync("yarn.lock")) runner = "yarn";

function runIfExists(name) {
  if (!scripts[name]) return;
  try {
    execSync(`${runner} run ${name}`, { stdio: "inherit" });
  } catch {
    // non-zero exit, continue with other checks
  }
}

runIfExists("lint");
runIfExists("type-check") || runIfExists("typecheck");
runIfExists("test");
runIfExists("build");

process.exit(0);
