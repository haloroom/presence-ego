---
title: Coding Conventions
last_updated: 2026-07-19
status: active
---

# Coding Conventions

## File Naming

| Type | Convention | Example |
|:---|:---|:---|
| Astro pages | kebab-case | `blog-post.astro` |
| Components | PascalCase | `PostCard.astro` |
| Content files | kebab-case | `a-new-earth-review.md` |
| Utility files | kebab-case | `date-utils.ts` |
| Config | kebab-case | `astro.config.mjs` |
| Docs | UPPER_CASE | `ARCHITECTURE.md` |

## Code Style

### Do ✅

```typescript
// Early return pattern
function getPost(slug: string): Post | null {
  if (!slug) return null;
  return findPost(slug);
}

// Descriptive naming
const isPublished = post.draft !== true;

// Const assertion for categories
const CATEGORIES = ['reading', 'study', 'reflection', 'essay'] as const;
```

### Don't ❌

```typescript
// ❌ Deep nesting
function getPost(slug: string) {
  if (slug) {
    if (isValid(slug)) {
      // ...
    }
  }
}

// ❌ Magic numbers
if (posts.length > 10) { /* ... */ }

// ❌ Swallowing errors
try { doSomething(); } catch (e) {}
```

## Import Ordering

```typescript
// 1. Astro built-ins
import { getCollection } from 'astro:content';

// 2. External packages
import { format } from 'date-fns';

// 3. Internal modules (absolute path)
import { formatDate } from '@/utils/date-utils';

// 4. Relative imports
import PostCard from '../components/PostCard.astro';

// 5. Type-only imports
import type { CollectionEntry } from 'astro:content';
```

## Astro Component Guidelines

- 컴포넌트 script 영역은 `---` fence 안에 작성
- Props는 `Astro.props`로 접근
- 클라이언트 사이드 JS는 `client:` 디렉티브 사용 시에만 포함
- 가능한 한 서버 사이드 렌더링 우선

## Content Conventions

### Frontmatter 필수 필드
```yaml
---
title: "글 제목"
description: "짧은 설명"
category: reading | study | reflection | essay
tags: ["태그1", "태그2"]
pubDate: 2026-07-19
draft: false
---
```

### 글 작성 가이드
- 제목: 명확하고 구체적으로
- 태그: 소문자 kebab-case, 최소 1개
- draft: true로 시작, 완료 시 false

### 콘텐츠 QA 검수 (글 작성 후 필수)

글을 작성한 뒤 **반드시** 아래 항목을 검수한다. `bash scripts/validate-content.sh` 실행으로 자동 검증 가능.

#### 1. 볼드/이탤릭 마크업 검증
- `*` 또는 `**`가 짝을 이루지 않아 원시 문자열로 노출되는 경우 확인
- 빌드 결과 HTML에 `*` 텍스트가 남아있지 않은지 검증
- **주의**: 파서는 `**` 직전에 특수 문자가 올 때 볼드 경계를 인식하지 못함
  - **괄호 패턴**: `**text(괄호)**` → raw `**` 노출
    - ❌ `**React Server Components(RSC)**`
    - ✅ `<strong>React Server Components(RSC)</strong>`
  - **따옴표 패턴**: `**"text"**` 또는 `**'text'**` → raw `**` 노출
    - ❌ `**"컨벤션이 곧 컨텍스트다"**`
    - ✅ `<strong>"컨벤션이 곧 컨텍스트다"</strong>`
  - **규칙**: 닫는 `**` 직전에 `)`, `"`, `'` 등 특수 문자가 올 때 HTML `<strong>` 태그 사용
#### 2. 취소선(Strikethrough) 검증
- 의도하지 않은 `~` 취소선 렌더링 확인
- **같은 줄에 `~`가 2개 이상** 있으면 파서가 취소선으로 해석할 수 있음
- 해결: 해당 `~`를 HTML 엔티티 `&#126;`로 이스케이프
- 빌드 결과 HTML에 의도하지 않은 `<del>` 태그가 없는지 검증

#### 3. 테이블 레이아웃 검증
- 테이블이 `post-container`(720px) 안에서 읽기 좋게 표시되는지 확인
- `overflow-x: auto` + `white-space: nowrap` 스타일이 적용되어 있으므로, 넓은 표는 가로 스크롤로 처리됨
- 셀 내용이 과도하게 길어 레이아웃이 깨지지 않는지 확인

#### 4. 하이퍼링크 검증
- 모든 외부 링크(`http://`, `https://`)가 새 탭에서 열리는지 확인
- `PostLayout.astro`의 스크립트가 `target="_blank"` + `rel="noopener noreferrer"`를 자동 적용함
- 빌드 결과에 스크립트가 포함되어 있는지 검증

## Commit Messages

Conventional Commits:

```
feat(blog): 포스트 카드 컴포넌트 추가
fix(layout): 모바일 반응형 수정
content(reading): 'A New Earth' 독서 노트 추가
docs(arch): 아키텍처 다이어그램 업데이트
style(global): 타이포그래피 개선
chore(deps): Astro 업그레이드
```
