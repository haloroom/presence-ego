---
title: "웹 애플리케이션 기술 조감도 — 라이브러리, 프레임워크, 그리고 빌드 결과물"
description: "React, Vue, Angular, Svelte부터 Next.js, Nuxt, SvelteKit, Astro, 그리고 WebAssembly까지 — 2026년 시점의 핵심 원리, 렌더링 전략, 빌드 결과물, 배포 환경을 비교 분석합니다"
category: study
tags: ["웹-프레임워크", "리액트", "뷰", "앵귤러", "스벨트", "넥스트", "아스트로", "웹어셈블리"]
pubDate: 2026-08-01
draft: false
---

## 라이브러리 vs 프레임워크 — 경계의 재정의

전통적으로 **라이브러리**는 "내가 호출하는 코드"이고, **프레임워크**는 "나를 호출하는 코드"였다. React는 UI 렌더링만 담당하는 라이브러리, Angular는 라우팅부터 HTTP 클라이언트까지 품은 프레임워크. 이 구분은 오랫동안 명확했다.

2026년 현재, 이 경계는 사실상 무의미해졌다. React를 "라이브러리"라고 부르지만 실제 프로덕션에서 React만으로 애플리케이션을 만드는 경우는 거의 없다. 라우팅, 서버 렌더링, 데이터 페칭 — 모든 것이 **메타 프레임워크** 위에서 동작한다.

현재의 웹 기술 계층은 다음과 같이 정리된다:

| 계층 | 역할 | 기술 |
|:---|:---|:---|
| **UI 라이브러리** | 컴포넌트 모델, 반응성, 렌더링 | React, Vue, Svelte |
| **풀 프레임워크** | UI + 라우팅 + DI + HTTP 등 통합 | Angular |
| **메타 프레임워크** | 라이브러리 위에 라우팅, SSR, 빌드 최적화 제공 | Next.js, Nuxt, SvelteKit |
| **콘텐츠 프레임워크** | 콘텐츠 중심 + 다중 UI 라이브러리 지원 | Astro |
| **네이티브 바이너리** | 브라우저에서 네이티브 성능 실행 | WebAssembly (Rust) |

Svelte는 흥미로운 위치에 있다. 런타임 라이브러리라기보다는 **컴파일러**에 가깝다. 빌드 시점에 반응성 코드를 순수 JavaScript로 변환하기 때문에, 브라우저에 전달되는 "프레임워크 런타임"이 사실상 없다.

Astro 역시 독특하다. React, Vue, Svelte 등 어떤 UI 라이브러리든 섞어 쓸 수 있는 **멀티 프레임워크 지원**이 핵심이다. "프레임워크의 프레임워크"에 가깝지만, 콘텐츠 퍼스트라는 명확한 철학을 갖고 있다.

---

## 반응성 모델 — 원리와 발전 흐름

프론트엔드 기술의 핵심은 결국 하나의 질문으로 귀결된다: **"데이터가 변했을 때 UI를 어떻게 업데이트하는가?"** 이것이 반응성(Reactivity) 모델이며, 각 기술은 근본적으로 다른 접근을 취한다.

### React — Virtual DOM과 Reconciliation

React는 **Virtual DOM** 기반이다. 상태가 변하면 전체 컴포넌트 트리를 가상으로 다시 렌더링하고, 이전 트리와 비교(diffing)하여 변경된 부분만 실제 DOM에 적용한다.

이 방식의 장점은 **선언적 프로그래밍**이 가능하다는 것이다. 개발자는 "이 상태일 때 UI는 이렇게 보여야 한다"만 선언하면 된다. 단점은 비교 연산 자체에 CPU 비용이 들고, 불필요한 리렌더링을 방지하기 위해 `useMemo`, `useCallback` 같은 수동 최적화가 필요했다는 것이다.

**발전 흐름**: Class 컴포넌트 → Hooks(v16.8) → Concurrent Mode/Fiber(v18) → **React Compiler(v19)**

React 19에서 도입된 **React Compiler**는 게임 체인저다. 빌드 타임에 컴포넌트의 데이터 흐름을 분석하여 자동으로 메모이제이션을 적용한다. 개발자가 `useMemo`를 직접 쓸 필요가 사라졌다. 또한 **React Server Components(RSC)**가 표준 아키텍처로 자리잡으면서, 서버에서만 실행되는 컴포넌트와 클라이언트 컴포넌트를 명확히 분리할 수 있게 되었다.

### Vue — Proxy 기반 세밀한 추적

Vue는 JavaScript의 **Proxy API**를 사용하여 객체 속성 접근을 가로챈다. 컴포넌트가 렌더링될 때 어떤 반응형 데이터를 읽었는지 자동으로 추적하고, 해당 데이터가 변할 때 그 컴포넌트만 정확히 다시 렌더링한다.

이 방식은 Virtual DOM을 사용하지만, React와 달리 **어떤 컴포넌트가 영향받는지 정확히 안다**는 점에서 불필요한 리렌더링이 구조적으로 적다.

