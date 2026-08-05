---
title: "AI가 읽기 쉬운 풀스택 (1) — DB와 백엔드: AI가 잘 읽는 데이터 계층"
description: "표준 SQL, 스키마-퍼스트 ORM, 선언적 BaaS — AI 에이전트가 데이터 계층을 더 정확하게 이해하고 코드를 생성하는 기술 스택을 비교합니다"
category: study
tags: ["AI코딩", "바이브코딩", "데이터베이스", "백엔드", "풀스택", "아키텍처"]
pubDate: 2026-08-04
draft: false
---

2025년 초, Andrej Karpathy가 주창한 <strong>바이브 코딩(Vibe Coding)</strong>이라는 개념은 개발 생태계에 큰 파장을 일으켰습니다. 단순히 코드 몇 줄을 자동 생성하는 수준을 넘어, 기획 의도와 분위기(Vibe)만 던져주면 AI가 전체 코드를 직조해 내는 시대가 열린 것입니다.

이제 개발자의 역할은 '어떻게 구현할 것인가'에서 '어떤 구조를 설계할 것인가'로 이동하고 있습니다. 흥미로운 점은, AI 코딩의 도입이 단순히 생산성 도구를 넘어 **아키텍처 선택의 기준**까지 바꾸고 있다는 사실입니다. 우리가 사용하는 기술 스택이 AI가 이해하기 쉬운 구조일수록, AI가 생성하는 코드의 품질과 정확도는 비약적으로 상승합니다. 이를 <strong>AI 인지 친화성(AI Cognizability)</strong>이라고 부를 수 있겠습니다.

본 시리즈 "AI가 읽기 쉬운 풀스택"에서는 AI 코딩 시대에 걸맞은 아키텍처와 기술 스택을 3편에 걸쳐 탐구합니다.
- <strong>1편: DB와 백엔드 (현재 글)</strong>
- 2편: 프론트엔드와 배포
- 3편: 설계 원칙과 보안

이번 1편에서는 데이터베이스, ORM, 그리고 백엔드 아키텍처를 중심으로 AI가 가장 정확한 코드를 만들어낼 수 있는 데이터 계층 설계에 대해 알아보겠습니다.

---

## 1. 데이터베이스 — AI 학습 데이터와의 친화성

AI 에이전트가 코드를 작성할 때 가장 중요한 것은 모델이 학습한 데이터의 양과 질입니다. AI 모델의 학습 데이터에서 <strong>표준 SQL(Standard SQL)</strong>이 차지하는 비중은 압도적입니다. 따라서 표준 SQL을 기반으로 하는 데이터베이스를 선택할 때, AI는 훨씬 더 정확하고 최적화된 쿼리를 생성해 냅니다.

반면, 독자적인 SDK에 의존하는 NoSQL이나 특화된 데이터베이스(예: <strong>Firebase Firestore(NoSQL)</strong>)의 경우, AI가 복잡한 쿼리를 작성할 때 독자적인 메서드 체인이나 규칙을 오해하여 오류를 범할 확률이 상대적으로 높습니다.

| DB | 엔진 | AI 강점 | 가격 모델 | 적합 케이스 |
|---|---|---|---|---|
| Supabase | PostgreSQL | pgvector(벡터 검색), 표준 SQL, RLS 정책 | 사용량+무료 티어 | 데이터 중심 SaaS, RAG 앱 |
| Neon | PostgreSQL (서버리스) | 즉시 브랜칭(Git for DB), scale-to-zero | 사용량+무료 티어 | 모듈형 스택, AI 실험 |
| Firebase | Firestore (NoSQL) | Google Cloud AI 통합, 실시간 동기화 | 읽기/쓰기 기반 | 모바일 퍼스트, 실시간 앱 |
| Turso | libSQL (SQLite 포크) | 엣지 내장, AI 에이전트별 격리 DB | 행/저장 기반 | 읽기 중심, 엣지 퍼스트 |
| PlanetScale | MySQL (Vitess) + PostgreSQL | 브랜치 기반 스키마 마이그레이션 | 프로비저닝 (유료 전용) | 고처리량 관계형 데이터 |

