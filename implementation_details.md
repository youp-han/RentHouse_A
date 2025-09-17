# RentHouse 프로젝트 구현 상세 내역

이 문서는 `project_history.md`의 각 작업 항목이 실제 코드에서 어떻게 구현되었는지 상세히 설명합니다.

## 2025-09-17

### **task164: 데이터 백업 및 싱크**

데이터 백업 및 복원 기능은 사용자가 데이터를 안전하게 보관하고 필요할 때 복구할 수 있도록 구현되었습니다. 특히, 실행 중인 데이터베이스 파일 교체의 제약(Windows 등)을 우회하기 위해 '앱 재시작을 통한 복원' 매커니즘을 도입했습니다.

#### **1. 핵심 로직 (`/lib/core/services/database_backup_service.dart`)**

`DatabaseBackupService` 클래스가 백업 및 복원의 모든 핵심 로직을 담당합니다.

- **`backupDatabase(String backupPath)` (백업)**
  - `DatabasePathChecker`를 통해 현재 데이터베이스 파일의 경로를 가져옵니다.
  - `renthouse_backup_{타임스탬프}.sqlite` 형식의 고유한 파일명을 생성합니다.
  - 현재 DB 파일을 사용자가 선택한 `backupPath`로 복사하여 백업을 생성합니다.

- **`restoreDatabase(String backupFilePath)` (복원 준비)**
  - 이 함수는 DB를 즉시 복원하지 않고, '보류 중인 복원(Pending Restore)' 상태를 만듭니다.
  - **과정:**
    1.  선택된 백업 파일이 유효한 SQLite 파일인지 검사합니다.
    2.  만약을 대비해, 현재 DB를 `.pre-restore-backup` 확장자로 백업해둡니다.
    3.  사용자가 선택한 백업 파일을 DB 경로에 `.pending-restore` 라는 임시 파일로 복사합니다.
    4.  복원 작업이 필요함을 알리는 `.restore-flag` 파일을 생성합니다. 이 파일에는 임시 파일의 경로가 기록됩니다.
  - 이 과정이 완료되면 사용자에게 앱 재시작을 안내합니다.

- **`checkAndPerformPendingRestore()` (보류된 복원 실행)**
  - 이 함수는 앱이 시작될 때(`main.dart`에서) 가장 먼저 호출됩니다.
  - **과정:**
    1.  `.restore-flag` 파일의 존재 여부를 확인합니다.
    2.  파일이 존재하면, 현재 DB 파일을 삭제합니다.
    3.  `.pending-restore` 임시 파일의 이름을 실제 DB 파일명으로 변경하여 교체합니다.
    4.  `.restore-flag` 파일을 삭제하여 다음 시작 시 중복 실행을 방지합니다.

- **파일/폴더 선택 로직**
  - `selectBackupFolder()`: `file_picker` 패키지를 사용하여 백업을 저장할 폴더를 사용자가 선택하게 합니다.
  - `selectBackupFile()`: 복원에 사용할 `.sqlite` 파일을 사용자가 선택하게 합니다.

#### **2. UI 연동**

- **백업 UI (`/lib/features/settings/presentation/settings_screen.dart`)**
  - '설정' 화면에 '데이터베이스 백업' 메뉴가 존재합니다.
  - `_handleDatabaseBackup` 함수가 호출되어 `DatabaseBackupService.selectBackupFolder()`로 경로를 받고, `backupDatabase()`를 실행하여 백업을 수행합니다.
  - 결과(성공/실패)는 `SnackBar`를 통해 사용자에게 표시됩니다.

- **복원 UI (`/lib/features/auth/presentation/login_screen.dart`)**
  - '로그인' 화면 하단에 '백업에서 데이터 복원' 버튼이 있습니다.
  - `_handleDatabaseRestore` 함수가 호출됩니다.
  - **과정:**
    1.  `DatabaseBackupService.selectBackupFile()`을 호출하여 복원할 파일을 선택합니다.
    2.  `_showRestoreConfirmationDialog`를 통해 사용자에게 데이터가 교체됨을 경고하고 최종 확인을 받습니다.
    3.  `DatabaseBackupService.restoreDatabase()`를 호출하여 '복원 준비' 상태로 만듭니다.
    4.  성공 시, 앱 재시작이 필요하다는 안내 다이얼로그를 표시하고 사용자가 앱을 종료/재시작할 수 있도록 돕습니다.

#### **3. 앱 시작 시 처리 (`/lib/main.dart`)**

- `main()` 함수 최상단에서 `runApp()`이 실행되기 전에 `await DatabaseBackupService.checkAndPerformPendingRestore()`가 호출됩니다.
- 이를 통해 앱의 다른 부분이 DB에 접근하기 전에 데이터베이스 교체 작업이 먼저 완료되도록 보장합니다.

---

## 2025-09-16

### **task155, 156, 157: 데이터베이스 마이그레이션, 스키마 버전업 및 중복 청구 방지**

이 작업들은 `drift` 라이브러리를 사용하여 데이터베이스 스키마를 점진적으로 변경하고 데이터 무결성을 강화하는 과정을 포함합니다. 모든 관련 로직은 `/lib/core/database/app_database.dart` 파일에 중앙화되어 있습니다.

#### **1. 핵심 파일 및 구조**

- **`/lib/core/database/app_database.dart`**: `drift`를 사용하여 데이터베이스의 모든 테이블, 칼럼, 그리고 마이그레이션 전략을 정의하는 핵심 파일입니다.

