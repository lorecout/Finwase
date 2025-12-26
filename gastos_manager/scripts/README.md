# Uninstall Ollama Scripts

This folder contains safe, interactive scripts to remove Ollama and its user data on macOS and Windows.

Files:

- `uninstall_ollama_mac.sh`: macOS Bash script. Prompts for confirmation and removes known Ollama paths. Run with:

```bash
chmod +x scripts/uninstall_ollama_mac.sh
./scripts/uninstall_ollama_mac.sh
```

- `uninstall_ollama_win.ps1`: PowerShell script for Windows. Run from PowerShell (preferably as Administrator):

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\uninstall_ollama_win.ps1
```

Notes:

- Both scripts are interactive and require typing `YES` to proceed.
- The macOS script will use `sudo` for removing `/Applications/Ollama.app` and `/usr/local/bin/ollama`.
- If you want to run the macOS script on a remote host via SSH, you can use:

```bash
ssh -p <port> user@host 'bash -s' < ./scripts/uninstall_ollama_mac.sh
```

- Review the paths in the scripts before running. These scripts delete files permanently.
