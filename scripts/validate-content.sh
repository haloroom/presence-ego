#!/usr/bin/env bash
# ==========================================================================
#  Content QA Validation Script
#  마크다운 콘텐츠 렌더링 품질 검수 자동화
#  Usage: bash scripts/validate-content.sh [파일명]
#    파일명 생략 시 모든 포스트 검수
# ==========================================================================

set -euo pipefail

CONTENT_DIR="src/content/posts"
DIST_DIR="dist/posts"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

# ── 헬퍼 함수 ──

log_pass() { echo -e "  ${GREEN}✓${NC} $1"; }
log_fail() { echo -e "  ${RED}✗${NC} $1"; ERRORS=$((ERRORS + 1)); }
log_warn() { echo -e "  ${YELLOW}⚠${NC} $1"; WARNINGS=$((WARNINGS + 1)); }

# ── 빌드 확인 ──

if [ ! -d "$DIST_DIR" ]; then
  echo -e "${YELLOW}빌드 결과(dist/)가 없습니다. npm run build 실행 중...${NC}"
  npm run build --silent
fi

# ── 검수 대상 결정 ──

if [ $# -gt 0 ]; then
  TARGET_SLUG="$1"
  MD_FILES=("${CONTENT_DIR}/${TARGET_SLUG}.md")
  if [ ! -f "${MD_FILES[0]}" ]; then
    echo -e "${RED}파일을 찾을 수 없습니다: ${MD_FILES[0]}${NC}"
    exit 1
  fi
else
  MD_FILES=(${CONTENT_DIR}/*.md)
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " 콘텐츠 QA 검수 (${#MD_FILES[@]}개 파일)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for MD_FILE in "${MD_FILES[@]}"; do
  SLUG=$(basename "$MD_FILE" .md)
  HTML_FILE="${DIST_DIR}/${SLUG}/index.html"

  echo ""
  echo "📄 ${SLUG}"

  if [ ! -f "$HTML_FILE" ]; then
    log_warn "빌드 결과 없음 (draft이거나 빌드 필요)"
    continue
  fi

  # ── 1. 볼드/이탤릭 마크업 검증 ──

  # HTML에서 script, style, code 태그와 모든 HTML 태그를 제거한 뒤
  # raw * 가 남아있는지 확인 (정상 렌더링이면 <em>/<strong>으로 변환됨)
  UNMATCHED_BOLD=$(sed 's/<script[^>]*>.*<\/script>//g; s/<style[^>]*>.*<\/style>//g; s/<code>[^<]*<\/code>//g; s/<[^>]*>//g' "$HTML_FILE" 2>/dev/null | grep -oE '\*[^*]+\*' | head -3 || true)
  if [ -n "$UNMATCHED_BOLD" ]; then
    log_fail "볼드 마크업 잔여: ${UNMATCHED_BOLD}"
  else
    log_pass "볼드/이탤릭 마크업 정상"
  fi

  # ── 2. 취소선 검증 ──

  STRIKETHROUGH=$(grep -oE '<del>[^<]+</del>' "$HTML_FILE" 2>/dev/null || true)
  if [ -n "$STRIKETHROUGH" ]; then
    # 의도된 취소선인지 확인 (마크다운 원본에 ~~가 있는지)
    HAS_INTENTIONAL=$(grep -c '~~' "$MD_FILE" 2>/dev/null || echo "0")
    if [ "$HAS_INTENTIONAL" -eq 0 ]; then
      log_fail "의도하지 않은 취소선 발견: ${STRIKETHROUGH}"
    else
      log_pass "취소선 존재 (의도적 ~~사용 확인됨)"
    fi
  else
    log_pass "취소선 없음"
  fi

  # ── 3. 테이블 레이아웃 검증 ──

  TABLE_COUNT=$(grep -c '<table>' "$HTML_FILE" 2>/dev/null | tr -d '[:space:]' || echo "0")
  if [ "$TABLE_COUNT" -gt 0 ]; then
    # 마크다운 원본에서 한 줄에 셀이 너무 많거나 셀 내용이 긴 표 감지
    WIDE_TABLES=$(grep '^|' "$MD_FILE" | awk -F'|' '{if(NF > 8) print NR": "NF-1"열"}' | head -3)
    if [ -n "$WIDE_TABLES" ]; then
      log_warn "넓은 테이블 감지 (6열 이상, 가로 스크롤 확인 필요): ${WIDE_TABLES}"
    else
      log_pass "테이블 ${TABLE_COUNT}개 — 열 수 적정"
    fi
  else
    log_pass "테이블 없음"
  fi

  # ── 4. 하이퍼링크 검증 ──

  # 외부 링크 스크립트가 빌드 결과에 포함되어 있는지 확인
  HAS_LINK_SCRIPT=$(grep -c 'post-content a\[href' "$HTML_FILE" 2>/dev/null | tr -d '[:space:]' || echo "0")
  EXTERNAL_LINKS=$(grep -oE 'href="https?://[^"]+' "$HTML_FILE" 2>/dev/null | wc -l | tr -d '[:space:]')

  if [ "$EXTERNAL_LINKS" -gt 0 ]; then
    if [ "$HAS_LINK_SCRIPT" -gt 0 ]; then
      log_pass "외부 링크 ${EXTERNAL_LINKS}개 — 새 탭 스크립트 포함됨"
    else
      log_fail "외부 링크 ${EXTERNAL_LINKS}개 있으나 새 탭 스크립트 미포함"
    fi
  else
    log_pass "외부 링크 없음"
  fi

  # ── 5. 같은 줄 다중 틸드 사전 경고 ──

  # 표(|로 시작) 안의 ~는 셀 구분으로 안전하므로 제외
  MULTI_TILDE_LINES=$(grep -n '~[^~]*~' "$MD_FILE" | grep -v '~~' | grep -v '^ *#' | grep -v '```' | grep -v '^[0-9]*:|' | head -3 || true)
  if [ -n "$MULTI_TILDE_LINES" ]; then
    # 이미 이스케이프된 것은 제외
    UNESCAPED=$(echo "$MULTI_TILDE_LINES" | grep -v '&#126;' || true)
    if [ -n "$UNESCAPED" ]; then
      log_warn "같은 줄에 ~가 2개 이상 (취소선 위험): ${UNESCAPED}"
    else
      log_pass "다중 틸드 이스케이프 처리됨"
    fi
  else
    log_pass "다중 틸드 위험 없음"
  fi

done

# ── 결과 요약 ──

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -gt 0 ]; then
  echo -e " ${RED}검수 실패${NC}: ${ERRORS}개 오류, ${WARNINGS}개 경고"
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo -e " ${YELLOW}검수 통과 (경고 있음)${NC}: ${WARNINGS}개 경고"
else
  echo -e " ${GREEN}검수 통과${NC}: 모든 항목 정상 ✨"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
