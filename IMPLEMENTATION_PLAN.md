# Implementation Plan: OpenCode Model Switcher - GitHub Open Source Project

## Project Overview

**Project Name**: opencode-model-switcher
**Type**: Bash shell script utility
**Purpose**: Quick AI model switching for opencode and oh-my-opencode tools
**Current Location**: `/home/zxzhao/opencode-model/`
**Main Script**: `opencode-switch-model.sh` (772 lines)

## Phase 1: Repository Setup & Foundation

### 1.1 Project Structure
```
opencode-model-switcher/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   ├── pull_request_template.md
│   └── workflows/
│       ├── ci.yml
│       └── release.yml
├── bin/
│   └── opencode-switch-model.sh          # Main executable script
├── scripts/
│   ├── install.sh                         # One-click install script
│   └── uninstall.sh                      # Uninstall script
├── docs/
│   ├── INSTALLATION.md
│   └── USAGE.md
├── tests/
│   └── test_installation.sh              # Test suite
├── .gitignore
├── LICENSE
├── README.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CHANGELOG.md
└── package.json                          # Version tracking
```

### 1.2 Essential Files

**LICENSE**: MIT License (permissive, widely used, simple)
**README.md**: Comprehensive documentation with badges, installation, usage
**CONTRIBUTING.md**: Contribution guidelines, code of conduct
**SECURITY.md**: Security policy, vulnerability reporting
**CHANGELOG.md**: Version history and changes
**.gitignore**: Ignore backup files, temp files

### 1.3 Package.json for Versioning
```json
{
  "name": "opencode-model-switcher",
  "version": "1.0.0",
  "description": "Quick AI model switching for opencode and oh-my-opencode",
  "main": "bin/opencode-switch-model.sh",
  "bin": {
    "opencode-model": "./bin/opencode-switch-model.sh"
  },
  "scripts": {
    "test": "./tests/test_installation.sh"
  },
  "keywords": [
    "opencode",
    "ai",
    "model-switcher",
    "oh-my-opencode"
  ],
  "author": "Your Name",
  "license": "MIT"
}
```

## Phase 2: Installation Script Design

### 2.1 Installation Approach

**Decision**: User-level installation to home directory
- **Reason**: No sudo required, safer, works for all users
- **Install Location**: `~/.config/opencode/bin/opencode-switch-model.sh`
- **Symlink**: Create symlink in `~/.local/bin/opencode-model` (standard XDG bin location)

### 2.2 Install Script Features

**Features to Implement**:
1. **Dependency Check**: Verify python3 and bash are available
2. **Config Directory Check**: Ensure `~/.config/opencode/` exists
3. **Download Main Script**: Fetch from GitHub raw or jsDelivr CDN
4. **Make Executable**: `chmod +x`
5. **Create Symlink**: Link to `~/.local/bin/opencode-model`
6. **PATH Check**: Warn if `~/.local/bin` not in PATH
7. **Verify Installation**: Run `opencode-model --version` or `opencode-model --help`
8. **Backup Handling**: Don't overwrite existing backups
9. **Uninstall Support**: Add uninstall option

### 2.3 Curl Command

**Primary Command**:
```bash
curl -fsSL https://raw.githubusercontent.com/[zhengxiongzhao]/opencode-model-switcher/main/scripts/install.sh | bash
```

**Alternative (with CDN)**:
```bash
curl -fsSL https://cdn.jsdelivr.net/gh/[zhengxiongzhao]/opencode-model-switcher@main/scripts/install.sh | bash
```

### 2.4 Install Script Pseudocode

