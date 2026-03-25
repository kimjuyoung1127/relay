# 2026-03-25 — 문서 거버넌스 체계 이식

> Historical snapshot only.
> 현재 기준: `docs/status/PROJECT-STATUS.md`, `docs/status/EXECUTION-CHECKLIST.md`

## 완료 항목
- unityctl 문서 거버넌스 시스템 분석 완료
- relay 프로젝트에 맞게 전체 구조 이식:
  - `AGENTS.md` 생성 — 폴더 책임 및 탐색 순서 정의
  - `docs/ref/CLAUDE.md` — 참조 문서 거버넌스 규칙
  - `docs/status/CLAUDE.md` — 운영 상태 거버넌스 규칙
  - `docs/internal/CLAUDE.md` — 내부 문서 거버넌스 규칙
  - `docs/internal/daily/CLAUDE.md` — 일일 로그 컨벤션
  - `docs/internal/weekly/CLAUDE.md` — 주간 롤업 컨벤션
- 5개 자동화 프롬프트 생성 (relay 맥락 적응):
  - `docs-status-integrity` — Python 모듈 기반 코드↔문서 검증
  - `architecture-sync` — ARCHITECTURE.md↔실제 코드 구조 검증
  - `readme-sync` — README 숫자/예시 드리프트 검출
  - `automation-health-monitor` — Lock/리포트 건강 점검
  - `docs-nightly-organizer` — daily→weekly 롤업
- `.claude/commands/grill-me.md` — 인터뷰 커맨드 이식
- `docs/README.md` 업데이트 — internal/ 계층 반영
- 기존 `docs/daily/`, `docs/weekly/` → `docs/internal/` 하위로 재구성

## 이식 원본
- `C:\Users\ezen601\Desktop\Jason\unityctl` 문서 거버넌스 시스템
- C# → Python 맥락 적응
- CommandCatalog → models.py Enum, schemas.py
- MCP tools → adapters.py 프로바이더
- dotnet test → unittest discover

## 주요 적응 사항
- unityctl의 C# source-of-truth (CommandCatalog, Program.cs, MCP Tools)를
  relay의 Python source-of-truth (models.py, schemas.py, adapters.py, cli.py)로 매핑
- Lock/NDJSON 패턴은 언어 독립적이므로 그대로 이식
- 자동화 실행 시간대는 동일 (Asia/Seoul)
