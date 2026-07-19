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
