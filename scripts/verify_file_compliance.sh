#!/usr/bin/env bash
# verify_file_compliance.sh — Post-creation compliance verification
#
# Usage:
#   bash verify_file_compliance.sh --file <path-to-created-file>
#   bash verify_file_compliance.sh --file specs/spec-my-feature.md --project .
#
# Exit codes:
#   0 = All checks passed
#   1 = Warnings found (auto-fixable or minor)
#   2 = Critical violations found

set -euo pipefail

# ── Configuration ──────────────────────────────────────────────
PROJECT_ROOT="${PROJECT_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# ── Argument parsing ───────────────────────────────────────────
FILE=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --file) FILE="$2"; shift 2 ;;
        --project) PROJECT_ROOT="$2"; shift 2 ;;
        --help|-h)
            echo "Usage: verify_file_compliance.sh --file <path> [--project <dir>]"
            exit 0
            ;;
        *) echo "Unknown argument: $1"; exit 2 ;;
    esac
done

if [[ -z "$FILE" ]]; then
    echo -e "${RED}ERROR: --file is required${NC}"
    exit 2
fi

ABSOLUTE_PATH="$PROJECT_ROOT/$FILE"
if [[ ! -f "$ABSOLUTE_PATH" ]]; then
    echo -e "${RED}ERROR: File not found: ${ABSOLUTE_PATH}${NC}"
    exit 2
fi

EXIT_CODE=0
FILENAME=$(basename "$FILE")
STEM="${FILENAME%.*}"
PREFIX="${STEM%%-*}"

echo -e "${GREEN}═══ Verifying compliance: ${FILE} ═══${NC}"
echo ""

# ── Check 1: Required sections ────────────────────────────────
echo "─── [1/7] Required sections check ───"
case "$PREFIX" in
    spec)    SECTION_PATTERN="Executive Summary|Core Objectives|Architecture|Security & Privacy|Status" ;;
    context) SECTION_PATTERN="Purpose|Rules|Guidelines|Scope" ;;
    plan)    SECTION_PATTERN="Goal|Phases|Steps|Timeline|Success Criteria" ;;
    ref)     SECTION_PATTERN="Source|Effective Date|Notes" ;;
    notes)   SECTION_PATTERN="Context|Observations|Key Points|Date" ;;
    *)       SECTION_PATTERN="" ;;
esac

if [[ -n "$SECTION_PATTERN" ]]; then
    ALL_FOUND=true
    IFS='|' read -ra SECTIONS <<< "$SECTION_PATTERN"
    for section in "${SECTIONS[@]}"; do
        if grep -qi "^## ${section}" "$ABSOLUTE_PATH"; then
            echo -e "${GREEN}  ✓ ${section}${NC}"
        else
            echo -e "${YELLOW}  ⚠ Missing: ${section}${NC}"
            ALL_FOUND=false
        fi
    done
    if [[ "$ALL_FOUND" == false ]]; then
        EXIT_CODE=1
    fi
else
    echo -e "${YELLOW}  ⚠ Unknown prefix '${PREFIX}', cannot verify required sections${NC}"
    EXIT_CODE=1
fi

# ── Check 2: No placeholder content ───────────────────────────
echo ""
echo "─── [2/7] Placeholder check ───"
PLACEHOLDERS=$(grep -ic "TODO\|FIXME\|XXX\|to be filled\|TBD" "$ABSOLUTE_PATH" || true)
if [[ "$PLACEHOLDERS" -gt 0 ]]; then
    echo -e "${YELLOW}  ⚠ Found ${PLACEHOLDERS} placeholder(s) (TODO/FIXME/XXX/TBD)${NC}"
    echo -e "${YELLOW}  → Manual: Resolve before committing${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ No placeholders found${NC}"
fi

# ── Check 3: Markdown only (no HTML) ──────────────────────────
echo ""
echo "─── [3/7] Markdown-only check ───"
HTML_TAGS=$(grep -cE '<(div|span|style|font|center|marquee)[^>]*>' "$ABSOLUTE_PATH" || true)
if [[ "$HTML_TAGS" -gt 0 ]]; then
    echo -e "${YELLOW}  ⚠ Found ${HTML_TAGS} HTML tag(s). Use Markdown only.${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ No HTML tags found${NC}"
fi

# ── Check 4: Markdown formatting quality ──────────────────────
echo ""
echo "─── [4/7] Markdown formatting check ───"

