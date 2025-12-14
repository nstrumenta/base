# nstrumenta/base

Docker images for the nstrumenta platform.

## Images

### nstrumenta/base
Minimal CI/CD image for building and testing.

**Included:**
- Node.js 24.12.0 LTS (Krypton, active until 2027-04-30)
- Python 3 + pip (for npm native modules)
- Essential utils: git, jq, curl, wget, zip

**Size:** ~200MB

**Usage:**
```dockerfile
FROM nstrumenta/base:latest
# or pin to specific version
FROM nstrumenta/base:2.0.0
```

### nstrumenta/developer
Full development environment extending base with deployment and dev tools.

**Includes everything in base plus:**
- Google Cloud SDK (gcloud)
- Chromium (for Angular tests)
- Python packaging tools (setuptools, wheel, twine)
- MCAP CLI (for inspecting/converting MCAP files)
- GitHub CLI (gh)
- Docker CLI v29.1.3 (uses host daemon via socket mount)
- tmux

**Size:** ~580MB

**Usage:**
```dockerfile
FROM nstrumenta/developer:latest
# or pin to specific version
FROM nstrumenta/developer:2.0.0
```
