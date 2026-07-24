---
last_session: 2026-07-19
agent: Antigravity (Gemini)
---

# Session Log

## Latest Session: 2026-07-25 (Session 3)

### What was done
- 기술 에세이 "인지 부채 — AI 시대, 우리가 빌려 쓰는 것은 시간이 아니라 사고다" 작성
- MIT Media Lab, Margaret-Anne Storey 연구 기반 리서치 수행
- 인지 부채 개념, 다양한 관점, 실천 전략, 현존 철학 연결 포함
- 빌드 성공 확인 (8 pages)

### Key Decisions
- 에세이 카테고리로 작성 (essay → peach 색상)
- 기존 블로그 톤(성찰적 1인칭, 기술+내면 연결) 유지

### Current State
- 8개 페이지 빌드 성공
- 5개 콘텐츠 포스트 (신규 1건 추가)

### Next Session Should
1. Vercel 배포 확인 및 추가 콘텐츠 작성
2. SEO 최적화 (sitemap, RSS)

### Open Issues
- 없음

---

## Session 2: 2026-07-19

### What was done
- Astro 5.x 프로젝트 초기화 (minimal template)
- DESIGN.md 기반 Clay-inspired 디자인 시스템 전체 구현
- 3개 CSS 파일 (design-tokens, global, components)
- 2개 레이아웃, 7개 컴포넌트, 4개 페이지 생성
- 4개 샘플 콘텐츠 작성
- 히어로 일러스트레이션 생성 (Clay 스타일 3D)
- Content Collections 스키마 정의 (glob loader)
- npm run build 성공 (7 pages)
- GitHub 원격 저장소(`https://github.com/haloroom/presence-ego.git`) 연동 및 최초 커밋 푸시 완료
- Vercel 배포 플랫폼 채택 및 배포 가이드 문서(`docs/guides/deployment.md`) 추가
- `posts/index.astro` 및 `Header.astro` 애니메이션 렌더링 큐 처리 보완 및 JSDoc 규칙 추가 적용

### Key Decisions
- Inter 폰트 weight 500으로 Plain Black 대체
- 카테고리-색상 매핑: reading→pink, study→teal, reflection→lavender, essay→peach
- 크림 푸터 (NOT dark) — DESIGN.md 준수
- Content Layer API (Astro 5.x)
- 호스팅 솔루션으로 Vercel 채택 (Static SSG 빌드)

### Current State
- 7개 페이지 빌드 성공
- 디자인 시스템 전체 구현 완료
- GitHub 원격 저장소 연동 및 푸시 완료
- Vercel 배포 가이드 작성 완료 (대시보드 즉시 연동 가능 상태)

### Next Session Should
1. Vercel 대시보드에서 GitHub 저장소 연동 및 배포 확인
2. 실질적인 블로그 콘텐츠(에크하르트 톨레 철학 탐구글 등) 본격 작성 시작

### Open Issues
- 없음

---

## Session 1: 2026-07-19

### What was done
- AI 코딩 인프라 전체 초기 설정 완료

### Key Decisions
- Astro + TypeScript + Markdown 기술 스택 선택
- 블로그 카테고리: reading, study, reflection, essay
