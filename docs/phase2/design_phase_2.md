# RentHouse 프로젝트 설계 문서 (Phase 2)

## 1. 문서 개요

이 문서는 RentHouse 애플리케이션 Phase 2 개발 단계의 설계를 기술합니다. Phase 1에서 구축된 핵심 아키텍처를 기반으로, 실제 사용자의 피드백과 요구사항을 반영하여 기능을 구체화하고 확장하는 것을 목표로 합니다. 특히 **수익 관리(Revenue Management)** 기능을 대폭 강화하고, 사용자 경험을 개선하는 데 중점을 둡니다.

## 2. Phase 2 주요 변경 및 추가 사항

Phase 1의 아키텍처(클린 아키텍처, Riverpod, go_router, Drift)는 그대로 유지하며, 다음의 기능 영역을 중심으로 설계 변경 및 확장이 이루어집니다.

### 2.1. 수익 관리 기능 상세 설계

가장 큰 변화는 단순 청구서 관리를 넘어, 수납, 배분, 상태 추적을 포함하는 포괄적인 수익 관리 시스템을 구축하는 것입니다.

#### 2.1.1. 데이터 모델 변경 (Drift Schema)

- **`Billings` 테이블 수정:**
  - `status` 컬럼 추가: 청구서의 상태를 관리 (`DRAFT`, `ISSUED`, `PARTIALLY_PAID`, `PAID`, `OVERDUE`, `VOID`)
  - `(lease_id, yearMonth)`에 유니크 인덱스 추가하여 중복 청구 방지

- **`BillingItems` 테이블 수정:**
  - `name`, `category`, `quantity`, `unitPrice`, `tax`, `memo` 등 청구 항목의 상세 정보를 담기 위한 컬럼 추가

- **`Payments` 테이블 신규 생성:**
  - 수납 내역을 독립적으로 관리합니다.
  ```dart
  class Payments extends Table {
    TextColumn get id => text()();
    TextColumn get tenantId => text().references(Tenants, #id)();
    TextColumn get method => text()(); // CASH, TRANSFER, CARD
    IntColumn get amount => integer()();
    DateTimeColumn get paidDate => dateTime()();
    TextColumn get memo => text().nullable()();
    
    @override
    Set<Column> get primaryKey => {id};
  }
  ```

- **`PaymentAllocations` 테이블 신규 생성:**
  - 하나의 수납(Payment)이 여러 청구서(Billing)에 어떻게 배분되었는지 추적합니다. (다대다 관계)
  ```dart
  class PaymentAllocations extends Table {
    TextColumn get id => text()();
    TextColumn get paymentId => text().references(Payments, #id)();
    TextColumn get billingId => text().references(Billings, #id)();
    IntColumn get amount => integer()();

    @override
    Set<Column> get primaryKey => {id};
  }
  ```

#### 2.1.2. 데이터 및 어플리케이션 계층 설계

- **`BillingRepository` / `PaymentRepository`:**
  - 수납, 배분, 상태 업데이트 등 새로운 CRUD 로직을 처리할 메소드 추가
  - `createPaymentWithAllocation(Payment, List<Billing> toAllocate)`: 수납과 동시에 자동/수동 배분을 처리하는 트랜잭션 메소드
  - `getOverdueBillings()`: 연체된 청구서를 조회하는 메소드
- **`BillingController` / `PaymentController` (Riverpod):**
  - 청구서 목록에서 여러 항목을 선택하고 일괄 발행하는 상태 관리 로직 추가
  - 수납 화면에서 청구서 목록을 불러오고, 배분할 금액을 계산하며, UI 상태를 관리하는 로직

### 2.2. 회원 관리 기능 설계

- **`Users` 테이블 신규 생성:**
  - 앱 사용자의 계정 정보를 저장합니다.
  ```dart
  class Users extends Table {
    TextColumn get id => text()();
    TextColumn get email => text().unique()();
    TextColumn get name => text()();
    TextColumn get passwordHash => text()(); // 암호화된 비밀번호
    DateTimeColumn get createdAt => dateTime()();

    @override
    Set<Column> get primaryKey => {id};
  }
  ```
- **Presentation Layer:**
  - **회원가입 화면 (`/join`):** 이메일, 이름, 비밀번호를 입력받는 신규 화면
  - **설정 화면 (`/settings`):** 프로필 수정, 암호 변경, 로그아웃, 회원 탈퇴 기능을 제공하는 화면

### 2.3. 기존 기능 개선 설계

- **자산(Property) 모델 변경:**
  - `type`, `lease_type` 필드는 `TextColumn`으로 유지하되, UI에서는 Dropdown 목록으로 제한하여 입력을 받습니다.
  - `address` 필드는 `zip`, `address1`, `address2` 세분화된 컬럼으로 변경됩니다.
  - `totalFloors` 컬럼은 테이블에서 삭제됩니다.
  - `ownerId` 컬럼을 추가하여 `Customers` 테이블(신규 제안)과 연결합니다.

- **임대 계약(Lease) 등록 UI 로직:**
  - **`LeaseFormScreen`**은 `Tenant`와 `Property` 데이터를 모두 `watch`합니다.
  - `Tenant` Dropdown 목록은 `leases` 테이블에 ID가 존재하지 않는 임차인만으로 필터링하여 표시합니다.
  - `Property` Dropdown 선택 시, 해당 `propertyId`를 가진 `Unit` 목록을 비동기적으로 다시 불러와 `Unit` Dropdown을 갱신합니다.

## 3. 데이터베이스 마이그레이션 계획

- 상기 데이터 모델 변경에 따라 `drift`의 `schemaVersion`을 4에서 5로 올립니다.
- `onUpgrade` 콜백 내에서 다음 마이그레이션 작업을 수행합니다.
  1. `Users`, `Payments`, `PaymentAllocations` 테이블 추가
  2. `Billings`, `BillingItems`, `Properties` 테이블에 신규 컬럼 추가 및 기존 컬럼 수정/삭제
  3. `Billings` 테이블에 `(lease_id, yearMonth)` 유니크 인덱스 생성

## 4. Phase 2 범위에서 제외되는 항목

- **보안/RBAC(역할 기반 접근 제어):** Phase 3 아이디어로 이전
- **유지보수(Work Order):** Phase 3 아이디어로 이전
- **백엔드 API 연동:** 현재 모든 기능은 로컬 DB를 기준으로 설계
