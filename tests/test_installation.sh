#!/bin/bash
#
# Test Suite for OpenCode Model Switcher
# Runs automated tests for installation and functionality
#

set -e

# Configuration
TEST_DIR=$(mktemp -d)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/bin/opencode-switch-model.sh"
INSTALL_SCRIPT="$SCRIPT_DIR/scripts/install.sh"
UNINSTALL_SCRIPT="$SCRIPT_DIR/scripts/uninstall.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Functions
print_header() {
    echo -e "${GREEN}"
    echo "═══════════════════════════════════════════════════"
    echo "   OpenCode Model Switcher - Test Suite"
    echo "═══════════════════════════════════════════════════"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ PASS${NC} - $1"
}

print_error() {
    echo -e "${RED}✗ FAIL${NC} - $1"
}

test_pass() {
    ((TOTAL_TESTS++))
    ((PASSED_TESTS++))
    print_success "$1"
}

test_fail() {
    ((TOTAL_TESTS++))
    ((FAILED_TESTS++))
    print_error "$1"
}

# Test Suite 1: Dependency Checks
test_dependencies() {
    echo ""
    echo -e "${YELLOW}Test Suite 1: Dependency Checks${NC}"
    echo ""

    if command -v bash >/dev/null 2>&1; then
        BASH_VER=$(bash --version | head -n1 | awk '{print $4}')
        test_pass "bash found (version: $BASH_VER)"
    else
        test_fail "bash not found"
    fi

    if command -v python3 >/dev/null 2>&1; then
        PYTHON_VER=$(python3 --version 2>&1 | awk '{print $2}')
        test_pass "python3 found (version: $PYTHON_VER)"
    else
        test_fail "python3 not found"
    fi

    if command -v curl >/dev/null 2>&1; then
        CURL_VER=$(curl --version | head -n1 | awk '{print $2}')
        test_pass "curl found (version: $CURL_VER)"
    else
        test_fail "curl not found"
    fi
}

# Test Suite 2: Script Syntax
test_syntax() {
    echo ""
    echo -e "${YELLOW}Test Suite 2: Script Syntax${NC}"
    echo ""

    if bash -n "$SCRIPT_PATH" 2>/dev/null; then
        test_pass "Main script has valid syntax"
    else
        test_fail "Main script has syntax errors"
    fi

    if bash -n "$INSTALL_SCRIPT" 2>/dev/null; then
        test_pass "Install script has valid syntax"
    else
        test_fail "Install script has syntax errors"
    fi

    if bash -n "$UNINSTALL_SCRIPT" 2>/dev/null; then
        test_pass "Uninstall script has valid syntax"
    else
        test_fail "Uninstall script has syntax errors"
    fi
}

# Test Suite 3: Script Executability
test_executability() {
    echo ""
    echo -e "${YELLOW}Test Suite 3: Script Executability${NC}"
    echo ""

    if [ -f "$SCRIPT_PATH" ]; then
        test_pass "Main script file exists"
    else
        test_fail "Main script file not found"
    fi

    if [ -x "$SCRIPT_PATH" ]; then
        test_pass "Main script is executable"
    else
        test_fail "Main script is not executable"
    fi

    if [ -f "$INSTALL_SCRIPT" ]; then
        test_pass "Install script file exists"
    else
        test_fail "Install script file not found"
    fi

    if [ -x "$INSTALL_SCRIPT" ]; then
        test_pass "Install script is executable"
    else
        test_fail "Install script is not executable"
    fi

    if [ -f "$UNINSTALL_SCRIPT" ]; then
        test_pass "Uninstall script file exists"
    else
        test_fail "Uninstall script file not found"
    fi

    if [ -x "$UNINSTALL_SCRIPT" ]; then
        test_pass "Uninstall script is executable"
    else
        test_fail "Uninstall script is not executable"
    fi
}

