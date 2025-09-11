# RentHouse 1차 개발 검토 & 개선 제안 (건물주 중심 관점 · v2)
_작성: 2025-09-09_

## 1) 핵심 사용자(Target)
- **건물주/소규모 임대사업자(Owner/Landlord)** — 10~30 유닛 규모
- 반복 업무(계약·청구·수납·보고서) 자동화와 한눈 현황 파악이 최우선

## 2) 현황 요약
- 구현: 자산/유닛, 임차인, 계약, **청구 관리**, 대시보드, 로컬 DB(Drift)  
- 남은 핵심: **수익관리(수납/영수증/보고서 심화)**, RBAC, 작업주문(유지보수), 설정, 품질/테스트  
- 참고: 1단계 리포트의 기능 요약(로그인/자산/임차인/계약/청구, M3/반응형/라우팅/Drift/대시보드)  
  → 세부 근거는 문서 하단 “참고/근거” 섹션 참조.

---

## 3) 건물주 관점 주요 니즈(요약)
1. **수익/현황을 한눈에** — 월세 수입, 미납, 공실
2. **청구→수납→영수증** 자동화
3. **문서·증빙(PDF)** — 계약서·영수증·점검표 (※ 법적 증빙은 후순위)
4. **유지보수 요청 추적** — 요청→할당→처리→완료
5. **권한 위임(RBAC)** — 관리인/회계사에 제한 권한

---

## 4) “원래 계획된 파일 3개”와 가치 연결(요약)
- **임대차 계약서 PDF** — 법적 관계 증빙 (후순위)
- **월별 수익·임차인 현황 보고서 PDF** — 경영 지표
- **입주/퇴실 체크리스트 PDF** — 시설 상태·분쟁 예방

---

## 5) 우선 강화: 수익관리(Revenue Management) — **상세 설계**

### 5.1 데이터 모델(최소 확장)
- `Billing(id, lease_id, yearMonth, issueDate, dueDate, totalAmount, status)`  
  - `status`: `DRAFT | ISSUED | PARTIALLY_PAID | PAID | OVERDUE | VOID`
- `BillingItem(id, billing_id, name, category, quantity, unitPrice, tax, amount, memo)`
- **신규** `Payment(id, tenant_id, method, amount, paidDate, reference, memo)`
  - `method`: `CASH | TRANSFER | CARD | ETC`
- **신규** `PaymentAllocation(id, payment_id, billing_id, amount)`  
  - 부분 수납/여러 청구서에 배분 가능
- **선택** `Adjustment(id, billing_id, type, amount, reason)`  
  - `type`: `DISCOUNT | WRITE_OFF | LATE_FEE | ADJUST_UP/DOWN`
- **선택** `Receipt(id, payment_id, number, pdfUrl/hash)` — 영수증 메타

> **중복 청구 방지**: `(lease_id, yearMonth)` 유니크 인덱스

### 5.2 워크플로우
1) **월초 자동 청구 생성**  
   - 트리거: 사용자가 “청구 생성” 실행(로컬 앱은 상시 백그라운드가 없으므로 _수동/반자동_ 버튼 우선)  
   - 규칙: 계약기간 내 유효한 Lease에 대해 1건씩 생성, 기존 존재 시 스킵  
   - 프레이밍: 보증금·월세·관리비·유틸리티 항목 템플릿 적용
2) **수납(Payment) 등록**  
   - 금액 입력 → **자동 배분**(가장 오래된 미납부터) 또는 수동 배분  
   - 결과: Billing 상태 전이(예: `ISSUED→PARTIALLY_PAID→PAID`)
3) **영수증 발행(PDF)**  
   - Payment 기준 단일/복수 Billing 배분 내역 포함  
   - 고유 번호/일자/금액/납부방법/임차인/세부배분/발행자
4) **연체/가산금(선택)**  
   - `dueDate`+X일 초과 시 `LATE_FEE` Adjustment 추가(비율/정액)  
   - 미납 Aging 산출(0–30/31–60/61–90/90+ 일)
5) **정산/환불**  
   - 초과 입금은 `Credit`(양수 조정) 또는 다음달 상계  
   - 환불은 음수 Payment(또는 별도 Refund)로 기록

### 5.3 계산/검증 규칙
- 금액 단위: **KRW 정수(원)** — 반올림 없는 합산(세금도 원 단위)  
- **일할 계산(Proration)**: 중도 입주/퇴실 시 `월세 × (사용일/월일수)`  
- 증감: **임대료 인상분**이 월 중 발생 시 이월 분리 또는 일할  
- Deposit 전용: 별도 계정으로 관리, 임대료 상계는 명시적 전표(Adjustment)로 처리  
- 데이터 제약: Payment ≤ 미납 합계(단, 크레딧 허용 시 초과 가능)

### 5.4 UI/UX 사양
- **대시보드 KPI**:  
  - 이번 달 _청구/수납/미납_, 공실 수, 연체 비중  
- **청구 리스트**: 상태 배지, 연체 필터, 합계/미납 합계, **대량 선택→대량 발행**  
- **수납 화면**: 자동배분 미리보기, 수동배분 Drag-to-allocate(데스크톱), 빠른 입력(숫자패드)  
- **영수증 PDF**: 로고/사업자 정보/발행자, 항목·배분 테이블, 하단 바코드/QR(선택)  
- **리포트(다운로드)**:  
  - **월별 수익**(청구 vs 수납, 전년동월 대비)  
  - **연체 리포트/에이징**(임차인·유닛별)  
  - **점유율 vs 잠재 수익**(공실 손실 추정)
- **CSV 가져오기(선택)**: 은행 입출금 CSV 업로드 → 키워드/금액 일치로 반자동 매칭

