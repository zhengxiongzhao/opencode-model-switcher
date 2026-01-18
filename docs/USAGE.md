# Usage Guide

This guide provides comprehensive usage instructions for OpenCode Model Switcher.

## Quick Start

```bash
# Launch interactive mode
opencode-model

# List available models and current configuration
opencode-model --list

# Show help
opencode-model --help
```

## Commands

### Interactive Mode

```bash
opencode-model
```

Launches an interactive menu system that guides you through:

1. **Select Configuration Type**:
   - opencode main model
   - opencode small model
   - oh-my-opencode agents
   - All models

2. **Select Target**:
   - For agents: Choose specific agent or all agents
   - For opencode: No target selection needed

3. **Select Model**:
   - Choose from built-in free models
   - Choose from your favorite models
   - Enter custom model name

### Interactive Mode Navigation

- Use numbers to select options
- Use `0` to go back to previous menu
- Use `q` or `Q` to quit

### Interactive Mode Example Flow

```
╔════════════════════════════════════════════════╗
║   Current Model Configuration                              ║
╚════════════════════════════════════════════════╝

[opencode]
  Main Model:   zhipuai-coding-plan/glm-4.7
  Small Model:  zhipuai-coding-plan/glm-4.7

[oh-my-opencode]
  Sisyphus:                   zhipuai-coding-plan/glm-4.7
  librarian:                   zhipuai-coding-plan/glm-4.7
  ...

╔════════════════════════════════════════════════╗
║   Select Configuration Type                             ║
╚════════════════════════════════════════════════╝

  1) opencode main model
  2) opencode small model
  3) oh-my-opencode agents
  4) All models

Select type [1-4] or q to exit: 1
```

## Command-Line Mode

### List Models

```bash
opencode-model --list
# or
opencode-model -l
```

**Output**:
- Current configuration for opencode (main and small models)
- Current configuration for all oh-my-opencode agents
- Available models (built-in free models + your favorites)
- Free models marked with `[FREE]` tag

**Example Output**:
```
╔════════════════════════════════════════════════╗
║   Current Model Configuration                              ║
╚════════════════════════════════════════════════╝

[opencode]
  Main Model:   zhipuai-coding-plan/glm-4.7
  Small Model:  zhipuai-coding-plan/glm-4.7

[oh-my-opencode]
  Sisyphus:                   zhipuai-coding-plan/glm-4.7
  librarian:                   zhipuai-coding-plan/glm-4.7
  ...

╔════════════════════════════════════════════════╗
║   oh-my-opencode Model List                           ║
╚════════════════════════════════════════════════╝

Available Models:

   1) opencode/glm-4.7-free [FREE]
   2) opencode/minimax-m2.1-free [FREE]
   3) opencode/grok-code [FREE]
   4) opencode/big-pickle [FREE]
   5) custom
```

### Switch All Agents

```bash
opencode-model <model_name>
```

Switches all oh-my-opencode agents to the specified model.

**Example**:
```bash
opencode-model opencode/glm-4.7-free
```

**Output**:
```
✓ [Sisyphus] switched to: opencode/glm-4.7-free
✓ [librarian] switched to: opencode/glm-4.7-free
✓ [explore] switched to: opencode/glm-4.7-free
✓ [oracle] switched to: opencode/glm-4.7-free
✓ [frontend-ui-ux-engineer] switched to: opencode/glm-4.7-free
✓ [document-writer] switched to: opencode/glm-4.7-free
✓ [multimodal-looker] switched to: opencode/glm-4.7-free
```

### Switch Specific Agent

```bash
opencode-model --agent <agent_name> <model>
```

Switches a single oh-my-opencode agent to the specified model.

**Example**:
```bash
opencode-model --agent Sisyphus opencode/glm-4.7-free
```

**Output**:
```
✓ [Sisyphus] switched to: opencode/glm-4.7-free
```

**Available Agents**:
- `Sisyphus` - Main orchestration agent
- `librarian` - External code research
- `explore` - Internal codebase exploration
- `oracle` - High-IQ reasoning and architecture
- `frontend-ui-ux-engineer` - UI/UX design
- `document-writer` - Technical documentation
- `multimodal-looker` - Media file analysis

### Switch OpenCode Main Model

```bash
opencode-model --main-model <model>
```

Switches the opencode main model (used for primary coding tasks).

