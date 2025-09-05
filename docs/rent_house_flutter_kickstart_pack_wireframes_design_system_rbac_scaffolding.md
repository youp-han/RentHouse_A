# RentHouse — Flutter Kickstart Pack
_초판: 2025-09-05_

본 문서는 Flutter 초심자 기준으로 **와이어프레임 → 디자인 시스템 → 라우팅/네비 → RBAC → 프로젝트 구조/의존성 → 스타터 코드 → MVP 백로그**를 한 번에 제공합니다. 이 한 파일만 보고 바로 구현을 시작할 수 있도록 구성했습니다.

---

## A. 텍스트 와이어프레임 (모바일/데스크톱 핵심 화면)

> 표기 규칙: `[]` 버튼, `<>` 입력, `( )` 설명, `→` 흐름, `|` 구분자

### A1. 로그인
```
[Logo]
이메일 <________________>
비밀번호 <______________> [표시]
[로그인]
(오류시) 경고 토스트: 이메일/비밀번호를 확인하세요.
(링크) 비밀번호 재설정
```
데스크톱: 가운데 정렬 카드, 480px 폭. 모바일: 전체폭.

### A2. 대시보드
```
헤더: 검색 <임차인/계약/유닛 검색>
카드(2열 모바일/4열 데스크톱)
 ├ 이번 달 청구 합계  ├ 이번 달 수납 합계 ├ 미납 건수 ├ 활성 계약 수
테이블: 최근 활동 10건  |  빠른 작업: [신규 계약] [월 청구 생성] [보고서 다운로드]
```

### A3. 리스트(공통)
```
타이틀: 자산 목록 (Property)
필터: 키워드, 타입, 상태 | [필터적용]
테이블: [선택] 이름 | 주소 | 타입 | 유닛수 | 액션([상세] [수정])
푸터: 페이지네이션 « 1 2 3 »  |  [+ 신규 등록]
```

### A4. 등록/수정 폼(공통)
```
섹션: 기본 정보
이름 <__________>  타입 <드롭다운>  주소 <주소검색>
설명 <멀티라인>
[저장] [취소]
(검증 실패시) 필드 하단 에러 메시지 + 상단 요약 토스트
```

### A5. 계약 생성 플로우
```
1) 유닛 선택 → 2) 세입자 연결/신규 → 3) 조건(보증금/월세/기간) → 4) 첨부/메모 → 5) 미리보기 → [계약 생성]
완료 화면: [청구 스케줄 생성]
```

### A6. 청구/수납
```
리스트: 청구서(Year-Month, 계약, 금액, 기한, 상태, 액션)
액션: [발행] [취소] [수납 처리]
대량 작업: 체크박스 선택 → [월 청구 대량 발행]
```

### A7. 리포트
```
카드: 월별 수익 / 임차인 현황
[PDF 다운로드]
```

---

## B. 디자인 시스템 (Material 3 기반, SB Admin 2 미사용)

### B1. 컬러 토큰(예시)
- Seed: `#2E6A9E` (브랜드 블루)
- Semantic: Success `#2E7D32`, Warning `#ED6C02`, Error `#D32F2F`
- 명암: 텍스트 대비 WCAG AA 이상 유지

### B2. 타이포그래피
- 본문: Noto Sans KR, 16–18px, line-height 1.6
- 제목 스케일: display/title/body/label(M3 권장값)

### B3. 간격/레이아웃
- 4px base spacing, 8/16/24 단위 권장
- 브레이크포인트: ≤600(모바일), 600–1024(태블릿), ≥1024(데스크톱)

### B4. 컴포넌트 가이드(발췌)
- 버튼: 기본/강조/파괴적(확인 다이얼로그 필요)
- 폼: 실시간 검증, 헬프텍스트, 오류 텍스트, 엔터/탭 이동
- 테이블: 고정 헤더, 정렬, 필터, 페이지 유지
- 피드백: 토스트, 스낵바, 빈 상태(Skeleton)

---

## C. 라우팅/네비게이션 맵 (go_router 전제)

```
/                   → (로그인 여부에 따라) /admin/dashboard 또는 /login
/login              → 로그인 화면
/admin/dashboard    → 대시보드 [권한: any authenticated]
/property           → 자산 목록 [read]
/property/new       → 자산 등록 [create]
/property/:id       → 자산 상세 [read]
/tenants            → 세입자 목록 [read]
/leases             → 계약 목록 [read]
/billings           → 청구 목록 [read]
/reports            → 리포트 [read]
/settings/roles     → 역할/권한 [admin]
```

