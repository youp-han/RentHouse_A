# RentHouse 프로젝트 진행 상황

## 최종 업데이트: 2025-09-08

### 현재 상태
- **UI/UX 개선 완료**: 테마 일관성, 반응형 내비게이션, 폼 유효성 검사 및 사용자 피드백, 빈 상태 디자인 개선이 완료되었습니다.

### 완료된 단계
- 프로젝트 문서 검토 (PRD, UI/UX 추가 문서, Kickstart Pack).
- Flutter 경로 문제 해결 후 `renthouse` 프로젝트 생성 성공.
- 초기 폴더 구조 생성 (`app`, `core`, `features`, `shared`).
- `pubspec.yaml`에 필요한 의존성 업데이트.
- `flutter pub get` 실행하여 의존성 패키지 설치.
- 모든 초기 스타터 코드 파일 생성 (`app.dart`, `theme.dart`, `router.dart`, `auth_state.dart`, `permissions.dart`, `login_screen.dart`, `dashboard_screen.dart`, `property_list_screen.dart`, `property_form_screen.dart`, `main.dart`).
- `login_screen.dart`에 기본 UI 및 폼 유효성 검증 구현.
- 네트워크 요청을 위한 `dio_client.dart` 생성.
- 인증 로직 및 토큰 저장을 위한 `auth_repository.dart` 생성.
- Riverpod 상태 관리를 위한 `login_controller.dart` 생성.
- `login_screen.dart`를 `LoginController` 및 `Riverpod`와 통합.
- `dashboard_screen.dart`에 반응형 레이아웃, KPI 카드, 최근 활동 플레이스홀더, 빠른 작업 버튼을 포함한 기본 UI 구현.
- `auth_repository.dart`에 시뮬레이션 로그인 구현 (백엔드 통합 후 제거 예정).
- 시뮬레이션 로그인을 통해 로그인 및 대시보드 화면 정상 작동 확인.
- 자산 기능에 대한 `domain`, `data`, `application` 디렉토리 생성.
- `freezed` 및 `json_serializable`을 사용하여 `Property` 및 `Unit` 데이터 모델 정의.
- `build_runner`를 사용하여 Freezed 및 JSON Serializable 파일 생성.
- `property_repository.dart`에 **시뮬레이션된 인메모리 데이터베이스**를 사용하여 자산 CRUD 작업을 구현.
- 자산 목록의 Riverpod 상태 관리를 위한 `property_controller.dart` 생성.
- `property_controller.dart`를 사용하여 자산을 표시하도록 `property_list_screen.dart` 업데이트.
- `property_form_screen.dart`에 자산 생성을 위한 기본 폼 구현, 시뮬레이션 저장소와 통합.
- 대시보드에 "자산 관리" 버튼 추가하여 내비게이션 구현.
- `dashboard_screen.dart`의 `go_router` 임포트 오류 수정.
- `property_repository.dart`가 초기 빈 목록을 반환하도록 수정하여 "등록된 자산이 없습니다." 메시지 표시.
- `property_form_screen.dart` 취소 버튼 내비게이션 수정.
- **자산 상세/편집 구현**: 기존 자산을 보고 편집하는 기능 추가.
- **자산 삭제 구현**: 자산 삭제 기능 추가.
- **전역 내비게이션 시스템 구현**: `NavigationRail` 또는 `Drawer`를 활용하여 모든 모듈에 쉽게 접근할 수 있는 전역 내비게이션 시스템을 구현.
- **SQLite 데이터 영속성 구현**: 모든 데이터 처리를 SQLite 데이터베이스를 통해 영구적으로 저장하도록 변경.
- **UI/UX 개선**: 테마 일관성, 반응형 내비게이션, 폼 유효성 검사 및 사용자 피드백, 빈 상태 디자인 개선 완료.
- **임차인(Tenant) 기능 구현**: 임차인 정보(CRUD) 관리 기능을 구현했습니다. (Domain, Data, Application, Presentation 계층 포함)
- **임대 계약(Lease) 기능 구현**: 임대 계약 정보(CRUD) 관리 기능을 구현했습니다. (Domain, Data, Application, Presentation 계층 포함)

### 다음 단계
- **청구(Billing) 기능 구현**: 청구서 및 청구 항목 관리 기능을 구현합니다.
- **백엔드 연동**: (보류) 실제 백엔드 서버가 준비되면 다시 진행합니다.
- **단위 테스트 및 통합 테스트 작성**: (보류) 코드 안정성 및 품질 향상을 위해 테스트 코드를 추가합니다.

## 최종 업데이트: 2025-09-09

### 현재 상태
- **자산 및 유닛 관리 기능 개선**:
  - 자산 상세 화면에서 'property not found' 오류 및 문자열 보간 오류 수정.
  - 로그인 화면에 개발용 기본 계정(test@example.com / password) 자동 입력 기능 추가.
  - 유닛 등록/수정 시 'there's nothing to pop' 오류 수정 (go_router push/pop 문제 해결).
  - 라우팅 구조 전면 개편: 모든 상세/폼 화면이 `MainLayout` 내에서 동작하도록 변경하여 일관된 내비게이션 및 뒤로가기 버튼 제공.
  - 유닛 등록 방식 변경: 자산 저장 후 유닛을 별도로 순차 등록하는 워크플로우 구현.

### 다음 단계
- **유닛 상세 화면 구현**:
  - `unitDetailProvider`를 `property_repository.dart`에 추가 (진행 중).
  - `router.dart`에 유닛 상세 화면(`unit_detail_screen.dart`) 라우트 추가.
  - `unit_detail_screen.dart` 파일 생성 및 유닛 정보 표시 기능 구현.
  - `property_detail_screen.dart`에서 유닛 목록 클릭 시 `unit_detail_screen.dart`로 이동하도록 연결.