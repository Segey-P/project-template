#!/usr/bin/env bash
# validate_file_creation.sh — Pre-creation validation for new files
#
# Usage:
#   bash validate_file_creation.sh --file <proposed-path>
#   bash validate_file_creation.sh --file specs/spec-my-feature.md
#
# Exit codes:
#   0 = All checks passed, safe to create
#   1 = Auto-fixable violations found and fixed, safe to create
#   2 = Violations requiring human review, do not create
#
# This script is meant to be run by AI agents as part of the
# File Creation Protocol (see AGENTS.md and FILE_CREATION_GUIDE.md).

set -euo pipefail

# ── Configuration ──────────────────────────────────────────────
PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# ── Argument parsing ───────────────────────────────────────────
FILE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --file) FILE="$2"; shift 2 ;;
        --help|-h)
            echo "Usage: validate_file_creation.sh --file <proposed-path>"
            exit 0
            ;;
        *) echo "Unknown argument: $1"; exit 2 ;;
    esac
done

if [[ -z "$FILE" ]]; then
    echo -e "${RED}ERROR: --file is required${NC}"
    exit 2
fi

# ── State ──────────────────────────────────────────────────────
EXIT_CODE=0
FILENAME=$(basename "$FILE")
DIRNAME=$(dirname "$FILE")
EXTENSION="${FILENAME##*.}"
STEM="${FILENAME%.*}"

echo -e "${GREEN}═══ Validating: ${FILE} ═══${NC}"
echo ""

# ── Check 1: Protected file check ─────────────────────────────
echo "─── [1/9] Protected file check ───"
PROTECTED_NAMES=("AGENTS.md" "opencode.json" "opencode.jsonc")
PROTECTED_PATTERNS=("financial" "finance" "ledger" "deploy" "deployment" "docker-compose")
PROTECTED_EXTS=("pem" "key" "env" "p12" "jks")

IS_PROTECTED=false
REASON=""

# Check exact filenames
for pn in "${PROTECTED_NAMES[@]}"; do
    if [[ "$FILENAME" == "$pn" ]]; then
        IS_PROTECTED=true
        REASON="Protected filename: $pn"
        break
    fi
done

# Check protected patterns in path
if [[ "$IS_PROTECTED" == false ]]; then
    FILE_LOWER=$(echo "$FILE" | tr '[:upper:]' '[:lower:]')
    for pp in "${PROTECTED_PATTERNS[@]}"; do
        if [[ "$FILE_LOWER" == *"$pp"* ]]; then
            IS_PROTECTED=true
            REASON="Path matches protected pattern: $pp"
            break
        fi
    done
fi

# Check protected extensions
if [[ "$IS_PROTECTED" == false ]]; then
    for pe in "${PROTECTED_EXTS[@]}"; do
        if [[ "$FILENAME" == *".$pe" ]]; then
            IS_PROTECTED=true
            REASON="Protected extension: .$pe"
            break
        fi
    done
fi

if [[ "$IS_PROTECTED" == true ]]; then
    echo -e "${RED}  ✗ ${REASON}${NC}"
    echo -e "${RED}  → Protected files require explicit human approval (see AGENTS.md)${NC}"
    echo -e "${RED}  → Stop: Do not create without user confirmation${NC}"
    exit 2
fi
echo -e "${GREEN}  ✓ Not a protected file${NC}"

# ── Check 2: Extension must be .md for spec files ─────────────
echo ""
echo "─── [2/9] Extension check ───"
if [[ "$DIRNAME" == "specs"* && "$EXTENSION" != "md" ]]; then
    echo -e "${YELLOW}  ⚠ WARNING: Spec files should be Markdown (.md), got .${EXTENSION}${NC}"
    echo -e "${YELLOW}  → Auto-fix: Rename to ${STEM}.md${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ Extension is .md${NC}"
fi

# ── Check 2: Type prefix ──────────────────────────────────────
echo ""
echo "─── [3/9] Type prefix check ───"
PREFIX="${STEM%%-*}"
VALID_PREFIXES=("spec" "context" "plan" "ref" "notes")
PREFIX_VALID=false
for p in "${VALID_PREFIXES[@]}"; do
    if [[ "$PREFIX" == "$p" ]]; then
        PREFIX_VALID=true
        break
    fi
done

if [[ "$PREFIX" == "$STEM" ]]; then
    echo -e "${YELLOW}  ⚠ No type prefix found in filename${NC}"
    echo -e "${YELLOW}  → Auto-fix: Rename to spec-${FILENAME} (assuming requirements)${NC}"
    echo -e "${YELLOW}  → Manual: Choose correct prefix: spec- context- plan- ref- notes-${NC}"
    EXIT_CODE=1
elif [[ "$PREFIX_VALID" == false ]]; then
    echo -e "${YELLOW}  ⚠ Unknown prefix '${PREFIX}'. Valid: ${VALID_PREFIXES[*]}${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ Valid type prefix: ${PREFIX}-${NC}"
fi

