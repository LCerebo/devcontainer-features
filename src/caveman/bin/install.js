#!/usr/bin/env node

const fs = require("fs");
const os = require("os");
const path = require("path");
const childProcess = require("child_process");

const targetUser = process.env._REMOTE_USER || process.env.USER || "root";
const targetHome =
  process.env._REMOTE_USER_HOME || process.env.HOME || os.homedir();

process.chdir(targetHome);

const result = childProcess.spawnSync(
  "npx",
  ["-y", "github:JuliusBrussee/caveman", ...process.argv.slice(2)],
  {
    stdio: "inherit",
  },
);

if (result.error) {
  throw result.error;
}

if (process.getuid && process.getuid() === 0) {
  try {
    const uid = Number(
      childProcess
        .execFileSync("id", ["-u", targetUser], { encoding: "utf8" })
        .trim(),
    );
    const gid = Number(
      childProcess
        .execFileSync("id", ["-g", targetUser], { encoding: "utf8" })
        .trim(),
    );
    chownRecursive(path.join(targetHome, ".agents"), uid, gid);
  } catch (error) {
    console.warn(
      `Unable to update ownership for ${targetUser}: ${error.message}`,
    );
  }
}

process.exit(result.status ?? 1);

function chownRecursive(targetPath, uid, gid) {
  if (!fs.existsSync(targetPath)) {
    return;
  }

  const stat = fs.lstatSync(targetPath);
  fs.chownSync(targetPath, uid, gid);

  if (!stat.isDirectory() || stat.isSymbolicLink()) {
    return;
  }

  for (const entry of fs.readdirSync(targetPath)) {
    chownRecursive(path.join(targetPath, entry), uid, gid);
  }
}