#### **2. 스키마 버전 관리 (`task156`)**

- `AppDatabase` 클래스 내에 `int get schemaVersion => 8;` 코드가 현재 데이터베이스 스키마 버전을 `8`로 명시합니다.
- `drift`는 앱 실행 시 이 버전과 실제 DB 파일에 저장된 버전을 비교하여, 코드의 버전이 더 높을 경우 `onUpgrade` 마이그레이션 로직을 실행합니다.

#### **3. 마이그레이션 전략 (`task155`)**

- `MigrationStrategy` 클래스를 사용하여 데이터베이스의 생성 및 업그레이드 방법을 정의합니다.
- **`onCreate`**: 데이터베이스 파일이 없을 때, `m.createAll()`을 통해 모든 테이블을 한 번에 생성합니다.
- **`onUpgrade`**: 데이터베이스 버전이 올라갔을 때 실행되는 핵심 로직입니다.
  - `if (from < version)` 형태의 조건문을 사용하여, 이전 버전부터 현재 버전까지의 모든 변경사항이 순차적으로 적용되도록 보장합니다. 예를 들어, 버전 4에서 8로 업데이트하는 사용자는 5, 6, 7, 8 버전에 대한 마이그레이션 코드가 모두 순서대로 실행됩니다.

#### **4. 주요 마이그레이션 내용**

- **`if (from < 5)`: 버전 5로의 마이그레이션**
  - **`task157: 중복 청구 방지 인덱스 추가`**:
    - `await m.createIndex(...)`를 사용하여 `billings` 테이블의 `lease_id`와 `year_month` 칼럼을 조합한 `UNIQUE INDEX`를 생성했습니다.
    - 이 인덱스는 동일한 계약에 대해 동일한 년/월의 청구서가 두 번 이상 생성되는 것을 데이터베이스 수준에서 원천적으로 방지하여 데이터의 정합성을 보장합니다.
  - `users`, `payments`, `paymentAllocations` 등 Phase 2의 새로운 테이블들을 생성합니다.
  - `billings` 테이블에 `status` 칼럼을 추가합니다.

- **`if (from < 6)`: 버전 6으로의 마이그레이션**
  - `properties` 테이블에 `zipCode`, `address1`, `address2` 등 주소 관련 신규 칼럼들을 추가합니다 (`task136`).
  - `propertyBillingItems` 테이블을 새로 생성합니다.
  - 주석을 통해 `totalFloors` 칼럼 삭제(`task133`)는 `drift`에서 직접 지원하지 않아 코드상에서 더 이상 사용하지 않는 방식으로 처리되었음을 명시했습니다.

- **`if (from < 7)`: 버전 7로의 마이그레이션**
  - `task160`을 위해 `activityLogs` 테이블을 생성합니다.

- **`if (from < 8)`: 버전 8로의 마이그레이션**
  - `billingItems` 테이블에 청구 항목 이름을 직접 저장하기 위한 `itemName` 칼럼을 추가합니다.

---

## 2025-09-15

### **task163: `logger`, `sentry_flutter` 통합**

이 프로젝트는 `sentry_flutter`를 직접 통합하는 대신, `logger` 패키지를 기반으로 유연한 자체 로깅 및 오류 보고 시스템을 구축했습니다. 이 시스템은 향후 Sentry와 같은 외부 서비스로 확장할 수 있는 추상화된 구조를 가집니다.

#### **1. 핵심 로직 및 파일**

- **`/lib/core/logging/app_logger.dart`**:
  - `logger` 패키지를 감싸는 간단한 퍼사드(Facade) 클래스입니다.
  - `info`, `warning`, `error` 등 정적 메서드를 제공하여 앱의 다른 부분들이 특정 로깅 구현에 종속되지 않도록 합니다.

- **`/lib/core/logging/crash_reporting_service.dart`**:
  - 로깅 및 오류 보고의 핵심 서비스입니다.
  - **사용자 동의 기반**: `flutter_secure_storage`를 사용해 사용자에게 오류 보고 동의를 받고, 동의한 경우에만 보고를 전송합니다.
  - **오프라인 저장**: 동의하지 않거나 즉시 전송이 불가능할 경우, 오류 로그를 기기 내에 `_pendingCrashLogs`로 안전하게 저장합니다.
  - **이메일 보고**: Sentry 대신 `url_launcher`를 사용하여, 수집된 오류 정보를 포함한 이메일 초안을 생성하는 `_trySendEmail` 함수를 구현했습니다. 이는 외부 서비스 의존성 없이 간단하게 보고 기능을 구현하는 영리한 방법입니다.
  - **전역 오류 핸들링**: `main.dart`에서 `initialize()` 메서드를 호출하여 `FlutterError.onError`를 재정의하고, 앱 전반에서 발생하는 프레임워크 오류를 모두 수집합니다.

- **`/lib/core/logging/crash_consent_dialog.dart`** 및 **`crash_consent_wrapper.dart`**:
  - 앱 최초 실행 시 사용자에게 오류 보고 동의를 구하는 UI를 제공합니다.

#### **2. UI 연동 (`/lib/features/settings/presentation/settings_screen.dart`)**

- '설정' 화면에서 사용자가 '오류 보고' 기능을 켜고 끌 수 있습니다.
- 기기에 저장된 미전송 로그 개수를 표시하고, '누적 로그 전송' 버튼을 통해 수동으로 이메일 보고를 트리거할 수 있습니다.
- 개발용 '테스트 크래시 발생' 버튼을 포함하여 전체 보고 시스템을 검증할 수 있도록 구현했습니다.

