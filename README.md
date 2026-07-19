# presence-ego

> 현존(Presence)과 에고(Ego) 사이의 자기 탐구 블로그

## Overview

presence-ego는 에크하르트 톨레(Eckhart Tolle)의 'A New Earth'에서 영감받은 개인 탐구 블로그입니다. "현존"(진리에 가까운 나)과 "에고"(생각과 나를 동일시하는 가짜 나) 사이에서 탐구하며, 내려놓고 어떻게 느끼는지 진실되게 나를 바라봅니다.

### 기록하는 것들
- 📚 **독서**: 책에서 얻은 인사이트와 공감
- 📖 **공부**: 배우고 정리한 지식의 흔적
- 🌿 **느낌**: 내면에서 일어나는 솔직한 탐구
- ✍️ **에세이**: 생각의 흐름을 따라가는 자유 글쓰기

### Key Benefits
- **🎯 Token-Efficient**: 계층적 정보 구조로 AI의 컨텍스트 윈도우 최적화
- **🔄 Session Persistence**: Memory Bank 패턴으로 세션 간 상태 유지
- **📐 Spec-Driven**: 코드 전에 스펙을 작성하여 AI의 요구사항 이탈 방지
- **📝 Living Documentation**: 코드와 함께 진화하는 살아있는 문서

## Tech Stack

| Category | Technology |
|:---|:---|
| Framework | Astro |
| Language | TypeScript |
| Content | Markdown (Content Collections) |
| AI Tools | Antigravity + Claude Code |

## Quick Start

```bash
# 의존성 설치
npm install

# 개발 서버 시작
npm run dev

# 프로덕션 빌드
npm run build

# 빌드 미리보기
npm run preview
```

## Project Structure

```
presence-ego/
├── .agents/                     # 🤖 AI 에이전트 설정 (Antigravity)
│   ├── AGENTS.md                #    워크스페이스 스코프 지침
│   └── skills/                  #    커스텀 스킬 정의
│       └── project-conventions/
├── docs/                        # 📚 문서 허브
│   ├── ARCHITECTURE.md          #    시스템 아키텍처
│   ├── TECH_STACK.md            #    기술 스택 명세
│   ├── CONVENTIONS.md           #    코딩 컨벤션
│   ├── GLOSSARY.md              #    용어 사전
│   ├── adr/                     #    Architecture Decision Records
│   ├── specs/                   #    기능 명세서
│   └── guides/                  #    심화 가이드
├── .state/                      # 🧠 상태 관리 (Memory Bank)
│   ├── PROJECT_STATUS.md        #    프로젝트 현재 상태
│   ├── CHANGELOG.md             #    변경 이력
│   ├── SESSION_LOG.md           #    세션 핸드오프 기록
│   ├── DECISIONS_LOG.md         #    빠른 결정 로그
│   └── KNOWN_ISSUES.md         #    알려진 이슈
├── scripts/                     # 🔧 자동화 스크립트
│   ├── ai-context-update.sh     #    상태 파일 자동 갱신
│   └── validate-docs.sh         #    문서 무결성 검증
├── src/                         # 💻 소스 코드
│   ├── content/                 #    블로그 콘텐츠 (Markdown)
│   │   ├── reading/             #    독서 기록
│   │   ├── study/               #    공부 정리
│   │   ├── reflection/          #    내면 탐구
│   │   └── essay/               #    자유 에세이
│   ├── components/              #    Astro 컴포넌트
│   ├── layouts/                 #    페이지 레이아웃
│   ├── pages/                   #    라우트 페이지
│   └── styles/                  #    글로벌 스타일
├── public/                      # 🖼️ 정적 에셋
├── README.md                    # 📄 프로젝트 진입점 (이 파일)
├── AGENTS.md                    # 🤖 루트 AI 지침 (벤더 중립)
├── CLAUDE.md                    # 🤖 Claude Code 호환
└── .gitignore
```

## Design Principles

| # | 원칙 | 설명 |
|:-:|:---|:---|
| 1 | **Progressive Disclosure** | AI가 필요한 시점에 필요한 깊이만 접근 |
| 2 | **Single Source of Truth** | 모든 상태는 Markdown 파일에 기록 |
| 3 | **Token-Efficient** | 파일별 줄 수 제한으로 컨텍스트 윈도우 효율 보장 |
| 4 | **Living Documentation** | 코드 변경 시 관련 문서가 함께 갱신 |

## Key Files for AI

| 파일 | 로드 시점 | 최대 줄 수 | 목적 |
|:---|:---|:---:|:---|
| `README.md` | 항상 | 200 | 프로젝트 개요 |
| `AGENTS.md` | 항상 | 150 | AI 핵심 지침 |
| `docs/ARCHITECTURE.md` | 아키텍처 작업 | 300 | 설계 참조 |
| `docs/specs/*.md` | 기능 구현 시 | 200/파일 | 요구사항 |
| `.state/SESSION_LOG.md` | 세션 시작/종료 | 100 | 핸드오프 |
| `.state/PROJECT_STATUS.md` | 세션 시작 | 80 | 현재 상태 |

## Session Handoff Protocol

```
세션 시작 → .state/SESSION_LOG.md 읽기 → 컨텍스트 복원
    ↓
작업 수행 → 코드 변경 + 문서 갱신
    ↓
세션 종료 → .state/SESSION_LOG.md 핸드오프 노트 작성
           → .state/CHANGELOG.md 변경사항 추가
           → 주요 결정 시 docs/adr/ 기록
```

## License

MIT
