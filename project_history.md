# RentHouse 프로젝트 작업 내역

이 문서는 Git 커밋 로그와 완료된 작업 목록을 기반으로 재구성한 프로젝트 진행 내역입니다.

## 2025-09-05

### 💻 코드 변경사항 (Commits)
- feat: Implement initial Flutter project setup and Property module (simulated)

## 2025-09-08

### 💻 코드 변경사항 (Commits)
- first windows build ok

## 2025-09-09

### 💻 코드 변경사항 (Commits)
- 1. 청구 모델 저장/삭제 후 목록 업데이트 안 됨:
- a bug fix: tenant cannot be deleted when lease is signed
- bug fixed
- document updated
- error fixed for adding properties
- 첨부파일 기능 추가

## 2025-09-10

### 💻 코드 변경사항 (Commits)
- code ref: additional info level fixed
- code ref: info level fixed
- code: build warning fixed
- gemini md updated

## 2025-09-11

### ✅ 완료된 작업
- task100: 회원가입 기능 추가
- task103: 사용자 설정(Settings) 화면 구현
- task113: 수익 관리 기능 상세 구현 (Revenue Management)
- task139: 유닛 데이터 모델 변경
- task140: `임대 상태` 필드 DropdownList로 변경
- task144: 임대 계약 등록 화면 개선
- task153: 반응형 내비게이션 개선
- task154: 모바일 화면 하단 내비게이션

### 💻 코드 변경사항 (Commits)
- Update README.md
- added: test code <claude>, and docs rearranged
- billing added
- database changed, test file changed
- feature: login/join page added, secure password check etc
- navigation fixed
- settings added
- ui/ux changed for the property register module
- unit data, dropdown changed, lease register ui, ux changed

## 2025-09-12

### ✅ 완료된 작업
- task101: 이메일, 이름, 암호 입력 폼 구현
- task102: 암호는 암호화하여 저장
- task104: 프로필 관리 화면
- task105: 개인정보(이름 등) 수정 기능
- task106: 암호 변경 기능
- task108: 통화(Currency) 설정 기능 (원, 달러 등)
- task109: 로그인/로그아웃 기능 연동
- task114: 데이터 모델 확장 및 신규 생성
- task115: `Billing` 모델: `status` 필드 추가
- task117: `Payment` 모델 신규 생성
- task118: `PaymentAllocation` 모델 신규 생성
- task119: 핵심 워크플로우 구현
- task121: 수납 등록 및 자동 배분
- task127: 보고서 기능 구체화
- task128: 월별 수익 보고서
- task129: 연체 보고서
- task130: 점유율 보고서
- task131: 자산 데이터 모델 변경
- task141: 주민등록번호 저장 방식 변경
- task142: 주민등록번호 분리 저장
- task143: UI 마스킹 처리
- task145: 임차인 선택 개선
- task146: 신규 임차인 바로 추가 기능
- task147: 자산-유닛 연동 선택
- task148: 자산 먼저 선택
- task149: 선택된 자산의 유닛만 표시
- task150: 유닛 없는 자산 처리
- task151: 계약별 기본 청구 항목 추가
- task152: 기본 항목 자동 추가 기능
- task162: 로깅 및 크래시 보고 시스템 통합

### 💻 코드 변경사항 (Commits)
- Core Improvements (Task131-136):
- bugfix:
- feature added
- fixed not completed tasks
- task162) 로깅 및 크래시 보고 시스템 통합

## 2025-09-13

### ✅ 완료된 작업
- task107: 회원 탈퇴 기능
- task120: 반자동 청구 생성
- task122: 영수증 발행
- task160: 활동 로그 구현

### 💻 코드 변경사항 (Commits)
- (task120) 반자동 청구 생성: 사용자가 버튼을 눌러 특정 월의 청구서를 일괄 생성 (중복 생성 방지 로직 포함)
- (task122) 영수증 발행: 수납 내역을 바탕으로 PDF 영수증을 생성하는 기능
- Task 120: 반자동 청구 생성 (Semi-automatic Billing Generation)
- Task160 활동 로그 구현
- 오류 보고 기능 UI 업데이트 수정 완료!
- 회원탈퇴 기능 추가

## 2025-09-15

### ✅ 완료된 작업
- task123: UI/UX 개선
- task124: 대시보드 KPI 추가
- task125: 청구 목록 화면 개선
- task126: 수납 화면 개선
- task132: `자산 유형` 필드 DropdownList로 변경
- task133: `층수` 필드 제거
- task135: `계약 종류` 필드 추가
- task136: 주소 필드 구조 변경
- task158: 테스트 코드 작성
- task159: 기능별 테스트 코드 작성
- task161: 대시보드 활동 로그 표시
- task163: `logger`, `sentry_flutter` 통합

### 💻 코드 변경사항 (Commits)
- Task158 테스트 코드 작성
- androidManifest update
- bug fix
- phase2_completed
- uat 오류 수정 1
- uat 오류 수정 2
- 개선 사항
- 개선사항
- 개선사항 - 드래그
- 공지 개선사항
- 변경사항
- 빌드 오류 수정 완료!
- 삭제 화면 변경
- 수정사항
- 청구서 표시 방식 개선
- 청구서 화면 버그 수정

## 2025-09-16

### ✅ 완료된 작업
- task155: 데이터베이스 마이그레이션
- task156: Drift 스키마 버전업 및 마이그레이션
- task157: 중복 청구 방지 인덱스 추가
- task164: 데이터 백업 및 싱크

### 💻 코드 변경사항 (Commits)
- complete_report
- 데이터베이스 백업 완료
- 안드로이드/윈도우 빌드 환경 설정
- 청구서 생성 시 관리비 자동 추가 로직 개선:
- 청구서 생성 화면에서 계약 선택 드롭다운에서 가상 테넌트 ID 처리 개선:

## 2025-09-17

### ✅ 완료된 작업
- task137: 주소 검색 API 연동 (Daum Postcode)
- task138: 주소 검색 결과 자동 입력 및 포커스 이동
- task164: 데이터 백업 및 싱크

### 💻 코드 변경사항 (Commits)
- 수정된 데이터베이스 복원 프로세스