```bash
#!/bin/bash
set -e

REPO="zhengxiongzhao/opencode-model-switcher"
VERSION="latest"
INSTALL_DIR="$HOME/.config/opencode/bin"
SYMLINK_DIR="$HOME/.local/bin"
SYMLINK_PATH="$SYMLINK_DIR/opencode-model"
SCRIPT_URL="https://raw.githubusercontent.com/$REPO/main/bin/opencode-switch-model.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing opencode-model-switcher...${NC}"

# Check dependencies
command -v python3 >/dev/null 2>&1 || { echo -e "${RED}Error: python3 is required${NC}" && exit 1; }
command -v bash >/dev/null 2>&1 || { echo -e "${RED}Error: bash is required${NC}" && exit 1; }

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$SYMLINK_DIR"

# Download script
curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/opencode-switch-model.sh"

# Make executable
chmod +x "$INSTALL_DIR/opencode-switch-model.sh"

# Create symlink
ln -sf "$INSTALL_DIR/opencode-switch-model.sh" "$SYMLINK_PATH"

# Check PATH
if [[ ":$PATH:" != *":$SYMLINK_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $SYMLINK_DIR is not in PATH${NC}"
    echo -e "${YELLOW}Add this to your shell profile: export PATH=\"\$PATH:$SYMLINK_DIR\"${NC}"
fi

# Verify installation
if "$SYMLINK_PATH" --help > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Installation successful!${NC}"
    echo -e "${GREEN}Run 'opencode-model' to get started${NC}"
else
    echo -e "${RED}✗ Installation verification failed${NC}" && exit 1
fi
```

### 2.5 Uninstall Script

```bash
#!/bin/bash
set -e

INSTALL_DIR="$HOME/.config/opencode/bin"
SYMLINK_PATH="$HOME/.local/bin/opencode-model"

# Remove symlink
rm -f "$SYMLINK_PATH"

# Remove script
rm -f "$INSTALL_DIR/opencode-switch-model.sh"

# Remove directory if empty
rmdir "$INSTALL_DIR" 2>/dev/null || true

echo -e "${GREEN}✓ Uninstallation complete${NC}"
```

## Phase 3: Security Considerations

### 3.1 Security Measures

1. **Checksum Verification**: Include SHA256 checksum in install script for verification
2. **HTTPS Only**: All downloads via HTTPS
3. **Script Signing**: Consider GPG signing for production (optional for initial version)
4. **No Sudo Required**: User-level installation reduces risk
5. **Backup Before Changes**: The main script already has backup/restore
6. **Validate Input**: Sanitize all user inputs
7. **Secure Temporary Files**: Use `mktemp` for temp files

### 3.2 Checksum Approach

**In GitHub Release**:
- Attach `opencode-switch-model.sh.sha256` to releases
- Install script downloads and verifies checksum

**Implementation**:
```bash
# Download checksum
curl -fsSL "$SCRIPT_URL.sha256" -o "$INSTALL_DIR/script.sha256"

# Verify
cd "$INSTALL_DIR"
sha256sum -c script.sha256 || { echo -e "${RED}Checksum verification failed${NC}" && exit 1; }
```

## Phase 4: Documentation

### 4.1 README.md Sections

1. **Title & Badges**:
   - Build status
   - License
   - Latest release

2. **Description**: Brief project description
3. **Features**: Bullet list of key features
4. **Installation**:
   - One-line curl install
   - Manual install
   - Uninstall instructions
5. **Usage**:
   - Command examples
   - Interactive mode
   - Quick reference
6. **Configuration**: How to configure models
7. **Troubleshooting**: Common issues
8. **Contributing**: Link to CONTRIBUTING.md
9. **License**: License info
10. **Acknowledgments**: Thanks to contributors

### 4.2 INSTALLATION.md
Detailed installation guide with screenshots
- Prerequisites
- Installation methods
- Configuration
- Verification
- Troubleshooting

### 4.3 USAGE.md
Comprehensive usage documentation
- All commands explained
- Examples for each command
- Tips and tricks

## Phase 5: CI/CD Setup

### 5.1 GitHub Actions - CI.yml

**Checks**:
1. Shell script linting (shellcheck)
2. Test execution
3. Script syntax validation
4. Security scanning (optional)

```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: ShellCheck
        uses: ludeeus/action-shellcheck@master

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y python3 curl
      - name: Run tests
        run: ./tests/test_installation.sh
```

### 5.2 Release.yml

**Automation**:
1. Auto-generate changelog
2. Create GitHub release
3. Upload artifacts (script, checksum)
4. Update version

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Generate checksum
        run: sha256sum bin/opencode-switch-model.sh > opencode-switch-model.sh.sha256
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            bin/opencode-switch-model.sh
            opencode-switch-model.sh.sha256