### **task161: 대시보드 활동 로그 표시**

사용자의 주요 활동을 기록하고 대시보드에 표시하여 직관적인 사용 내역을 제공합니다.

#### **1. 데이터 계층 (`ActivityLog`)**

- **`/lib/core/database/app_database.dart`**: `drift` 데이터베이스에 `ActivityLogs` 테이블을 정의하여 활동 기록을 영구적으로 저장합니다.
- **`/lib/features/activity/data/activity_log_repository.dart`**: `ActivityLogs` 테이블에 접근하여 데이터를 추가(`addActivityLog`)하거나 최근 로그를 조회(`getRecentActivityLogs`)하는 리포지토리입니다.

#### **2. 서비스 계층 (`ActivityLogService`)**

- **`/lib/features/activity/application/activity_log_service.dart`**:
  - 활동 기록 로직을 중앙에서 관리하는 서비스입니다.
  - `logPropertyCreated`, `logUserLogin` 등 활동 유형에 맞는 특화된 메서드를 제공하여 일관성 없는 로그가 쌓이는 것을 방지합니다.
  - **`/lib/features/activity/domain/activity_log.dart`**: `ActivityLogBuilder`를 사용해 정형화된 로그 객체를 생성한 후, 리포지토리를 통해 데이터베이스에 저장합니다.

#### **3. UI 계층 (`/lib/features/dashboard/presentation/dashboard_screen.dart`)**

- 대시보드 화면의 '최근 활동' 섹션에 구현되어 있습니다.
- `FutureBuilder`를 사용하여 `activityLogService.getRecentActivityLogs(limit: 10)`를 호출, 최근 10개의 활동 기록을 가져옵니다.
- 가져온 로그 목록을 `ListView`로 표시하며, 각 항목은 아이콘, 설명, 타임스탬프로 구성되어 사용자가 쉽게 활동 내역을 파악할 수 있습니다.

---
### **task124: 대시보드 KPI 추가**

대시보드는 사용자가 앱의 핵심 현황을 한눈에 파악할 수 있도록 주요 성과 지표(KPI)를 시각적으로 제공합니다.

#### **1. 도메인 계층 (`/lib/features/dashboard/domain/dashboard_stats.dart`)**

- `freezed`를 사용하여 `DashboardStats`라는 불변(immutable) 데이터 클래스를 정의했습니다.
- 이 클래스는 `currentMonthBillingAmount`(이번 달 청구액), `unpaidAmount`(총 미납액), `activeLeaseCount`(활성 계약 수) 등 대시보드에 표시될 모든 KPI 데이터를 담는 컨테이너 역할을 합니다. 이를 통해 데이터 구조를 명확하고 예측 가능하게 관리합니다.

#### **2. 애플리케이션 계층 (`/lib/features/dashboard/application/dashboard_controller.dart`)**

- Riverpod의 `AsyncNotifier`를 상속받는 `DashboardController`가 KPI 데이터의 계산 및 상태 관리를 담당합니다.
- `build()` 메서드 내에서 `Future.wait`를 사용하여 여러 리포지토리(자산, 계약, 청구 등)의 데이터를 병렬로 조회하여 성능을 최적화합니다.
- 가져온 원시 데이터를 바탕으로 합계, 평균, 비율 등 KPI 지표를 계산한 후, 최종적으로 `DashboardStats` 객체를 생성하여 상태로 관리합니다.

#### **3. 프레젠테이션 계층 (`/lib/features/dashboard/presentation/dashboard_screen.dart`)**

- 대시보드 UI는 `dashboardControllerProvider`를 `watch`하여 KPI 데이터의 상태(로딩, 데이터, 오류)를 실시간으로 반영합니다.
- `_KPI`라는 별도의 내부 위젯을 만들어 개별 KPI 카드를 컴포넌트화했습니다. 이 위젯은 제목, 값, 로딩 상태 등을 인자로 받아 일관된 UI를 표시합니다.
- `GridView`를 사용하여 여러 `_KPI` 위젯을 격자 형태로 배치하고, `DashboardStats` 객체의 각 데이터를 `_KPI` 위젯에 전달하여 전체 KPI 섹션을 구성합니다.

### **task158, 159: 테스트 코드 작성**

코드의 안정성과 품질을 보장하기 위해 `test` 디렉토리 아래에 단위(Unit), 위젯(Widget), 통합(Integration) 세 가지 유형의 테스트를 체계적으로 구성했습니다.

#### **1. 단위 테스트 (`/test/unit/`)**

- UI와 분리하여 순수 Dart 로직(주로 도메인 모델)을 검증합니다.
- **`property_test.dart`**: `Property` 모델의 `copyWith` 기능 및 `fullAddress`와 같은 계산된 속성이 정확히 동작하는지 테스트합니다.
- **`tenant_test.dart`**: `Tenant` 모델의 `maskedSocialNo`와 같이 민감한 정보를 마스킹하는 비즈니스 로직을 테스트합니다.
- **`activity_log_test.dart`**: `ActivityLogBuilder`가 다양한 활동에 대해 올바른 로그 객체를 생성하는지 검증합니다.
- **`unit_test.dart`**: `Unit` 모델의 생성 및 상태 변경을 테스트합니다.

