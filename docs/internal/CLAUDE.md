# docs/internal/ 거버넌스 규칙

## 용도
내부 작업 증거, 일일/주간 로그, 벤치마크, 개발 이력 보관소.

## 폴더 구조
- `daily/` — 일일 실행 로그 (`MM-DD/module-{slug}.md`)
- `weekly/` — 주간 롤업 (`YYYY-WNN.md`)

## 주의
- 이 폴더의 문서는 **당시 시점 기록**
- **현재 상태 판단 기준이 아님**
- 현재 기준:
  - `docs/status/PROJECT-STATUS.md`
  - `docs/status/EXECUTION-CHECKLIST.md`
  - `docs/ref/ARCHITECTURE.md`

## 규칙
- 일일 로그: 작업 완료 시 해당 날짜 폴더에 기록
- 주간 롤업: 수동 또는 nightly 자동화로 생성
- 코드 진실과 충돌 시 코드가 우선
