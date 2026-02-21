# Security Policy

## Supported Versions

| Version         | Supported              |
| --------------- | ---------------------- |
| `0.3.1-alpha.0` | ✅ Current             |
| `0.3.0-alpha.1` | ❌ No longer supported |
| `0.2.0-alpha.0` | ❌ No longer supported |
| `0.1.0-alpha`   | ❌ No longer supported |

## Reporting a Vulnerability

**Do not open a public GitHub issue for security vulnerabilities.**

Please report security vulnerabilities by emailing the maintainers via a [GitHub Security Advisory](https://github.com/Kompkit/KompKit/security/advisories/new).

Include:

- A description of the vulnerability
- Steps to reproduce
- Potential impact
- Any suggested fix (optional)

We will acknowledge receipt within 48 hours and aim to provide a fix or mitigation within 14 days for confirmed vulnerabilities.

## Scope

KompKit Core is a utility library with no network access, no file system access, and no external runtime dependencies (Web/Android). The attack surface is limited to:

- Input validation logic (`isEmail`) — regex denial-of-service (ReDoS) is in scope
- Dependency vulnerabilities in `intl` (Dart) or `kotlinx-coroutines` (Kotlin)

## Out of Scope

- Vulnerabilities in development-only dependencies (test runners, build tools)
- Issues in generated documentation