#### **2. 위젯 테스트 (`/test/widget/`)**

- `flutter_test`의 `WidgetTester`를 사용하여 특정 위젯이 의도대로 렌더링되고 사용자의 상호작용에 반응하는지 검증합니다.
- **`dashboard_screen_test.dart`**: 대시보드 화면에 KPI 카드와 같은 주요 요소들이 정상적으로 표시되는지 확인합니다.
- **`login_screen_test.dart`**: 로그인 화면의 텍스트 필드 입력과 버튼 탭 기능이 동작하는지 테스트합니다.
- **`tenant_form_screen_test.dart`**: 임차인 등록 폼의 유효성 검사(Validation) 로직이 올바르게 작동하는지 확인합니다.
- 테스트 실행에 필요한 컨텍스트(e.g., `MaterialApp`, `ProviderScope`)로 테스트할 위젯을 감싸는 공통 패턴을 사용합니다.

#### **3. 통합 테스트 (`/test/integration/app_integration_test.dart`)**

- `integration_test` 패키지를 사용하여 여러 화면에 걸친 사용자 시나리오를 E2E(End-to-End) 관점에서 테스트합니다.
- **주요 시나리오**: 앱 실행 → 로그인 → 대시보드 확인 → 자산 목록 이동의 전체 흐름을 시뮬레이션합니다.
- `tester.tap` (탭), `tester.enterText` (입력) 등의 `WidgetTester` 유틸리티를 사용하여 실제 사용자와 유사한 상호작용을 자동화합니다.

---
### **task123, 125, 126: UI/UX 개선 (전역 테마, 청구 및 수납 화면)**

애플리케이션 전반의 사용자 경험을 향상시키기 위해 일관된 디자인 시스템을 적용하고, 주요 화면의 정보 구성과 상호작용을 개선했습니다.

#### **1. 전역 테마 적용 (`/lib/app/theme.dart`)**

- **일관된 디자인 시스템**: `Material 3`(`useMaterial3: true`)를 기반으로, 신뢰감을 주는 파란색(`Color(0xFF2E6A9E)`)을 기본 색상으로 하는 라이트/다크 테마를 정의했습니다. 이를 통해 앱 전체의 시각적 통일성을 확보했습니다.
- **컴포넌트 스타일 중앙화**: `AppBar`, `ElevatedButton`, `Card`, `InputDecoration` 등 핵심 위젯의 스타일을 `ThemeData`에 미리 정의했습니다. 이로써 반복적인 스타일 코드를 제거하고, 앱 전반의 디자인을 한 곳에서 쉽게 변경할 수 있도록 구조를 개선했습니다.

#### **2. 청구 목록 화면 개선 (`/lib/features/billing/presentation/billing_list_screen.dart`)**

- **강력한 필터 및 검색**:
  - 사용자가 계약 ID나 연월로 쉽게 검색할 수 있는 `TextField`를 상단에 배치했습니다.
  - '미발행', '완납', '연체' 등 청구 상태에 따라 목록을 필터링할 수 있는 `FilterChip` 그룹을 추가하여 사용자가 원하는 정보를 빠르게 찾을 수 있도록 UX를 개선했습니다.
- **시각적 정보 강화**:
  - 각 청구서 항목 좌측에 상태별로 다른 색상과 아이콘을 가진 `CircleAvatar`를 추가하여 (예: 완납-초록색 체크, 연체-빨간색 경고) 상태를 즉시 인지할 수 있도록 했습니다.
  - 상태 텍스트를 강조하는 `_buildStatusBadge` 위젯을 추가하여 정보의 가독성을 높였습니다.
- **핵심 기능 전면 배치**:
  - 모든 활성 계약의 청구서를 한 번에 생성하는 '일괄 생성' 버튼을 앱 바에 추가하여 반복 작업을 최소화했습니다.

#### **3. 수납 및 수익 관리 화면 개선**

- **수익 관리 대시보드 도입 (`/lib/features/payment/presentation/revenue_screen.dart`)**:
  - 단순한 수납 목록을 넘어, '수익 관리'라는 종합적인 대시보드 화면을 신설했습니다.
  - `TabBar`를 사용해 '대시보드', '수납 관리', '청구 현황' 세 가지 탭으로 정보를 구조화하여 사용자가 재무 상태를 다각도로 분석할 수 있게 했습니다.
  - 대시보드 탭에서는 이번 달 수납액, 결제 수단별 통계 등 핵심 지표를 요약하여 보여줍니다.
- **수납 목록 정보 강화 (`/lib/features/payment/presentation/payment_list_screen.dart`)**:
  - 각 수납 항목을 `Card` 위젯으로 구성하고, 결제 수단에 따라 다른 아이콘과 색상을 부여하여 가독성을 높였습니다.
  - `FutureBuilder`를 통해 각 수납 건이 어떤 청구서에 얼마나 배분되었는지 요약 정보를 목록에서 바로 확인할 수 있도록 개선했습니다.
  - `PopupMenuButton`을 도입하여 '영수증 발행', '상세 보기', '삭제' 등 주요 기능을 각 항목에 통합하여 제공합니다.
- **영수증 발행 기능**: 수납 목록에서 직접 PDF 영수증을 생성하고 인쇄 미리보기를 할 수 있는 기능을 추가하여 사용자 편의성을 크게 향상시켰습니다.

---
### **task132, 133, 135, 136: 자산 데이터 모델 및 UI 변경**

