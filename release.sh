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

# Check if tag already exists
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
  echo "Error: Tag v$VERSION already exists"
  exit 1
fi

# Check if working directory is clean
if ! git diff-index --quiet HEAD --; then
  echo "Error: Working directory has uncommitted changes"
  echo "Please commit changes before releasing"
  exit 1
fi

echo "✅ Working directory is clean"
echo ""

# Confirm before tagging
read -p "Create tag v$VERSION on current commit? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

echo "🏷️  Creating tag v$VERSION..."
git tag -a "v$VERSION" -m "Release v$VERSION"

echo ""
echo "🚀 Pushing to origin..."
git push --follow-tags origin main

echo ""
echo "✨ Release v$VERSION complete!"
echo ""
echo "Note: GitHub Actions will now build and publish the images"
