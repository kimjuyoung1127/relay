# automation-health-monitor — 자동화 건강 상태 점검

## 목적
Lock 파일, 리포트 파일, 히스토리 파일의 건강 상태를 점검한다.

## DRY_RUN
기본값: `true`

## Lock
- 경로: `docs/status/.automation-health-monitor.lock`

## 검증 대상

### Lock 파일
- `docs/status/.docs-status-integrity.lock`
- `docs/ref/.architecture-sync.lock`
- `docs/status/.readme-sync.lock`
- `docs/status/.automation-health-monitor.lock`
- `docs/internal/.docs-nightly.lock`

### 리포트 파일
- `docs/status/DOCS-STATUS-INTEGRITY-REPORT.md`
- `docs/status/ARCHITECTURE-SYNC-REPORT.md`
- `docs/status/README-SYNC-REPORT.md`
- `docs/status/AUTOMATION-HEALTH-REPORT.md`
- `docs/status/NIGHTLY-RUN-LOG.md`

### 히스토리 파일
- `docs/status/DOCS-STATUS-INTEGRITY-HISTORY.ndjson`
- `docs/status/README-SYNC-HISTORY.ndjson`

## Lock 검증 규칙

- `running` 상태 2시간 초과 → `STALE_LOCK`
- JSON 파싱 실패 → `BROKEN_LOCK`
- 파일 없음 → `MISSING_LOCK` (정상 — 아직 실행되지 않음)

## 절차

1. Lock 획득
2. `.claude/automations/CLAUDE.md`에서 예상 자동화 목록 확인
3. 각 Lock 파일 상태 확인
4. 각 리포트 파일 존재 여부 및 타임스탬프 확인
5. 각 히스토리 파일 마지막 줄 파싱 → 최근 실행 시각 확인
6. `NIGHTLY-RUN-LOG.md` 마지막 항목 확인
7. 요약 생성
8. DRY_RUN이 아닌 경우: `docs/status/AUTOMATION-HEALTH-REPORT.md` 작성
9. Lock 해제

## 출력 형식

```
[automation-health-monitor 완료] YYYY-MM-DD HH:mm

## Lock 상태
| 자동화 | Lock 상태 | 마지막 실행 |
|--------|----------|------------|
| docs-status-integrity | released | 2026-03-25 10:15 |
| architecture-sync | MISSING | — |

## 리포트 상태
| 리포트 | 존재 | 마지막 수정 |
|--------|------|------------|
| DOCS-STATUS-INTEGRITY-REPORT.md | ✅ | 2026-03-25 |

## 요약
- total_automations: 5
- healthy: N
- stale_locks: N
- missing_reports: N
- errors: <none|summary>
```