자산(Property) 정보의 정확성과 사용자 입력 편의성을 높이기 위해 데이터 모델을 변경하고, 이를 자산 등록/수정 화면에 반영했습니다. 모든 UI 변경 사항은 `/lib/features/property/presentation/property_form_screen.dart` 파일에서 확인할 수 있습니다.

#### **1. `task136`: 주소 필드 구조 변경**

- **변경 전**: 단일 `address` 텍스트 필드.
- **변경 후**: 주소 필드를 `우편번호`, `주소`, `상세주소` 세 부분으로 구조화했습니다.
- **UI 구현**:
  - 폼에 `_zipCodeController`, `_address1Controller`, `_address2Controller`에 연결된 3개의 `TextFormField`를 배치했습니다.
  - **'주소 검색' 버튼**: `PostcodeService`를 호출하여 Daum 우편번호 서비스와 같은 네이티브 주소 검색 기능을 실행합니다.
  - **자동 입력 및 포커스 이동**: 사용자가 주소를 선택하면 우편번호와 기본 주소가 자동으로 입력되고, 포커스는 '상세주소' 필드로 이동하여 매끄러운 입력 흐름을 제공합니다.
  - 사용자가 '주소 검색' 기능을 사용하도록 유도하기 위해 우편번호와 주소 필드는 `readOnly`로 설정하여 데이터의 정합성을 높였습니다.

#### **2. `task132`: '자산 유형' 필드를 DropdownList로 변경**

- **변경 전**: 자산 유형을 자유 텍스트로 입력.
- **변경 후**: `PropertyType` enum을 정의하고, `DropdownButtonFormField`를 사용하여 정해진 값(예: 아파트, 빌라, 상가)만 선택할 수 있도록 변경했습니다.
- **UI 구현**:
  - `PropertyType.values`를 순회하며 `DropdownMenuItem`을 동적으로 생성합니다.
  - 각 메뉴 항목에는 `type.displayName` (예: '아파트')을 표시하여 사용자 친화적인 UI를 제공합니다.
  - 이 변경으로 오타나 비정형 데이터 입력을 원천적으로 차단하여 데이터 일관성을 확보했습니다.

#### **3. `task135`: '계약 종류' 필드 추가**

- **변경 전**: 해당 필드 없음.
- **변경 후**: `ContractType` enum을 새로 정의하고 `properties` 테이블에 칼럼을 추가했습니다.
- **UI 구현**:
  - '자산 유형'과 유사하게 `DropdownButtonFormField`를 추가했습니다.
  - 사용자는 '월세', '전세' 등 미리 정의된 계약 종류 중에서 선택할 수 있습니다.

#### **4. `task133`: '층수' 필드 제거**

- **변경 전**: '층수'를 입력하는 필드 존재.
- **변경 후**: 데이터베이스 스키마에서 `totalFloors` 칼럼이 제거되었습니다.
- **UI 구현**:
  - `property_form_screen.dart`의 `build` 메서드 내 `ListView`에서 '층수' 관련 `TextFormField`와 `TextEditingController`가 완전히 삭제되어 UI에 더 이상 표시되지 않습니다.

---

## 2025-09-12 (그룹 1/3)

### **task101, 102, 104, 105, 106, 109: 사용자 인증 및 프로필 관리**

사용자 계정의 전체 생명주기(회원가입, 로그인/로그아웃, 프로필 수정)를 관리하는 기능입니다. 보안과 사용자 경험을 고려하여 체계적으로 구현되었습니다.

#### **1. 회원가입 (`task101`, `task102`)**

- **UI (`/lib/features/auth/presentation/register_screen.dart`)**:
  - 회원가입을 위한 전용 화면으로, 이메일, 이름, 비밀번호, 비밀번호 확인을 위한 `TextFormField`를 제공합니다.
  - **실시간 비밀번호 강도 검사 (`task101`)**: 사용자가 비밀번호를 입력할 때마다 `PasswordValidator` 유틸리티를 사용하여 실시간으로 강도를 분석합니다. 분석 결과(예: '강함', '보통')와 시각적인 `LinearProgressIndicator`를 함께 제공하여 사용자가 안전한 비밀번호를 설정하도록 유도합니다.
  - **입력값 검증**: 각 필드에 `validator`를 설정하여 이메일 형식, 필수 입력 여부, 비밀번호 일치 여부 등을 검증합니다.
- **비밀번호 암호화 (`task102`)**:
  - **해싱 처리 (`/lib/core/auth/auth_repository.dart`)**: `AuthRepository`에서 `crypto` 패키지의 `sha256` 알고리즘을 사용하여 비밀번호를 해싱합니다. `_hashPassword` 메서드를 통해 암호화가 이루어지며, 원본 비밀번호는 절대 데이터베이스에 저장되지 않습니다.
  - **중앙화된 정책 (`/lib/core/utils/password_validator.dart`)**: 비밀번호 정책(최소 8자, 대/소문자 및 숫자 포함 등)을 `PasswordValidator` 클래스에 중앙화하여, 정책의 일관성을 유지하고 변경을 용이하게 했습니다.

#### **2. 로그인 및 로그아웃 (`task109`)**

