# docs-nightly-organizer — daily→weekly 롤업

## 목적
일일 작업 로그를 주간 요약으로 롤업하고, nightly 실행 로그에 기록한다.

## DRY_RUN
기본값: `true`

## Lock
- 경로: `docs/internal/.docs-nightly.lock`

## Source-of-Truth 입력
- `docs/internal/daily/**` — 일일 로그
- `docs/internal/weekly/**` — 기존 주간 롤업
- `docs/status/PROJECT-STATUS.md` — 현재 Phase 상태 참조
- `docs/status/EXECUTION-CHECKLIST.md` — 현재 백로그 참조

## 절차

1. Lock 획득
2. `docs/internal/daily/`에서 최신 날짜 폴더 식별
3. 해당 폴더의 모든 `module-*.md` 읽기
4. 현재 ISO 주차 계산 (`YYYY-WNN`)
5. `docs/internal/weekly/YYYY-WNN.md` 생성 또는 업데이트:
   - Phase 진행률 (PROJECT-STATUS.md 참조)
   - 완료 항목 (daily 로그에서 추출)
   - 문서 업데이트 내역
   - 열린 리스크 (EXECUTION-CHECKLIST.md 참조)
   - 다음 주 목표
6. `docs/status/NIGHTLY-RUN-LOG.md`에 실행 기록 추가
7. `docs/ref/`, `docs/status/`, `docs/internal/weekly/` 간 깨진 링크 검사
8. Lock 해제

## 주간 롤업 형식

```markdown
# YYYY-WNN 주간 롤업

> Historical snapshot only.
> 현재 기준: docs/status/PROJECT-STATUS.md, docs/status/EXECUTION-CHECKLIST.md

기간: YYYY-MM-DD ~ YYYY-MM-DD

## Phase 진행률
| 항목 | 시작 상태 | 종료 상태 |
|------|----------|----------|
| vendor-specific live origin | in progress | in progress |

## 완료 항목
- 항목 1
- 항목 2

## 문서 업데이트
- 변경된 문서 목록

## 열린 리스크
- 리스크 항목

## 다음 주 목표
- 목표 1
```

## Nightly 로그 형식

`docs/status/NIGHTLY-RUN-LOG.md`에 추가:

```
[docs nightly organizer 완료] YYYY-MM-DD HH:mm
- rolled_daily_folder: <MM-DD|none>
- weekly_created_or_updated: <file|none>
- nightly_log_appended: <true|false>
- broken_links: N
- errors: <none|summary>
```

## 금지 사항
- `src/` 또는 `tests/` 편집 금지
- 기존 daily 로그 수정 금지 (읽기 전용)
- NDJSON 히스토리 파일 truncate 금지 — append만
