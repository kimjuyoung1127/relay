# readme-sync — README 드리프트 검출

## 목적
`README.md`에 기록된 숫자, 예시, 기능 목록이 실제 코드/상태와 일치하는지 검증한다.

## DRY_RUN
기본값: `true`

## Lock
- 경로: `docs/status/.readme-sync.lock`

## Source-of-Truth 입력

### 코드 사실
- `src/relay/models.py` — AgentKind 멤버 (프로바이더 수)
- `src/relay/schemas.py` — TaskType별 스키마 (태스크 유형 수)
- `src/relay/cli.py` — CLI 서브커맨드
- `tests/test_*.py` — 테스트 함수 카운트 (`def test_` 패턴)

### 문서 사실
- `README.md` — 숫자 인스턴스, CLI 예시, 검증 스냅샷
- `docs/status/PROJECT-STATUS.md` — Phase 완료 상태

## 절차

1. Lock 획득
2. 코드에서 사실 수집:
   - `actual_provider_count` — AgentKind 멤버 수
   - `actual_test_count` — 테스트 함수 총 수
   - `actual_task_types` — TaskType 멤버 목록
   - `cli_subcommands` — CLI 서브커맨드 목록
3. README에서 파싱:
   - 모든 숫자 인스턴스 (정규식: `N tests`, `N providers`, 등)
   - CLI 예시 코드 블록 (`relay <subcommand>` 패턴)
   - 검증 스냅샷 섹션
4. 비교 → 드리프트 검출:
   - `TEST_COUNT_DRIFT` (CRITICAL) — 테스트 수 불일치
   - `PROVIDER_COUNT_DRIFT` (HIGH) — 프로바이더 수 불일치
   - `EXAMPLE_COMMAND_MISSING` (MEDIUM) — README 예시에 없는 서브커맨드
   - `VALIDATION_DRIFT` (HIGH) — 검증 스냅샷과 PROJECT-STATUS 불일치
5. DRY_RUN이 아닌 경우:
   - `docs/status/README-SYNC-REPORT.md` 작성
   - `docs/status/README-SYNC-HISTORY.ndjson` 한 줄 추가
6. Lock 해제

## 출력 형식

```
[readme-sync 완료] YYYY-MM-DD HH:mm

## 숫자 Drift
| 위치 | 현재값 | 정확한값 | 심각도 |
|------|--------|----------|--------|
| README:250 "86 tests" | 86 | 92 | CRITICAL |

## 요약
- test_count_drift: <true|false>
- provider_count_drift: <true|false>
- total_issues: N
- auto_fixable: N (숫자만)
- manual_review_needed: N
```

## 금지 사항
- `src/` 또는 `tests/` 편집 금지
- README 자동 수정은 숫자 치환만 허용 — 예시/설명은 수동 리뷰 필요
