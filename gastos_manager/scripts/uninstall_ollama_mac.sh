#!/usr/bin/env bash
set -euo pipefail

# Safe uninstall script for Ollama on macOS
# Prompts for confirmation and removes only the known Ollama paths.

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only. Exiting."
  exit 1
fi

FILES=(
  "/Applications/Ollama.app"
  "/usr/local/bin/ollama"
  "$HOME/Library/Application Support/Ollama"
  "$HOME/Library/Saved Application State/com.electron.ollama.savedState"
  "$HOME/Library/Caches/com.electron.ollama"
  "$HOME/Library/Caches/ollama"
  "$HOME/Library/WebKit/com.electron.ollama"
  "$HOME/.ollama"
)

echo "The following paths will be removed (if they exist):"
for f in "${FILES[@]}"; do
  echo " - $f"
done

read -p "Type EXACTLY YES to continue and permanently delete these paths: " ans
if [[ "$ans" != "YES" ]]; then
  echo "Aborting. No changes made."
  exit 0
fi

if [[ -d "/Applications/Ollama.app" ]]; then
  echo "Removing /Applications/Ollama.app (requires sudo)..."
  sudo rm -rf "/Applications/Ollama.app"
fi

if [[ -f "/usr/local/bin/ollama" ]]; then
  echo "Removing /usr/local/bin/ollama (may require sudo)..."
  sudo rm -f "/usr/local/bin/ollama"
fi

for p in "${FILES[@]}"; do
  if [[ -e "$p" ]]; then
    echo "Removing $p"
    rm -rf "$p"
  else
    echo "Not found: $p"
  fi
done

echo "Uninstall complete. You may want to restart your terminal and verify 'ollama' is gone." 
