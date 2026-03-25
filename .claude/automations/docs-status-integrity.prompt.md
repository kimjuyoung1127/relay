# docs-status-integrity — 코드↔문서 정합성 검증

## 목적
relay 소스 코드의 실제 상태와 문서에 기록된 상태 간 드리프트를 검출한다.

## DRY_RUN
기본값: `true` — 리포트만 출력, 파일 쓰기 없음.

## Lock
- 경로: `docs/status/.docs-status-integrity.lock`
- 형식: `{"status":"running","started_at":"<ISO>"}`
- 완료: `{"status":"released","released_at":"<ISO>"}`
- 2시간 초과 running → `STALE_LOCK` 리포트

## Source-of-Truth 입력

### 코드 진실
- `src/relay/models.py` — AgentKind, TaskType, ApprovalMode 등 Enum 정의
- `src/relay/schemas.py` — 태스크별 출력 스키마, 프리셋 목록
- `src/relay/adapters.py` — 프로바이더별 커맨드 빌더
- `src/relay/cli.py` — CLI 서브커맨드 목록
- `src/relay/service.py` — RECOMMENDED_FOR_BY_KIND, EXPERIMENTAL_FOR_BY_KIND
- `tests/` — 테스트 파일 수 및 테스트 함수 수

### 문서 진실
- `docs/status/PROJECT-STATUS.md` — Phase 완료 상태, 검증 스냅샷
- `docs/status/EXECUTION-CHECKLIST.md` — 실행 백로그
- `docs/status/TEST-MATRIX.md` — 테스트 매트릭스
- `docs/ref/ARCHITECTURE.md` — 프로바이더 모델, 안정성 경계
- `docs/internal/daily/` — 최신 일일 폴더

## 절차

1. Lock 획득
2. 코드에서 사실 수집:
   - `AgentKind` 멤버 목록 파싱
   - `TaskType` 멤버 목록 파싱
   - `RECOMMENDED_FOR_BY_KIND` 매핑 파싱
   - 프로바이더 커맨드 빌더 목록 (`adapters.py`)
   - CLI 서브커맨드 목록 (`cli.py`)
   - 스키마/프리셋 목록 (`schemas.py`)
   - 테스트 함수 카운트 (`tests/test_*.py`에서 `def test_` 패턴)
3. 문서에서 사실 수집:
   - `PROJECT-STATUS.md` Phase 항목 파싱
   - `ARCHITECTURE.md` 프로바이더 모델 파싱
   - `TEST-MATRIX.md` must-pass 항목 카운트
4. 비교 → 드리프트 검출:
   - `PROVIDER_COUNT_DRIFT` — AgentKind 멤버 ≠ 문서 프로바이더 수
   - `TASK_TYPE_DRIFT` — TaskType 멤버 ≠ 문서 태스크 유형 수
   - `TEST_COUNT_DRIFT` — 실제 테스트 수 ≠ 문서 기록 수
   - `RECOMMENDATION_DRIFT` — 코드 추천 매핑 ≠ 문서 추천 설명
   - `SCHEMA_DRIFT` — 스키마 목록 ≠ 문서 태스크 유형 설명
   - `STATUS_MISMATCH` — 최신 daily 로그와 PROJECT-STATUS 불일치
5. DRY_RUN이 아닌 경우:
   - `docs/status/DOCS-STATUS-INTEGRITY-REPORT.md` 작성
   - `docs/status/DOCS-STATUS-INTEGRITY-HISTORY.ndjson` 한 줄 추가
6. Lock 해제

## 출력 형식

```
[docs-status-integrity 완료] YYYY-MM-DD HH:mm

## 드리프트 검출
| 유형 | 코드 값 | 문서 값 | 심각도 |
|------|---------|---------|--------|
| PROVIDER_COUNT_DRIFT | 4 | 3 | HIGH |

## 요약
- provider_count_drift: <true|false>
- task_type_drift: <true|false>
- test_count_drift: <true|false>
- total_issues: N
- errors: <none|summary>
```

## 금지 사항
- `src/` 또는 `tests/` 편집 금지
- Lock이 이미 running이면 즉시 종료