**발전 흐름**: Options API → Composition API(v3) → `<script setup>` 문법 → **Vapor Mode(v3.6 RC)**

Vapor Mode는 Vue의 미래다. 선택적으로 Virtual DOM을 완전히 우회하고, 컴파일 타임에 직접적인 DOM 조작 코드를 생성한다. `<script setup vapor>`라고 선언하면 해당 컴포넌트는 VDOM 없이 동작한다. Svelte의 컴파일 접근에 영감을 받았지만, 기존 Vue 생태계와의 호환성을 유지한다는 점이 다르다.

### Angular — Zone에서 Signals로

Angular는 오랫동안 **Zone.js**에 의존했다. Zone.js는 모든 비동기 이벤트(setTimeout, Promise, XHR 등)를 가로채서, "뭔가 변했을 수 있다"는 신호를 Angular에 보내는 방식이었다. 간편하지만, 변경 여부와 무관하게 전체 컴포넌트 트리를 검사하는 비효율이 있었다.

**발전 흐름**: Zone.js 전역 감지 → OnPush 전략 → **Signals(v17+)** → **Zone-less 완전 안정화(v22)**

Angular 22에서 Signals가 기본 반응성 모델이 되었다. `signal()`, `computed()`, `effect()`로 세밀한 반응성을 제공하며, Zone.js 없이도 변경 감지가 동작한다. `linkedSignal`, `resource()`, `httpResource()` 같은 API가 안정화되면서, Angular의 반응성은 근본적으로 새로운 시대에 접어들었다.

### Svelte — 컴파일러가 곧 프레임워크

Svelte의 접근은 근본적으로 다르다. Virtual DOM도, Proxy도, Zone도 없다. **컴파일러가 빌드 시점에 반응성 코드를 순수 JavaScript로 변환**한다. 브라우저에 전달되는 코드에는 "프레임워크 런타임"이 사실상 존재하지 않는다.

**발전 흐름**: `$:` 선언적 반응성(v3~4) → **Runes(v5)**

Svelte 5의 Runes는 반응성을 명시적으로 만들었다:

```javascript
// Svelte 5 Runes
let count = $state(0);           // 반응형 상태
let doubled = $derived(count * 2); // 파생 값
$effect(() => {                   // 부수 효과
  console.log(`count is ${count}`);
});
```

이전의 `$:` 구문은 `.svelte` 파일에서만 동작했지만, Runes는 `.js`, `.ts` 파일에서도 사용 가능하다. 반응성이 파일 확장자에 의존하지 않게 된 것이다.

### 업계 전체의 방향성

이 발전 과정에서 세 가지 공통 흐름이 보인다:

1. **런타임 → 컴파일 타임**: React Compiler, Vue Vapor, Svelte 모두 빌드 시점에 더 많은 최적화를 수행하는 방향으로 움직이고 있다. 런타임에서 해야 할 일을 줄이는 것이 성능 향상의 핵심이다.

2. **거친 반응성 → 세밀한 반응성**: 컴포넌트 단위 리렌더링에서 개별 값(Signal) 단위 업데이트로. Angular Signals, Vue의 Proxy 추적, Svelte Runes 모두 "정확히 변한 것만 업데이트"하는 방향이다.

3. **프레임워크의 경량화**: 브라우저 표준 API(Web Components, Popover API, View Transitions 등)가 강화되면서, 프레임워크가 대신 해줘야 할 일이 줄어들고 있다.

---

## 렌더링 전략 — 콘텐츠가 생성되는 곳

같은 React 코드라도 CSR로 빌드하면 빈 HTML 하나와 JS 번들이 나오고, SSR로 빌드하면 완성된 HTML이 서버에서 생성된다. **렌더링 전략**은 "HTML이 어디서, 언제 만들어지는가"를 결정하며, 이것이 성능, SEO, 사용자 경험을 좌우한다.

### CSR (Client-Side Rendering)

서버는 빈 HTML과 JavaScript 번들만 전달한다. 브라우저가 JS를 다운로드하고 실행한 뒤에야 화면이 그려진다.

- **원리**: `<div id="root"></div>` + `<script src="bundle.js">` → 브라우저에서 DOM 생성
- **장점**: 서버 부하 없음, 페이지 간 전환이 빠름 (SPA), 서버 인프라 단순
- **단점**: 초기 로딩 느림 (빈 화면 → JS 다운로드 → 렌더링), SEO에 불리
- **여전히 유효한 경우**: 대시보드, 어드민 패널, 사내 도구처럼 SEO가 불필요하고 로그인 뒤에만 접근하는 앱

### SSR (Server-Side Rendering)

서버에서 요청마다 HTML을 완성하여 전달한다. 브라우저는 완성된 HTML을 즉시 보여주고, 이후 JS가 로드되면 인터랙티브하게 만드는 **Hydration** 과정을 거친다.

