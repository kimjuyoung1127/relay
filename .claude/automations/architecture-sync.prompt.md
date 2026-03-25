# architecture-sync — 코드 구조↔아키텍처 문서 검증

## 목적
`docs/ref/ARCHITECTURE.md`의 시스템 구조 설명이 실제 코드 구조와 일치하는지 검증한다.

## DRY_RUN
기본값: `true`

## Lock
- 경로: `docs/ref/.architecture-sync.lock`
- 2시간 초과 running → `STALE_LOCK`

## Source-of-Truth 입력

### 코드 구조
- `src/relay/*.py` — 모든 모듈 파일 목록 및 import 관계
- `src/relay/service.py` — 오케스트레이션 흐름 (direct/workflow)
- `src/relay/adapters.py` — 프로바이더 목록 및 커맨드 빌더
- `src/relay/repository.py` — 테이블 목록 및 영속 모델
- `src/relay/workflow_store.py` — 워크플로우 상태 모델
- `src/relay/session_host.py` — PTY/소켓 패턴

### 문서
- `docs/ref/ARCHITECTURE.md` — Layers, Core Runtime Model, State Model, Provider Model, Stability Boundary
- `AGENTS.md` — 폴더 책임 규칙

## 검증 포인트

1. **Layers 섹션**: 나열된 모듈이 실제 `src/relay/` 파일과 일치하는가?
2. **Core Runtime Model**: Direct/Workflow 흐름 설명이 `service.py` 로직과 일치하는가?
3. **State Model**: 나열된 SQLite 테이블이 `repository.py` 테이블과 일치하는가?
4. **Provider Model**: 프로바이더 목록/추천이 `adapters.py` + `service.py`와 일치하는가?
5. **Stability Boundary**: Stable/Experimental 분류가 코드 실제 상태와 일치하는가?
6. **누락 모듈**: `src/relay/`에 새 파일이 추가되었는데 ARCHITECTURE.md에 없는가?

## 드리프트 유형

- `MODULE_MISSING` — 코드에 있지만 문서에 없는 모듈
- `MODULE_GHOST` — 문서에 있지만 코드에 없는 모듈
- `TABLE_DRIFT` — SQLite 테이블 목록 불일치
- `PROVIDER_DRIFT` — 프로바이더 목록/추천 불일치
- `STABILITY_DRIFT` — Stable/Experimental 경계 불일치
- `FLOW_DRIFT` — Direct/Workflow 흐름 설명 불일치

## 출력
- DRY_RUN이 아닌 경우: `docs/status/ARCHITECTURE-SYNC-REPORT.md`

## 금지 사항
- `src/` 또는 `tests/` 편집 금지