---

## D. RBAC 설계 (역할·권한 매트릭스 및 가드)

### D1. 역할
- OWNER, ADMIN, MANAGER, STAFF, ACCOUNTANT, READONLY

### D2. 권한(예)
- property: read/create/update/delete
- tenant: read/create/update/delete
- lease: read/create/update/delete
- billing: read/create/update/delete/export/approve
- reports: read/export
- settings: read/update (roles)

### D3. 매트릭스(발췌)
| 모듈 \ 역할 | OWNER | ADMIN | MANAGER | STAFF | ACCOUNTANT | READONLY |
|---|---|---|---|---|---|---|
| 자산/유닛 | CRUD | CRUD | CRUD | R/U | R | R |
| 세입자 | CRUD | CRUD | CRUD | R/U | R | R |
| 계약 | CRUD | CRUD | CRUD | C/U | R | R |
| 청구/수납 | CRUD | CRUD | R/U | C/U | CRUD | R |
| 리포트 | CRUD | CRUD | R | R | R | R |
| 설정/역할 | CRUD | CRUD | R | - | - | - |

### D4. Flutter 적용 지침
- 라우팅 가드: go_router `redirect`에서 세션/JWT roles 확인
- 위젯 가드: `can('billing.create')` 헬퍼로 액션 노출 제어
- 서버 재검증: 민감 API는 서버에서 최종 403/401 판단

---

## E. 프로젝트 구조 & 의존성

### E1. 폴더 구조(권장)
```
lib/
  app/
    app.dart         # MaterialApp + 테마 + 라우터
    theme.dart       # 색/타이포/컴포넌트 테마
    router.dart      # go_router 정의
  core/
    auth/
      auth_state.dart
      auth_repository.dart
      auth_guard.dart
    rbac/
      permissions.dart
      rbac_guard.dart
    utils/
      logger.dart
      localization.dart
  features/
    dashboard/
      presentation/dashboard_screen.dart
    property/
      data/property_api.dart
      domain/property.dart
      presentation/property_list_screen.dart
      presentation/property_form_screen.dart
    tenant/
    lease/
    billing/
    reports/
  shared/
    widgets/
    forms/
```

### E2. pubspec.yaml (발췌)
```yaml
name: renthouse
environment:
  sdk: ">=3.4.0 <4.0.0"
dependencies:
  flutter: { sdk: flutter }
  go_router: ^14.2.0
  flutter_riverpod: ^2.5.1
  dio: ^5.5.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  intl: ^0.19.0
  flutter_secure_storage: ^9.2.2
  # 선택: data_table_2, file_picker, sentry_flutter 등

dev_dependencies:
  build_runner: ^2.4.11
  freezed: ^2.5.2
  json_serializable: ^6.9.0
  flutter_test:
    sdk: flutter
```

---

## F. 스타터 코드 (필수 파일)

### F1. lib/app/app.dart
```dart
import 'package:flutter/material.dart';
import 'theme.dart';
import 'router.dart';

class RentHouseApp extends StatelessWidget {
  const RentHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RentHouse',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### F2. lib/app/theme.dart
```dart
import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const seed = Color(0xFF2E6A9E);
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
  return ThemeData(colorScheme: scheme, useMaterial3: true);
}

ThemeData buildDarkTheme() {
  const seed = Color(0xFF2E6A9E);
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
  return ThemeData(colorScheme: scheme, useMaterial3: true);
}
```

### F3. lib/app/router.dart (go_router + 가드 훅)
```dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../core/auth/auth_state.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/property/presentation/property_list_screen.dart';
import '../features/property/presentation/property_form_screen.dart';
import '../features/auth/login_screen.dart';

final authState = AuthState.instance; // 간단 싱글톤(초기 PoC용)

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final loggedIn = authState.isLoggedIn;
    final loggingIn = state.matchedLocation == '/login';
    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/admin/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/', redirect: (_, __) => '/admin/dashboard'),
    GoRoute(path: '/admin/dashboard', builder: (c, s) => const DashboardScreen()),
    GoRoute(path: '/property', builder: (c, s) => const PropertyListScreen()),
    GoRoute(path: '/property/new', builder: (c, s) => const PropertyFormScreen()),
  ],
);
```

### F4. lib/core/auth/auth_state.dart (아주 단순화)
```dart
class AuthState {
  static final AuthState instance = AuthState._();
  AuthState._();