- **원리**: 서버에서 `renderToString()` 또는 `renderToPipeableStream()` → 완성된 HTML 전달 → 클라이언트 Hydration
- **장점**: 빠른 First Contentful Paint, SEO 친화적, 동적 데이터 반영 가능
- **단점**: 서버 부하 증가 (요청마다 렌더링), TTFB(Time To First Byte)가 렌더링 시간에 의존
- **지원**: Next.js(기본), Nuxt(기본), SvelteKit(기본), Angular Universal

### SSG (Static Site Generation)

빌드 시점에 모든 페이지의 HTML을 미리 생성한다. 런타임에는 정적 파일을 CDN에서 전달할 뿐이다.

- **원리**: `npm run build` 시 모든 라우트를 순회 → HTML 파일 생성 → CDN 배포
- **장점**: 최고의 TTFB (CDN 캐시), 서버 비용 거의 없음, 보안 표면 최소
- **단점**: 빌드 시간이 페이지 수에 비례, 데이터 변경 시 재빌드 필요
- **지원**: Astro(기본), Next.js(`generateStaticParams`), Nuxt(`nuxi generate`), SvelteKit(`prerender`)

### ISR (Incremental Static Regeneration)

SSG의 단점(재빌드)을 해결한다. 정적으로 생성된 페이지를 런타임에 개별적으로 재생성할 수 있다.

- **원리**: 첫 요청 → 캐시된 정적 페이지 반환 + 백그라운드에서 재생성 트리거 → 다음 요청부터 새 페이지
- **장점**: SSG의 성능 + 동적 데이터 신선도, 전체 재빌드 불필요
- **단점**: 캐시 무효화 전략이 복잡, stale 데이터 표시 구간 존재
- **지원**: Next.js(`revalidate` 옵션), Nuxt(Hybrid Rendering, route rules)

### Streaming SSR

SSR의 TTFB 문제를 해결한다. HTML을 한 번에 완성하여 보내는 대신, **준비된 부분부터 청크 단위로 스트리밍** 전송한다.

- **원리**: HTTP Chunked Transfer → 헤더·네비게이션 먼저 전송 → 데이터 페칭 완료된 영역부터 순차 전송 → 최종 `</html>`
- **장점**: TTFB 대폭 개선 (첫 바이트가 즉시 전달), 느린 API 응답이 전체 페이지를 블록하지 않음
- **Suspense와의 관계**: React의 `<Suspense>` boundary가 스트리밍 단위가 된다. 각 Suspense 영역이 독립적으로 로딩 → 완료 → HTML 교체
- **지원**: Next.js App Router(기본), React 18+ `renderToPipeableStream`

### Partial Hydration

전체 페이지의 JS를 한꺼번에 hydrate하는 대신, **인터랙티브한 부분만 선택적으로 hydrate**한다. 나머지는 정적 HTML 그대로 둔다.

두 가지 대표적 접근이 있다:

**Astro Islands**: 페이지는 기본적으로 Zero JS. 인터랙티브가 필요한 컴포넌트만 `client:load`, `client:visible`, `client:idle` 같은 디렉티브로 명시적으로 hydrate한다. 개발자가 "이 컴포넌트는 JS가 필요합니다"라고 선언하는 방식이다.

**React Server Components(RSC)**: 서버 컴포넌트와 클라이언트 컴포넌트를 분리한다. 서버 컴포넌트는 서버에서만 실행되어 HTML을 생성하고, JS 번들에 포함되지 않는다. `'use client'` 디렉티브가 붙은 컴포넌트만 클라이언트 번들에 포함된다.

**핵심 차이**: Astro는 "기본 정적, 명시적 동적"이고, RSC는 "서버 우선, 필요 시 클라이언트"다. 접근 철학은 다르지만, 결과적으로 **클라이언트에 전달되는 JS 양을 최소화**한다는 목적은 같다.

---

## 제품 유형별 적합성

### SPA — 대시보드, 어드민

**핵심 요구사항**: 빠른 인터랙션, 복잡한 클라이언트 상태 관리, SEO 불필요

**적합한 기술**: React + Vite, Vue + Vite, Angular

대시보드는 로그인 뒤에만 접근하며, 복잡한 폼과 테이블, 실시간 차트가 주를 이룬다. CSR이면 충분하고, 오히려 SSR은 불필요한 복잡성을 더한다. React와 Vue는 Vite와 조합하면 빠른 개발 서버와 최적화된 번들을 얻는다. Angular는 CLI가 제공하는 풀스택 구조(라우팅, HTTP, 폼 검증, DI)가 대규모 엔터프라이즈 대시보드에 적합하다.

### 콘텐츠 사이트 — 블로그, 문서

**핵심 요구사항**: SEO, 빠른 초기 로드, 최소한의 JavaScript

**적합한 기술**: Astro, Next.js(SSG 모드), Nuxt(`generate`)

