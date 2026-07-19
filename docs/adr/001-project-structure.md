---
title: "[ADR-001] Astro 프레임워크 선택과 프로젝트 구조 설계"
status: Accepted
date: 2026-07-19
deciders: ["halo"]
superseded_by: null
---

# ADR-001: Astro 프레임워크 선택과 프로젝트 구조 설계

## Status

Accepted

## Context

presence-ego는 개인 탐구 블로그로, 다음 요구사항을 충족해야 한다:

1. Markdown으로 글을 작성하고 관리하는 것이 편리해야 함
2. 정적 사이트로 빠른 로딩 속도 보장
3. 필요 시 인터랙티브 요소 추가 가능
4. AI 에이전트가 프로젝트를 효율적으로 인지할 수 있는 구조
5. 블로그 콘텐츠를 카테고리별로 체계적으로 관리

## Decision

**Astro 프레임워크를 채택하고, 4-Layer Progressive Disclosure AI 인프라와 결합:**

1. **Astro**: 정적 사이트 생성 + Content Collections로 Markdown 관리
2. **TypeScript**: 타입 안정성
3. **Content Collections**: 카테고리별 콘텐츠 관리 (reading, study, reflection, essay)
4. **AI 인프라**: Entry → Context → Knowledge → State 4계층 정보 구조

## Alternatives Considered

### Option A: Next.js
- 장점: 풍부한 에코시스템, SSR/SSG 모두 지원
- 단점: 블로그에 과도한 복잡도, 번들 사이즈 큼

### Option B: Hugo / Jekyll
- 장점: 빠른 빌드, 심플
- 단점: Go/Ruby 기반으로 TypeScript 통합 어려움

### Option C (선택): Astro
- 장점: Markdown 우선, 제로 JS by default, Islands Architecture, Content Collections
- 단점: 상대적으로 젊은 에코시스템

## Consequences

### Positive
- Markdown 콘텐츠 관리가 매우 자연스럽
- 빌드 시 제로 JS로 최고 성능 보장
- AI 인프라와 소스 코드가 깔끔하게 분리

### Negative
- Astro 특유의 문법 학습 필요

### Risks
- Astro 에코시스템 변화 속도 → LTS 버전 사용으로 완화