# ── Check 3: Lowercase only ───────────────────────────────────
echo ""
echo "─── [4/9] Lowercase check ───"
if [[ "$FILENAME" =~ [A-Z] ]]; then
    LOWERCASED=$(echo "$FILENAME" | tr '[:upper:]' '[:lower:]')
    echo -e "${YELLOW}  ⚠ Filename contains uppercase characters${NC}"
    echo -e "${YELLOW}  → Auto-fix: Rename to ${LOWERCASED}${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ All lowercase${NC}"
fi

# ── Check 4: Hyphens only (no underscores) ────────────────────
echo ""
echo "─── [5/9] Hyphen check ───"
if [[ "$FILENAME" =~ _ ]]; then
    HYPHENATED=$(echo "$FILENAME" | tr '_' '-')
    echo -e "${YELLOW}  ⚠ Filename contains underscores${NC}"
    echo -e "${YELLOW}  → Auto-fix: Rename to ${HYPHENATED}${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ Hyphens only${NC}"
fi

# ── Check 5: No version numbers in filename ───────────────────
echo ""
echo "─── [6/9] Version number check ───"
if [[ "$STEM" =~ -v[0-9] ]] || [[ "$STEM" =~ _v[0-9] ]] || [[ "$STEM" =~ [0-9]+\.[0-9]+ ]]; then
    echo -e "${YELLOW}  ⚠ Filename appears to contain a version number${NC}"
    echo -e "${YELLOW}  → Note: git tracks history, remove version from filename${NC}"
    echo -e "${YELLOW}  → Manual: Rename without version (e.g., spec-auth.md)${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ No version number detected${NC}"
fi

# ── Check 6: Duplicate detection ──────────────────────────────
echo ""
echo "─── [7/9] Duplicate check ───"
TOPIC="${STEM#*-}"  # Remove prefix (e.g., "spec-my-feature" -> "my-feature")
if [[ -n "$TOPIC" && "$TOPIC" != "$STEM" ]]; then
    PROJECT_SPECS_DIR="$PROJECT_ROOT/specs"
    if [[ -d "$PROJECT_SPECS_DIR" ]]; then
        DUPLICATES=$(find "$PROJECT_SPECS_DIR" -maxdepth 1 -name "*.md" \
            | while read -r f; do
                base=$(basename "$f" .md)
                f_topic="${base#*-}"
                if [[ "$f_topic" == "$TOPIC" ]]; then
                    echo "$f"
                fi
            done)
        if [[ -n "$DUPLICATES" ]]; then
            echo -e "${YELLOW}  ⚠ Potential duplicate found:${NC}"
            echo "$DUPLICATES" | while read -r d; do
                echo -e "${YELLOW}    → ${d}${NC}"
            done
            echo -e "${YELLOW}  → Manual: Review and update existing file instead${NC}"
            EXIT_CODE=2
        else
            echo -e "${GREEN}  ✓ No duplicate found${NC}"
        fi
    else
        echo -e "${YELLOW}  ⚠ No specs/ directory found at ${PROJECT_SPECS_DIR} (skipping)${NC}"
    fi
else
    echo -e "${YELLOW}  ⚠ Cannot determine topic for duplicate check${NC}"
fi

# ── Check 7: Directory correctness ────────────────────────────
echo ""
echo "─── [8/9] Directory check ───"
case "$PREFIX" in
    spec|context|plan|ref|notes)
        if [[ "$DIRNAME" != "specs" && "$DIRNAME" != "specs/"* && "$DIRNAME" != "." ]]; then
            echo -e "${YELLOW}  ⚠ Spec files belong in specs/ directory (trying to create in ${DIRNAME})${NC}"
            echo -e "${YELLOW}  → Auto-fix: Move to specs/${FILENAME}${NC}"
            EXIT_CODE=1
        else
            echo -e "${GREEN}  ✓ Correct directory for ${PREFIX} file${NC}"
        fi
        ;;
    *)
        echo -e "${GREEN}  ✓ Skipping directory check (non-spec or unknown prefix)${NC}"
        ;;
esac

# ── Check 8: File doesn't already exist ───────────────────────
echo ""
echo "─── [9/9] Existing file check ───"
ABSOLUTE_PATH="$PROJECT_ROOT/$FILE"
if [[ -f "$ABSOLUTE_PATH" ]]; then
    echo -e "${RED}  ✗ File already exists: ${ABSOLUTE_PATH}${NC}"
    echo -e "${RED}  → Stop: Update existing file instead of creating new one${NC}"
    EXIT_CODE=2
else
    echo -e "${GREEN}  ✓ File does not already exist${NC}"
fi

# ── Summary ────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}═══ Validation complete ═══${NC}"
case $EXIT_CODE in
    0)
        echo -e "${GREEN}Result: All checks passed. Safe to create.${NC}"
        ;;
    1)
        echo -e "${YELLOW}Result: Auto-fixable violations found. Fix and proceed.${NC}"
        ;;
    2)
        echo -e "${RED}Result: Blocking violations found. Do not create without review.${NC}"
        ;;
esac

exit $EXIT_CODE
