# relay Docs Hub

이 폴더는 relay 프로젝트의 문서 관리 허브입니다.

## 시작 순서

1. `AGENTS.md` 읽기 — 폴더 책임 및 탐색 순서
2. `docs/ref/ARCHITECTURE.md` — 시스템 구조
3. `docs/status/PROJECT-STATUS.md` — 현재 상태
4. `docs/status/EXECUTION-CHECKLIST.md` — 다음 작업

## 문서 계층

### `docs/status/` — 운영 상태 (빠르게 변함)

| 문서 | 역할 |
|------|------|
| [PROJECT-STATUS.md](status/PROJECT-STATUS.md) | Phase 완료 상태, 검증 스냅샷 |
| [DECISION-LOG.md](status/DECISION-LOG.md) | 확정된 제품/아키텍처 결정 |
| [EXECUTION-CHECKLIST.md](status/EXECUTION-CHECKLIST.md) | 우선순위 실행 백로그 |
| [TEST-MATRIX.md](status/TEST-MATRIX.md) | must-pass / known-risk / optional 테스트 |
| [NIGHTLY-RUN-LOG.md](status/NIGHTLY-RUN-LOG.md) | 자동화 실행 기록 |

### `docs/ref/` — 안정적 참조 (느리게 변함)

| 문서 | 역할 |
|------|------|
| [ARCHITECTURE.md](ref/ARCHITECTURE.md) | 시스템 구조, 상태 모델, 프로바이더 모델 |
| [CODE-REVIEW-GRAPH-TUNING.md](ref/CODE-REVIEW-GRAPH-TUNING.md) | 그래프 기반 스코프 분석 |
| [DOCS-OPERATING-MODEL.md](ref/DOCS-OPERATING-MODEL.md) | 문서 유지보수 모델 |

### `docs/internal/` — 내부 작업 기록 (증거용)

| 폴더 | 역할 |
|------|------|
| [daily/](internal/daily/) | 일일 작업 로그 (`MM-DD/module-{slug}.md`) |
| [weekly/](internal/weekly/) | 주간 롤업 (`YYYY-WNN.md`) |

### 루트 장문 참조 (전환 중)

| 문서 | 역할 |
|------|------|
| [AUTH_SETUP.md](../AUTH_SETUP.md) | 프로바이더 인증 설정 |
| [IMPLEMENTATION_HISTORY.md](../IMPLEMENTATION_HISTORY.md) | 구현 타임라인 |
| [PRODUCTION_CHECKLIST.md](../PRODUCTION_CHECKLIST.md) | 프로덕션 체크리스트 |
| [UX_SPEC.md](../UX_SPEC.md) | UX 설계 명세 |

## 진실 계층 (충돌 시)

1. **코드/테스트** — 실제 구현
2. **docs/status/** — 운영 상태
3. **docs/ref/** — 설계 의도
4. **docs/internal/** — 역사적 증거 (참조용)

## 자동화

5개 자동화 프롬프트가 `.claude/automations/`에 등록되어 있습니다:

| 시간 (KST) | 자동화 | 역할 |
|------------|--------|------|
| 10:00 | docs-status-integrity | 코드↔문서 정합성 검증 |
| 10:30 | architecture-sync | 코드 구조↔아키텍처 문서 검증 |
| 10:45 | readme-sync | README 숫자/예시 드리프트 검출 |
| 11:00 | automation-health-monitor | Lock/리포트 건강 점검 |
| 14:00 | docs-nightly-organizer | daily→weekly 롤업 |

## 업데이트 규칙

작업 완료 시:
1. 코드 업데이트
2. `docs/status/PROJECT-STATUS.md` 업데이트
3. `docs/status/DECISION-LOG.md`에 결정 기록
4. `docs/status/EXECUTION-CHECKLIST.md` 조정
5. `docs/internal/daily/MM-DD/module-{slug}.md` 증거 기록
6. 참조 문서는 안정 모델이 변한 경우에만 업데이트