# Check for broken tables (lines with | that don't align)
TABLE_LINES=$(grep -c '|' "$ABSOLUTE_PATH" || true)
if [[ "$TABLE_LINES" -gt 0 ]]; then
    UNPAIRED_PIPES=$(grep -c '^[^|]*|[^|]*$' "$ABSOLUTE_PATH" || true)
    if [[ "$UNPAIRED_PIPES" -gt 0 ]]; then
        echo -e "${YELLOW}  ⚠ ${UNPAIRED_PIPES} line(s) have unpaired pipes (possible broken table)${NC}"
        EXIT_CODE=1
    else
        echo -e "${GREEN}  ✓ Table formatting looks consistent${NC}"
    fi
else
    echo -e "${GREEN}  ✓ No tables to check${NC}"
fi

# Check for proper heading hierarchy (no jumps from H1 to H3)
H1_COUNT=$(grep -c '^# ' "$ABSOLUTE_PATH" || true)
H2_COUNT=$(grep -c '^## ' "$ABSOLUTE_PATH" || true)
H3_COUNT=$(grep -c '^### ' "$ABSOLUTE_PATH" || true)
if [[ "$H1_COUNT" -gt 1 ]]; then
    echo -e "${YELLOW}  ⚠ Multiple H1 headings (${H1_COUNT}). Should have exactly one title.${NC}"
    EXIT_CODE=1
elif [[ "$H1_COUNT" -eq 0 ]]; then
    echo -e "${YELLOW}  ⚠ No H1 heading found. File should start with a title.${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ Heading hierarchy: 1 H1, ${H2_COUNT} H2, ${H3_COUNT} H3${NC}"
fi

# ── Check 5: File length ──────────────────────────────────────
echo ""
echo "─── [5/7] File length check ───"
LINE_COUNT=$(wc -l < "$ABSOLUTE_PATH")
if [[ "$LINE_COUNT" -gt 150 ]]; then
    echo -e "${YELLOW}  ⚠ File is ${LINE_COUNT} lines (recommended max: 150). Consider splitting.${NC}"
    echo -e "${YELLOW}  → Manual: Split by sub-topic with consistent prefix${NC}"
    EXIT_CODE=1
else
    echo -e "${GREEN}  ✓ ${LINE_COUNT} lines (under 150 limit)${NC}"
fi

# ── Check 6: Security/privacy mention ─────────────────────────
echo ""
echo "─── [6/7] Security & privacy check ───"
if [[ "$PREFIX" == "spec" ]]; then
    if grep -qi "security\|privacy\|local.*only\|no.*cloud\|data.*handling" "$ABSOLUTE_PATH"; then
        echo -e "${GREEN}  ✓ Security/privacy mentioned${NC}"
    else
        echo -e "${YELLOW}  ⚠ No security/privacy section found. Add one for clarity.${NC}"
        EXIT_CODE=1
    fi
else
    echo -e "${GREEN}  ✓ Skipping (not a spec file)${NC}"
fi

# ── Check 7: Cross-reference verification ─────────────────────
echo ""
echo "─── [7/7] Cross-reference check ───"
TOPIC="${STEM#*-}"
SPEC_DIR="$PROJECT_ROOT/specs"
if [[ -d "$SPEC_DIR" && "$PREFIX" != "notes" ]]; then
    # Check if any other file in specs/ references this new file
    REFERENCES=$(grep -rl "$STEM\|$TOPIC" "$SPEC_DIR" 2>/dev/null || true)
    if [[ -z "$REFERENCES" ]]; then
        echo -e "${YELLOW}  ℹ No references to this file found in other specs/ files${NC}"
        echo -e "${YELLOW}  → Consider: Add cross-references in related files${NC}"
    else
        echo -e "${GREEN}  ✓ Referenced by:${NC}"
        echo "$REFERENCES" | while read -r r; do
            echo -e "${GREEN}    → ${r#$PROJECT_ROOT/}${NC}"
        done
    fi
fi

# ── Summary ────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}═══ Verification complete ═══${NC}"
case $EXIT_CODE in
    0)
        echo -e "${GREEN}Result: All checks passed. File is compliant.${NC}"
        ;;
    1)
        echo -e "${YELLOW}Result: Warnings found. Review and fix before committing.${NC}"
        ;;
    2)
        echo -e "${RED}Result: Critical violations. Must fix before committing.${NC}"
        ;;
esac

exit $EXIT_CODE
