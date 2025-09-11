# RentHouse 프로젝트 설계 문서 (Phase 1)

## 1. 문서 개요

이 문서는 RentHouse 애플리케이션 Phase 1 개발 단계의 최종 설계 내용을 기술합니다. Phase 1은 애플리케이션의 핵심 아키텍처를 구축하고, 주요 기능(자산, 임차인, 계약, 청구)을 로컬 데이터베이스와 연동하여 구현하는 것을 목표로 합니다.

## 2. 시스템 아키텍처

RentHouse는 확장성과 유지보수성을 고려하여 계층형 아키텍처(Layered Architecture)를 채택했습니다. 이는 클린 아키텍처(Clean Architecture)의 개념을 따르며, 각 계층은 명확한 책임 분리를 가집니다.

- **Presentation Layer (UI)**: Flutter를 사용하여 사용자 인터페이스를 구현합니다. 화면(Screen)과 위젯(Widget)으로 구성되며, 사용자의 입력을 받아 Application Layer로 전달하고, 상태 변화를 화면에 갱신합니다.

- **Application Layer (State Management)**: `Riverpod`를 사용하여 애플리케이션의 상태를 관리합니다. UI(Presentation)와 비즈니스 로직(Domain)을 연결하는 컨트롤러(Controller) 또는 프로바이더(Provider)가 이 계층에 속합니다.

- **Domain Layer (Business Logic)**: 애플리케이션의 핵심 비즈니스 로직과 엔티티(Entity)를 정의합니다. 이 계층은 다른 계층에 대한 의존성이 없는 순수한 Dart 코드로 작성됩니다. `Freezed`를 사용하여 불변(Immutable) 데이터 모델을 정의합니다.

- **Data Layer (Data Persistence & Access)**: 데이터의 출처를 관리하고 추상화합니다. `Repository` 패턴을 사용하여 데이터 소스(로컬 DB, 원격 API)에 접근하며, Phase 1에서는 `Drift` 라이브러리를 통해 로컬 SQLite 데이터베이스에 데이터를 영속적으로 저장합니다.

### 2.1. 주요 기술 스택

- **UI Framework**: `Flutter`
- **State Management**: `Riverpod`
- **Routing**: `go_router`
- **Data Modeling**: `freezed`, `json_serializable`
- **Local Database**: `drift` (SQLite 기반)
- **HTTP Client**: `dio` (Phase 2 연동 예정)

## 3. 프로젝트 구조

프로젝트는 기능별, 계층별로 모듈화되어 구성됩니다.

```
renthouse/
└── lib/
    ├── app/                # 앱의 핵심 설정 (main, router, theme, layout)
    ├── core/               # 여러 기능에서 공유되는 핵심 모듈
    │   ├── auth/           # 인증 상태 및 로직
    │   ├── database/       # Drift 데이터베이스 설정
    │   └── network/        # 네트워크 클라이언트 (Dio)
    │
    └── features/           # 개별 기능별 디렉토리
        └── [feature_name]/ # 예: property, tenant, lease, billing
            ├── application/  # 상태 관리 (Riverpod Controllers)
            ├── data/         # 데이터 저장소 (Repositories)
            ├── domain/       # 핵심 로직 및 모델 (Entities)
            └── presentation/ # UI (Screens, Widgets)
```

## 4. 핵심 컴포넌트 설계

### 4.1. 데이터베이스 (Drift)

로컬 데이터 저장은 `drift`를 사용하여 구현되었습니다. 모든 테이블은 `lib/core/database/app_database.dart` 파일에 정의되어 있습니다.

- **Tables**: `Properties`, `Units`, `Tenants`, `Leases`, `BillTemplates`, `Billings`, `BillingItems`
- **Relationships**:
  - `Properties` (1) <--> `Units` (N) : Cascade delete
  - `Tenants` (1) <--> `Leases` (N) : Cascade delete
  - `Units` (1) <--> `Leases` (N) : Cascade delete
  - `Leases` (1) <--> `Billings` (N) : Cascade delete
  - `Billings` (1) <--> `BillingItems` (N) : Cascade delete
  - `BillTemplates` (1) <--> `BillingItems` (N) : Restrict delete
- **DAO**: 각 테이블에 대한 기본적인 CRUD(Create, Read, Update, Delete) 메소드가 `AppDatabase` 클래스 내에 구현되어 있습니다.

```dart
// lib/core/database/app_database.dart 예시

@DriftDatabase(tables: [Properties, Units, Tenants, ...])
class AppDatabase extends _$AppDatabase {
  // ... DAO methods
  Future<List<Property>> getAllProperties() => select(properties).get();
  Future<void> insertProperty(PropertiesCompanion property) => into(properties).insert(property);
  // ...
}
```

### 4.2. 라우팅 (go_router)

화면 간 내비게이션은 `go_router`를 사용하여 선언적으로 관리됩니다. `lib/app/router.dart` 파일에서 모든 경로를 정의합니다.