콘텐츠 사이트는 읽기가 99%이고 인터랙션은 최소한이다. Astro는 이 영역을 위해 설계되었다. 기본적으로 JS를 전혀 보내지 않으며, 필요한 곳에만 Island으로 인터랙티브 컴포넌트를 삽입한다. Next.js와 Nuxt도 SSG 모드로 정적 사이트를 생성할 수 있지만, 프레임워크 런타임이 번들에 포함되므로 Astro 대비 JS 전송량이 크다.

### 이커머스

**핵심 요구사항**: SEO + 동적 데이터(가격, 재고) + 성능(전환율과 직결)

**적합한 기술**: Next.js(ISR/SSR), Nuxt(Hybrid), SvelteKit

이커머스는 SEO와 동적 데이터가 동시에 필요한 까다로운 영역이다. 상품 목록 페이지는 ISR로 정적 생성하되 주기적으로 재생성하고, 장바구니와 결제는 CSR로 처리하는 하이브리드 전략이 효과적이다. Next.js의 ISR과 Nuxt의 Route Rules가 이런 페이지별 전략 분리를 자연스럽게 지원한다. SvelteKit은 번들 크기가 작아 모바일 전환율에 유리하다.

### 실시간 앱 — 채팅, 협업 도구

**핵심 요구사항**: WebSocket 통합, 빈번한 상태 갱신, 낮은 지연

**적합한 기술**: React + 전용 서버, Vue, Svelte

실시간 앱은 초당 수십~수백 회의 상태 갱신이 일어난다. 렌더링 전략보다 **반응성 모델의 효율**이 중요하다. Svelte는 컴파일 타임 반응성 덕분에 빈번한 업데이트에서 오버헤드가 가장 적다. Vue의 Proxy 기반 추적도 변경된 부분만 정확히 업데이트한다. React는 Concurrent Mode와 `useTransition`으로 대량 업데이트를 우선순위별로 처리할 수 있다.

### 하이브리드 — 마케팅 랜딩 + 앱

**핵심 요구사항**: 정적 마케팅 페이지와 인터랙티브 앱 영역이 하나의 프로젝트에 공존

**적합한 기술**: Astro Islands, Next.js App Router

마케팅 랜딩 페이지는 빠른 로드와 SEO가 필수이고, 로그인 후 대시보드는 풍부한 인터랙션이 필요하다. Astro Islands 패턴은 정적 페이지에 React/Vue/Svelte 컴포넌트를 "섬"처럼 삽입하여 이 문제를 해결한다. Next.js App Router는 서버 컴포넌트(마케팅 영역)와 클라이언트 컴포넌트(앱 영역)를 하나의 라우팅 체계 안에서 자연스럽게 혼합한다.

---

## 빌드 결과물의 해부

`npm run build`를 실행하면 각 기술은 근본적으로 다른 구조의 결과물을 만들어낸다. 이 결과물의 차이를 이해하면 성능 특성과 배포 전략이 명확해진다.

### React + Vite (순수 CSR)

```
dist/
├── index.html          ← 빈 HTML (<div id="root"></div> + script 태그)
├── assets/
│   ├── index-[hash].js       ← 메인 번들 (React 런타임 + 앱 코드)
│   ├── vendor-[hash].js      ← 외부 라이브러리 청크
│   ├── [route]-[hash].js     ← 라우트별 동적 임포트 청크
│   └── index-[hash].css      ← 추출된 CSS
└── public/                    ← 정적 에셋 복사
```

가장 단순한 형태다. `index.html`은 사실상 빈 껍데기이고, 모든 렌더링은 JS가 담당한다. Vite(Rolldown 1.0 기반, v8)가 Rollup 대비 10~30배 빠른 빌드를 제공하며, 자동 Code Splitting으로 `import()`된 모듈을 별도 청크로 분리한다.

### Next.js (App Router, Turbopack)

```
.next/
├── server/
│   ├── app/
│   │   ├── page.js            ← RSC 페이로드 (서버에서만 실행)
│   │   ├── layout.js          ← 레이아웃 서버 컴포넌트
│   │   └── [route]/
│   │       └── page.js        ← 라우트별 서버 컴포넌트
│   └── chunks/                ← 서버 사이드 공유 모듈
├── static/
│   ├── chunks/
│   │   ├── main-[hash].js     ← 클라이언트 런타임
│   │   ├── webpack-[hash].js  ← 청크 로더
│   │   └── [id]-[hash].js     ← 클라이언트 컴포넌트 청크
│   ├── css/                   ← 추출된 스타일
│   └── media/                 ← 최적화된 이미지, 폰트
├── BUILD_ID                   ← 빌드 식별자
└── prerender-manifest.json    ← 정적 생성 페이지 목록
```

CSR과 결정적으로 다른 점은 **`server/` 디렉토리의 존재**다. Server Components는 서버 번들에만 포함되고 클라이언트 번들에는 없다. `'use client'` 경계를 기준으로 서버/클라이언트 코드가 물리적으로 분리된다. Turbopack이 기본 번들러로 안정화되면서 대규모 프로젝트의 빌드 시간이 대폭 줄었다.

