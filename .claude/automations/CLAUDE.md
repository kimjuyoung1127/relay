# relay 자동화 거버넌스

## 원칙
- 모든 자동화는 결정적(deterministic)이고 멱등(idempotent)해야 한다
- 비교/리포트 전에 정확한 source-of-truth 파일을 명시한다
- Lock 파일로 중복 실행을 방지한다
- 기본값: `DRY_RUN=true` — 명시적 프로모션 시에만 쓰기 모드
- `src/` 또는 `tests/`를 편집하지 않는다 (증거 재생성 시 제외)

## 실행 순서 (Asia/Seoul)

```
10:00  docs-status-integrity      — 코드↔문서 정합성 검증
10:30  architecture-sync          — 코드 구조↔아키텍처 문서 검증
10:45  readme-sync                — README 숫자/예시 드리프트 검출
11:00  automation-health-monitor  — Lock/리포트 건강 상태 요약
14:00  docs-nightly-organizer     — daily→weekly 롤업
```

## relay 고유 규칙
- source-of-truth 탐색: `AGENTS.md` → `RELAY.md` → `docs/ref/ARCHITECTURE.md`
- 제품/상태 진실: `docs/status/`
- 참조 진실: `docs/ref/`
- 일일 로그는 증거 — 명시적 프로모션 없이 현재 상태를 덮어쓰지 않음

## Lock 파일 위치
- `docs/status/.docs-status-integrity.lock`
- `docs/ref/.architecture-sync.lock`
- `docs/status/.readme-sync.lock`
- `docs/status/.automation-health-monitor.lock`
- `docs/internal/.docs-nightly.lock`
