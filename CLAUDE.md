# Claude Code Configuration

이 파일은 Claude Code 호환성을 위해 존재합니다.
모든 프로젝트 지침은 AGENTS.md를 참조하세요.

> 📖 See [AGENTS.md](./AGENTS.md) for all project instructions.

## Quick Reference

### Commands
```bash
npm run dev                      # 개발 서버 시작
npm run build                    # 프로덕션 빌드
bash scripts/validate-docs.sh    # 문서 무결성 검증
bash scripts/ai-context-update.sh  # 상태 파일 갱신
```

### Session Protocol
- **시작**: `.state/SESSION_LOG.md` + `.state/PROJECT_STATUS.md` 읽기
- **종료**: `.state/SESSION_LOG.md` 핸드오프 노트 작성, `.state/CHANGELOG.md` 갱신

### Core Principles
1. Progressive Disclosure — 필요한 정보만 로드
2. Token Budget — 문서 줄 수 제한 준수
3. Spec First — 코드 전 스펙 확인/작성
4. Living Docs — 코드 변경 시 문서 동기화
5. State Persistence — 상태는 .state/에 기록
