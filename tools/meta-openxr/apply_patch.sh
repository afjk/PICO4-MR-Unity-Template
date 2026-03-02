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

# -- Verification ----------------------------------------------------------
# The patch creates this new file (absent in the unpatched package) and adds
# a reference to it inside an existing file.  Both checks must pass.
VERIFY_NEW_FILE="$PACKAGE_DEST/Runtime/Subsystems/Camera/PassthroughInitializationGate.cs"
VERIFY_MODIFIED_FILE="$PACKAGE_DEST/Runtime/CompositionLayers/MetaOpenXRPassthroughLayer.cs"
VERIFY_GREP_PATTERN="PassthroughInitializationGate"

verify_patch_applied() {
    [[ -f "$VERIFY_NEW_FILE" ]] \
        && grep -q "$VERIFY_GREP_PATTERN" "$VERIFY_MODIFIED_FILE" 2>/dev/null
}

reset_package() {
    rm -rf "$PACKAGE_DEST"
    cp -R "$PACKAGE_SOURCE" "$PACKAGE_DEST"
}

# -- Apply patch (highest-confidence method first) -------------------------
echo "Applying passthrough patch..."
PATCH_APPLIED=false

# 1) patch -p1 --batch  -- handles CRLF transparently on all platforms, non-interactive
if command -v patch >/dev/null 2>&1; then
    echo "  Trying: patch -p1 --batch ..."
    if (cd "$PROJECT_ROOT" && patch -p1 --batch < "$PATCH_FILE"); then
        if verify_patch_applied; then
            echo "  Patch applied successfully via 'patch -p1 --batch'."
            PATCH_APPLIED=true
        else
            echo "  Warning: 'patch -p1 --batch' reported success but verification failed."
        fi
    else
        echo "  'patch -p1 --batch' did not apply cleanly."
    fi
else
    echo "  'patch' command not found, skipping."
fi

# 2) git apply --ignore-whitespace  -- tolerates CRLF/LF differences
if [[ "$PATCH_APPLIED" != "true" ]]; then
    if command -v git >/dev/null 2>&1; then
        echo "  Trying: git apply --ignore-whitespace ..."
        reset_package
        if git -C "$PROJECT_ROOT" apply --ignore-whitespace -p1 "$PATCH_FILE" 2>/dev/null; then
            if verify_patch_applied; then
                echo "  Patch applied successfully via 'git apply --ignore-whitespace'."
                PATCH_APPLIED=true
            else
                echo "  Warning: 'git apply --ignore-whitespace' reported success but verification failed."
            fi
        else
            echo "  'git apply --ignore-whitespace' did not apply cleanly."
        fi
    else
        echo "  'git' command not found, skipping."
    fi
fi

# 3) git apply  -- standard method
if [[ "$PATCH_APPLIED" != "true" ]]; then
    if command -v git >/dev/null 2>&1; then
        echo "  Trying: git apply ..."
        reset_package
        if git -C "$PROJECT_ROOT" apply -p1 "$PATCH_FILE" 2>/dev/null; then
            if verify_patch_applied; then
                echo "  Patch applied successfully via 'git apply'."
                PATCH_APPLIED=true
            else
                echo "  Warning: 'git apply' reported success but verification failed."
            fi
        else
            echo "  'git apply' did not apply cleanly."
        fi
    else
        echo "  'git' command not found, skipping."
    fi
fi

# -- Result ----------------------------------------------------------------
if [[ "$PATCH_APPLIED" != "true" ]]; then
    echo "" >&2
    echo "ERROR: All patch methods failed." >&2
    echo "The package version may be incompatible with the patch." >&2
    echo "  Package source: $PACKAGE_SOURCE" >&2
    echo "  Patch file:     $PATCH_FILE" >&2
    rm -rf "$PACKAGE_DEST"
    exit 1
fi

echo "Done. You can now build with the patched Meta OpenXR package."