- **로그인 UI 및 로직**:
  - **UI (`/lib/features/auth/presentation/login_screen.dart`)**: 이메일과 비밀번호를 입력하는 단순한 폼을 제공합니다. 단일 사용자 앱의 특성을 살려, `initState`에서 `authRepository.getFirstUserEmail()`을 호출해 등록된 사용자 이메일을 미리 채워넣어 편의성을 높였습니다.
  - **로직 (`/lib/core/auth/auth_repository.dart`)**: `login` 메서드는 입력된 비밀번호를 `_hashPassword`로 해싱한 후, DB에 저장된 해시와 비교합니다. 인증 성공 시, `FlutterSecureStorage`에 세션 토큰과 사용자 ID를 저장하여 앱을 재시작해도 로그인 상태가 유지되도록 구현했습니다.
- **로그아웃 로직**:
  - `AuthRepository`의 `logout` 메서드는 `FlutterSecureStorage`에 저장된 세션 토큰과 사용자 정보를 삭제하여 세션을 종료합니다. 이 기능은 '설정' 화면의 로그아웃 버튼을 통해 호출됩니다.

#### **3. 프로필 관리 (`task104`, `task105`, `task106`)**

- **UI (`/lib/features/settings/presentation/profile_screen.dart`)**:
  - '프로필 관리' 화면 내에 `TabBar`를 사용하여 '개인정보' 탭과 '비밀번호 변경' 탭으로 기능을 명확히 분리하여 체계적인 UI를 구성했습니다 (`task104`).
- **개인정보 수정 (`task105`)**:
  - '개인정보' 탭에서 사용자 이름을 수정할 수 있는 폼을 제공합니다. 계정의 고유 식별자인 이메일 필드는 `enabled: false`로 설정하여 변경할 수 없도록 보호합니다.
- **비밀번호 변경 (`task106`)**:
  - '비밀번호 변경' 탭에서 현재 비밀번호, 새 비밀번호, 새 비밀번호 확인을 위한 폼을 제공합니다.
- **업데이트 로직 (`/lib/core/auth/auth_repository.dart`)**:
  - `updateUserProfile` 메서드가 이름과 비밀번호 변경을 모두 처리합니다.
  - 비밀번호 변경 시에는 현재 비밀번호의 정확성을 먼저 검증한 후에만 새 비밀번호 해시를 데이터베이스에 업데이트하여 보안을 강화했습니다.

---

## 2025-09-12 (그룹 2/3)

### **task114, 115, 117, 118, 119, 121: 수납 및 자동 배분 워크플로우 구현**

수납금 등록 시 미납 청구서에 자동으로 배분하고, 청구 상태를 업데이트하는 핵심 재무 워크플로우를 구현했습니다.

#### **1. 데이터 모델 확장 및 신규 생성 (`task114`, `task115`, `task117`, `task118`)**

- **위치**: `/lib/core/database/app_database.dart`
- **`Billings` 테이블 확장 (`task115`)**: 기존 `Billings` 테이블에 `status` 칼럼을 추가했습니다. 이를 통해 청구서의 상태를 '미발행(DRAFT)', '발행(ISSUED)', '부분납(PARTIALLY_PAID)', '완납(PAID)', '연체(OVERDUE)' 등으로 상세하게 추적할 수 있게 되었습니다.
- **`Payments` 테이블 신규 생성 (`task117`)**: 수납된 금액 자체를 기록하는 `Payments` 테이블을 새로 만들었습니다. 이 테이블은 어떤 임차인이, 어떤 방법으로, 얼마를, 언제 입금했는지에 대한 정보를 저장합니다.
- **`PaymentAllocations` 테이블 신규 생성 (`task118`)**: `Payments`와 `Billings`를 연결하는 핵심 테이블입니다. 특정 수납(Payment) 금액의 일부 또는 전체가 특정 청구서(Billing)에 얼마만큼 할당되었는지를 기록합니다. 이 다대다 관계를 통해, '하나의 수납금으로 여러 청구서 납부' 또는 '여러 수납금으로 하나의 청구서 납부'와 같은 복잡한 시나리오를 처리할 수 있습니다.

#### **2. 핵심 워크플로우 구현 (`task119`, `task121`)**

- **위치**: `/lib/features/payment/data/payment_repository.dart`
- **수납 생성 진입점 (`createPayment`)**:
  1.  먼저 `Payments` 테이블에 수납 기록을 생성합니다.
  2.  그 후, 수동 배분 요청이 있으면 `_processManualAllocations`를, 없으면 **자동 배분 로직**인 `_processAutoAllocation`을 호출합니다.
- **자동 배분 로직 (`_processAutoAllocation`)**:
  1.  `_getUnpaidBillingsForTenant`를 통해 해당 임차인의 미납 청구서를 **가장 오래된 순서**로 조회합니다.
  2.  조회된 미납 청구서들에 대해, 수납 금액이 소진될 때까지 순서대로 채워나가는 방식으로 `PaymentAllocation` 레코드를 생성합니다.
- **청구서 상태 자동 업데이트 (`_updateBillingStatus`)**:
  - 금액이 배분될 때마다 영향을 받은 청구서에 대해 이 메서드가 호출됩니다.
  - 해당 청구서에 연결된 모든 `PaymentAllocation` 금액의 합계를 계산하여 미납액을 새로 구합니다.
  - 미납액이 0원이면 `PAID`, 0보다 크지만 총액보다 작으면 `PARTIALLY_PAID` 등으로 청구서의 `status`를 자동으로 업데이트하여 데이터 정합성을 유지합니다.
