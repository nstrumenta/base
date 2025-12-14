#!/usr/bin/env bash
set -euo pipefail

# Release script for nstrumenta/base Docker images
# Usage: ./release.sh <version>
# Example: ./release.sh 2.0.0

VERSION="${1:-}"

if [ -z "$VERSION" ]; then
  echo "Error: Version required"
  echo "Usage: ./release.sh <version>"
  echo "Example: ./release.sh 2.0.0"
  exit 1
fi

# Validate semantic versioning format
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Version must follow semantic versioning (e.g., 2.0.0)"
  exit 1
fi

echo "🚀 Preparing release v$VERSION"
echo ""

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
  echo "Error: Working directory has uncommitted changes"
  echo "Please commit or stash changes before releasing"
  exit 1
fi

# Check if tag already exists
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
  echo "Error: Tag v$VERSION already exists"
  exit 1
fi

echo "✏️  Updating version in README..."

# Update version examples in README.md
sed -i.bak "s/nstrumenta\/base:[0-9]\+\.[0-9]\+\.[0-9]\+/nstrumenta\/base:$VERSION/g" README.md
sed -i.bak "s/nstrumenta\/developer:[0-9]\+\.[0-9]\+\.[0-9]\+/nstrumenta\/developer:$VERSION/g" README.md
rm README.md.bak

echo "✅ Version updated to $VERSION"
echo ""

# Show what changed
echo "📝 Changes:"
git diff README.md
echo ""

# Confirm before committing
read -p "Commit these changes and create tag v$VERSION? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted. Rolling back changes..."
  git checkout -- README.md
  exit 1
fi

# Commit and tag
echo "📦 Committing changes..."
git add README.md
git commit -m "Release v$VERSION"

echo "🏷️  Creating tag v$VERSION..."
git tag -a "v$VERSION" -m "Release v$VERSION"

echo ""
echo "✨ Release v$VERSION prepared!"
echo ""
echo "Next steps:"
echo "  1. Review the commit: git show"
echo "  2. Push when ready: git push origin main && git push origin v$VERSION"
echo ""
echo "Note: Pushing the tag will trigger GitHub Actions to build and publish the images"