# Test Suite 4: Help Command
test_help() {
    echo ""
    echo -e "${YELLOW}Test Suite 4: Help Command${NC}"
    echo ""

    if "$SCRIPT_PATH" --help >/dev/null 2>&1; then
        test_pass "Help command executes successfully"
    else
        test_fail "Help command failed"
    fi

    if "$SCRIPT_PATH" -h >/dev/null 2>&1; then
        test_pass "Short help flag (-h) works"
    else
        test_fail "Short help flag failed"
    fi
}

# Test Suite 5: List Command
test_list() {
    echo ""
    echo -e "${YELLOW}Test Suite 5: List Command${NC}"
    echo ""

    if "$SCRIPT_PATH" --list >/dev/null 2>&1; then
        test_pass "List command executes successfully"
    else
        test_fail "List command failed"
    fi

    if "$SCRIPT_PATH" -l >/dev/null 2>&1; then
        test_pass "Short list flag (-l) works"
    else
        test_fail "Short list flag failed"
    fi
}

# Test Suite 6: Install Script Help
test_install_help() {
    echo ""
    echo -e "${YELLOW}Test Suite 6: Install Script${NC}"
    echo ""

    if "$INSTALL_SCRIPT" --help >/dev/null 2>&1; then
        test_pass "Install script help works"
    else
        test_fail "Install script help failed"
    fi

    if "$UNINSTALL_SCRIPT" --help >/dev/null 2>&1; then
        test_pass "Uninstall script help works"
    else
        test_fail "Uninstall script help failed"
    fi
}

# Test Suite 7: File Permissions
test_permissions() {
    echo ""
    echo -e "${YELLOW}Test Suite 7: File Permissions${NC}"
    echo ""

    MAIN_PERMS=$(stat -c "%a" "$SCRIPT_PATH" 2>/dev/null || stat -f "%Lp" "$SCRIPT_PATH" 2>/dev/null)
    if [[ "$MAIN_PERMS" == *"x"* ]]; then
        test_pass "Main script has execute permission"
    else
        test_fail "Main script lacks execute permission"
    fi

    INSTALL_PERMS=$(stat -c "%a" "$INSTALL_SCRIPT" 2>/dev/null || stat -f "%Lp" "$INSTALL_SCRIPT" 2>/dev/null)
    if [[ "$INSTALL_PERMS" == *"x"* ]]; then
        test_pass "Install script has execute permission"
    else
        test_fail "Install script lacks execute permission"
    fi
}

test_functions() {
    echo ""
    echo -e "${YELLOW}Test Suite 8: Essential Functions${NC}"
    echo ""

    if grep -q "list_models" "$SCRIPT_PATH"; then
        test_pass "list_models function exists"
    else
        test_fail "list_models function not found"
    fi

    if grep -q "switch_to" "$SCRIPT_PATH"; then
        test_pass "switch_to function exists"
    else
        test_fail "switch_to function not found"
    fi

    if grep -q "show_current" "$SCRIPT_PATH"; then
        test_pass "show_current function exists"
    else
        test_fail "show_current function not found"
    fi

    if grep -q "update_models" "$SCRIPT_PATH"; then
        test_pass "update_models function exists"
    else
        test_fail "update_models function not found"
    fi
}

print_summary() {
    echo ""
    echo -e "${GREEN}"
    echo "═══════════════════════════════════════════════════"
    echo "   Test Summary"
    echo "═══════════════════════════════════════════════════"
    echo -e "${NC}"
    echo ""
    echo -e "Total Tests:  ${YELLOW}$TOTAL_TESTS${NC}"
    echo -e "Passed:       ${GREEN}$PASSED_TESTS${NC}"
    echo -e "Failed:       ${RED}$FAILED_TESTS${NC}"
    echo ""

    if [ $FAILED_TESTS -eq 0 ]; then
        echo -e "${GREEN}✓ All tests passed!${NC}"
        return 0
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        return 1
    fi
}

cleanup() {
    echo ""
    echo "Cleaning up test directory..."
    rm -rf "$TEST_DIR"
}

main() {
    print_header

    test_dependencies
    test_syntax
    test_executability
    test_help
    test_list
    test_install_help
    test_permissions
    test_functions

    print_summary
    EXIT_CODE=$?

    cleanup

    exit $EXIT_CODE
}

main