- **UI 연동 (`/lib/features/payment/presentation/payment_form_screen.dart`)**:
  - '수납 등록' 화면은 이 워크플로우를 기반으로 설계되었습니다.
  - 사용자가 미납 청구서를 선택하면, 해당 청구서의 미납액이 수납 금액으로 자동 입력됩니다.
  - '등록' 버튼을 누르면 `createPayment`가 호출되어, 선택된 청구서에 수납액을 할당하는 '수동 배분' 방식으로 워크플로우가 실행됩니다. 이는 복잡한 자동 배분 로직을 사용자에게는 단순한 인터페이스로 제공하는 효과적인 UX 설계입니다.

---

## 2025-09-12 (그룹 3/3)

### **task127, 128, 129, 130: 보고서 기능 구현**

자산의 재무 및 운영 상태에 대한 통찰력을 제공하기 위해 월별 수익, 연체 현황, 점유율의 세 가지 핵심 보고서 기능을 구현했습니다.

#### **1. 도메인 모델 (`/lib/features/reports/domain/monthly_revenue_report.dart`)**

- `freezed`를 사용하여 각 보고서의 데이터 구조를 명확하게 정의했습니다.
  - **`MonthlyRevenueReport` (`task128`)**: 특정 월의 총 청구액, 총 수납액, 수납률, 전년 동월 대비 증감률 등의 데이터를 포함합니다.
  - **`OverdueReport` (`task129`)**: 임차인별 연체 현황을 나타내며, 총 연체액과 상세 연체 청구서 목록을 가집니다.
  - **`OccupancyReport` (`task130`)**: 자산별 총 유닛 수, 임대된 유닛 수, 공실 수 등을 통해 점유율과 공실로 인한 수익 손실을 계산합니다.

#### **2. 데이터 계층 (`/lib/features/reports/data/reports_repository.dart`)**

- `ReportsRepository`는 보고서 생성에 필요한 데이터를 조회하고 가공하는 역할을 담당합니다.
- **복합 SQL 쿼리 활용**: 여러 테이블을 `JOIN`하고 `SUM`, `COUNT` 같은 집계 함수를 사용하는 순수 SQL 쿼리(`_database.customSelect`)를 적극적으로 활용했습니다. 이는 앱단에서 데이터를 조합하는 것보다 훨씬 효율적이고 빠른 성능을 보장합니다.
  - **`getOverdueReports`**: `billings`, `leases`, `tenants`, `units`, `properties` 테이블을 모두 `JOIN`하여 연체 현황에 필요한 모든 정보를 한 번의 쿼리로 가져옵니다.
  - **`getOccupancyReports`**: `SUM(CASE WHEN ...)` 구문을 사용하여 자산별 점유/공실 유닛 수를 데이터베이스단에서 효율적으로 계산합니다.
- **데이터 변환**: SQL 쿼리로 가져온 데이터를 임차인별, 자산별로 그룹화하여 위에서 정의한 `freezed` 도메인 모델 객체로 변환하는 로직을 포함합니다.

#### **3. 애플리케이션 및 프레젠테이션 계층**

- **상태 관리 (`/lib/features/reports/application/reports_controller.dart`)**:
  - 각 보고서 유형에 맞춰 Riverpod의 `FutureProvider`를 생성했습니다 (`monthlyRevenueReportProvider`, `overdueReportsProvider` 등).
  - `FutureProvider`를 통해 데이터 로딩 및 오류 상태가 UI에 자동으로 반영되도록 하여 상태 관리를 단순화했습니다.
  - 월별 수익 보고서처럼 파라미터가 필요한 경우 `.family` 수식어를 사용하여 구현했습니다.
- **UI (`/lib/features/reports/presentation/reports_screen.dart`)**:
  - `TabBar`를 사용하여 세 가지 보고서를 명확하게 분리하여 제공합니다 (`task127`).
  - **월별 수익 탭**: 사용자가 `DropdownButton`으로 조회할 월을 선택할 수 있으며, 주요 지표를 `Card` 위젯에 표시하고 수납률을 `LinearProgressIndicator`로 시각화합니다.
  - **연체 현황 탭**: 연체 금액이 가장 큰 임차인 순으로 목록을 정렬하고, `ExpansionTile`을 사용하여 각 임차인의 상세 연체 내역을 확인할 수 있도록 UX를 구성했습니다.
  - **점유율 탭**: 자산별 점유율을 `LinearProgressIndicator`로 시각화하고, 잠재 수익과 실제 수익, 그로 인한 '수익 손실'을 명확히 표시하여 직관적인 분석을 돕습니다.

---

## 2025-09-11 (그룹 1/2)

### **task139, 140, 144-152: 임대 계약 및 유닛 관리 워크플로우 개선**

임대 계약 생성 프로세스의 사용자 경험을 향상시키고, 데이터의 정합성을 강화하기 위해 유닛 모델과 계약 등록 화면을 전반적으로 개선했습니다.

#### **1. 유닛 및 임대 상태 모델링 (`task139`, `task140`)**

- **위치**: `/lib/features/property/domain/unit.dart`, `/lib/features/lease/domain/lease.dart`
- **`enum`을 통한 상태 명확화**:
  - **`RentStatus` (`task139`)**: 유닛의 상태를 문자열이나 boolean 대신 `rented`(임대 중), `vacant`(공실) 값을 가지는 `enum`으로 정의했습니다. `RentStatusExtension`을 통해 UI에 '임대 중', '공실'과 같이 사용자 친화적인 텍스트를 표시합니다.
  - **`LeaseStatus`**: 계약의 상태 또한 `active`, `terminated`, `pending` 등의 `enum`으로 명확하게 정의했습니다.
