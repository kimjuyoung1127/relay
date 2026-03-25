# docs/status/ 거버넌스 규칙

## 용도
빠르게 변하는 운영 상태, 의사결정, 자동화 리포트 보관소.

## 규칙
- 상태 파일만 변경 (`ref/`, `internal/`은 수정 금지)
- Phase 변경은 `PROJECT-STATUS.md`에만 기록
- 의사결정은 `DECISION-LOG.md`에 기록
- 자동화 리포트는 자동 생성됨 (수동 편집 주의)
- Lock 파일로 자동화 중복 실행 방지

## Lock 파일 형식
```json
{"status": "running", "started_at": "2026-03-25T10:00:00Z"}
```
→ 완료 시:
```json
{"status": "released", "released_at": "2026-03-25T10:15:00Z"}
```

- `running` 상태가 2시간 이상이면 `STALE_LOCK`
- 자동 삭제 금지 — 리포트만 생성

## 현재 문서
- `PROJECT-STATUS.md` — 현재 Phase 및 검증 상태
- `DECISION-LOG.md` — 확정된 제품/아키텍처 결정
- `EXECUTION-CHECKLIST.md` — 우선순위 실행 백로그
- `TEST-MATRIX.md` — must-pass / known-risk / optional 테스트