### Supabase와 Neon: PostgreSQL의 귀환

최근 풀스택 생태계에서 가장 주목받는 DB 엔진은 단연 PostgreSQL입니다. **Supabase**는 PostgreSQL의 강력한 표준 SQL과 `pgvector` 확장을 제공하여, AI가 RAG(Retrieval-Augmented Generation) 쿼리를 자연스럽게 생성할 수 있도록 돕습니다. 또한 행 수준 보안(RLS) 역시 표준 SQL 문법을 따르므로 AI가 정책을 작성하기 용이합니다.

<strong>Neon(서버리스 Postgres)</strong>은 즉각적인 브랜칭 기능을 제공하여 AI 기반 개발 워크플로우에 최적화되어 있습니다. AI가 새로운 기능을 구현할 때 메인 DB를 건드리지 않고 브랜치 DB에서 안전하게 스키마 변경을 테스트할 수 있기 때문입니다.

### Turso와 Firebase: 엣지와 실시간의 딜레마

**Turso**는 SQLite를 포크한 libSQL을 기반으로 하며, 초저지연 엣지(Edge) 환경에 강점을 가집니다. 특히 AI 에이전트별로 수천 개의 격리된 마이크로 DB를 생성하는 패턴에 적합하며, SQLite 문법을 사용해 AI 친화적입니다.

반면 **Firebase Firestore**는 실시간 동기화와 모바일 앱에서는 여전히 강력하지만, AI 코딩 관점에서는 양날의 검입니다. 비관계형 구조와 독자적인 쿼리 제약 조건(예: 복합 인덱스 규칙)을 AI가 완벽히 추론하지 못해 런타임 에러를 발생시키는 경우가 종종 있습니다.

---

## 2. ORM — 스키마가 곧 계약

데이터베이스가 결정되었다면, 애플리케이션 코드와 DB를 이어줄 ORM(Object-Relational Mapping)을 선택해야 합니다. AI 코딩 시대에 ORM 스키마는 단순한 모델 정의를 넘어, AI에게 데이터 구조를 알려주는 <strong>명확한 계약(Contract)</strong> 역할을 합니다.

여기서 핵심적인 차이는 코드젠(Codegen) 의존 여부, 번들 사이즈, 그리고 엣지 환경 호환성입니다.

| 특성 | Prisma | Drizzle ORM |
|---|---|---|
| 철학 | Schema-first (.prisma DSL) | SQL-first (TypeScript as SQL wrapper) |
| 타입 안전 | 생성된 클라이언트 (prisma generate) | 코드에서 직접 추론 (코드젠 없음) |
| 번들 사이즈 | &#126;1.6MB (TypeScript/WASM) | &#126;7.4KB (제로 런타임 의존) |
| AI 코딩 관점 | 선언적 .prisma 파일 → AI가 전체 모델을 한눈에 파악 | TypeScript 스키마 → 코드젠 스텝 없이 타입 즉시 전파 |
| 적합 환경 | 팀 프로젝트, SQL 추상화 선호 | 엣지/서버리스, SQL 직접 제어 선호 |

### 단일 스키마 흐름: Zod 연계

AI 에이전트가 코드를 작성할 때 가장 헷갈려 하는 부분은 DB 스키마, API 페이로드, 프론트엔드 상태의 타입이 파편화되어 있을 때입니다. 이를 해결하기 위해 <strong>Zod(스키마 검증 라이브러리)</strong>를 활용한 단일 소스 진실(Single Source of Truth) 패턴이 유행하고 있습니다.

Drizzle ORM과 Zod를 결합하면, 데이터베이스 스키마에서 타입과 검증 로직을 단 번에 추출할 수 있습니다. AI는 이 흐름을 한 번만 인지하면 프론트엔드 폼 검증까지 일관성 있는 코드를 작성합니다.

```typescript
import { pgTable, serial, text, integer } from 'drizzle-orm/pg-core';
import { createInsertSchema, createSelectSchema } from 'drizzle-zod';
import { z } from 'zod';

// 1. Drizzle DB 스키마 정의
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  age: integer('age'),
});

// 2. Zod 스키마 자동 추출
export const insertUserSchema = createInsertSchema(users, {
  name: (schema) => schema.name.min(2, "이름은 2글자 이상이어야 합니다."),
});

// 3. TypeScript 타입 추론
export type InsertUser = z.infer<typeof insertUserSchema>;
```

