# Project: presence-ego

> 에크하르트 톨레의 철학에서 영감받은 개인 탐구 블로그 — 현존(Presence)과 에고(Ego) 사이의 자기 탐구

## Identity

- **Project**: presence-ego — 개인 탐구 블로그
- **Purpose**: 공부, 독서, 느낌을 기록하며 현존과 에고 사이에서 진실된 자기 탐구
- **Languages**: TypeScript, Markdown, Astro
- **Docs**: `docs/` 디렉토리 참조

## Core Principles

1. **Progressive Disclosure** — 필요한 시점에 필요한 깊이의 정보만 로드
2. **Token Budget** — 각 문서는 정해진 줄 수 제한 준수
3. **Spec First** — 코드 작성 전에 반드시 스펙(docs/specs/) 확인 또는 작성
4. **Living Docs** — 코드 변경 시 관련 문서 반드시 동기화
5. **State Persistence** — 세션 상태는 .state/ 디렉토리에 기록

## Commands

```bash
# Development
npm run dev          # 개발 서버 시작
npm run build        # 프로덕션 빌드
npm run preview      # 빌드 미리보기

# Documentation
bash scripts/validate-docs.sh    # 문서 무결성 검증
bash scripts/ai-context-update.sh  # 상태 파일 갱신
```

## File Organization

| Directory | Purpose |
|:---|:---|
| `.agents/` | Antigravity 워크스페이스 설정 |
| `docs/` | 문서 허브 (아키텍처, 스펙, ADR, 컨벤션) |
| `.state/` | 프로젝트 상태 관리 (Memory Bank) |
| `scripts/` | 자동화 스크립트 |
| `src/` | 소스 코드 (Astro 페이지, 컴포넌트, 레이아웃) |
| `src/content/` | 블로그 콘텐츠 (Markdown) |
| `src/components/` | Astro/UI 컴포넌트 |
| `src/layouts/` | 페이지 레이아웃 |
| `src/pages/` | 라우트 페이지 |
| `src/styles/` | 글로벌 스타일 |
| `public/` | 정적 에셋 |

## Content Structure

블로그 콘텐츠는 `src/content/` 디렉토리에 Markdown으로 작성됩니다.

### 카테고리
- **reading**: 독서 기록과 인사이트
- **study**: 공부한 내용 정리
- **reflection**: 내면 탐구와 느낌 기록
- **essay**: 자유 에세이

### Frontmatter 형식
```yaml
---
title: "글 제목"
description: "짧은 설명"
category: reading | study | reflection | essay
tags: ["태그1", "태그2"]
pubDate: 2026-07-19
updatedDate: 2026-07-19
draft: false
---
```

## Coding Standards

### General
- 모든 함수에 JSDoc 작성
- 매직 넘버 사용 금지 → 상수로 정의
- 함수는 단일 책임 원칙(SRP) 준수
- 최대 함수 길이: 50줄 / 최대 파일 길이: 300줄
- Early return 패턴 사용

### Naming
- 파일: `kebab-case` (e.g., `blog-post.astro`)
- 컴포넌트: `PascalCase` (e.g., `PostCard.astro`)
- 함수·변수: `camelCase`
- 상수: `UPPER_SNAKE_CASE`

### Error Handling
- 에러를 무시하지 않기 (catch 후 최소한 로깅)
- 에러 메시지는 구체적이고 actionable하게

### Import Ordering
1. Astro 내장 모듈 → 2. 외부 패키지 → 3. 내부 모듈 → 4. 상대 경로 → 5. 타입

### Git
- Conventional Commits: `type(scope): description`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `content`

## State Management Protocol

### Session Start
1. `.state/SESSION_LOG.md` 읽기 → 이전 세션 핸드오프 확인
2. `.state/PROJECT_STATUS.md` 읽기 → 현재 상태 파악
3. `.state/KNOWN_ISSUES.md` 확인 → 알려진 이슈 인지

### Session End
1. `.state/SESSION_LOG.md` 업데이트 → 핸드오프 노트 작성
2. `.state/CHANGELOG.md` 업데이트 → 변경사항 추가
3. 주요 결정이 있었다면 → `docs/adr/` 또는 `.state/DECISIONS_LOG.md` 기록

## Token Budget

| File Type | Max Lines | Load Condition |
|:---|:---:|:---|
| `README.md` | 200 | Always |
| `AGENTS.md` | 150 | Always |
| `docs/ARCHITECTURE.md` | 300 | Architecture work |
| `docs/specs/*.md` | 200 | Feature implementation |
| `docs/adr/*.md` | 100 | Decision review |
| `.state/*.md` | 100 | Session start/end |

## Constraints

- ❌ `Accepted` 상태의 ADR을 삭제하거나 내용 변경하지 않기
- ❌ Token Budget을 초과하는 문서 작성 금지
- ✅ 코드 변경 시 관련 문서 반드시 업데이트
- ✅ 커밋 전 `bash scripts/validate-docs.sh` 실행
