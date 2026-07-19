# Workspace AI Agent Rules

## Project Context
presence-ego는 에크하르트 톨레의 'A New Earth'에서 영감받은 개인 탐구 블로그입니다.
현존(Presence)과 에고(Ego) 사이에서 공부, 독서, 느낌을 기록하며 진실된 자기 탐구를 합니다.

## Tech Stack
- **Framework**: Astro
- **Language**: TypeScript
- **Content**: Markdown (Content Collections)
- **AI Tools**: Antigravity + Claude Code

## Detailed Coding Standards

### General
- 모든 함수에 JSDoc 작성
- 매직 넘버 사용 금지 → 상수로 정의
- 함수는 단일 책임 원칙(SRP) 준수
- 최대 함수 길이: 50줄 / 최대 파일 길이: 300줄
- 조기 반환(early return) 패턴 사용

### Naming Conventions
| Type | Convention | Example |
|:---|:---|:---|
| File | kebab-case | `blog-post.astro` |
| Component | PascalCase | `PostCard.astro` |
| Function/Variable | camelCase | `getPostsByTag` |
| Constant | UPPER_SNAKE_CASE | `MAX_POSTS_PER_PAGE` |
| Content file | kebab-case | `a-new-earth-review.md` |

### Astro-Specific
- 컴포넌트는 `.astro` 확장자 사용
- 클라이언트 사이드 JS는 최소화 (Astro Islands 패턴)
- Content Collections로 블로그 콘텐츠 관리
- 이미지 최적화를 위해 Astro Image 사용

### Error Handling
- 에러는 절대 무시하지 않기 (catch 후 최소한 로깅)
- 에러 메시지는 구체적이고 actionable하게

### Import Ordering
1. Astro 내장 모듈
2. 외부 패키지
3. 내부 모듈 (절대 경로)
4. 상대 경로 임포트
5. 타입 임포트

### Git Commit Messages
- Conventional Commits 형식: `type(scope): description`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `content`
- `content` 타입은 블로그 글 추가/수정 시 사용

## Documentation Maintenance
- 코드 변경 시 관련 문서 반드시 업데이트
- 스펙 변경 시 `docs/specs/` 먼저 업데이트 후 코드 수정

## Token Budget Guidelines
| 파일 유형 | 최대 줄 수 |
|:---|:---:|
| AGENTS.md (root) | 150 |
| docs/ARCHITECTURE.md | 300 |
| docs/specs/*.md | 200 |
| docs/adr/*.md | 100 |
| .state/*.md | 100 |

## Handoff Protocol

### 세션 시작 시
1. `.state/SESSION_LOG.md` 읽기
2. `.state/PROJECT_STATUS.md` 읽기
3. 이전 세션의 미완료 작업 확인

### 세션 종료 시
1. `.state/SESSION_LOG.md` 업데이트
2. `.state/CHANGELOG.md`에 변경사항 추가
3. 주요 결정이 있었다면 `docs/adr/` 또는 `.state/DECISIONS_LOG.md` 기록