### Nuxt (Nitro 엔진)

```
.output/
├── server/
│   ├── index.mjs              ← Nitro 서버 엔트리
│   ├── chunks/
│   │   ├── runtime.mjs        ← Nitro 런타임
│   │   ├── routes/            ← 서버 라우트 핸들러
│   │   └── _/                 ← 서버 사이드 Vue 렌더러
│   └── node_modules/          ← 서버 의존성 (번들됨)
├── public/
│   ├── _nuxt/
│   │   ├── entry.[hash].js    ← 클라이언트 엔트리
│   │   ├── [component].[hash].js  ← 컴포넌트별 청크
│   │   └── [route].[hash].js ← 라우트별 청크
│   └── [static assets]       ← 정적 에셋
└── nitro.json                 ← 빌드 메타데이터
```

Nuxt의 핵심은 **Nitro 서버 엔진**이다. `.output/server/`에 자체적인 경량 서버가 포함되어, Node.js, Cloudflare Workers, Deno 등 다양한 런타임에서 동작한다. `server/`와 `public/`이 명확히 분리되어, `public/`만 CDN에 배포하고 `server/`는 서버리스 함수로 배포하는 구조를 자연스럽게 지원한다.

### SvelteKit (어댑터 패턴)

```
# adapter-node 사용 시
build/
├── client/
│   ├── _app/
│   │   ├── immutable/
│   │   │   ├── entry/         ← 앱 엔트리 + 시작 코드
│   │   │   ├── chunks/        ← 공유 청크
│   │   │   └── nodes/         ← 라우트별 컴포넌트
│   │   └── version.json
│   └── [static files]
├── server/
│   ├── index.js               ← 서버 엔트리
│   ├── manifest.json          ← 라우트 매니페스트
│   └── chunks/                ← 서버 모듈
└── handler.js                 ← HTTP 핸들러
```

SvelteKit의 독특한 점은 **어댑터에 따라 출력 구조가 완전히 달라진다**는 것이다. `adapter-node`는 위와 같은 서버 구조를, `adapter-static`은 순수 정적 파일만을, `adapter-vercel`은 Vercel Serverless Function 형태를 생성한다. 같은 소스 코드가 빌드 타겟에 따라 전혀 다른 결과물이 된다.

### Astro (Zero JS by Default)

```
dist/
├── index.html                 ← 완성된 정적 HTML
├── about/
│   └── index.html             ← 각 페이지가 완성된 HTML
├── posts/
│   └── [slug]/
│       └── index.html
├── _astro/
│   ├── [island].[hash].js     ← Island 컴포넌트 JS (있는 경우만)
│   └── [style].[hash].css     ← 추출된 CSS
└── [static assets]            ← 이미지, 폰트 등
```

Astro의 빌드 결과는 **전통적인 정적 사이트와 가장 비슷**하다. 각 페이지가 완성된 HTML 파일이다. `_astro/` 디렉토리에 JS가 있다면, 그것은 `client:` 디렉티브로 명시한 Island 컴포넌트의 JS뿐이다. Island이 없는 페이지는 **문자 그대로 JS가 0바이트**다. Astro 7에서 Rust 기반 `.astro` 컴파일러와 Vite 8 + Rolldown 통합으로 빌드 속도가 극적으로 향상되었다.

### 번들 분리 전략

각 기술의 Code Splitting 접근:

| 전략 | 설명 | 사용 기술 |
|:---|:---|:---|
| **Route-based** | 라우트 단위로 청크 분리 | Next.js, Nuxt, SvelteKit |
| **Component-based** | 컴포넌트 단위 분리 (`import()`) | React, Vue (수동) |
| **Island-based** | 인터랙티브 컴포넌트만 별도 번들 | Astro |
| **Entry-based** | 멀티 엔트리 포인트 | Vite, Angular |

### 런타임 성능 비교

빌드 결과물의 차이는 런타임 성능에 직접 영향을 미친다.

#### 브라우저 측

| 측정 항목 | React | Vue | Angular | Svelte |
|:---|:---|:---|:---|:---|
| **프레임워크 런타임 크기** | ~42KB (gzip) | ~33KB (gzip) | ~90KB (gzip) | ~2KB (gzip) |
| **Hydration 비용** | 전체 트리 재구성 | 전체 트리 재구성 | 전체 트리 재구성 | 컴파일된 바인딩 연결 |
| **리렌더 비용** | VDOM diff (Fiber) | Proxy 추적 (타겟팅) | Signal 기반 (타겟팅) | 컴파일된 직접 업데이트 |
| **메모리 패턴** | VDOM 트리 상시 유지 | VDOM + Proxy 래퍼 | Signal 그래프 | 추가 자료구조 최소 |

Svelte의 런타임 크기가 압도적으로 작은 이유: 프레임워크 "런타임"이 아니라, 각 컴포넌트에 필요한 코드만 컴파일 결과에 인라인되기 때문이다. 반면 React는 Reconciler, Scheduler, Event System 등의 런타임을 항상 포함해야 한다.

