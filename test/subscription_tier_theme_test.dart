import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/mapper/subscription_tier_mapper.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_entity.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/entities/subscription_tier_theme_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';

void main() {
  group('Subscription Tier Theme Resolver Tests', () {
    test(
      'resolveSubscriptionTierDesign handles null, 1, 2, 999 and supported flags',
      () {
        // null designId
        expect(
          resolveSubscriptionTierDesign(
            null,
            supportsClassic: true,
            supportsAurora: true,
          ),
          equals(SubscriptionTierDesign.current),
        );

        // designId: 1 (Classic)
        expect(
          resolveSubscriptionTierDesign(
            1,
            supportsClassic: true,
            supportsAurora: false,
          ),
          equals(SubscriptionTierDesign.classic),
        );
        expect(
          resolveSubscriptionTierDesign(
            1,
            supportsClassic: false,
            supportsAurora: true,
          ),
          equals(SubscriptionTierDesign.current),
        );

        // designId: 2 (Aurora)
        expect(
          resolveSubscriptionTierDesign(
            2,
            supportsClassic: false,
            supportsAurora: true,
          ),
          equals(SubscriptionTierDesign.aurora),
        );
        expect(
          resolveSubscriptionTierDesign(
            2,
            supportsClassic: true,
            supportsAurora: false,
          ),
          equals(SubscriptionTierDesign.current),
        );

        // unknown designId (999)
        expect(
          resolveSubscriptionTierDesign(
            999,
            supportsClassic: true,
            supportsAurora: true,
          ),
          equals(SubscriptionTierDesign.current),
        );
      },
    );

    test(
      'SubscriptionTierResponseDto deserializes theme and maps to entity',
      () {
        final json = <String, dynamic>{
          'tier': 'premium',
          'nameAr': 'المميز',
          'nameEn': 'Premium',
          'theme': {'designId': 2, 'designName': 'Aurora'},
        };

        final dto = SubscriptionTierResponseDto.fromJson(json);
        expect(dto.theme?.designId, equals(2));
        expect(dto.theme?.designName, equals('Aurora'));

        final entity = dto.toEntity();
        expect(entity.theme, isNotNull);
        expect(entity.theme?.designId, equals(2));
        expect(entity.theme?.designName, equals('Aurora'));
      },
    );

    test(
      'SubscriptionTierResponseDto handles null theme without regression',
      () {
        final json = <String, dynamic>{
          'tier': 'standard',
          'nameAr': 'الأساسي',
          'nameEn': 'Standard',
          'theme': null,
        };

        final dto = SubscriptionTierResponseDto.fromJson(json);
        expect(dto.theme, isNull);

        final entity = dto.toEntity();
        expect(entity.theme, isNull);
        expect(entity.tier, equals('standard'));
      },
    );

    test(
      'SubscriptionPlanState resolvedTierDesign enforces screen-wide consistency and fallbacks safely',
      () {
        const tierWithDesign2 = SubscriptionTierEntity(
          tier: 'plus',
          nameAr: 'بلس',
          nameEn: 'Plus',
          logoUrl: null,
          descriptionAr: '',
          descriptionEn: '',
          restaurantCount: 2,
          restaurants: [],
          currencyCode: 'KWD',
          selectionCount: 0,
          isRecommended: false,
          includeFriday: false,
          theme: SubscriptionTierThemeEntity(designId: 2, designName: 'Aurora'),
        );

        const tierWithDesign1 = SubscriptionTierEntity(
          tier: 'max',
          nameAr: 'ماكس',
          nameEn: 'Max',
          logoUrl: null,
          descriptionAr: '',
          descriptionEn: '',
          restaurantCount: 3,
          restaurants: [],
          currencyCode: 'KWD',
          selectionCount: 0,
          isRecommended: true,
          includeFriday: false,
          theme: SubscriptionTierThemeEntity(
            designId: 1,
            designName: 'Classic',
          ),
        );

        // Empty tiers -> current
        const emptyState = SubscriptionPlanState(tiers: []);
        expect(
          emptyState.resolvedTierDesign,
          equals(SubscriptionTierDesign.current),
        );

        // Aurora without Figma support -> current
        const stateAurora = SubscriptionPlanState(tiers: [tierWithDesign2]);
        expect(
          stateAurora.resolvedTierDesign,
          equals(SubscriptionTierDesign.current),
        );

        // Mismatched designs across tiers -> contract mismatch fallback to current
        const mismatchState = SubscriptionPlanState(
          tiers: [tierWithDesign2, tierWithDesign1],
        );
        expect(
          mismatchState.resolvedTierDesign,
          equals(SubscriptionTierDesign.current),
        );
      },
    );
  });
}