  bool isLoggedIn = false;
  List<String> roles = []; // ['ADMIN', 'MANAGER', ...]

  void login({required List<String> roles}) {
    isLoggedIn = true;
    this.roles = roles;
  }

  void logout() {
    isLoggedIn = false;
    roles = [];
  }
}
```

### F5. lib/core/rbac/permissions.dart (간단 헬퍼)
```dart
import '../auth/auth_state.dart';

bool can(String permission) {
  // 초기 PoC: 권한-역할 매핑은 하드코딩, 추후 서버/토큰 기반으로 교체
  final roles = AuthState.instance.roles;
  if (roles.contains('OWNER') || roles.contains('ADMIN')) return true;
  // 예: billing.create 는 MANAGER 이상 허용
  if (permission == 'billing.create' && roles.contains('MANAGER')) return true;
  return false;
}
```

### F6. 대시보드/리스트 스크린(예시)
```dart
// lib/features/dashboard/presentation/dashboard_screen.dart
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('대시보드')),
      body: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width >= 1024 ? 4 : 2,
        children: const [
          _KPI(title: '이번 달 청구 합계', value: '₩0'),
          _KPI(title: '이번 달 수납 합계', value: '₩0'),
          _KPI(title: '미납 건수', value: '0'),
          _KPI(title: '활성 계약 수', value: '0'),
        ],
      ),
    );
  }
}

class _KPI extends StatelessWidget {
  final String title; final String value;
  const _KPI({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
```

```dart
// lib/features/property/presentation/property_list_screen.dart
import 'package:flutter/material.dart';

class PropertyListScreen extends StatelessWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('자산 목록')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextField(decoration: const InputDecoration(hintText: '검색'))),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: () {}, child: const Text('필터적용')),
                const Spacer(),
                FilledButton(onPressed: () {}, child: const Text('+ 신규 등록')),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (_, i) => ListTile(
                title: Text('건물 ${i+1}'),
                subtitle: const Text('용인시 수지구 ...'),
                trailing: Wrap(spacing: 8, children: [
                  TextButton(onPressed: () {}, child: const Text('상세')),
                  TextButton(onPressed: () {}, child: const Text('수정')),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
```

```dart
// lib/features/property/presentation/property_form_screen.dart
import 'package:flutter/material.dart';

class PropertyFormScreen extends StatefulWidget {
  const PropertyFormScreen({super.key});
  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('자산 등록')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: '이름'),
              validator: (v) => (v==null || v.isEmpty) ? '이름은 필수입니다' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(labelText: '주소'),
            ),
            const SizedBox(height: 24),
            Row(children: [
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('저장되었습니다')));
                    Navigator.pop(context);
                  }
                },
                child: const Text('저장'),
              ),
              const SizedBox(width: 12),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
            ])
          ],
        ),
      ),
    );
  }
}
```

---

## G. MVP 백로그 (2주치 예시)

### 스프린트 1 (주요 흐름 확보)
- [ ] 프로젝트 생성, pubspec 의존성 추가, `app/` 구성
- [ ] 라우팅/가드: `/login`, `/admin/dashboard`, `/property`, `/property/new`
- [ ] 대시보드 KPI 카드(더미 데이터)
- [ ] Property 리스트/폼(로컬 메모리 저장으로 임시 구현)
- [ ] 기본 테마(Material 3 seed)

### 스프린트 2 (데이터/권한/품질)
- [ ] `dio`로 백엔드 API 연동(목업 서버도 가능)
- [ ] RBAC: `can()` 적용해 버튼/메뉴 노출 제어
- [ ] 입력 검증·오류 처리·토스트 패턴 통일
- [ ] 위젯 테스트 3건, 골든 테스트 1건

---

## H. 다음 행동 가이드
1) 본 문서 기준으로 프로젝트 생성 및 `F. 스타터 코드`를 파일에 복사 → 실행 확인
2) Property 모듈부터 실제 API 계약에 맞춰 `data/domain` 추가 구현
3) 텍스트 와이어프레임을 Figma로 이행(원하실 경우, 템플릿 프레임을 제공 가능)

> 필요 시: 다음 개정판에서 **HTTP 인터셉터(dio), 에러 핸들러, 로컬 캐시(drift), 폼 빌더, 테이블 최적화(가상 스크롤)** 추가 샘플을 드리겠습니다.