#### 서버 측

| 측정 항목 | 영향 | 관련 기술 |
|:---|:---|:---|
| **SSR 메모리** | 요청마다 컴포넌트 트리 인스턴스 생성 → GC 부하 | Next.js, Nuxt, SvelteKit |
| **SSR CPU** | `renderToString` 소요 시간 → TTFB 결정 | 모든 SSR 프레임워크 |
| **Streaming 오버헤드** | 청크 관리 비용 있으나, 전체 TTFB 개선 | Next.js (App Router) |
| **Cold Start** | 번들 크기 → 서버리스 기동 시간 | 모든 SSR (Serverless 배포 시) |
| **동시 처리** | Node.js 단일 스레드 → 이벤트 루프 블로킹 주의 | 모든 Node 기반 SSR |

서버 측에서 주목할 점은 **SSR은 무료가 아니라는 것**이다. 요청마다 컴포넌트 트리를 생성·렌더링·폐기하므로 CPU와 메모리를 소비한다. Streaming SSR은 전체 렌더링 시간은 줄이지 않지만, 사용자가 느끼는 응답 속도(TTFB)를 개선한다. Serverless 환경에서는 Cold Start 시간이 추가되며, 이는 번들 크기에 비례한다.

---

## 배포 환경과 인프라

같은 프레임워크라도 배포 환경에 따라 성능 특성과 비용이 완전히 달라진다.

### 정적 호스팅 (GitHub Pages, S3, Cloudflare Pages)

가장 단순하고 저렴한 환경이다. 빌드 결과물(HTML, CSS, JS)을 CDN에 올리면 끝이다.

- **적합한 기술**: Astro(SSG), React+Vite(SPA), Next.js(`output: 'export'`), SvelteKit(`adapter-static`)
- **핵심 이점**: 사실상 무료(대부분 무료 티어), 글로벌 CDN으로 최고의 TTFB, 서버 관리 없음
- **한계**: 동적 데이터 불가 (API는 별도 서비스 필요), 빌드-배포 사이클 필수

### Serverless (Vercel, Netlify, AWS Lambda)

함수 단위로 서버 로직을 실행한다. 요청이 올 때만 함수가 실행되고, 유휴 시 비용이 없다.

- **적합한 기술**: Next.js(기본 타겟), Nuxt(Nitro auto-preset), SvelteKit(`adapter-vercel`)
- **핵심 이점**: 자동 스케일링, 사용량 기반 과금, 인프라 관리 최소
- **한계**: **Cold Start** — 함수가 "잠들었다가" 깨어나는 시간. 번들이 클수록 길어진다. Next.js의 경우 `.next/server/` 전체를 로드해야 하므로, 경량 프레임워크 대비 Cold Start가 길 수 있다. 또한 실행 시간 제한(보통 10~30초), 메모리 제한, 패키지 크기 제한(50~250MB)이 있다.

### Edge (Cloudflare Workers, Vercel Edge Runtime, Deno Deploy)

Serverless의 진화형이다. 사용자와 가장 가까운 CDN 노드에서 서버 코드를 실행한다.

- **적합한 기술**: Next.js(Edge Runtime), Nuxt(Nitro edge preset), SvelteKit(`adapter-cloudflare`), Astro(Cloudflare adapter)
- **핵심 이점**: 극도로 낮은 지연시간 (물리적 거리 최소화), Cold Start가 거의 없음 (V8 Isolate 기반)
- **한계**: **Node.js API를 모두 쓸 수 없다**. `fs`, `child_process`, `net` 등 OS 레벨 API가 없다. 이는 Node.js 네이티브 모듈에 의존하는 라이브러리(예: `sharp`, `bcrypt`)를 사용할 수 없음을 의미한다. 메모리 제한(보통 128MB)과 CPU 시간 제한(5~50ms)도 엄격하다.

### 전통 서버 (VPS, Docker, Kubernetes)

풀 Node.js 프로세스가 영속적으로 실행되는 환경이다.

- **적합한 기술**: 모든 SSR 프레임워크, 특히 Angular SSR
- **핵심 이점**: Node.js API 제한 없음, 메모리 상주로 Cold Start 없음, 데이터베이스 커넥션 풀 유지 가능, WebSocket 등 영속 연결 지원
- **한계**: 직접 스케일링 관리, 고정 비용 (유휴 시에도 과금), 보안 패치와 업데이트 책임

### 어댑터 패턴의 원리

SvelteKit, Astro, Nuxt(Nitro)는 **어댑터** 패턴으로 다양한 환경을 지원한다. 핵심 아이디어는 단순하다:

1. 프레임워크가 **중간 표현(IR)**을 생성한다 (라우트 매니페스트, 핸들러 함수 등)
2. 어댑터가 이 IR을 **타겟 환경의 형식**으로 변환한다

