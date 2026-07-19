---
title: Architecture Decision Records Index
last_updated: 2026-07-19
---

# Architecture Decision Records (ADR)

## 개요

프로젝트의 주요 아키텍처 결정을 기록합니다.
새로운 ADR은 `docs/adr/_template.md`를 복사하여 작성합니다.

## 번호 규칙

- 3자리 숫자: 001, 002, ...
- 한번 부여된 번호는 재사용 금지
- Superseded된 ADR도 삭제하지 않음

## 작성 가이드

1. `_template.md` 복사 → `NNN-title.md`로 이름 지정
2. Context, Decision, Alternatives, Consequences 작성
3. Status를 `Proposed`로 설정
4. 리뷰 후 `Accepted`로 변경
5. 이 README의 목록에 추가

## ADR 목록

| # | Title | Status | Date |
|:--|:------|:-------|:-----|
| 001 | [Astro 프레임워크 선택과 프로젝트 구조 설계](./001-project-structure.md) | Accepted | 2026-07-19 |