**Example**:
```bash
opencode-model --main-model opencode/glm-4.7-free
```

**Output**:
```
✓ opencode main model switched to: opencode/glm-4.7-free
```

### Switch OpenCode Small Model

```bash
opencode-model --small-model <model>
```

Switches the opencode small model (used for quick tasks).

**Example**:
```bash
opencode-model --small-model opencode/minimax-m2.1-free
```

**Output**:
```
✓ opencode small model switched to: opencode/minimax-m2.1-free
```

### Help

```bash
opencode-model --help
# or
opencode-model -h
```

Displays usage information and available commands.

## Built-in Free Models

The tool comes pre-configured with these free-to-use models:

| Model | Description |
|--------|-------------|
| `opencode/glm-4.7-free` | GLM 4.7 (Free tier) |
| `opencode/minimax-m2.1-free` | MiniMax M2.1 (Free tier) |
| `opencode/grok-code` | Grok Code (Free tier) |
| `opencode/big-pickle` | Big Pickle (Free tier) |

These models are marked with `[FREE]` tag in the interactive menu.

## Custom Models

You can use any model supported by opencode by:

1. **Using `custom` option** in interactive mode
2. **Entering custom model name directly**:
   ```bash
   opencode-model anthropic/claude-3-opus
   ```

### Custom Model Format

Custom models follow the format: `<provider>/<model>`

Examples:
- `anthropic/claude-3-opus`
- `openai/gpt-4`
- `google/gemini-pro`
- `zhipuai-coding-plan/glm-4`

## Favorite Models

The tool automatically loads your favorite models from opencode's configuration.

**How Favorites Work**:
1. When you mark a model as favorite in opencode, it's saved to `~/.local/state/opencode/model.json`
2. This tool reads that file on startup
3. Favorites appear in the model list automatically

**Managing Favorites**:
- Use opencode's interface to add/remove favorites
- This tool will automatically include them in model lists

**Favorites Integration**:
```bash
# After marking favorites in opencode
opencode-model --list

# Output includes your favorites:
   1) opencode/glm-4.7-free [FREE]
   2) opencode/minimax-m2.1-free [FREE]
   3) anthropic/claude-3-opus           # Your favorite
   4) openai/gpt-4                      # Your favorite
   5) custom
```

## Backup and Restore

The tool automatically creates backups before making any configuration changes.

**Backup Location**:
- `~/.config/opencode/oh-my-opencode.json.backup`
- `~/.config/opencode/opencode.json.backup`

**How Backups Work**:
1. Before any change, the current config is copied to `.backup`
2. Changes are applied to the original file
3. If changes fail, the backup is restored automatically

**Manual Restore**:

If you need to restore from a backup:

```bash
# Restore oh-my-opencode config
cp ~/.config/opencode/oh-my-opencode.json.backup ~/.config/opencode/oh-my-opencode.json

# Restore opencode config
cp ~/.config/opencode/opencode.json.backup ~/.config/opencode/opencode.json
```

## Use Cases and Examples

### Use Case 1: Switch to Free Model for Cost Savings

```bash
# Check current configuration
opencode-model --list

# Switch all agents to free model
opencode-model opencode/glm-4.7-free

# Verify change
opencode-model --list
```

### Use Case 2: Switch Different Agents to Different Models

```bash
# Main agent uses powerful model
opencode-model --agent Sisyphus anthropic/claude-3-opus

# Other agents use free model
opencode-model --agent librarian opencode/glm-4.7-free
opencode-model --agent explore opencode/glm-4.7-free
```

### Use Case 3: Interactive Model Selection

```bash
# Launch interactive mode for guided selection
opencode-model

# Follow prompts:
# 1. Choose configuration type (e.g., "oh-my-opencode agents")
# 2. Choose target (e.g., "Sisyphus")
# 3. Choose model from list (e.g., "opencode/glm-4.7-free")
```

### Use Case 4: Configure Both opencode and oh-my-opencode

```bash
# Set opencode main model
opencode-model --main-model opencode/glm-4.7-free

# Set opencode small model
opencode-model --small-model opencode/minimax-m2.1-free

# Set all oh-my-opencode agents
opencode-model opencode/glm-4.7-free

# Verify all settings
opencode-model --list
```

### Use Case 5: Use Interactive Mode for "All Models"

