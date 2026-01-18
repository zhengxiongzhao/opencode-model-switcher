#!/bin/bash
#
# OpenCode Model Switcher - Uninstallation Script
# Removes all installed components of opencode-model
#
# Usage: curl -fsSL <url> | bash -s --uninstall
#

set -e

# Configuration
INSTALL_DIR="${INSTALL_DIR:-$HOME/.config/opencode/bin}"
SYMLINK_DIR="${SYMLINK_DIR:-$HOME/.local/bin}"
SYMLINK_PATH="$SYMLINK_DIR/opencode-model"
SCRIPT_NAME="opencode-switch-model.sh"

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
    echo "   OpenCode Model Switcher - Uninstallation"
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

# Main uninstallation flow
main() {
    print_header

    print_info "Removing OpenCode Model Switcher..."
    echo ""

    REMOVED_COUNT=0

    if [ -L "$SYMLINK_PATH" ]; then
        rm -f "$SYMLINK_PATH"
        print_success "Removed symlink: $SYMLINK_PATH"
        ((REMOVED_COUNT++))
    elif [ -f "$SYMLINK_PATH" ]; then
        rm -f "$SYMLINK_PATH"
        print_success "Removed file: $SYMLINK_PATH"
        ((REMOVED_COUNT++))
    else
        print_info "Symlink not found (already removed): $SYMLINK_PATH"
    fi

    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        rm -f "$INSTALL_DIR/$SCRIPT_NAME"
        print_success "Removed script: $INSTALL_DIR/$SCRIPT_NAME"
        ((REMOVED_COUNT++))
    else
        print_info "Script not found (already removed): $INSTALL_DIR/$SCRIPT_NAME"
    fi

    if [ -d "$INSTALL_DIR" ]; then
        if [ -z "$(ls -A $INSTALL_DIR)" ]; then
            rmdir "$INSTALL_DIR"
            print_success "Removed empty directory: $INSTALL_DIR"
            ((REMOVED_COUNT++))
        else
            print_info "Installation directory not empty, keeping: $INSTALL_DIR"
        fi
    fi

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   Uninstallation Complete!${NC}"
    echo -e "${GREEN}   Removed $REMOVED_COUNT item(s)${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo ""

    print_info "Note: Your opencode configuration files and backups were not removed:"
    echo "  - $HOME/.config/opencode/"
    echo "  - $HOME/.local/state/opencode/"
    echo "  - $HOME/.opencode/"
    echo ""
    echo "These directories contain your OpenCode settings and are safe to keep."
    echo ""
}

# Run main function
main "$@"