```

## Phase 6: Testing Strategy

### 6.1 Test Cases

**Installation Tests**:
1. Fresh install works
2. Reinstall works (idempotent)
3. PATH check works
4. Dependencies are detected
5. Symlink is created correctly
6. Command is accessible
7. Uninstall works completely

**Functional Tests**:
1. Script runs without errors
2. Help command works
3. List command works
4. Model switching works
5. Backup/restore works
6. Interactive mode works

**Cross-Platform Tests**:
1. Ubuntu/Debian
2. macOS
3. Other Linux distributions

### 6.2 Test Script Structure

```bash
#!/bin/bash
# tests/test_installation.sh

set -e

echo "Running tests..."

# Test 1: Check dependencies
command -v python3 >/dev/null 2>&1 || { echo "FAIL: python3 not found"; exit 1; }
echo "PASS: python3 found"

# Test 2: Script is executable
[ -x "bin/opencode-switch-model.sh" ] || { echo "FAIL: script not executable"; exit 1; }
echo "PASS: script is executable"

# Test 3: Help command works
./bin/opencode-switch-model.sh --help >/dev/null 2>&1 || { echo "FAIL: help command failed"; exit 1; }
echo "PASS: help command works"

# Add more tests...

echo "All tests passed!"
```

## Phase 7: Release Strategy

### 7.1 Versioning (Semantic Versioning)

**Format**: MAJOR.MINOR.PATCH
- MAJOR: Breaking changes
- MINOR: New features, backward compatible
- PATCH: Bug fixes, backward compatible

**Initial Release**: v1.0.0

### 7.2 Release Process

1. Update version in package.json
2. Update CHANGELOG.md
3. Commit changes
4. Create git tag: `git tag v1.0.0`
5. Push tag: `git push origin v1.0.0`
6. GitHub Actions creates release automatically
7. Update install script if needed

## Phase 8: Answering Key Questions

### Q1: Install Location?
**Answer**: User-level to `~/.config/opencode/bin/` with symlink in `~/.local/bin/opencode-model`
**Reason**: No sudo required, follows XDG spec, safer, works for all users

### Q2: CDN for curl?
**Answer**: GitHub raw as primary, jsDelivr CDN as fallback
**Reason**: Simple, reliable, GitHub raw is fast enough for script

### Q3: Symlink or alias?
**Answer**: Symlink in `~/.local/bin/opencode-model`
**Reason**: Standard XDG location, works across shells, easy to remove

### Q4: Backup handling during install?
**Answer**: Don't touch existing backups in config directory; script already handles its own backups

### Q5: License?
**Answer**: MIT License
**Reason**: Permissive, widely used, simple, encourages adoption

### Q6: Versioning strategy?
**Answer**: Semantic Versioning (SemVer) with tags
**Reason**: Industry standard, clear communication, automation-friendly

### Q7: Update support?
**Answer**: Install script should check version and offer update
**Implementation**: Add `--update` flag to install script that fetches latest version and compares

## Execution Timeline

**Day 1**: Phase 1-2 (Setup & Install Script)
**Day 2**: Phase 3-4 (Security & Documentation)
**Day 3**: Phase 5-6 (CI/CD & Testing)
**Day 4**: Phase 7-8 (Release & Final Polish)
**Day 5**: Testing & Verification

## Success Criteria

✅ Repository is professional and follows best practices
✅ One-line curl installation works flawlessly
✅ After install, `opencode-model` command is available
✅ All functionality works after installation
✅ Tests pass on multiple platforms
✅ Documentation is comprehensive and clear
✅ Security best practices are implemented
✅ First release (v1.0.0) is published on GitHub

## Post-Launch Considerations

1. **Monitoring**: Track GitHub stars, issues, downloads
2. **Community**: Respond to issues, accept contributions
3. **Improvements**: Gather feedback, iterate
4. **Promotion**: Share in relevant communities
5. **Documentation**: Keep updated with new features
