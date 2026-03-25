# relay Navigation Index

이 파일은 relay 프로젝트의 **폴더 책임**과 **파일 탐색 순서**를 정의하는 단일 진입점입니다.

## 시작 순서 (Must)

1. 이 파일 (`AGENTS.md`) 읽기
2. `docs/ref/ARCHITECTURE.md` — 시스템 구조 파악
3. `docs/status/PROJECT-STATUS.md` — 현재 상태 파악
4. `docs/status/EXECUTION-CHECKLIST.md` — 다음 작업 파악
5. `RELAY.md` — 작업 규칙 및 그래프 워크플로우

## 폴더 책임 규칙

### `src/relay/`

| 파일 | 책임 | 위험도 |
|------|------|--------|
| `cli.py` | CLI 진입점, 서브커맨드 라우팅 | Low |
| `tui.py` | Textual TUI, 슬래시 명령, 워크플로우 모달 | **High** |
| `service.py` | 오케스트레이션: 직접 채팅, 워크플로우, 위임, 복귀, 재생 | **High** |
| `repository.py` | SQLite 영속 계층 (agents, sessions, runs, results) | **High** |
| `workflow_store.py` | JSON 기반 워크플로우 상태 영속 | **High** |
| `adapters.py` | 프로바이더별 헤드리스 커맨드 빌더 | **High** |
| `prompts.py` | 위임/복귀 프롬프트 빌더, 출력 정규화 | **High** |
| `session_host.py` | PTY 기반 라이브 세션 호스트 (실험적) | Medium |
| `session_client.py` | Unix 소켓 세션 클라이언트 | Medium |
| `context.py` | 컨텍스트 스냅샷 캡처 (git, tree) | Low |
| `schemas.py` | 태스크별 출력 스키마 정의 | Low |
| `models.py` | Enum 정의 (AgentKind, TaskType, 등) | Low |
| `config.py` | 홈 디렉토리 및 경로 설정 | Low |
| `ids.py` | 프리픽스 순차 ID 생성 | Low |

### `tests/`

| 파일 | 대상 | 테스트 수 |
|------|------|----------|
| `test_service.py` | service.py | 19 |
| `test_tui.py` | tui.py | 47 |
| `test_workflow_store.py` | workflow_store.py | 5 |
| `test_repository.py` | repository.py | 1 |
| `test_adapters.py` | adapters.py | 5 |
| `test_prompts.py` | prompts.py | 7 |
| `test_schemas.py` | schemas.py | 1 |
| `test_session_host.py` | session_host.py | 3 |

### `docs/`

| 폴더 | 책임 | 업데이트 빈도 |
|------|------|-------------|
| `docs/ref/` | 안정적 참조 문서 | Phase/기능 단위 |
| `docs/status/` | 운영 상태 + 자동화 리포트 | 실시간/일일 |
| `docs/internal/daily/` | 일일 작업 증거 로그 | 작업 세션 단위 |
| `docs/internal/weekly/` | 주간 롤업 요약 | 주간 |

## 제품 문서 거버넌스

- 공식 참조 문서: `docs/ref/`에만 생성
- 운영 상태: `docs/status/`에서만 관리
- 상태 변경 시 downstream docs 동일 턴에 동기화
- 마일스톤: `docs/internal/daily/MM-DD/` 로그 + 주간 롤업 반영

## 태스크 라우팅

작업 종류별 참조 문서:

1. **코드 변경**: `RELAY.md` → 그래프 가이드 워크플로우 확인
2. **버그 수정**: `docs/status/TEST-MATRIX.md` → 관련 테스트 확인
3. **새 기능**: `docs/status/EXECUTION-CHECKLIST.md` → 우선순위 확인
4. **아키텍처 변경**: `docs/ref/ARCHITECTURE.md` → 경계 확인
5. **의사결정**: `docs/status/DECISION-LOG.md` → 기존 결정 확인
6. **문서 작업**: `docs/ref/DOCS-OPERATING-MODEL.md` → 운영 모델 확인
7. **프로바이더 작업**: `docs/ref/ARCHITECTURE.md` → 프로바이더 모델 확인
8. **테스트 작업**: `docs/status/TEST-MATRIX.md` → must-pass/known-risk 확인

## 진실 계층 (충돌 시 우선순위)

1. **코드/테스트 현실** — 실제 구현
2. **`docs/status/`** — 운영 상태
3. **`docs/ref/`** — 설계 의도
4. **`docs/internal/`** — 역사적 증거 (참조용)

## 편집 규칙

- `src/relay/` 변경 시: 관련 테스트 확인 필수
- High 위험도 모듈 변경 시: `code-review-graph` 사용 권장
- 상태 문서 변경 시: 코드 현실과 대조 후 업데이트
- 일일 로그는 증거 기록이며 현재 진실이 아님
