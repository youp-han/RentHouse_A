# PRD — RentHouse (소스 기반 개정판)
_작성일: 2025-09-05

## 1. 개요
소규모 임대사업자를 위한 **임차인/계약/청구/자산** 관리 웹 애플리케이션.  
현재 코드는 Flutter 기반으로 구현하며, **월별 청구 자동화**, **PDF 리포트**, **역할 기반 화면**을 포함합니다.

## 2. 목표
1) 18개 유닛 규모의 임대 현황을 **한눈에 파악**  
2) 계약/월세 청구/미납 알림 등 **반복 업무 자동화**  
3) **보고서(PDF)**로 월별 수익/임차인 현황 제공

## 3. 역할
- **ADMIN / LANDLORD**: 전체 관리, 대시보드 접근
- **MANAGER**: 등록/수정 권한(제한적)
- **USER(향후 TENANT)**: 본인 정보/청구 확인(향후)

## 4. 범위
### 포함
- 회원/권한 관리, 로그인(폼) + SNS OAuth(자리만 준비)
- 자산 관리: `Property`, `Unit` CRUD
- 임차인: 등록/조회/수정/삭제
- 임대 계약: 생성/수정, 상태 관리(예: ACTIVE/TERMINATED/EXPIRED)
- 청구 관리: `Billing`(청구서), `Bill`(항목 타입), `BillingItem`
- 스케줄링: **월초 자동 청구 생성**, **미납 점검**
- 보고서: **월별 수익**·**임차인 현황** PDF
- 대시보드: 핵심 지표 카드/바로가기

### 제외(향후)
- 온라인 결제, 모바일 앱, 세무 연동, 푸시 알림/SMS

## 5. 기능 요구 (현행 코드 기준)
### 5.1 화면(MVC)
- 홈(`/`), 로그인(`/login`), 대시보드(`/admin/dashboard`)
- 부동산/유닛: `/property/propertyList`, `/property/register`, `/property/detail/{id}`
- 임차인: `/tenants/register`, `...`
- 임대 계약: `/leases/register`, `...`
- 보고서 다운로드: `/reports/monthly-revenue.pdf`, `/reports/tenant-status.pdf`

### 5.2 API(JSON)
- `/api/property`, `/api/unit`, `/api/units` (생성)
- `/api/member`, `/api/members` (생성)
- `/api/tenant`, `/api/tenants` (생성)

> **참고**: MVC용 컨트롤러(`/member`, `/property` 등)와 API(`/api/**`)가 혼재 → 차기 스프린트에서 **명확 분리**.

### 5.3 스케줄러
- `generateMonthlyBillingsForLease(lease)` 월초 실행(중복 방지 필요)
- `checkForOverduePayments()` 미납 탐지 → 활동 로그 기록(향후: 알림)

## 6. 데이터 모델(요약)
- **Property(id, name, address, type, totalFloors, totalUnits, units[])**
- **Unit(id, property_id, unitNumber, rentStatus, size_meter, size_korea, useType, description)**
- **Tenant(id, name, phone, email, socialNo, currentAddress)**
- **Lease(id, tenant_id, unit_id, startDate, endDate, deposit, monthlyRent, leaseType, leaseStatus, contractNotes)**
- **Bill(id, name, category, amount, description)**
- **Billing(id, lease_id, yearMonth, issueDate, dueDate, paid, paidDate, totalAmount, items[])**
- **BillingItem(id, billing_id, bill_id, amount)**
- **Member(id, email, password, role, phoneNumber, snsId, snsType, flags...)**
- **ActivityLog(id, type, description, createdDate...)**

> 모든 엔티티는 `BaseEntity`(감사필드) 상속. **PK 필수**.

## 7. 비기능
- 인증/인가: Spring Security(Form) + OAuth Provider 자리
- 비밀번호: BCrypt
- 템플릿: FreeMarker, UI: SB Admin 2
- PDF: iText7
- 성능: 50유닛까지 원활(로컬 H2/운영 Postgres 가정)
- 로깅: 운영 `INFO` 권장, 감사 이벤트(청구/미납) 로그

## 8. 환경/배포
- 프로파일: `mobile`(slqLite), `pc(win/mac/linux`(slqLite), `web`(Postgres)
- 배포 : 확인 중


## 9. 대시보드 지표(예시)
- 이번 달 청구 합계 / 수납 합계 / 미납 건수
- 활성 계약 수 / 공실 수
- 최근 활동 로그 10건

## 10. 백로그(우선순위)
1) **Must**: PK/달렉트/보안/트랜잭션/검증/중복청구 방지 정리  
2) **Should**: API/뷰 경로 분리, 전역 예외처리, 조회 DTO/프로젝션, Flyway  
3) **Could**: 이메일/카카오 알림, Excel 보고서, 다국어(i18n), 첨부파일(계약서)

## 11. 마일스톤(제안)
- M1 (1주): Must-Fix 적용 + 통합 테스트
- M2 (1주): API/뷰 경로 분리 + 전역 예외처리 + 대시보드 지표 연결
- M3 (1주): Flyway + 보고서 개선 + 알림 채널 PoC

## 12. 성공지표
- 대시보드에서 **1분 내** 이번 달 지표 확인
- 월별 청구 자동 생성 **중복 0건**
- 미납 탐지/로그 **100% 기록**