예를 들어 SvelteKit의 `adapter-vercel`은 각 서버 라우트를 Vercel Serverless Function으로 변환하고, `adapter-static`은 모든 라우트를 사전 렌더링하여 정적 HTML로 출력한다. 개발자는 코드를 바꾸지 않고 어댑터만 교체하면 된다.

### 비용-성능 트레이드오프

| 환경 | 비용 모델 | TTFB | 운영 복잡도 |
|:---|:---|:---|:---|
| 정적 호스팅 | 대부분 무료 | 최상 (CDN) | 최저 |
| Serverless | 사용량 과금 | 양호 (Cold Start 변수) | 낮음 |
| Edge | 사용량 과금 (프리미엄) | 최상 (지연시간 최소) | 낮음 |
| 전통 서버 | 고정 비용 | 양호 (위치 의존) | 높음 |

---

## WebAssembly와 Rust — 다른 차원의 접근

지금까지 다룬 모든 기술은 JavaScript (또는 JS로 컴파일되는 언어) 기반이다. WebAssembly(WASM)는 이와 근본적으로 다른 접근이다.

### WASM의 원리

WebAssembly는 브라우저에서 실행되는 **바이너리 명령어 포맷**이다. C, C++, Rust, Go 등의 언어를 컴파일하여 `.wasm` 파일을 생성하고, 이를 브라우저가 네이티브에 가까운 속도로 실행한다.

핵심 특성:

- **선형 메모리 모델**: 가비지 컬렉터가 없다. 메모리를 직접 할당·해제한다 (Rust의 경우 소유권 시스템이 이를 안전하게 관리한다)
- **스택 기반 가상 머신**: 레지스터가 아닌 스택에서 연산을 수행하는 VM이 브라우저에 내장되어 있다
- **샌드박스 실행**: JS와 같은 보안 샌드박스 안에서 실행되므로, 파일 시스템이나 네트워크에 직접 접근할 수 없다

### JS와의 실행 모델 차이

| | JavaScript | WebAssembly |
|:---|:---|:---|
| **소스** | 텍스트 (JS/TS) | 바이너리 (.wasm) |
| **파싱** | 인터프리팅 → JIT 컴파일 | AOT 컴파일 (빌드 시 완료) |
| **메모리 관리** | 가비지 컬렉션 | 수동/소유권 (Rust) |
| **DOM 접근** | 직접 접근 | ❌ JS 브릿지 필요 |
| **문자열 처리** | 네이티브 | 인코딩 변환 오버헤드 |
| **적합 영역** | UI, DOM 조작, 이벤트 | 연산 집약적 작업 |

**DOM 접근이 직접 불가능하다**는 것이 핵심 한계다. WASM에서 DOM을 조작하려면 JS를 거쳐야 하며, 이 브릿지 비용이 빈번한 DOM 업데이트에서는 JS 직접 조작보다 느릴 수 있다.

### 빌드 과정 (Rust 기준)

```
Rust 소스 (.rs)
    ↓ rustc + wasm-bindgen
[target/wasm32-unknown-unknown/]
    ├── app.wasm        ← 바이너리 모듈
    ├── app_bg.js       ← JS 글루 코드 (DOM 브릿지)
    └── app.js          ← 초기화 + 로더
```

`wasm-pack`이 이 과정을 자동화한다. 최종 결과물은 `.wasm` 바이너리와 이를 로드하는 JS 글루 코드로 구성된다.

### Rust 웹 프레임워크 간단 언급

- **Leptos (v0.9 beta)**: Signal 기반 세밀한 반응성을 제공하는 풀스택 Rust 프레임워크. SSR을 지원하며, 클라이언트 사이드에서는 WASM으로 실행된다. React의 JSX와 유사한 `view!` 매크로를 사용한다.
- **Yew (v0.23)**: React에서 영감받은 컴포넌트 기반 프레임워크. Virtual DOM을 사용하며, Rust의 타입 안전성을 웹 개발에 가져온다.

### WASM의 현재 위치

WASM은 JS를 **대체**하는 것이 아니라 **보완**한다. 각각이 잘하는 영역이 명확히 다르다:

- **WASM이 빛나는 곳**: 이미지/비디오 처리, 게임 엔진, 암호화 연산, 데이터 시각화 연산, 코덱
- **JS가 여전히 유리한 곳**: DOM 조작, UI 인터랙션, 이벤트 핸들링, API 통신

WASI(WebAssembly System Interface) 0.3과 Component Model이 안정화되면서 서버 사이드에서의 WASM 활용도 확대되고 있다. 하나의 WASM 모듈을 브라우저, 서버, Edge 어디서든 실행할 수 있는 "Write Once, Run Anywhere"의 가능성이 열리고 있다.

---

## 전체 조감 비교표

