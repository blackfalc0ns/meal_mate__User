import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_checkout/data/mapper/family_checkout_mapper.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_view_model.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_member_restaurants.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_member_restaurants_card.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_restaurant_repetition_banner.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class _FakeFamilyCheckoutViewModel extends Cubit<FamilyCheckoutState>
    implements FamilyCheckoutViewModel {
  _FakeFamilyCheckoutViewModel(super.initialState);

  @override
  String get correlationId => 'test-correlation-id';

  @override
  void doIntent(dynamic intent) {}
}

Widget _wrapTestWidget(Widget child, {Locale locale = const Locale('ar')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('Family Summary Restaurants Mapping and DTO Tests', () {
    test(
      'FamilyMemberScheduleDto parses restaurants and restaurantRepetition',
      () {
        final json = {
          'memberId': 'mem-101',
          'mealsPerDay': 2,
          'totalMeals': 40,
          'deliveryDaysCount': 20,
          'restaurants': [
            {
              'restaurantId': 'res-1',
              'name': 'Diet Center',
              'nameAr': 'دايت سنتر',
              'logoUrl': 'https://example.com/logo1.png',
              'occurrenceCount': 3,
            },
            {
              'restaurantId': 'res-2',
              'name': 'Healthy Choice',
              'nameAr': 'خيار صحي',
              'logoUrl': null,
              'occurrenceCount': 1,
            },
          ],
          'restaurantRepetition': {'limit': 5, 'restaurantCount': 2},
        };

        final dto = FamilyMemberScheduleDto.fromJson(json);
        expect(dto.memberId, 'mem-101');
        expect(dto.restaurants?.length, 2);
        expect(dto.restaurants?.first.restaurantId, 'res-1');
        expect(dto.restaurants?.first.name, 'Diet Center');
        expect(dto.restaurants?.first.nameAr, 'دايت سنتر');
        expect(dto.restaurants?.first.logoUrl, 'https://example.com/logo1.png');
        expect(dto.restaurants?.first.occurrenceCount, 3);
        expect(dto.restaurantRepetition?.limit, 5);
        expect(dto.restaurantRepetition?.restaurantCount, 2);

        final entity = dto.toEntity();
        expect(entity.memberId, 'mem-101');
        expect(entity.restaurants.length, 2);
        expect(entity.restaurants[0].restaurantId, 'res-1');
        expect(entity.restaurants[0].displayName('ar'), 'دايت سنتر');
        expect(entity.restaurants[0].displayName('en'), 'Diet Center');
        expect(entity.restaurants[0].occurrenceCount, 3);
        expect(entity.restaurantRepetition?.limit, 5);
        expect(entity.restaurantRepetition?.restaurantCount, 2);
      },
    );

    test('FamilyMemberScheduleDto supports legacy string restaurant list', () {
      final json = {
        'memberId': 'mem-102',
        'restaurants': ['Diet Kitchen', 'Green Salad'],
      };

      final dto = FamilyMemberScheduleDto.fromJson(json);
      expect(dto.restaurants?.length, 2);
      expect(dto.restaurants?.first.name, 'Diet Kitchen');

      final entity = dto.toEntity();
      expect(entity.restaurants.length, 2);
      expect(entity.restaurants[0].name, 'Diet Kitchen');
    });
  });

  group('FamilyMemberRestaurants Widget Tests', () {
    testWidgets('Renders empty state when restaurants list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapTestWidget(const FamilyMemberRestaurants(restaurants: [])),
      );
      await tester.pumpAndSettle();

      expect(find.text('لا توجد مطاعم متاحة لهذا الفرد'), findsOneWidget);
    });

    testWidgets(
      'Renders circular logo keys and accessibility semantics for each restaurant',
      (tester) async {
        const restaurants = [
          FamilyMemberRestaurantEntity(
            restaurantId: 'rest-1',
            name: 'Healthy Express',
            nameAr: 'هيلثي إكسبريس',
            logoUrl: '',
            occurrenceCount: 2,
          ),
          FamilyMemberRestaurantEntity(
            restaurantId: 'rest-2',
            name: 'Fit Food',
            nameAr: 'فيت فود',
            logoUrl: 'https://example.com/fit.png',
            occurrenceCount: 1,
          ),
        ];

        await tester.pumpWidget(
          _wrapTestWidget(
            const FamilyMemberRestaurants(restaurants: restaurants),
          ),
        );
        await tester.pump();

        expect(find.byKey(const ValueKey('restaurant-rest-1')), findsOneWidget);
        expect(find.byKey(const ValueKey('restaurant-rest-2')), findsOneWidget);

        // Verify no visible text of the restaurant name exists (only logos)
        expect(find.text('هيلثي إكسبريس'), findsNothing);
        expect(find.text('Healthy Express'), findsNothing);
      },
    );
  });

  group('FamilyRestaurantRepetitionBanner Tests', () {
    testWidgets('Renders repetition message with durationDays', (tester) async {
      await tester.pumpWidget(
        _wrapTestWidget(
          const FamilyRestaurantRepetitionBanner(limit: 3, durationDays: 20),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تكرار المطاعم'), findsOneWidget);
      expect(
        find.text('يمكن تكرار المطعم حتى 3 مرات خلال 20 يومًا'),
        findsOneWidget,
      );
    });

    testWidgets('Renders summary repetition when durationDays is 0', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapTestWidget(
          const FamilyRestaurantRepetitionBanner(limit: 4, durationDays: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تكرار المطاعم'), findsOneWidget);
      expect(
        find.text('الحد الأقصى لتكرار أي مطعم هو 4 مرات خلال فترة الاشتراك'),
        findsOneWidget,
      );
    });
  });

  group('FamilyMemberRestaurantsCard BlocSelector Tests', () {
    testWidgets(
      'Binds to active member schedule and updates when member switches',
      (tester) async {
        const scheduleMember1 = FamilyMemberScheduleEntity(
          memberId: 'm-1',
          deliveryDaysCount: 20,
          restaurants: [
            FamilyMemberRestaurantEntity(
              restaurantId: 'r-1',
              name: 'Keto Kitchen',
              nameAr: 'كيتو كيتشن',
              occurrenceCount: 2,
            ),
          ],
          restaurantRepetition: FamilyMemberRestaurantRepetitionEntity(
            limit: 3,
            restaurantCount: 1,
          ),
        );

        const scheduleMember2 = FamilyMemberScheduleEntity(
          memberId: 'm-2',
          deliveryDaysCount: 15,
          restaurants: [
            FamilyMemberRestaurantEntity(
              restaurantId: 'r-2',
              name: 'Vegan House',
              nameAr: 'فيجان هاوس',
              occurrenceCount: 1,
            ),
          ],
          restaurantRepetition: FamilyMemberRestaurantRepetitionEntity(
            limit: 2,
            restaurantCount: 1,
          ),
        );

        const summary = FamilySummaryEntity(
          subtotal: 100,
          familyDiscountPercent: 0,
          familyDiscountAmount: 0,
          finalPrice: 100,
          canCheckout: true,
          members: [
            FamilySummaryMemberEntity(
              memberId: 'm-1',
              displayName: 'Member One',
            ),
            FamilySummaryMemberEntity(
              memberId: 'm-2',
              displayName: 'Member Two',
            ),
          ],
          memberSchedules: [scheduleMember1, scheduleMember2],
          selectedMemberId: 'm-1',
        );

        final flowMembers = [
          const FamilyMemberEntity(
            memberId: 'm-1',
            displayName: 'Member One',
            role: 1,
            relationshipCode: 'SELF',
            gender: 1,
            ageYears: 30,
            setupStatus: 2,
            includeFriday: false,
            subscribeNow: true,
            isCurrentUser: true,
          ),
          const FamilyMemberEntity(
            memberId: 'm-2',
            displayName: 'Member Two',
            role: 2,
            relationshipCode: 'CHILD',
            gender: 1,
            ageYears: 10,
            setupStatus: 2,
            includeFriday: false,
            subscribeNow: true,
            isCurrentUser: false,
          ),
        ];

        final initialState = FamilyCheckoutState(
          summary: summary,
          currentFlow: FamilyFlowCurrentEntity(members: flowMembers),
          selectedSummaryMemberId: 'm-1',
        );

        final vm = _FakeFamilyCheckoutViewModel(initialState);

        await tester.pumpWidget(
          BlocProvider<FamilyCheckoutViewModel>.value(
            value: vm,
            child: _wrapTestWidget(const FamilyMemberRestaurantsCard()),
          ),
        );
        await tester.pumpAndSettle();

        // Check Member 1 restaurants are shown
        expect(find.byKey(const ValueKey('restaurant-r-1')), findsOneWidget);
        expect(find.byKey(const ValueKey('restaurant-r-2')), findsNothing);
        expect(
          find.text('يمكن تكرار المطعم حتى 3 مرات خلال 20 يومًا'),
          findsOneWidget,
        );

        // Now switch active member to Member 2
        vm.emit(initialState.copyWith(selectedSummaryMemberId: 'm-2'));
        await tester.pumpAndSettle();

        // Member 2 restaurants should now be shown
        expect(find.byKey(const ValueKey('restaurant-r-1')), findsNothing);
        expect(find.byKey(const ValueKey('restaurant-r-2')), findsOneWidget);
        expect(
          find.text('يمكن تكرار المطعم حتى 2 مرات خلال 15 يومًا'),
          findsOneWidget,
        );
      },
    );
  });

  group('FamilyPaymentSetupScreen Loading & Animation Integration Tests', () {
    test(
      'Uses shimmer FamilyPaymentSetupLoadingSkeleton during initial summary loading',
      () {
        final screenSource = File(
          'lib/features/family_checkout/presentation/screens/'
          'family_payment_setup_screen.dart',
        ).readAsStringSync();

        expect(
          screenSource,
          contains('if (state.isSummaryLoading && state.summary == null)'),
        );
        expect(
          screenSource,
          contains('return const FamilyPaymentSetupLoadingSkeleton();'),
        );
      },
    );

    test(
      'Uses CustomProgressIndicator during request loading (checkout or retry)',
      () {
        final screenSource = File(
          'lib/features/family_checkout/presentation/screens/'
          'family_payment_setup_screen.dart',
        ).readAsStringSync();

        expect(
          screenSource,
          contains('if (state.isCheckoutLoading || state.isRetryLoading)'),
        );
        expect(screenSource, contains('child: const Center('));
        expect(screenSource, contains('child: CustomProgressIndicator()'));
      },
    );

    test(
      'Uses flutter_animate on FamilyMemberRestaurantsCard for entrance animation',
      () {
        final cardSource = File(
          'lib/features/family_checkout/presentation/widgets/'
          'family_member_restaurants_card.dart',
        ).readAsStringSync();

        expect(
          cardSource,
          contains("import 'package:flutter_animate/flutter_animate.dart';"),
        );
        expect(cardSource, contains('.animate()'));
        expect(cardSource, contains('.fadeIn('));
        expect(cardSource, contains('.slideY('));
      },
    );
  });
}
