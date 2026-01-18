# Contributing to OpenCode Model Switcher

Thank you for your interest in contributing to OpenCode Model Switcher! We welcome contributions from everyone.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When creating a bug report, please include:

- **Clear title**: Summarize the issue
- **Description**: What happened and what you expected to happen
- **Steps to reproduce**: Detailed steps to reproduce the issue
- **Environment**:
  - Operating system and version
  - Bash version (`bash --version`)
  - Python3 version (`python3 --version`)
- **Logs**: Any error messages or output

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:

- **Clear title**: Summarize the enhancement
- **Description**: What the enhancement would do and why it would be useful
- **Use cases**: Real-world examples of how this enhancement would help
- **Alternatives considered**: Any alternative approaches you've thought about

### Pull Requests

1. **Fork the repository** and create your branch from `master`:
   ```bash
   git checkout -b my-feature-branch
   ```

2. **Make your changes**:
   - Follow the existing code style and conventions
   - Add tests for new features
   - Update documentation as needed
   - Keep commits atomic and focused

3. **Test your changes**:
   ```bash
   # Run tests
   ./tests/test_installation.sh

   # Test the main script
   ./bin/opencode-switch-model.sh --help
   ./bin/opencode-switch-model.sh --list
   ```

4. **Commit your changes** with clear messages:
   ```bash
   git commit -m "feat: add new feature"
   # or
   git commit -m "fix: resolve issue with model switching"
   ```

5. **Push to your fork** and create a pull request

### Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/zhengxiongzhao/opencode-model-switcher.git
   cd opencode-model-switcher
   ```

2. Make the script executable:
   ```bash
   chmod +x bin/opencode-switch-model.sh
   ```

3. Create a symlink for development:
   ```bash
   ln -s $(pwd)/bin/opencode-switch-model.sh ~/.local/bin/opencode-model-dev
   ```

4. Test changes:
   ```bash
   opencode-model-dev --help
   ```

### Code Style

- **Shell Script**: Follow [Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Indentation**: 4 spaces (no tabs)
- **Comments**: Explain why, not what
- **Functions**: Keep them small and focused
- **Error Handling**: Use `set -e` and handle errors appropriately

### Testing

Before submitting a PR, ensure:

1. All tests pass: `./tests/test_installation.sh`
2. The script is executable: `chmod +x bin/opencode-switch-model.sh`
3. The help command works: `./bin/opencode-switch-model.sh --help`
4. The list command works: `./bin/opencode-switch-model.sh --list`
5. Interactive mode works: `./bin/opencode-switch-model.sh`

### Documentation

When adding new features or making changes:

- Update [README.md](README.md) if user-facing
- Update [USAGE.md](docs/USAGE.md) with usage examples
- Update [CHANGELOG.md](CHANGELOG.md) with version changes

## Code of Conduct

### Our Pledge

We as members, contributors, and leaders pledge to make participation in our community a harassment-free experience for everyone.

### Our Standards

Examples of behavior that contributes to a positive environment:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

Examples of unacceptable behavior:

- The use of sexualized language or imagery
- Trolling, insulting/derogatory comments, and personal attacks
- Harassment, public or private
- Publishing others' private information without permission
- Other unethical or unprofessional conduct

### Responsibilities

Project maintainers are responsible for clarifying standards of acceptable behavior and are expected to take appropriate and fair corrective action in response to any instances of unacceptable behavior.

## Getting Help

If you need help contributing:

- Check existing [Issues](https://github.com/zhengxiongzhao/opencode-model-switcher/issues)
- Start a [Discussion](https://github.com/zhengxiongzhao/opencode-model-switcher/discussions)
- Contact maintainers via GitHub

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🎉
