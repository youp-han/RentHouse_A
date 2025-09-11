import 'package:flutter_test/flutter_test.dart';

// 도메인 모델 테스트
import 'features/property/domain/property_test.dart' as property_domain_test;
import 'features/property/domain/unit_test.dart' as unit_domain_test;
import 'features/tenant/domain/tenant_test.dart' as tenant_domain_test;
import 'features/lease/domain/lease_test.dart' as lease_domain_test;
import 'features/billing/domain/billing_test.dart' as billing_domain_test;
import 'features/billing/domain/billing_item_test.dart' as billing_item_domain_test;
import 'features/billing/domain/bill_template_test.dart' as bill_template_domain_test;

// Repository 테스트
import 'features/property/data/property_repository_test.dart' as property_repository_test;
import 'features/tenant/data/tenant_repository_test.dart' as tenant_repository_test;

// Controller 테스트
import 'features/property/application/property_controller_test.dart' as property_controller_test;
import 'features/tenant/application/tenant_controller_riverpod_test.dart' as tenant_controller_test;

// 위젯 테스트
import 'features/property/presentation/property_list_screen_test.dart' as property_list_widget_test;
import 'features/tenant/presentation/tenant_list_screen_test.dart' as tenant_list_widget_test;

// 통합 테스트
import 'integration/app_integration_test.dart' as app_integration_test;

void main() {
  group('🏠 RentHouse 전체 테스트 모음', () {
    group('📦 도메인 모델 테스트', () {
      group('Property 도메인', () {
        property_domain_test.main();
      });

      group('Unit 도메인', () {
        unit_domain_test.main();
      });

      group('Tenant 도메인', () {
        tenant_domain_test.main();
      });

      group('Lease 도메인', () {
        lease_domain_test.main();
      });

      group('Billing 도메인', () {
        billing_domain_test.main();
      });

      group('BillingItem 도메인', () {
        billing_item_domain_test.main();
      });

      group('BillTemplate 도메인', () {
        bill_template_domain_test.main();
      });
    });

    group('🗄️ Repository 테스트', () {
      group('Property Repository', () {
        property_repository_test.main();
      });

      group('Tenant Repository', () {
        tenant_repository_test.main();
      });
    });

    group('🎮 Controller 테스트', () {
      group('Property Controller', () {
        property_controller_test.main();
      });

      group('Tenant Controller', () {
        tenant_controller_test.main();
      });
    });

    group('🎨 위젯 테스트', () {
      group('Property List Widget', () {
        property_list_widget_test.main();
      });

      group('Tenant List Widget', () {
        tenant_list_widget_test.main();
      });
    });

    group('🔗 통합 테스트', () {
      group('App Integration', () {
        app_integration_test.main();
      });
    });
  });
}