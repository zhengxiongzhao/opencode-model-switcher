# Installation Guide

This guide provides detailed installation instructions for OpenCode Model Switcher.

## Prerequisites

Before installing, ensure you have:

- **bash** version 4.0 or higher
- **python3** for JSON parsing
- **curl** for downloading the script

### Check Prerequisites

```bash
# Check bash version
bash --version

# Check python3
python3 --version

# Check curl
curl --version
```

## Installation Methods

### Method 1: One-Click Installation (Recommended)

The fastest way to install OpenCode Model Switcher:

```bash
curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/master/scripts/install.sh | bash
```

#### What This Does:

1. Checks your system for required dependencies (bash, python3, curl)
2. Downloads the main script to `~/.config/opencode/bin/`
3. Makes the script executable
4. Creates a symlink in `~/.local/bin/opencode-model`
5. Verifies the installation works
6. Checks if `~/.local/bin` is in your PATH

#### After Installation:

If `~/.local/bin` is not in your PATH, you'll see instructions to add it:

**For bash**:
```bash
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
source ~/.bashrc
```

**For zsh**:
```bash
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Method 2: Manual Installation

If you prefer manual installation or need to install offline:

1. **Clone or download the repository**:

   ```bash
   git clone https://github.com/zhengxiongzhao/opencode-model-switcher.git
   cd opencode-model-switcher
   ```

   Or download as ZIP and extract.

2. **Make the script executable**:

   ```bash
   chmod +x bin/opencode-switch-model.sh
   ```

3. **Create a symlink for easy access**:

   ```bash
   mkdir -p ~/.local/bin
   ln -s $(pwd)/bin/opencode-switch-model.sh ~/.local/bin/opencode-model
   ```

4. **Add to PATH** (if not already):

   ```bash
   echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

### Method 3: Development Installation

For contributing or development:

1. **Clone repository**:
   ```bash
   git clone https://github.com/zhengxiongzhao/opencode-model-switcher.git
   cd opencode-model-switcher
   ```

2. **Create development symlink**:
   ```bash
   ln -s $(pwd)/bin/opencode-switch-model.sh ~/.local/bin/opencode-model-dev
   ```

3. **Use development version**:
   ```bash
   opencode-model-dev --help
   ```

## Verifying Installation

After installation, verify it works:

```bash
# Check if command is available
which opencode-model

# Should output: /home/user/.local/bin/opencode-model

# Test help command
opencode-model --help

# List models
opencode-model --list
```

## Uninstallation

### One-Click Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/master/scripts/install.sh | bash -s --uninstall
```

### Manual Uninstallation

```bash
# Remove symlink
rm -f ~/.local/bin/opencode-model

# Remove script
rm -f ~/.config/opencode/bin/opencode-switch-model.sh

# Remove empty directory (if empty)
rmdir ~/.config/opencode/bin 2>/dev/null || true
```

**Note**: Your opencode configuration files (`~/.config/opencode/`, `~/.local/state/opencode/`) are not removed. These contain your settings and should be kept.

## Updating

### Update to Latest Version

```bash
curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/master/scripts/install.sh | bash -s --update
```

Or manually re-run the installation command:
```bash
curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/master/scripts/install.sh | bash
```

## Troubleshooting

### Command Not Found

**Problem**: `opencode-model: command not found`

**Solution**: Add `~/.local/bin` to your PATH:

```bash
# For bash
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.zshrc
source ~/.zshrc
```

Verify PATH:
```bash
echo $PATH | grep ~/.local/bin
```

### Permission Denied

**Problem**: `Permission denied` when running script

**Solution**: Make scripts executable:

```bash
chmod +x ~/.config/opencode/bin/opencode-switch-model.sh
chmod +x ~/.local/bin/opencode-model
```

### Python3 Not Found

**Problem**: `python3: command not found`

**Solution**: Install python3:

**Ubuntu/Debian**:
```bash
sudo apt-get update
sudo apt-get install python3
```

**macOS**:
```bash
brew install python3
```

**Fedora**:
```bash
sudo dnf install python3
```

### Installation Fails

**Problem**: Installation script fails with errors

**Solution**:

1. Check internet connection
2. Verify repository URL is correct
3. Download script manually and review:
    ```bash
    curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/master/scripts/install.sh -o install.sh
    cat install.sh  # Review the script
    bash install.sh
    rm install.sh
    ```

4. Report issue at: https://github.com/zhengxiongzhao/opencode-model-switcher/issues

## Installation Directory Structure

After installation, your files will be organized as:

```
~/.config/opencode/bin/
└── opencode-switch-model.sh          # Main script

~/.local/bin/
└── opencode-model                     # Symlink to script
```

Configuration files (managed by opencode, not this tool):

```
~/.config/opencode/
├── opencode.json                    # OpenCode main config
├── oh-my-opencode.json              # oh-my-opencode agents config
└── *.backup                        # Auto-generated backups

~/.local/state/opencode/
└── model.json                      # Favorite models
```

## Advanced Configuration

### Custom Installation Location

To install to a custom location, use environment variables:

```bash
INSTALL_DIR=/custom/path/bin SYMLINK_DIR=/custom/path/bin curl -fsSL <url> | bash
```

### Install Specific Version

To install a specific version:

```bash
VERSION=v1.0.0 curl -fsSL <url> | bash
```

### Use Different Repository

To install from a fork:

```bash
REPO=zhengxiongzhao/repo curl -fsSL <url> | bash
```

## Security Best Practices

1. **Review Before Installing**:
   ```bash
   curl -fsSL <url> -o install.sh
   cat install.sh  # Review the script
   bash install.sh
   rm install.sh
   ```

2. **Verify Checksum** (if available):
   ```bash
   # Download script and checksum
   curl -fsSL <script-url> -o script.sh
   curl -fsSL <checksum-url> -o script.sha256

   # Verify
   sha256sum -c script.sha256
   ```

3. **Use HTTPS Only**: Always use `https://` URLs

4. **Keep Updated**: Install updates when available

## Next Steps

After successful installation:

1. Read [USAGE.md](USAGE.md) for detailed usage instructions
2. Run `opencode-model --list` to see available models
3. Run `opencode-model` to launch interactive mode

## Support

- 📖 [Documentation](../README.md)
- 🐛 [Report Issues](https://github.com/zhengxiongzhao/opencode-model-switcher/issues)
- 💬 [Discussions](https://github.com/zhengxiongzhao/opencode-model-switcher/discussions)
