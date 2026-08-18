#!/bin/sh
set -eu

cd /app

echo "Running as user: $(whoami)"
echo ""

#? Check if we're running as root
#* Docker defaults to root permissions with created volumes
if [ "$(id -u)" = "0" ]; then
  chown -R vscode:vscode /app/node_modules
  chown vscode:vscode /home/vscode/.local /home/vscode/.local/share
  chown -R vscode:vscode /home/vscode/.local/share/pnpm

  # Re-execute this script as vscode user; gosu is container sudo "downgrade" alternative
  exec gosu vscode "$0" "$@"
fi

#? Git security thingy https://git-scm.com/docs/git-config#Documentation/git-config.txt-safedirectory
if [ -d .git ]; then
  git config --global --add safe.directory /app
fi

#? Theoretically not needed because allowBuilds in pnpm-workspace.yaml; but better be safe than sorry
if [ -d .git ]; then
  pnpm exec lefthook install
fi

#? Continue with the command 'command: tail -f /dev/null' from docker-compose.yml
exec "$@"