- **ShellRoute**: `MainLayout`을 사용하여 모든 주 화면에 일관된 내비게이션 UI(좌측 NavigationRail 또는 하단 BottomNavigationBar)를 제공합니다.
- **Authentication Redirect**: 사용자가 로그인하지 않은 경우 `/login` 화면으로 리디렉션하는 인증 가드가 구현되어 있습니다.
- **Nested Routes**: 각 기능은 중첩된 경로 구조를 가집니다. 예를 들어, 자산 기능은 다음과 같은 경로를 사용합니다.
  - `/property`: 자산 목록
  - `/property/new`: 신규 자산 등록
  - `/property/:id`: 자산 상세 정보
  - `/property/edit/:id`: 자산 수정
  - `/property/:id/units/add`: 유닛 추가
  - `/property/:id/units/edit/:unitId`: 유닛 수정

```dart
// lib/app/router.dart 예시

final router = GoRouter(
  redirect: (context, state) { /* ... auth guard ... */ },
  routes: [
    GoRoute(path: '/login', ...),
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(path: '/admin/dashboard', ...),
        GoRoute(
          path: '/property',
          builder: (c, s) => const PropertyListScreen(),
          routes: [ /* ... nested routes ... */ ],
        ),
        // ... other features
      ],
    ),
  ],
);
```

### 4.3. UI 및 반응형 레이아웃

`lib/app/main_layout.dart`는 화면 너비에 따라 반응형 UI를 제공합니다.

- **Large Screens (width >= 600)**: `NavigationRail`을 사용하여 좌측에 메뉴를 표시합니다.
- **Small Screens (width < 600)**: `BottomNavigationBar`를 사용하여 하단에 메뉴를 표시합니다.

중앙 테마는 `lib/app/theme.dart`에서 `buildLightTheme`와 `buildDarkTheme`을 통해 관리되어 앱 전체의 디자인 일관성을 유지합니다.

## 5. 기능별 상세 설계

각 기능은 **Domain -> Data -> Application -> Presentation**의 흐름으로 구현되었습니다.

| 기능         | Domain Models                               | Data Repository Methods (CRUD) | Application (Riverpod Providers)                               | Presentation Screens                                     |
|--------------|---------------------------------------------|--------------------------------|----------------------------------------------------------------|----------------------------------------------------------|
| **자산 관리**  | `Property`, `Unit`                          | `getProperties`, `createProperty`, `updateProperty`, `deleteProperty`, `addUnit`, `updateUnit`, `deleteUnit` | `propertyListControllerProvider`, `propertyDetailProvider`, `unitDetailProvider` | `PropertyListScreen`, `PropertyFormScreen`, `UnitFormScreen` |
| **임차인 관리**| `Tenant`                                    | `getTenants`, `createTenant`, `updateTenant`, `deleteTenant` | `tenantControllerProvider`                                     | `TenantListScreen`, `TenantFormScreen`                   |
| **계약 관리**  | `Lease` (LeaseType, LeaseStatus enums)      | `getLeases`, `createLease`, `updateLease`, `deleteLease` | `leaseControllerProvider`                                      | `LeaseListScreen`, `LeaseFormScreen`                     |
| **청구 관리**  | `Billing`, `BillingItem`, `BillTemplate`    | `getBillings`, `createBilling`, `deleteBilling`, `getBillTemplates`, `createBillTemplate`, ... | `billingControllerProvider`, `billTemplateControllerProvider` | `BillingListScreen`, `BillingFormScreen`, `BillTemplateListScreen`, `BillTemplateFormScreen` |

## 6. Phase 1 결론

Phase 1에서는 클린 아키텍처 기반의 안정적인 애플리케이션 구조를 확립하고, 핵심 기능들의 전체 CRUD 사이클을 로컬 데이터베이스와 연동하여 완성했습니다. 이를 통해 향후 기능 확장 및 백엔드 연동을 위한 견고한 토대를 마련했습니다.

### 6.1. 구현된 주요 사항
- 4대 핵심 기능(자산, 임차인, 계약, 청구)의 데이터 모델링 및 로컬 DB 연동.
- 반응형 UI 레이아웃 및 일관된 내비게이션 시스템.
- Riverpod를 활용한 상태 관리 패턴 정립.
- GoRouter를 이용한 선언적이고 안정적인 라우팅 구조.

### 6.2. 다음 단계(Phase 2)에서 진행할 사항
- **백엔드 API 연동**: 현재 로컬 DB를 사용하는 데이터 계층을 실제 원격 서버와 통신하도록 확장합니다.
- **테스트 코드 작성**: 단위(Unit) 테스트와 통합(Integration) 테스트를 추가하여 코드의 안정성과 품질을 향상시킵니다.
- **고급 기능 추가**: 전체 검색, 리포트 생성, 알림 기능 등을 추가합니다.
