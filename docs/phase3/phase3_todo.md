# RentHouse 프로젝트 Phase 3 To-Do 리스트

Phase 2에서 완료되지 않은 작업 목록입니다.

## 1. 신규 기능 (New Features)

- [ ] (task110) **고객 관리 기능 추가**
    - [ ] (task111) 자산 소유자가 앱 사용자의 고객인 경우를 위한 고객 관리 화면 구현
    - [ ] (task112) 고객 정보 (이름, 이메일 등) CRUD 기능

- [ ] (task113) **수익 관리 기능 상세 구현 (Revenue Management)**
    - [ ] (task116) `BillingItem` 모델: `quantity`, `unitPrice`, `tax`, `memo` 등 상세 필드 추가

## 2. 기존 기능 개선 및 변경 (Improvements & Changes)

### 2.1. 자산 (Property) 및 유닛 (Unit)
- [ ] (task131) **자산 데이터 모델 변경**
- [ ] (task137) **우편번호 검색 API 연동**
    - [ ] (task138) 자산 등록/수정 시 다음 우편번호 API 등을 사용하여 주소 입력 기능 구현

    카카오 주소 API 연동 작업 목록
   1. `webview_flutter` 패키지 추가
   2. 주소 검색 화면(스크린) 신규 생성
   3. WebView 컨트롤러 설정 및 로드
   4. 데이터 수신 및 처리 로직 구현
   5. 기존 폼(자산 등록/수정)과 연동
   6. 전달받은 주소 데이터 적용 

     ### 1. 모바일 (Android, iOS)

  네, 완벽하게 동작합니다.
  webview_flutter 패키지는 안드로이드와 iOS를 주력으로 지원하며, 이 두 플랫폼에서는 카카오 주소
  API를 사용하는 것이 매우 안정적이고 일반적인 방법입니다.


  2. 데스크톱 (Windows, macOS, Linux)
   * Windows: WebView2 런타임이 시스템에 설치되어 있어야 합니다. 최신 Windows 10/11에는
     기본적으로 포함되어 있지만, 없는 경우 사용자가 직접 설치해야 앱의 해당 기능이 동작합니다.
  3. 웹 (Web)
   * 기술적 한계: Flutter Web에서 webview_flutter는 <iframe> HTML 태그를 사용하여 구현됩니다.
     하지만 카카오 주소 API는 보안 정책(Same-Origin Policy) 때문에 <iframe> 안에서 부모
     창(Flutter 웹 앱)으로 데이터를 전달하는 postMessage 호출이 대부분의 브라우저에서
     차단됩니다.
  | 플랫폼 | webview_flutter + 카카오 주소 API 사용 가능 여부 | 비고 |
  | :--- | :--- | :--- |
  | Android, iOS | O (가능, 최적의 방법) | 안정적이고 문제없이 동작 |
  | Windows, macOS, Linux | △ (조건부 가능) | OS별로 WebView 런타임/라이브러리 필요 |
  | Web | X (불가능/매우 어려움) | <iframe> 보안 정책 문제. 별도의 웹 전용 구현 필요 |

  결론적으로, 현재 제안된 방식은 모바일과 데스크톱을 위한 솔루션입니다.

## 3. 기술 부채 및 기타 작업 (Technical Debt & Chores)

- [ ] (task164) 데이터 백업 및 싱크
    - [ ] (task165) 기존 데이터 쉽게 입력 | Excel/CSV 템플릿 제공 및 가져오기(Import) 기능 구현 |
    - [ ] (task166) 데이터 백업 | 내보내기(Export) 기능 (DB 파일 자체 또는 CSV) 구현 |
    - [ ] (task167) 데스크톱-모바일 연동 | 클라우드 동기화 서비스(Dropbox 등)를 통해 DB 파일을 직접 동기화
shi 