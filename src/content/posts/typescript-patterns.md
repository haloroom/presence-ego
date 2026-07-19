---
title: "TypeScript 패턴 정리 — 타입 안정성을 위한 여정"
description: "프로젝트에서 자주 사용하는 TypeScript 패턴과 타입 가드를 정리합니다"
category: study
tags: ["타입스크립트", "프로그래밍", "패턴"]
pubDate: 2026-07-17
draft: false
---

## 왜 타입이 중요한가

TypeScript를 쓰면서 느끼는 것은, 타입이란 결국 **의도를 코드로 표현하는 방법**이라는 것이다. 런타임에서 발생할 수 있는 오류를 컴파일 타임에 잡아주는 안전장치이기도 하다.

## Discriminated Unions

가장 자주 사용하는 패턴 중 하나는 판별 유니온이다:

```typescript
type PostCategory = 'reading' | 'study' | 'reflection' | 'essay';

interface Post {
  title: string;
  category: PostCategory;
  pubDate: Date;
}

function getCategoryLabel(category: PostCategory): string {
  const labels: Record<PostCategory, string> = {
    reading: '독서',
    study: '공부',
    reflection: '성찰',
    essay: '에세이',
  };
  return labels[category];
}
```

## Type Guard 패턴

런타임에서 타입을 좁히는 타입 가드는 안전한 코드를 위해 필수적이다:

```typescript
function isPublished(post: Post & { draft?: boolean }): boolean {
  return post.draft !== true;
}

function hasTag(post: Post & { tags: string[] }, tag: string): boolean {
  return post.tags.includes(tag);
}
```

## Utility Types 활용

TypeScript 내장 유틸리티 타입은 불필요한 중복을 줄여준다:

```typescript
// 기존 타입에서 부분 타입 생성
type PostUpdate = Partial<Pick<Post, 'title' | 'category'>>;

// 읽기 전용 보장
type ReadonlyPost = Readonly<Post>;
```

## 배운 점

타입 시스템은 제약이 아니라 **자유**다. 타입이 정확할수록 리팩토링이 쉬워지고, 의도하지 않은 변경으로부터 보호받을 수 있다. 마치 톨레가 말하는 현존처럼 — 구조 안에서 오히려 진정한 유연함이 탄생한다.
