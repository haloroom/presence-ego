#!/bin/bash
# validate-docs.sh
# 문서 무결성을 검증합니다.
#
# Usage: bash scripts/validate-docs.sh

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0

echo "🔍 Document Validation"
echo "================================"

# 1. 필수 파일 존재 확인
echo ""
echo "📁 Required Files Check:"

REQUIRED_FILES=(
    "README.md"
    "AGENTS.md"
    "CLAUDE.md"
    ".gitignore"
    ".agents/AGENTS.md"
    ".agents/skills/project-conventions/SKILL.md"
    "docs/ARCHITECTURE.md"
    "docs/TECH_STACK.md"
    "docs/CONVENTIONS.md"
    "docs/GLOSSARY.md"
    "docs/adr/_template.md"
    "docs/adr/README.md"
    "docs/specs/_template.md"
    "docs/specs/README.md"
    "docs/guides/onboarding.md"
    ".state/PROJECT_STATUS.md"
    ".state/CHANGELOG.md"
    ".state/SESSION_LOG.md"
    ".state/DECISIONS_LOG.md"
    ".state/KNOWN_ISSUES.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$PROJECT_ROOT/$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file - MISSING!"
        ((ERRORS++))
    fi
done

# 2. Token Budget 검증
echo ""
echo "📊 Token Budget Validation:"

check_budget() {
    local file="$1"
    local max="$2"

    if [ -f "$PROJECT_ROOT/$file" ]; then
        local lines
        lines=$(wc -l < "$PROJECT_ROOT/$file" | tr -d ' ')
        if [ "$lines" -gt "$max" ]; then
            echo "  ⚠️  $file: ${lines}줄 > ${max}줄 limit"
            ((WARNINGS++))
        else
            echo "  ✅ $file: ${lines}/${max}줄"
        fi
    fi
}

check_budget "README.md" 200
check_budget "AGENTS.md" 150
check_budget "docs/ARCHITECTURE.md" 300
check_budget "docs/TECH_STACK.md" 200
check_budget "docs/CONVENTIONS.md" 250
check_budget "docs/GLOSSARY.md" 100

# .state/ 파일들 체크
for state_file in "$PROJECT_ROOT/.state/"*.md; do
    if [ -f "$state_file" ]; then
        local_name=".state/$(basename "$state_file")"
        check_budget "$local_name" 100
    fi
done

# 3. YAML Frontmatter 존재 확인 (docs/ 파일)
echo ""
echo "📝 YAML Frontmatter Check (docs/):"

check_frontmatter() {
    local file="$1"
    if [ -f "$PROJECT_ROOT/$file" ]; then
        if head -1 "$PROJECT_ROOT/$file" | grep -q "^---$"; then
            echo "  ✅ $file"
        else
            echo "  ⚠️  $file - No YAML frontmatter"
            ((WARNINGS++))
        fi
    fi
}

check_frontmatter "docs/ARCHITECTURE.md"
check_frontmatter "docs/TECH_STACK.md"
check_frontmatter "docs/CONVENTIONS.md"
check_frontmatter "docs/GLOSSARY.md"
check_frontmatter ".state/PROJECT_STATUS.md"
check_frontmatter ".state/SESSION_LOG.md"

# 4. ADR 인덱스 일관성 확인
echo ""
echo "📋 ADR Index Consistency:"

ADR_COUNT=$(find "$PROJECT_ROOT/docs/adr" -name "[0-9]*.md" 2>/dev/null | wc -l | tr -d ' ')
ADR_INDEX_COUNT=$(grep -cE "^\| 0[0-9]{2} " "$PROJECT_ROOT/docs/adr/README.md" 2>/dev/null || echo "0")

echo "  ADR files: $ADR_COUNT"
echo "  ADR index entries: $ADR_INDEX_COUNT"

if [ "$ADR_COUNT" != "$ADR_INDEX_COUNT" ]; then
    echo "  ⚠️  ADR 파일 수와 인덱스 엔트리 수가 다릅니다"
    ((WARNINGS++))
else
    echo "  ✅ ADR 인덱스 일관성 OK"
fi

# 5. 결과 요약
echo ""
echo "================================"
echo "📊 Validation Summary"
echo "  Errors:   $ERRORS"
echo "  Warnings: $WARNINGS"

if [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo "❌ Validation FAILED with $ERRORS error(s)"
    exit 1
elif [ "$WARNINGS" -gt 0 ]; then
    echo ""
    echo "⚠️  Validation PASSED with $WARNINGS warning(s)"
    exit 0
else
    echo ""
    echo "✅ Validation PASSED - All checks OK!"
    exit 0
fi
