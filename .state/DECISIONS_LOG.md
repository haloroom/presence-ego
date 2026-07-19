# Decisions Log

ADR까지 작성할 필요 없는 빠른 결정을 기록합니다.

---

### 2026-07-19: Clay-inspired 디자인 시스템 채택
- **결정**: DESIGN.md에 정의된 Clay.com 영감 디자인 시스템 적용
- **이유**: 크림톤 캔버스와 6색 피처카드가 따뜻하고 개인적인 탐구 블로그에 적합
- **영향**: 전체 색상 팔레트, 타이포그래피, 컴포넌트 스타일이 DESIGN.md 토큰을 따름

### 2026-07-19: Inter 폰트로 Plain Black 대체
- **결정**: Inter weight 500 + negative letter-spacing으로 display 타이포 대체
- **이유**: Plain Black은 Clay.com 라이선스 전용 폰트
- **영향**: 모든 display 헤드라인에 Inter 500 적용

### 2026-07-19: 카테고리-색상 매핑
- **결정**: reading→pink, study→teal, reflection→lavender, essay→peach
- **이유**: 각 카테고리의 성격에 맞는 색상 매칭
- **영향**: PostCard 컴포넌트에서 카테고리별 자동 색상 적용

### 2026-07-19: Astro 5.x Content Layer API 사용
- **결정**: content.config.ts + glob loader 방식
- **이유**: Astro 5.x의 최신 Content Layer API 채택
- **영향**: 콘텐츠 파일은 src/content/posts/에 Markdown으로 관리

### 2026-07-19: 블로그 카테고리 구분
- **결정**: reading, study, reflection, essay 4개 카테고리
- **이유**: 독서/공부/느낌/에세이로 글의 성격이 명확히 나뉨
- **영향**: Content Collections 스키마에 category 필드 필수

### 2026-07-19: AI 도구 선택
- **결정**: Antigravity + Claude Code 조합 사용
- **이유**: Antigravity의 워크스페이스 인식 + Claude Code의 강력한 코딩 지원
- **영향**: .agents/AGENTS.md + CLAUDE.md 설정

### 2026-07-19: Vercel 배포 플랫폼 채택
- **결정**: 프로젝트 호스팅 플랫폼으로 Vercel을 채택하여 배포 설정 진행
- **이유**: 정적 사이트(SSG) 배포가 매우 용이하며, GitHub 저장소와 무중단 자동 연동 및 최적화된 CDN 가속을 무료로 제공함
- **영향**: docs/guides/deployment.md 생성, TECH_STACK 및 PROJECT_STATUS 최신화

