#!/bin/sh
set -e

# Re-apply git/dolt config on every start so env var changes take effect
# even when the home volume already exists from a previous run.
if [ -n "$GIT_USER" ] && [ -n "$GIT_EMAIL" ]; then
    git config --global user.name "$GIT_USER"
    git config --global user.email "$GIT_EMAIL"
    git config --global credential.helper store
    dolt config --global --add user.name "$GIT_USER"
    dolt config --global --add user.email "$GIT_EMAIL"
fi

# Ensure tmux mouse mode is enabled globally so Gas Town sessions
# inherit mouse scrolling (EnableMouseMode respects this setting).
if ! grep -q 'set -g mouse on' "$HOME/.tmux.conf" 2>/dev/null; then
    echo 'set -g mouse on' >> "$HOME/.tmux.conf"
fi

# Dolt data must live on the container-local ext3 volume (agent-home),
# NOT the VirtioFS host mount (/gt). VirtioFS has mmap coherency issues
# that corrupt Dolt journal files under write load.
if [ -d /gt/.dolt-data ] && [ ! -L /gt/.dolt-data ]; then
    echo "Relocating .dolt-data from VirtioFS to container-local storage..."
    if [ -d /home/agent/.dolt-data ]; then
        # Merge: copy any databases not already on local storage
        for db in /gt/.dolt-data/*/; do
            dbname=$(basename "$db")
            if [ ! -d "/home/agent/.dolt-data/$dbname" ]; then
                cp -a "$db" "/home/agent/.dolt-data/$dbname"
            fi
        done
        # Preserve config
        for f in config.yaml dolt.pid; do
            [ -f "/gt/.dolt-data/$f" ] && cp "/gt/.dolt-data/$f" "/home/agent/.dolt-data/$f" 2>/dev/null || true
        done
    else
        cp -a /gt/.dolt-data /home/agent/.dolt-data
    fi
    mv /gt/.dolt-data /gt/.dolt-data.bak-virtiofs
    ln -s /home/agent/.dolt-data /gt/.dolt-data
    echo "Done. .dolt-data now on ext3 via symlink."
elif [ ! -e /gt/.dolt-data ] && [ -d /home/agent/.dolt-data ]; then
    ln -s /home/agent/.dolt-data /gt/.dolt-data
fi

if [ ! -f /gt/mayor/town.json ]; then
    echo "Initializing Gas Town workspace at /gt..."
    /app/gastown/gt install /gt --git
else
    echo "Refreshing Gas Town workspace at /gt..."
    /app/gastown/gt install /gt --git --force
fi

exec "$@"
