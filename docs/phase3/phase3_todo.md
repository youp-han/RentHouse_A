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

## 3. 기술 부채 및 기타 작업 (Technical Debt & Chores)

- [ ] (task155) **데이터베이스 마이그레이션**
    - [ ] (task156) 변경된 데이터 모델(`Billing`, `Property` 등)에 맞춰 `drift` 스키마 버전업 및 마이그레이션 전략 수립/실행
    - [ ] (task157) `(lease_id, yearMonth)`에 대한 유니크 인덱스 추가하여 중복 청구 방지
    - [ ] (task164) 데이터 백업 및 싱크
