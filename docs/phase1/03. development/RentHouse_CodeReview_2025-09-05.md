# RentHouse 코드 리뷰 (요약)
_작성일: 2025-09-05

## 👍 잘한 점
- **모듈 구조**: `members / properties / tenants / leases / bills(billing)` 등 도메인별 패키지 분리.
- **템플릿 & UI**: FreeMarker + SB Admin 2 적용으로 빠른 화면 구성.
- **DTO/매핑**: `ModelMapper` 기반 DTO 변환 유틸(`EntityConverter`) 도입.
- **리포트**: iText7로 PDF 보고서(`/reports/*.pdf`) 제공.
- **스케줄러**: `@EnableScheduling` + `@Scheduled`로 월별 청구 생성/미납 점검 로직 준비.
- **리포지토리**: Spring Data JPA 쿼리 메서드 적극 활용(예: `findByPropertyIdAndRentStatusIsFalse`).

## ⚠️ 즉시 개선 권장 (Must-Fix)
1) **JPA 기본키 정의 확인**  
   - `BaseEntity`에 `@Id @GeneratedValue(strategy = IDENTITY) Long id` 등 **PK 컬럼 선언이 명시적으로 있어야** 합니다. 현재 소스에 `...`가 포함되어 있어 누락 위험이 있습니다.
2) **프로파일별 JPA Dialect 충돌**  
   - `application-prd.properties`에 `spring.jpa.database-platform=org.hibernate.community.dialect.SQLiteDialect`와 `hibernate.dialect=PostgreSQLDialect`가 **동시에 설정**되어 있습니다.  
   - 프로파일별로 **하나만** 맞게 설정하세요. 예:
     - `local/dev`: `H2Dialect` (또는 SQLite를 쓸 경우 SQLiteDialect 하나만)
     - `prd`: `PostgreSQLDialect` (Postgres만 사용)
3) **보안/인증 중복 처리**  
   - `WebSecurityConfig`(Spring Security)와 `LoginInterceptor`가 모두 인증/세션 관련 로직을 다룹니다. 책임을 분리하거나 Interceptor는 **뷰 모델 보강** 정도로 축소하세요.
4) **로깅 레벨**  
   - `prd`에서 `org.springframework.security=DEBUG`, `data.jpa=DEBUG`는 과도합니다. 운영은 `INFO`(필요시 `WARN`) 권장.
5) **트랜잭션 경계**  
   - 쓰기 작업이 있는 서비스들에 `@Transactional` 명시가 드뭅니다. `*ServiceImpl`(save/update/delete) 메서드/클래스에 적용하세요.
6) **검증 & 예외 처리**  
   - DTO/엔티티에 `@NotNull`, `@Size`, `@Email` 등 Bean Validation 추가.  
   - 전역 예외 처리 `@ControllerAdvice`로 표준 에러 응답/뷰 정리.
7) **청구 중복 방지 보강**  
   - 월별 생성 시 `existsByLeaseAndDueDateBetween`를 통한 **중복 생성 방지**가 필요합니다(유니크 인덱스 권장: `billing(lease_id, year_month)` 등).

## ✅ 구조/설계 개선 (Should)
- **패키징 정리**: `service` 인터페이스 위치(`renthouse/service/`) vs 구현(`module/*/service/impl`)을 일관화.
- **도메인 용어 정밀화**: `Bill(BillingItem Type)`, `Billing(청구서)` 의미 구분은 좋으나, 네이밍 규칙을 README에 명시.
- **REST 경로 정리**: MVC(뷰) 컨트롤러는 `/view/**`, API는 `/api/**`로 분리. 현재 `/member` 등 혼재.
- **지연 로딩 최적화**: 템플릿에서 관계 접근 시 N+1 이슈 주의. 조회 전용은 **프로젝션/DTO 쿼리** 사용.
- **마이그레이션 도구**: `Flyway`/`Liquibase`로 스키마 버전 관리, `ddl-auto=validate` 권장.
- **테스트**: 서비스/리포지토리 단위 테스트와 통합 테스트(Profiles 분리) 추가.

## 🔧 예시 수정 스니펫

### 1) BaseEntity
```java
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @CreatedBy
    private String createdBy;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdDate;

    @LastModifiedBy
    private String lastModifiedBy;

    @LastModifiedDate
    @Column(nullable = false)
    private LocalDateTime lastModifiedDate;
}}
```

### 2) 프로파일별 JPA 설정 (예시)
```properties
# application-local.properties (H2)
spring.datasource.url=jdbc:h2:mem:renthouse;MODE=PostgreSQL;DB_CLOSE_DELAY=-1
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update

# application-prd.properties (PostgreSQL)
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=validate
```

### 3) 전역 예외 처리 뼈대
```java
@RestControllerAdvice
public class GlobalExceptionHandler {{
  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<Map<String, Object>> handleValidation(MethodArgumentNotValidException ex) {{
    Map<String, Object> body = Map.of(
      "error", "VALIDATION_FAILED",
      "details", ex.getBindingResult().getFieldErrors().stream()
                   .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
                   .toList()
    );
    return ResponseEntity.badRequest().body(body);
  }}
}}
```

### 4) 중복 청구 방지용 유니크 인덱스 (예시)
```java
@Entity
@Table(name = "billing",
       uniqueConstraints = @UniqueConstraint(columnNames = {{"lease_id", "year_month"}}))
public class Billing {{ ... }}
```

## 🔚 마무리
이 요약은 업로드된 소스를 기준으로 작성했습니다(일부 파일에 `...` 포함). 상세 리팩토링/패치가 필요하면 해당 클래스 단위로 같이 진행하겠습니다.
