#!/bin/bash
#
# OpenCode Model Switcher - Installation Script
# One-click installation script for opencode-model
#
# Usage: curl -fsSL <url> | bash
#

set -e

# Configuration
REPO="${REPO:-zhengxiongzhao/opencode-model-switcher}"
VERSION="${VERSION:-main}"
BRANCH="${VERSION}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.config/opencode/bin}"
SYMLINK_DIR="${SYMLINK_DIR:-$HOME/.local/bin}"
SYMLINK_PATH="$SYMLINK_DIR/opencode-model"
SCRIPT_NAME="opencode-switch-model.sh"
SCRIPT_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/bin/$SCRIPT_NAME"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}"
    echo "═══════════════════════════════════════════════════"
    echo "   OpenCode Model Switcher - Installation"
    echo "═══════════════════════════════════════════════════"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

check_dependencies() {
    print_info "Checking dependencies..."

    if ! command -v bash >/dev/null 2>&1; then
        print_error "bash is not installed"
        echo -e "  ${YELLOW}Install with:${NC}"
        echo "    Ubuntu/Debian: sudo apt-get install bash"
        echo "    macOS: (bash is pre-installed)"
        echo "    Fedora: sudo dnf install bash"
        exit 1
    fi

    BASH_VERSION=$(bash --version | head -n1 | awk '{print $4}' | cut -d'(' -f1)
    if [ "$(echo "$BASH_VERSION 4.0" | awk '{print ($1 < $2)}')" = 1 ]; then
        print_error "bash version 4.0 or higher is required (current: $BASH_VERSION)"
        exit 1
    fi
    print_success "bash $BASH_VERSION found"

    if ! command -v python3 >/dev/null 2>&1; then
        print_error "python3 is not installed"
        echo -e "  ${YELLOW}Install with:${NC}"
        echo "    Ubuntu/Debian: sudo apt-get install python3"
        echo "    macOS: brew install python3"
        echo "    Fedora: sudo dnf install python3"
        exit 1
    fi

    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    print_success "python3 $PYTHON_VERSION found"

    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is not installed"
        echo -e "  ${YELLOW}Install with:${NC}"
        echo "    Ubuntu/Debian: sudo apt-get install curl"
        echo "    macOS: (curl is pre-installed)"
        echo "    Fedora: sudo dnf install curl"
        exit 1
    fi

    CURL_VERSION=$(curl --version | head -n1 | awk '{print $2}')
    print_success "curl $CURL_VERSION found"

    echo ""
}

download_script() {
    print_info "Downloading script from GitHub..."

    mkdir -p "$INSTALL_DIR"

    if ! curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"; then
        print_error "Failed to download script from: $SCRIPT_URL"
        echo ""
        echo -e "${YELLOW}Possible solutions:${NC}"
        echo "  1. Check your internet connection"
        echo "  2. Verify the repository name and branch are correct"
        echo "  3. Try manually downloading and installing"
        exit 1
    fi

    print_success "Script downloaded to: $INSTALL_DIR/$SCRIPT_NAME"
    echo ""
}

install_script() {
    print_info "Installing script..."

    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

    mkdir -p "$SYMLINK_DIR"

    if [ -L "$SYMLINK_PATH" ]; then
        print_info "Removing existing symlink..."
        rm "$SYMLINK_PATH"
    fi

    ln -sf "$INSTALL_DIR/$SCRIPT_NAME" "$SYMLINK_PATH"

    print_success "Script installed to: $SYMLINK_PATH"
    echo ""
}

check_path() {
    print_info "Checking PATH configuration..."

    if [[ ":$PATH:" != *":$SYMLINK_DIR:"* ]]; then
        print_warning "$SYMLINK_DIR is not in your PATH"
        echo ""
        echo -e "${YELLOW}To add it to your PATH, run:${NC}"
        echo ""

        if [ -n "$ZSH_VERSION" ]; then
            echo "  echo 'export PATH=\"\$PATH:$SYMLINK_DIR\"' >> ~/.zshrc"
            echo "  source ~/.zshrc"
        elif [ -n "$BASH_VERSION" ]; then
            echo "  echo 'export PATH=\"\$PATH:$SYMLINK_DIR\"' >> ~/.bashrc"
            echo "  source ~/.bashrc"
        else
            echo "  export PATH=\"\$PATH:$SYMLINK_DIR\""
            echo "  Add this to your shell's configuration file"
        fi

        echo ""
        print_warning "You need to add the path to use 'opencode-model' command directly"
        echo -e "${YELLOW}For now, you can use: $SYMLINK_PATH${NC}"
        echo ""
    else
        print_success "$SYMLINK_DIR is in PATH"
        echo ""
    fi
}

