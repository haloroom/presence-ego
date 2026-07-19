---
title: Technology Stack
last_updated: 2026-07-19
status: active
---

# Technology Stack

## Active Stack

### Frontend / SSG

| Technology | Version | Notes |
|:---|:---|:---|
| Astro | 5.x | 정적 사이트 생성기 |
| TypeScript | 5.x+ | 타입 안정성 |
| Markdown | - | Content Collections (glob loader) |

### Styling

| Technology | Notes |
|:---|:---|
| Vanilla CSS | CSS Custom Properties 기반 디자인 시스템 |
| Google Fonts (Inter) | 400, 500, 600 weights |
| design-tokens.css | DESIGN.md 기반 토큰 시스템 |

### Build & Dev

| Tool | Purpose |
|:---|:---|
| npm | 패키지 관리 |
| Astro CLI | 빌드 / 개발 서버 |

### AI Coding Tools

| Tool | Configuration File | Notes |
|:---|:---|:---|
| Antigravity (AGY) | `.agents/AGENTS.md` | Workspace customization root |
| Claude Code | `CLAUDE.md` → `AGENTS.md` | References AGENTS.md |

### Design System

| Feature | Implementation |
|:---|:---|
| Design Spec | DESIGN.md (Clay-inspired) |
| Color Palette | 크림 캔버스 + 6색 브랜드 팔레트 |
| Typography | Inter (Plain Black 대체) |
| Components | 7개 Astro 컴포넌트 |

### Content Management

| Feature | Implementation |
|:---|:---|
| Content Collections | Astro Content Layer API (glob loader) |
| 카테고리 | reading, study, reflection, essay |
| 태그 시스템 | Frontmatter `tags` 필드 |
| 날짜 관리 | `pubDate`, `updatedDate` |
