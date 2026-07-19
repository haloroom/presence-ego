#!/bin/bash
# ai-context-update.sh
# 프로젝트 상태 파일을 자동으로 갱신합니다.
#
# Usage: bash scripts/ai-context-update.sh [OPTIONS]

set -euo pipefail

MODE="full"
SINCE_DATE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --diff) MODE="diff"; shift ;;
        --impact) MODE="impact"; shift ;;
        --since) SINCE_DATE="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: bash scripts/ai-context-update.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --diff      Show files changed since last update"
            echo "  --impact    Show impacted docs for recent changes"
            echo "  --since     Date to check changes from (YYYY-MM-DD)"
            echo "  -h          Help"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STATE_DIR="$PROJECT_ROOT/.state"
TODAY=$(date +%Y-%m-%d)

echo "🔄 AI Context Update - $TODAY (Mode: $MODE)"
echo "================================"

if [[ "$MODE" == "diff" || "$MODE" == "impact" ]]; then
    if [ -z "$SINCE_DATE" ]; then
        if [ -f "$STATE_DIR/PROJECT_STATUS.md" ]; then
            SINCE_DATE=$(grep "^last_updated:" "$STATE_DIR/PROJECT_STATUS.md" | awk '{print $2}' || echo "1.week.ago")
        else
            SINCE_DATE="1.week.ago"
        fi
    fi
    echo "📅 Checking changes since $SINCE_DATE"
    CHANGED_FILES=$(cd "$PROJECT_ROOT" && git log --since="$SINCE_DATE" --name-only --pretty=format:"" 2>/dev/null | grep -v '^$' | sort -u || true)
    
    echo -e "\n📂 Changed Files by Directory:"
    if [ -z "$CHANGED_FILES" ]; then
        echo "No files changed."
    else
        echo "$CHANGED_FILES" | awk -F/ '{if (NF>1) print $1"/"; else print "./"}' | sort | uniq -c
    fi

    if [[ "$MODE" == "impact" ]]; then
        echo -e "\n🎯 Impact Analysis (Docs to Update):"
        IMPACTED_DOCS=()
        
        if echo "$CHANGED_FILES" | grep -q "^src/"; then
            IMPACTED_DOCS+=("docs/ARCHITECTURE.md - src/ files changed")
        fi
        if echo "$CHANGED_FILES" | grep -qE "^package\.json$"; then
            IMPACTED_DOCS+=("docs/TECH_STACK.md - Dependency files changed")
        fi
        if echo "$CHANGED_FILES" | grep -q "^src/content/"; then
            IMPACTED_DOCS+=("Content structure changed - check categories")
        fi

        if [ ${#IMPACTED_DOCS[@]} -eq 0 ]; then
            echo "No major docs impact detected."
        else
            for doc in "${IMPACTED_DOCS[@]}"; do
                echo "- $doc"
            done
        fi
    fi
    exit 0
fi

# 1. PROJECT_STATUS.md의 last_updated 갱신
if [ -f "$STATE_DIR/PROJECT_STATUS.md" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^last_updated:.*/last_updated: $TODAY/" "$STATE_DIR/PROJECT_STATUS.md"
    else
        sed -i "s/^last_updated:.*/last_updated: $TODAY/" "$STATE_DIR/PROJECT_STATUS.md"
    fi
    echo "✅ PROJECT_STATUS.md - last_updated 갱신됨"
fi

# 2. 최근 git 커밋 로그
if command -v git &> /dev/null && git rev-parse --is-inside-work-tree &> /dev/null; then
    RECENT_COMMITS=$(cd "$PROJECT_ROOT" && git log --oneline -5 2>/dev/null || echo "No commits yet")
    echo ""
    echo "📋 Recent Commits (최근 5개):"
    echo "$RECENT_COMMITS"
    echo ""
    echo "💡 위 커밋들을 .state/CHANGELOG.md에 반영해주세요."
else
    echo "⚠️  Git 레포지토리가 아니거나 git이 설치되지 않았습니다."
fi

# 3. SESSION_LOG.md의 last_session 갱신
if [ -f "$STATE_DIR/SESSION_LOG.md" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^last_session:.*/last_session: $TODAY/" "$STATE_DIR/SESSION_LOG.md"
    else
        sed -i "s/^last_session:.*/last_session: $TODAY/" "$STATE_DIR/SESSION_LOG.md"
    fi
    echo "✅ SESSION_LOG.md - last_session 갱신됨"
fi

# 4. Token Budget 체크
echo ""
echo "📊 Token Budget Check:"
echo "================================"

check_lines() {
    local file="$1"
    local max="$2"
    local label="$3"

    if [ -f "$file" ]; then
        local lines
        lines=$(wc -l < "$file" | tr -d ' ')
        if [ "$lines" -gt "$max" ]; then
            echo "⚠️  $label: ${lines}줄 (max: ${max}줄) - OVER BUDGET"
        else
            echo "✅ $label: ${lines}줄 (max: ${max}줄)"
        fi
    fi
}

check_lines "$PROJECT_ROOT/README.md" 200 "README.md"
check_lines "$PROJECT_ROOT/AGENTS.md" 150 "AGENTS.md"
check_lines "$PROJECT_ROOT/docs/ARCHITECTURE.md" 300 "docs/ARCHITECTURE.md"

# .state/ 파일들 체크
for state_file in "$STATE_DIR/"*.md; do
    if [ -f "$state_file" ]; then
        check_lines "$state_file" 100 ".state/$(basename "$state_file")"
    fi
done

# 5. Dependency change detection
echo ""
echo "📦 Dependency Change Check:"
echo "================================"
if command -v git &> /dev/null && git rev-parse --is-inside-work-tree &> /dev/null; then
    SINCE_LAST=$(grep "^last_updated:" "$STATE_DIR/PROJECT_STATUS.md" 2>/dev/null | awk '{print $2}' || echo "1.week.ago")
    DEP_CHANGED=$(cd "$PROJECT_ROOT" && git log --since="$SINCE_LAST" --name-only --pretty=format:"" 2>/dev/null | grep -E "^package\.json$" || true)
    
    if [ -n "$DEP_CHANGED" ]; then
        echo "⚠️  Dependencies have changed since $SINCE_LAST (package.json modified)."
        echo "💡 Please update docs/TECH_STACK.md if new dependencies were added."
    else
        echo "✅ No dependency file changes detected."
    fi
else
    echo "⚠️  Skipped (Not a git repository)."
fi

echo ""
echo "✅ Context update complete!"
