# OpenCode Model Switcher

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/v/release/zhengxiongzhao/opencode-model-switcher)](https://github.com/zhengxiongzhao/opencode-model-switcher/releases)
[![ShellCheck](https://github.com/zhengxiongzhao/opencode-model-switcher/actions/workflows/ci.yml/badge.svg)](https://github.com/zhengxiongzhao/opencode-model-switcher/actions/workflows/ci.yml)

A powerful command-line utility for quickly switching between different AI language models for [OpenCode](https://opencode.ai) and [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode).

## Features

- 🚀 **Quick Model Switching**: Switch models for opencode and all oh-my-opencode agents in seconds
- 🎯 **Interactive Mode**: User-friendly menu system with color-coded output
- 🏷️ **Free Model Tagging**: Visual [FREE] indicators for free-to-use models
- 🔄 **Dynamic Model Loading**: Integrates with your favorite models from opencode
- 🛡️ **Safe Operations**: Automatic backup before any configuration changes
- 📝 **Command-Line Interface**: Perfect for automation and scripting
- 🌐 **Multi-Agent Support**: Configure individual agents or switch all at once

## Installation

### One-Click Installation (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/main/scripts/install.sh | bash
```

After installation, you can use the `opencode-model` command directly.

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/zhengxiongzhao/opencode-model-switcher.git
   cd opencode-model-switcher
   ```

2. Make the script executable:
   ```bash
   chmod +x bin/opencode-switch-model.sh
   ```

3. Create a symlink for easy access:
   ```bash
   ln -s $(pwd)/bin/opencode-switch-model.sh ~/.local/bin/opencode-model
   ```

4. Ensure `~/.local/bin` is in your PATH:
   ```bash
   export PATH="$PATH:$HOME/.local/bin"
   ```

### Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/main/scripts/uninstall.sh | bash
```

Or manually:
```bash
rm -f ~/.local/bin/opencode-model
rm -f ~/.config/opencode/bin/opencode-switch-model.sh
```

## Requirements

- **bash**: Version 4.0 or higher
- **python3**: For JSON parsing
- **curl**: For downloading installation script
- [OpenCode](https://opencode.ai) with [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) installed

## Usage

### Interactive Mode

Simply run the command without arguments to launch the interactive menu:

```bash
opencode-model
```

You'll be guided through selecting:
- What to configure (opencode main model, small model, oh-my-opencode agents)
- Which agent to modify
- Which model to use

### Quick Commands

```bash
# List all available models and current configuration
opencode-model --list

# Switch all oh-my-opencode agents to a specific model
opencode-model opencode/glm-4.7-free

# Switch a specific agent to a model
opencode-model --agent Sisyphus opencode/glm-4.7-free

# Switch opencode main model
opencode-model --main-model opencode/glm-4.7-free

# Switch opencode small model
opencode-model --small-model opencode/glm-4.7-free

# Show help
opencode-model --help
```

### Example Workflow

1. **Check current configuration**:
   ```bash
   opencode-model --list
   ```

2. **Switch to a free model**:
   ```bash
   opencode-model opencode/glm-4.7-free
   ```

3. **Verify the change**:
   ```bash
   opencode-model --list
   ```

## Available Free Models

The tool comes pre-configured with these free models:
- `opencode/glm-4.7-free` - GLM 4.7 (Free tier)
- `opencode/minimax-m2.1-free` - MiniMax M2.1 (Free tier)
- `opencode/grok-code` - Grok Code (Free tier)
- `opencode/big-pickle` - Big Pickle (Free tier)

Additional models are dynamically loaded from your opencode favorites.

## Configuration

The tool modifies configuration files managed by opencode:

- **OpenCode Config**: `~/.config/opencode/opencode.json`
- **oh-my-opencode Config**: `~/.config/opencode/oh-my-opencode.json`
- **Favorites**: `~/.local/state/opencode/model.json`

Before any modification, a backup is automatically created with the `.backup` extension.

## Troubleshooting

### Command not found

If you get "command not found" error after installation:

1. Check if `~/.local/bin` is in your PATH:
   ```bash
   echo $PATH | grep ~/.local/bin
   ```

2. If not, add it to your shell profile:
   - For bash: `echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc`
   - For zsh: `echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.zshrc`

3. Reload your shell or run `source ~/.bashrc`

### Python3 not found

The tool requires python3 for JSON parsing:

```bash
# On Ubuntu/Debian
sudo apt-get install python3

# On macOS
brew install python3

# On Fedora
sudo dnf install python3
```

### Permission denied

If you get permission errors:

```bash
chmod +x ~/.config/opencode/bin/opencode-switch-model.sh
chmod +x ~/.local/bin/opencode-model
```

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Security

For security concerns, please see [SECURITY.md](SECURITY.md).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [OpenCode](https://opencode.ai) - The AI coding platform
- [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) - Multi-agent framework
- All contributors and users of this tool

## Support

- 📖 [Documentation](docs/)
- 🐛 [Report Issues](https://github.com/zhengxiongzhao/opencode-model-switcher/issues)
- 💬 [Discussions](https://github.com/zhengxiongzhao/opencode-model-switcher/discussions)

---

**Made with ❤️ for the OpenCode community**
