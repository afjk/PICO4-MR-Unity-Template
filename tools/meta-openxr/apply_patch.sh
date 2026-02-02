#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PACKAGE_NAME="com.unity.xr.meta-openxr"
PACKAGE_CACHE_ROOT="$PROJECT_ROOT/Library/PackageCache"
PACKAGE_DEST="$PROJECT_ROOT/Packages/$PACKAGE_NAME"
PATCH_FILE="$PROJECT_ROOT/tools/meta-openxr/patches/meta-openxr-passthrough.patch"

echo "== Meta OpenXR patcher =="
echo "Project root: $PROJECT_ROOT"

if [[ ! -f "$PATCH_FILE" ]]; then
    echo "Patch file not found: $PATCH_FILE" >&2
    exit 1
fi

echo "Searching for $PACKAGE_NAME in $PACKAGE_CACHE_ROOT"
PACKAGE_SOURCE="$(ls -d "$PACKAGE_CACHE_ROOT/$PACKAGE_NAME"@* 2>/dev/null | head -n 1 || true)"

if [[ -z "$PACKAGE_SOURCE" ]]; then
    echo "Could not find $PACKAGE_NAME in Library/PackageCache." >&2
    echo "Open the project in Unity once so that UPM downloads the package, then retry." >&2
    exit 1
fi

echo "Copying package from:"
echo "  $PACKAGE_SOURCE"
echo "to:"
echo "  $PACKAGE_DEST"
rm -rf "$PACKAGE_DEST"
cp -R "$PACKAGE_SOURCE" "$PACKAGE_DEST"

echo "Applying passthrough patch..."
if git -C "$PROJECT_ROOT" apply --check -p1 "$PATCH_FILE"; then
    git -C "$PROJECT_ROOT" apply -p1 "$PATCH_FILE"
    echo "Patch applied successfully."
else
    echo "Patch cannot be applied cleanly. The package may already be patched." >&2
    exit 1
fi

echo "Done. You can now build with the patched Meta OpenXR package."
