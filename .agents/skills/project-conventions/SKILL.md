---
name: project-conventions
description: presence-ego 프로젝트의 코딩 컨벤션과 문서화 규칙을 적용합니다. 코드 리뷰, 새 파일 생성, 리팩토링 시 활성화됩니다.
---

# Project Conventions Skill

이 스킬은 presence-ego 프로젝트의 코딩 및 문서화 컨벤션을 정의합니다.

## When to Activate
- 새 파일 생성 시
- 코드 리뷰/리팩토링 시
- 문서 작성/수정 시
- 블로그 콘텐츠 작성/수정 시

## File Creation Checklist
1. 파일명은 kebab-case
2. 컴포넌트는 PascalCase (.astro 확장자)
3. 파일 상단에 목적 설명 주석
4. 관련 docs/ 문서 업데이트 여부 확인

## Content Creation Checklist
1. YAML frontmatter 필수 (title, description, category, tags, pubDate)
2. 카테고리: reading | study | reflection | essay
3. 태그는 kebab-case
4. draft: true로 작성 시작, 완료 시 false로 변경

## Documentation Checklist
1. YAML frontmatter 포함
2. 줄 수 제한 준수 (Token Budget)
3. 링크 무결성 확인
4. CHANGELOG 업데이트

## Commit Checklist
1. Conventional Commits 형식 준수
2. 블로그 글은 `content(category): description` 형식
3. 관련 문서 동기화 완료
4. `bash scripts/validate-docs.sh` 통과
5. .state/ 파일 갱신 (필요 시)