- **UI 구현 (`task140`)**:
  - `unit_form_screen.dart`에서 '임대 상태' 필드를 `DropdownButtonFormField<RentStatus>`로 구현하여 정해진 값만 선택할 수 있도록 데이터 입력 오류를 원천적으로 방지합니다.

#### **2. 임대 계약 등록 워크플로우 개선 (`task144`, `task145`, `task147`, `task148`, `task149`, `task150`)**

- **위치**: `/lib/features/lease/presentation/lease_form_screen.dart`
- **논리적 입력 순서 강제 (`task147`, `task148`)**: 사용자가 '임차인 → 자산 → 유닛' 순서로 정보를 선택하도록 워크플로우를 개선했습니다.
- **연동된 드롭다운 (`task149`)**: '자산'을 선택해야만 '유닛' 드롭다운이 활성화되며, 선택된 자산에 속한 유닛만 필터링하여 보여줍니다. 이는 사용자의 혼란을 줄이고 잘못된 데이터 입력을 방지합니다.
- **사용 가능한 임차인 필터링 (`task145`)**: '임차인' 드롭다운에는 현재 활성 계약이 없는 임차인만 표시하여, 동일한 임차인에게 중복으로 활성 계약을 생성하는 실수를 방지합니다.
- **'임차인 바로 추가' 기능 (`task146`)**: 임차인 선택 드롭다운 옆에 '임차인 등록' 버튼을 추가했습니다. 이를 통해 계약 등록 중 필요한 임차인이 목록에 없을 경우, 화면을 이탈하지 않고 새 임차인을 등록한 뒤 바로 계약 등록 절차를 이어갈 수 있어 작업 흐름이 끊기지 않습니다.
- **공실 자산 처리 (`task150`)**: 선택한 자산에 등록된 유닛이 없을 경우, 드롭다운에 "선택된 자산에 등록된 유닛이 없습니다"라는 안내 메시지를 표시하여 사용자에게 명확한 피드백을 제공합니다.

#### **3. 계약별 기본 청구 항목 자동 추가 (`task151`, `task152`)**

- **설정 (`/lib/features/property/presentation/property_form_screen.dart`)**: 자산 등록/수정 화면에 '기본 청구 항목' 섹션을 추가했습니다. 여기서 사용자는 '관리비', '수도비' 등 해당 자산의 모든 계약에 공통으로 적용될 항목과 기본 금액을 미리 설정할 수 있습니다.
- **자동 추가 로직 (`/lib/features/billing/data/billing_repository.dart`)**:
  - `createBulkBillings` (일괄 청구 생성) 로직 내에서, 계약의 월세를 기본으로 추가한 후, 해당 계약이 속한 자산에 미리 설정된 '기본 청구 항목'들을 자동으로 불러와 청구서에 함께 추가합니다.
  - 이 기능은 매월 반복되는 청구서 생성 작업을 자동화하여 사용자의 수고를 크게 덜어줍니다.

---

## 2025-09-12 (그룹 4/4)

### **task141, 142, 143: 주민등록번호 처리 개선 (분리 저장 및 UI 마스킹)**

개인정보 보호 강화를 위해 임차인의 주민등록번호 처리 방식을 변경했습니다. 전체 번호를 저장하지 않고, UI 상에서는 마스킹 처리하여 보안을 개선했습니다.

#### **1. 데이터 모델 및 저장 방식 변경 (`task141`, `task142`)**

- **위치**: `/lib/core/database/app_database.dart`, `/lib/features/tenant/domain/tenant.dart`
- **분리 저장**: 기존의 `socialNo` 필드 대신, `Tenants` 테이블에 `bday` (생년월일 6자리, Text)와 `personalNo` (성별 및 식별번호 첫째 자리, Integer) 두 개의 칼럼을 새로 추가하여 주민등록번호를 분리해 저장합니다. 이를 통해 전체 주민등록번호가 데이터베이스에 평문으로 저장되는 것을 방지합니다.
- **도메인 모델 반영**: `Tenant` 도메인 모델에도 `bday`와 `personalNo` 필드를 추가하여 분리된 데이터를 관리합니다.

#### **2. UI 마스킹 처리 (`task143`)**

- **계산된 속성 (`/lib/features/tenant/domain/tenant.dart`)**:
  - `Tenant` 모델 내에 `maskedSocialNo`라는 `getter`를 구현했습니다. 이 `getter`는 저장된 `bday`와 `personalNo`를 조합하여 `750331-1******`와 같은 형태로 마스킹된 주민등록번호 문자열을 동적으로 생성합니다. UI에서는 이 `maskedSocialNo`를 호출하여 항상 마스킹된 정보만 표시하도록 보장합니다.
- **입력 UI (`/lib/features/tenant/presentation/tenant_form_screen.dart`)**:
  - 임차인 등록/수정 화면에서 주민등록번호를 입력받는 UI를 단일 텍스트 필드가 아닌, '생년월일' 6자리와 '성별' 1자리를 입력하는 두 개의 분리된 `TextFormField`로 변경했습니다.
  - UI상에서 두 필드 사이에 하이픈(-)과 `******` 마스킹을 시각적으로 표시하여, 사용자에게 익숙한 입력 경험을 제공하면서도 데이터는 분리하여 처리합니다.

---