| | React | Vue | Angular | Svelte | Next.js | Nuxt | SvelteKit | Astro | WASM (Rust) |
|:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **계층** | 라이브러리 | 라이브러리 | 프레임워크 | 컴파일러 | 메타 FW | 메타 FW | 메타 FW | 콘텐츠 FW | 바이너리 |
| **반응성** | VDOM (Fiber) | Proxy | Signals | 컴파일 타임 | React 계승 | Vue 계승 | Svelte 계승 | — | — |
| **CSR** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | △ | ✅ |
| **SSR** | △ | △ | △ | △ | ✅ | ✅ | ✅ | ✅ | △ |
| **SSG** | — | — | — | — | ✅ | ✅ | ✅ | ✅ | — |
| **ISR** | — | — | — | — | ✅ | ✅ | — | — | — |
| **Streaming** | △ | — | — | — | ✅ | ✅ | — | — | — |
| **Partial Hydration** | — | — | — | — | RSC | — | — | Islands | — |
| **런타임 크기** | ~42KB | ~33KB | ~90KB | ~2KB | +React | +Vue | +Svelte | ≈0KB | N/A |
| **빌드 도구** | Vite 8 | Vite 8 | esbuild | Vite 8 | Turbopack | Vite+Nitro | Vite 8 | Vite 8+Rolldown | wasm-pack |
| **Edge 지원** | — | — | — | — | ✅ | ✅ | ✅ | ✅ | △ |
| **최신 버전** | v19.2 | v3.5 | v22 | v5.56 | v16.2 | v4.5 | v2.70 | v7.1 | — |

> ✅ 기본 지원 · △ 가능하나 직접 구성 필요 · — 기본 미지원

### 2026년 핵심 트렌드

이 조감도를 관통하는 세 가지 흐름:

**컴파일 타임으로의 이동**: React Compiler, Vue Vapor Mode, Svelte Runes. 런타임에서 수행하던 최적화를 빌드 시점으로 옮기는 것이 업계 전체의 방향이다. 빌드는 느려져도 되지만, 사용자의 브라우저는 빨라야 한다.

**서버의 복귀**: CSR 전성기가 지나고, 서버가 돌아왔다. React Server Components, Streaming SSR, Edge Rendering — 서버에서 더 많은 일을 처리하고, 클라이언트에는 최소한만 보내는 방향이다. 하지만 "모든 것을 서버에서"가 아니라, 페이지의 각 부분을 가장 적합한 환경에서 처리하는 **하이브리드 렌더링**이 핵심이다.

**프레임워크의 수렴**: Angular가 Signals를 도입하고, Vue가 Vapor Mode(컴파일 타임)를 준비하고, React가 Compiler를 출시했다. 출발점은 달랐지만, 모든 프레임워크가 "세밀한 반응성 + 컴파일 타임 최적화"라는 같은 방향으로 수렴하고 있다. 기술 선택의 핵심은 더 이상 "어느 것이 더 빠른가"가 아니라, **생태계, 팀 경험, 그리고 제품 요구사항**이다.

---

## References

이 글에서 다루는 기술의 2026년 기준 최신 버전과 공식 문서:

| 기술 | 버전 | 공식 문서 | 주요 발표 |
|:---|:---|:---|:---|
| React | v19.2 | [react.dev](https://react.dev) | [React 19 Release](https://react.dev/blog/2024/12/05/react-19) |
| Vue | v3.5 (3.6 RC) | [vuejs.org](https://vuejs.org) | [Vue.js Blog](https://blog.vuejs.org) |
| Angular | v22.0 | [angular.dev](https://angular.dev) | [Angular Blog](https://blog.angular.dev) |
| Svelte | v5.56 | [svelte.dev](https://svelte.dev) | [Svelte 5 is Alive](https://svelte.dev/blog/svelte-5-is-alive) |
| Next.js | v16.2 | [nextjs.org](https://nextjs.org) | [Next.js Blog](https://nextjs.org/blog) |
| Nuxt | v4.5 | [nuxt.com](https://nuxt.com) | [Nuxt Blog](https://nuxt.com/blog) |
| SvelteKit | v2.70 | [svelte.dev/docs/kit](https://svelte.dev/docs/kit) | [Svelte Blog](https://svelte.dev/blog) |
| Astro | v7.1 | [docs.astro.build](https://docs.astro.build) | [Astro 7.0 Release](https://astro.build/blog/astro-7) |
| Vite | v8.2 | [vite.dev](https://vite.dev) | [Vite Blog](https://vite.dev/blog) |
| Leptos | v0.9 beta | [leptos.dev](https://leptos.dev) | — |
| Yew | v0.23 | [yew.rs](https://yew.rs) | — |

### 벤치마크 및 서베이

- [js-framework-benchmark](https://github.com/krausest/js-framework-benchmark) — 프레임워크별 DOM 조작 성능 비교
- [State of JS](https://stateofjs.com) — 연간 JavaScript 생태계 서베이
- [Web Almanac](https://almanac.httparchive.org) — HTTP Archive 기반 웹 기술 사용 현황
- [WASI Component Model](https://component-model.bytecodealliance.org) — WebAssembly Component Model 명세