```bash
# Launch interactive mode
opencode-model

# Select "4) All models"
# Select desired model
# All opencode and oh-my-opencode agents will use the same model
```

## Tips and Tricks

### Tip 1: Quick Model Switching

Create aliases in your shell for quick switching:

```bash
# Add to ~/.bashrc or ~/.zshrc
alias model-free='opencode-model opencode/glm-4.7-free'
alias model-gpt4='opencode-model anthropic/claude-3-opus'

# Use aliases
model-free    # Switch all agents to free model
model-gpt4    # Switch all agents to GPT-4
```

### Tip 2: Batch Configuration

Create a shell script to configure multiple agents:

```bash
#!/bin/bash
# setup-models.sh

opencode-model --agent Sisyphus anthropic/claude-3-opus
opencode-model --agent oracle openai/gpt-4
opencode-model --agent explore opencode/glm-4.7-free

# Run: ./setup-models.sh
```

### Tip 3: Verify Before Using

Always verify configuration changes:

```bash
# Make change
opencode-model --agent Sisyphus new-model

# Verify
opencode-model --list
```

### Tip 4: Use Interactive Mode for Exploration

If you're not sure which model to use:

```bash
# Interactive mode shows:
# - Current configuration
# - Available models
# - Free model tags

opencode-model
```

## Error Handling

### Configuration File Not Found

**Error**: `✗ 配置文件不存在` (Configuration file does not exist)

**Cause**: OpenCode or oh-my-opencode is not installed

**Solution**: Install opencode with oh-my-opencode first

### Agent Not Found

**Error**: `✗ 切换失败或 agent 不存在` (Switch failed or agent does not exist)

**Cause**: Trying to switch an agent that doesn't exist

**Solution**: Check available agents with `opencode-model --list`

### Model Not Found

**Error**: Model doesn't work after switching

**Cause**: Model name is incorrect or not available

**Solution**:
1. Verify model name in opencode
2. Use `opencode-model --list` to see available models
3. Check model format: `<provider>/<model>`

## Advanced Usage

### Combining with Other Tools

Use with opencode CLI:

```bash
# Switch model
opencode-model opencode/glm-4.7-free

# Start opencode coding session
opencode
```

### Automation and Scripting

Use in scripts for automated model switching:

```bash
#!/bin/bash
# auto-switch.sh

case "$1" in
  "free")
    opencode-model opencode/glm-4.7-free
    ;;
  "fast")
    opencode-model opencode/minimax-m2.1-free
    ;;
  "power")
    opencode-model anthropic/claude-3-opus
    ;;
  *)
    echo "Usage: $0 {free|fast|power}"
    exit 1
    ;;
esac
```

## Configuration Files

The tool modifies these configuration files:

### OpenCode Configuration

**File**: `~/.config/opencode/opencode.json`

**Structure**:
```json
{
  "model": "zhipuai-coding-plan/glm-4.7",
  "small_model": "zhipuai-coding-plan/glm-4.7"
}
```

**Modified by**:
- `--main-model` command
- Interactive mode "opencode main model" option

### oh-my-opencode Configuration

**File**: `~/.config/opencode/oh-my-opencode.json`

**Structure**:
```json
{
  "agents": {
    "Sisyphus": {
      "model": "zhipuai-coding-plan/glm-4.7"
    },
    "librarian": {
      "model": "zhipuai-coding-plan/glm-4.7"
    },
    ...
  }
}
```

**Modified by**:
- `--agent` command
- Interactive mode "oh-my-opencode agents" option

### Favorite Models

**File**: `~/.local/state/opencode/model.json`

**Structure**:
```json
{
  "favorite": [
    {
      "providerID": "anthropic",
      "modelID": "claude-3-opus"
    },
    ...
  ]
}
```

**Read by**:
- Tool on startup to populate model list

**Modified by**:
- opencode interface (not this tool)

## Next Steps

- Read [INSTALLATION.md](INSTALLATION.md) for installation help
- Read [README.md](../README.md) for project overview
- Report issues at: https://github.com/zhengxiongzhao/opencode-model-switcher/issues

## Support

- 📖 [Documentation](../README.md)
- 🐛 [Report Issues](https://github.com/zhengxiongzhao/opencode-model-switcher/issues)
- 💬 [Discussions](https://github.com/zhengxiongzhao/opencode-model-switcher/discussions)