### 5.5 수용 기준(예시)
- (월초) “청구 생성” 실행 시 **중복 0건**, 로그에 건수/스킵 사유 기록  
- 부분 수납 케이스에서 배분 합계 = Payment 금액 **일치**  
- 영수증 PDF **1초 내 생성**, 재현성 있는 번호 체계  
- Aging 리포트 합계 = 미납 합계 **일치**, 필터(기간/자산/유닛/임차인) 동작

### 5.6 테스트 포인트
- 단위: 일할/가산금/배분/상태전이, 유니크 제약  
- 위젯: 수납 배분 UI, 대량 발행  
- 통합: 청구→수납→영수증→리포트 합계 정합성

---

## 6) 우선 강화: **보안/RBAC & 유지보수(Work Order)** — 구현 아이디어

### 6.1 보안 & RBAC (백엔드 전환 전 _프론트 가드_ 전략)
- **역할/권한 모델**: `OWNER, ADMIN, MANAGER, ACCOUNTANT, STAFF, READONLY`  
  - 권한 토글: 모듈×액션(`read/create/update/delete/export/approve`)
- **라우팅 가드**: `go_router.redirect`에서 세션/역할 검사  
- **위젯 가드**: `can('bills.create')` 헬퍼로 버튼/액션 노출 제어  
- **로컬 인증 상태**: 개발 단계에선 **Mock 세션** + 기기 보안 저장소  
  - `flutter_secure_storage`로 토큰/키 저장(키체인/Keystore/DPAPI)  
- **로컬 DB 암호화**(권장): Drift + SQLCipher(or sqlite_crypt)  
  - 암호화 키는 보안 저장소에서 파생, 앱 기동 시 언락  
- **감사 로그(AuditLog)**: 주체·액션·대상·이전/이후 값·시각·클라이언트 정보  
- **PII 최소화/마스킹**: 주민번호 미저장 또는 **마지막 4자리만**, 연락처 마스킹 표시  
- **잠금/재시도 제한**: 로그인 5회 실패 시 일시 락(로컬)  
- **에러/크래시**: `logger` + (선택)`sentry_flutter`, 민감정보 스크럽

> 주의: 프론트 가드는 **UX/사고 예방용**이며, **최종 보안은 서버에서**. 백엔드 도입 시 JWT 스코프/정책 + 서버 권한 재검증으로 승격.

### 6.2 유지보수(Work Order)
**데이터 모델**
- `WorkOrder(id, unit_id?, lease_id?, title, category, priority, status, dueDate, assignee, createdBy, createdAt, updatedAt)`  
  - `status`: `OPEN | ASSIGNED | IN_PROGRESS | ON_HOLD | DONE | CANCELLED`  
  - `priority`: `LOW | NORMAL | HIGH | URGENT`
- `WorkOrderActivity(id, work_order_id, type, comment, createdBy, createdAt)`  
  - `type`: `COMMENT | STATUS_CHANGE | PHOTO | FILE`
- `Attachment(id, ownerType, ownerId, name, mimeType, size, url/hash)`

**플로우**
- 발생(임차인/점검표/관리자) → 접수(카테고리/우선순위) → 할당 → 진행/코멘트/사진 → 완료/평가  
- **SLA**: 우선순위별 목표 기한(초기엔 표시만, 알림은 후순위)

**UI/UX**
- **리스트 + 칸반 보드**(상태별 컬럼), 필터(자산/유닛/우선순위/상태/기간)  
- 상세: 타임라인(활동/사진/파일), 상태 전환, 할당 변경  
- 체크리스트 연계: 체크 항목 “수리 필요” → **워크오더 생성** 바로가기  
- PDF 요약(선택): 완료 보고서(사진/비용/조치 내역)

**수용 기준**
- 상태 전환 규칙 준수(예: `DONE` 이후 재개는 `REOPEN` 기록)  
- 첨부 업로드/미리보기 동작, 20MB 이미지 10장에서도 UI 지연 없음  
- 리스트/칸반 필터·정렬 조합에서 결과 일관성

---

## 7) 단기 실행 플랜(3일)
- **D1**: RBAC 스캐폴딩(라우트/위젯 가드), Drift 암호화 PoC, Audit 로그 테이블  
- **D2**: Payment/Allocation 모델·화면, 수납 배분·영수증 PDF(기본 템플릿)  
- **D3**: Work Order 리스트·상세·상태전환, 칸반 보드(간이), 대시보드 KPI 연동

---

## 8) (후순위) 백엔드 연동 방향 — **3·4차 개발**
- 인증: 폼 로그인 → **JWT(roles/permissions 포함)**, 토큰 갱신/만료 처리(서버)  
- 대량 작업: **청구 대량 발행/보고서 생성**은 **비동기 Job** + 진행상태 폴링  
- 파일: 계약서/영수증/점검표 PDF는 **서버 렌더링** + 버전/감사로그  
- 알림: 이메일/카카오(선택) — 연체/만료/작업 배정 트리거

---

## 9) 결론
- 본 v2는 건물주가 당장 가치 체감하는 **수익관리**와 **보안/RBAC·유지보수**를 구체화  
- 백엔드 연동은 후순위로 미뤄도, 프론트/로컬 중심으로 충분히 **운영 가능한 스코프** 확보  
- 차기 스프린트는 “청구→수납→영수증→리포트”와 “워크오더 기본 흐름” 완성이 목표

---

## 참고/근거
- 1단계 완료 리포트: **로그인/자산/임차인/임대/청구 구현**, M3/반응형/라우팅/Drift/대시보드 등 현황  
- 남은 작업(우선순위): **결제(수납), Work Order, RBAC, 보고서 강화** 명시
