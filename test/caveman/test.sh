#!/bin/bash

set -e

source dev-container-features-test-lib

target_home="${_REMOTE_USER_HOME:-${HOME}}"
expected_user="${_REMOTE_USER:-$(id -un)}"

check "node installed" command -v node
check "npx installed" command -v npx
check "caveman skill installed" test -f "${target_home}/.agents/skills/caveman/SKILL.md"
check "caveman commit skill installed" test -f "${target_home}/.agents/skills/caveman-commit/SKILL.md"
check "caveman skill content present" bash -c "grep -q 'Respond terse like smart caveman' '${target_home}/.agents/skills/caveman/SKILL.md'"
if [ "${expected_user}" != "root" ]; then
	check "skills owned by expected user" bash -c "[ \"\$(stat -c '%U' '${target_home}/.agents')\" = '${expected_user}' ]"
fi

reportResults