verify_installation() {
    print_info "Verifying installation..."

    if "$INSTALL_DIR/$SCRIPT_NAME" --help >/dev/null 2>&1; then
        print_success "Script is executable and working"
    else
        print_error "Script verification failed"
        echo ""
        echo "The script was installed but does not work correctly."
        echo "Please report this issue at: https://github.com/$REPO/issues"
        exit 1
    fi

    VERSION_OUTPUT=$("$INSTALL_DIR/$SCRIPT_NAME" --version 2>/dev/null || echo "unknown")
    if [ "$VERSION_OUTPUT" != "unknown" ]; then
        print_success "Version: $VERSION_OUTPUT"
    fi

    echo ""
}

print_completion() {
    echo -e "${GREEN}"
    echo "═══════════════════════════════════════════════════"
    echo "   Installation Complete!"
    echo "═══════════════════════════════════════════════════"
    echo -e "${NC}"
    echo ""
    echo -e "${GREEN}OpenCode Model Switcher is now installed!${NC}"
    echo ""

    if [[ ":$PATH:" != *":$SYMLINK_DIR:"* ]]; then
        echo -e "${YELLOW}IMPORTANT: Before using, add $SYMLINK_DIR to your PATH${NC}"
        echo ""
        echo "Then you can use:"
        echo "  opencode-model          - Launch interactive mode"
        echo "  opencode-model --list  - List models"
        echo "  opencode-model --help  - Show help"
        echo ""
        echo "Or use directly:"
        echo "  $SYMLINK_PATH"
        echo ""
    else
        echo "You can now use:"
        echo "  opencode-model          - Launch interactive mode"
        echo "  opencode-model --list  - List models"
        echo "  opencode-model --help  - Show help"
        echo ""
    fi

    echo "For more information, visit:"
    echo "  https://github.com/$REPO"
    echo ""
}

main() {
    print_header

    case "${1:-}" in
        --uninstall)
            print_info "Uninstalling OpenCode Model Switcher..."
            if [ -L "$SYMLINK_PATH" ]; then
                rm -f "$SYMLINK_PATH"
                print_success "Removed symlink: $SYMLINK_PATH"
            fi

            if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
                rm -f "$INSTALL_DIR/$SCRIPT_NAME"
                print_success "Removed script: $INSTALL_DIR/$SCRIPT_NAME"
            fi

            if [ -d "$INSTALL_DIR" ]; then
                rmdir "$INSTALL_DIR" 2>/dev/null || true
            fi

            echo ""
            echo -e "${GREEN}✓ Uninstallation complete${NC}"
            exit 0
            ;;

        --update)
            print_info "Updating OpenCode Model Switcher..."
            download_script
            install_script
            verify_installation
            echo -e "${GREEN}✓ Update complete${NC}"
            exit 0
            ;;

        --help|-h)
            echo "OpenCode Model Switcher - Installation Script"
            echo ""
            echo "Usage: curl -fsSL <url> | bash [options]"
            echo ""
            echo "Options:"
            echo "  (no options)    Install OpenCode Model Switcher"
            echo "  --uninstall     Uninstall OpenCode Model Switcher"
            echo "  --update        Update to the latest version"
            echo "  --help          Show this help message"
            echo ""
            echo "Environment Variables:"
            echo "  REPO          Repository name (default: zhengxiongzhao/opencode-model-switcher)"
            echo "  VERSION       Branch or tag (default: main)"
            echo "  INSTALL_DIR   Installation directory (default: ~/.config/opencode/bin)"
            echo "  SYMLINK_DIR   Directory for symlink (default: ~/.local/bin)"
            echo ""
            echo "Examples:"
            echo "  curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/main/scripts/install.sh | bash"
            echo "  REPO=zhengxiongzhao/repo VERSION=v1.0.0 curl -fsSL <url> | bash"
            echo "  curl -fsSL <url> | bash -s --uninstall"
            exit 0
            ;;
    esac

    check_dependencies
    download_script
    install_script
    check_path
    verify_installation
    print_completion
}

main "$@"
