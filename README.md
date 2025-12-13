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
FROM nstrumenta/base:24.12.0
```

### nstrumenta/developer
Full development environment extending base with deployment and dev tools.

**Includes everything in base plus:**
- Google Cloud SDK (gcloud)
- Beads issue tracker
- Chromium (for Angular tests)
- Python packaging tools (setuptools, wheel, twine)
- MCAP CLI (for inspecting/converting MCAP files)
- GitHub CLI (gh)
- tmux

**Note**: Docker is accessed via host socket mount in devcontainer, not installed in image.

**Size:** ~580MB

**Usage:**
```dockerfile
FROM nstrumenta/developer:latest
# or pin to specific version
FROM nstrumenta/developer:24.12.0
```

## Building and Publishing

With `dockerd` running:

```shell
BUILDX_ARGS="--push" ./build.sh 
```

This creates multi-arch images (amd64 + arm64) and pushes:
- `nstrumenta/base:24.12.0` + `nstrumenta/base:latest`
- `nstrumenta/developer:24.12.0` + `nstrumenta/developer:latest`



