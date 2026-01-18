# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x.x   | ✅        |

## Reporting a Vulnerability

### How to Report

If you discover a security vulnerability, please **do not** open a public issue. Instead, send an email to the security team.

**Email**: security@example.com

### What to Include

Please include the following information in your report:

- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Any suggested fixes (if known)

### Response Timeline

- **Initial Response**: We will acknowledge receipt within 48 hours
- **Detailed Response**: We will provide a detailed response and estimated timeline for a fix within 5 business days
- **Fix Release**: We will release a patch as soon as possible, typically within 7-10 days for critical issues

### Coordinated Disclosure

We follow a responsible disclosure process:

1. **Triage and Verification**: We verify the vulnerability
2. **Develop Fix**: We work on a fix internally
3. **Security Advisory**: We prepare a security advisory
4. **Coordinated Release**: We release the fix and advisory simultaneously

## Security Best Practices

### For Users

To use this tool securely:

1. **Verify Checksums**: When installing, verify the SHA256 checksum if available
2. **Use HTTPS Only**: Only download scripts via HTTPS
3. **Review Script**: Review the install script before piping to bash
4. **Keep Updated**: Install updates as they are released
5. **Check Permissions**: Ensure the script has appropriate permissions

### Example: Secure Installation

```bash
# Download and review the install script first
curl -fsSL https://raw.githubusercontent.com/zhengxiongzhao/opencode-model-switcher/master/scripts/install.sh -o install.sh

# Review the script
cat install.sh

# Then execute
bash install.sh

# Clean up
rm install.sh
```

## Known Security Considerations

### Current Implementations

1. **Installation Script**: The install script is downloaded and executed via curl pipe
   - **Risk**: MITM attack if HTTPS is compromised
   - **Mitigation**: HTTPS provides protection; users can review script before execution

2. **Python3 Embedding**: The script embeds Python for JSON parsing
   - **Risk**: User input is passed to Python
   - **Mitigation**: Input validation and error handling in place

3. **File Operations**: The script modifies configuration files
   - **Risk**: Malicious input could cause issues
   - **Mitigation**: Backup/restore mechanism, path validation

### Future Improvements

We plan to implement:

- [ ] GPG signature verification for releases
- [ ] SHA256 checksums for all releases
- [ ] Code signing for install script
- [ ] Security audit by third party

## Dependency Security

### Dependencies

This project has minimal dependencies:

- **bash**: Core shell (system package)
- **python3**: For JSON parsing (system package)
- **curl**: For downloads (system package)

All dependencies are installed via system package managers, not npm/pip/etc.

### Updates

We recommend keeping your system packages updated:

```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get upgrade

# macOS
brew update && brew upgrade

# Fedora
sudo dnf upgrade
```

## Security Best Practices for Contributors

When contributing code:

1. **Input Validation**: Always validate and sanitize user input
2. **Error Handling**: Use proper error handling (`set -e`, trap errors)
3. **Path Validation**: Validate file paths before operations
4. **Least Privilege**: Don't request unnecessary permissions
5. **No Secrets**: Never commit secrets or sensitive data
6. **Review Changes**: Review all changes for security implications

## Security Audit

This project has not yet undergone a formal security audit. We welcome security researchers to review our code and report vulnerabilities responsibly.

## Receiving Security Updates

To stay informed about security updates:

1. **Watch the Repository**: Click "Watch" → "Releases only"
2. **Subscribe to Security Advisories**: Enable notifications for security advisories in repository settings
3. **Follow CHANGELOG**: Monitor [CHANGELOG.md](CHANGELOG.md) for security fixes

## Security Questions?

If you have security questions that don't involve a vulnerability:

- Open a [Discussion](https://github.com/zhengxiongzhao/opencode-model-switcher/discussions)
- Tag with the `security` label

---

Thank you for helping keep OpenCode Model Switcher secure! 🛡️