이처럼 선언적으로 정의된 스키마는 AI가 데이터의 유효성 검사 규칙까지 정확히 이해하고 관련 API와 UI를 생성하는 기반이 됩니다.

---

## 3. 백엔드 아키텍처 — 서버리스 / BaaS / 전통 서버

백엔드 아키텍처 역시 AI의 코드 생성 효율에 큰 영향을 미칩니다. 라우팅, 미들웨어, 의존성 주입 등 복잡한 보일러플레이트가 많은 구조일수록 AI가 컨텍스트를 놓칠 확률이 커집니다.

| 아키텍처 | 대표 기술 | AI 코딩 관점 강점 | 약점 |
|---|---|---|---|
| 서버리스 (FaaS) | Vercel Functions, Cloudflare Workers | 단일 함수 패턴 → AI가 범위를 좁혀 정확한 코드 생성 | 콜드 스타트, 상태 관리 한계 |
| BaaS | Supabase, Convex | 선언적 API → AI가 "무엇을 할지"만 기술 | 벤더 종속, 복잡한 비즈니스 로직 한계 |
| 전통 서버 | Express, FastAPI, Hono | 학습 데이터 풍부 → 복잡한 패턴도 AI가 잘 생성 | 운영 복잡도, 스케일링 직접 관리 |

### BaaS 심화 — Supabase vs Convex

프론트엔드 개발자가 AI와 함께 풀스택 앱을 빠르게 구축할 때, 백엔드를 통째로 추상화하는 BaaS(Backend-as-a-Service)는 매력적인 선택지입니다.

| 특성 | Supabase | Convex |
|---|---|---|
| 기반 | PostgreSQL (관계형) | Reactive Document Store |
| 실시간 | 옵트인 구독 | 기본 내장 (자동 반응형) |
| 언어 | SQL + 생성된 타입 | TypeScript 네이티브 (엔드투엔드) |
| AI 강점 | pgvector 기반 SQL RAG | 실시간 AI UI/스트리밍에 최적 |
| 적합 케이스 | 관계형 데이터, 자체 호스팅 | 실시간 협업 도구, AI 채팅 앱 |

**Convex**는 백엔드 로직을 순수 TypeScript 함수로 작성하고, 이것이 즉시 실시간 데이터베이스와 동기화되는 구조를 가집니다. AI 입장에서는 프론트엔드와 백엔드의 언어적 장벽이 없어져 매우 자연스럽게 풀스택 코드를 생성해 냅니다.

### 하이브리드 전략

모든 것을 하나로 통일할 필요는 없습니다. 최근의 권장 패턴은 빠르고 가벼운 요청(핫 패스)은 BaaS나 서버리스 함수로 AI가 빠르게 생성하도록 맡기고, 무거운 백그라운드 처리나 복잡한 트랜잭션은 전통적인 컨테이너(Cloud Run 등)로 오프로드하는 하이브리드 전략입니다.

---

## 마무리

AI 코딩 시대의 아키텍처 선택 기준은 한 문장으로 요약할 수 있습니다.
<strong>"AI가 잘 아는 것을 선택하라."</strong>

표준 SQL은 수십 년간 쌓인 방대한 데이터 덕분에 AI의 '모국어'와 다름없으며, 스키마-퍼스트 접근법은 AI가 혼동하지 않도록 명확한 '계약서'를 제공합니다. 복잡한 인프라 관리보다는 선언적인 서버리스와 BaaS 환경을 제공할 때 AI는 비즈니스 로직 구현에 더 집중할 수 있습니다.

데이터 계층이 탄탄하게 설계되었다면, 다음 단계는 사용자와 맞닿아 있는 프론트엔드입니다. 이어지는 <strong>"2편: 프론트엔드와 배포"</strong>에서는 AI가 컴포넌트를 어떻게 인식하는지, 그리고 어떤 렌더링 패턴과 배포 환경이 AI 코딩에 유리한지 살펴보겠습니다.
