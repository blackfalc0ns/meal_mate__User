import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_summary/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_summary/data/models/request/family_checkout_selection_request_dto.dart';
import 'package:meal_meat_user/features/family_summary/data/models/response/family_checkout_selection_response_dto.dart';
import 'package:meal_meat_user/features/family_summary/data/mapper/family_summary_mapper.dart';
import 'package:meal_meat_user/features/family_summary/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_blocker_destination.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_dietary_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';
import 'package:meal_meat_user/features/family_summary/data/models/request/family_renewal_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_contract_constants.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_subscription_schedule_section.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_delivery_address_section.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meals_table.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class _FakeFamilyCheckoutViewModel extends Cubit<FamilyCheckoutState>
    implements FamilyCheckoutViewModel {
  _FakeFamilyCheckoutViewModel(super.initialState);

  @override
  String get correlationId => 'mock-corr-id';

  @override
  void doIntent(FamilyCheckoutEvent event) {}
}

void main() {
  group('Family Checkout Contract Tests', () {
    test(
      'FamilyCheckoutRequestDto serializes contract version and idempotency key',
      () {
        const dto = FamilyCheckoutRequestDto(
          callbackUrl: 'mealmate://checkout/success',
          errorUrl: 'mealmate://checkout/error',
          correlationId: 'corr-123',
          paymentMethodId: 4,
          idempotencyKey: 'idemp-xyz',
          batchId: 'batch-999',
          batchVersion: 3,
          clientContractVersion: 1,
        );

        final json = dto.toJson();
        expect(json['clientContractVersion'], 1);
        expect(json['idempotencyKey'], 'idemp-xyz');
        expect(json['batchId'], 'batch-999');
        expect(json['batchVersion'], 3);
        expect(json['paymentMethodId'], 4);
      },
    );

    test('FamilyCheckoutSelectionRequestDto serializes subscribeNow', () {
      const req = FamilyCheckoutSelectionRequestDto(subscribeNow: true);
      expect(req.toJson(), {'subscribeNow': true});
    });

    test('FamilyCheckoutSelectionResponseDto maps correctly to entity', () {
      final dto = FamilyCheckoutSelectionResponseDto.fromJson({
        'batchId': 'batch-01',
        'batchVersion': 5,
        'memberId': 'mem-01',
        'checkoutSelected': true,
        'selectedNewSubscriberCount': 2,
      });

      final entity = dto.toEntity();
      expect(entity.batchId, 'batch-01');
      expect(entity.batchVersion, 5);
      expect(entity.memberId, 'mem-01');
      expect(entity.checkoutSelected, isTrue);
      expect(entity.selectedNewSubscriberCount, 2);
    });

    test(
      'FamilyCheckoutSelectionResponseDto parses alternative keys and loose types to entity',
      () {
        final dto = FamilyCheckoutSelectionResponseDto.fromJson({
          'batchId': 'batch-alt',
          'batchVersion': '4',
          'id': 'alt-mem-01',
          'subscribeNow': true,
          'selectedNewSubscriberCount': '3',
        });

        final entity = dto.toEntity();
        expect(entity.batchId, 'batch-alt');
        expect(entity.batchVersion, 4);
        expect(entity.memberId, 'alt-mem-01');
        expect(entity.checkoutSelected, isTrue);
        expect(entity.selectedNewSubscriberCount, 3);
      },
    );

    test(
      'FamilySummary invoice scope uses selectedNewSubscriberCount over rosterCount',
      () {
        final dto = FamilySummaryResponseDto.fromJson({
          'subtotal': 120.0,
          'familyDiscountPercent': 0.1,
          'familyDiscountAmount': 12.0,
          'finalPrice': 108.0,
          'canCheckout': true,
          'newMembersCount': 3,
          'rosterCount': 5,
          'selectedNewSubscriberCount': 2,
          'batchId': 'batch-77',
          'batchVersion': 2,
        });

        final entity = dto.toEntity();
        expect(entity.rosterCount, 5);
        expect(entity.selectedNewSubscriberCount, 2);
        expect(entity.invoiceSubscribersCount, 2);
        expect(entity.canCheckout, isTrue);
      },
    );

    test('FamilySummary canCheckout is false when blocker is present', () {
      const entity = FamilySummaryEntity(
        subtotal: 100,
        familyDiscountPercent: 0,
        familyDiscountAmount: 0,
        finalPrice: 100,
        canCheckout: false,
        checkoutBlockReason: 'family.member_account_required',
        rosterCount: 3,
        selectedNewSubscriberCount: 0,
      );

      expect(entity.canCheckout, isFalse);
      expect(entity.checkoutBlockReason, 'family.member_account_required');
    });

    test(
      'UpdateMemberStartDateEvent holds memberId and formatted startDate',
      () {
        const event = UpdateMemberStartDateEvent(
          memberId: 'mem-10',
          startDate: '2026-09-23',
        );
        expect(event.memberId, 'mem-10');
        expect(event.startDate, '2026-09-23');
      },
    );

    test(
      'Allergies payload serializes selectedCodes and defaults to NONE when empty',
      () {
        const emptyDto = FamilyMemberAllergiesRequestDto(selectedCodes: []);
        final emptyJson = emptyDto.toJson();
        expect(emptyJson, {
          'selectedCodes': ['NONE'],
        });
        expect(emptyJson.length, 1);

        const codesDto = FamilyMemberAllergiesRequestDto(
          selectedCodes: ['MILK', 'EGG'],
        );
        final codesJson = codesDto.toJson();
        expect(codesJson, {
          'selectedCodes': ['MILK', 'EGG'],
        });
        expect(codesJson.length, 1);
      },
    );

    test(
      'Disliked ingredients payload serializes ingredientCodes and defaults to NONE when empty',
      () {
        const emptyDto = FoodPreferencesDislikedIngredientsRequestDto(
          ingredientCodes: [],
        );
        final emptyJson = emptyDto.toJson();
        expect(emptyJson['ingredientCodes'], isEmpty);
        expect(emptyJson['eatsEverything'], true);

        const codesDto = FoodPreferencesDislikedIngredientsRequestDto(
          ingredientCodes: ['INGREDIENT:guid-1'],
        );
        final codesJson = codesDto.toJson();
        expect(codesJson['ingredientCodes'], ['INGREDIENT:guid-1']);
        expect(codesJson['eatsEverything'], false);
      },
    );

    test(
      'Dietary preferences payload serializes dietaryPreferenceCodes and defaults to NONE when empty',
      () {
        const emptyDto = FoodPreferencesDietaryRequestDto(
          dietaryPreferenceCodes: [],
        );
        final emptyJson = emptyDto.toJson();
        expect(emptyJson, {
          'dietaryPreferenceCodes': ['NO_DIETARY_RESTRICTIONS'],
        });
        expect(emptyJson.length, 1);

        const codesDto = FoodPreferencesDietaryRequestDto(
          dietaryPreferenceCodes: ['KETO'],
        );
        final codesJson = codesDto.toJson();
        expect(codesJson, {
          'dietaryPreferenceCodes': ['KETO'],
        });
        expect(codesJson.length, 1);
      },
    );

    test(
      'FamilySummary maps participantCount and memberSchedules accurately',
      () {
        final dto = FamilySummaryResponseDto.fromJson({
          'subtotal': 120.0,
          'familyDiscountPercent': 0.1,
          'familyDiscountAmount': 12.0,
          'finalPrice': 108.0,
          'canCheckout': true,
          'rosterCount': 3,
          'participantCount': 2,
          'memberSchedules': [
            {
              'memberId': 'mem-1',
              'paymentDate': '2026-10-15',
              'firstDeliveryDate': '2026-10-20',
              'endDate': '2026-11-15',
              'deliveryDaysCount': 20,
              'mealsPerDay': 2,
              'totalMeals': 40,
              'restaurants': ['Diet Kitchen', 'Healthy Corner'],
            },
          ],
        });

        final entity = dto.toEntity();
        expect(entity.participantCount, 2);
        expect(entity.invoiceSubscribersCount, 2);
        expect(entity.memberSchedules.length, 1);

        final schedule = entity.memberSchedules.first;
        expect(schedule.memberId, 'mem-1');
        expect(schedule.paymentDate, '2026-10-15');
        expect(schedule.firstDeliveryDate, '2026-10-20');
        expect(schedule.endDate, '2026-11-15');
        expect(schedule.deliveryDaysCount, 20);
        expect(schedule.mealsPerDay, 2);
        expect(schedule.totalMeals, 40);
        expect(schedule.restaurants.map((r) => r.name).toList(), [
          'Diet Kitchen',
          'Healthy Corner',
        ]);
      },
    );

    test('familyCheckoutBlockerRoute maps all required blocker reasons', () {
      expect(
        familyCheckoutBlockerRoute('family.min_members'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.manager_subscription_required'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.max_members'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.start_date_required'),
        AppRoutes.familyPackageDaysSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.address_required'),
        AppRoutes.familyAddresses,
      );
      expect(
        familyCheckoutBlockerRoute('family.allergies_required'),
        AppRoutes.familyAllergies,
      );
      expect(
        familyCheckoutBlockerRoute('family.plan_incomplete'),
        AppRoutes.familyPackageDaysSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.program_required'),
        AppRoutes.familyProgramSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.already_in_family'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.duplicate_member'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.cannot_remove_manager'),
        AppRoutes.familySubscriptionSetup,
      );
      expect(
        familyCheckoutBlockerRoute('restaurant.not_eligible'),
        AppRoutes.familyProgramSetup,
      );
      expect(
        familyCheckoutBlockerRoute('family.checkout_no_selection'),
        isNull,
      );
      expect(familyCheckoutBlockerRoute('family.quote_changed'), isNull);
    });

    test(
      'SubscriptionErrorCodes defines checkout blockers and review codes',
      () {
        expect(
          SubscriptionErrorCodes.familyBatchReviewRequired,
          'family.batch_review_required',
        );
        expect(
          SubscriptionErrorCodes.familyCheckoutPending,
          'family.checkout_pending',
        );
        expect(SubscriptionErrorCodes.familyBatchClosed, 'family.batch_closed');
        expect(
          SubscriptionErrorCodes.familyStartDateRequired,
          'family.start_date_required',
        );
        expect(
          SubscriptionErrorCodes.familyAllergiesRequired,
          'family.allergies_required',
        );
        expect(SubscriptionErrorCodes.familyMinMembers, 'family.min_members');
        expect(
          SubscriptionErrorCodes.familyManagerSubscriptionRequired,
          'family.manager_subscription_required',
        );
        expect(
          SubscriptionErrorCodes.familyProgramRequired,
          'family.program_required',
        );
        expect(
          SubscriptionErrorCodes.familyDuplicateMember,
          'family.duplicate_member',
        );
        expect(
          SubscriptionErrorCodes.noPreparedRestaurantsBare,
          'no_prepared_restaurants',
        );
      },
    );

    testWidgets('mapFailureMessage maps known codes and fallback for unknown', (
      tester,
    ) async {
      late BuildContext testContext;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (ctx) {
              testContext = ctx;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(
        mapFailureMessage(
          testContext,
          SubscriptionErrorCodes.familyQuoteChanged,
        ),
        isNotEmpty,
      );
      expect(
        mapFailureMessage(testContext, 'completely_unknown_backend_code_123'),
        isNot('completely_unknown_backend_code_123'),
      );
    });

    test(
      'FamilyCheckoutContractConstants defaults are serialized in requests',
      () {
        const renewalDto = FamilyRenewalCheckoutRequestDto(
          startDate: '2026-11-01',
          addressId: 'addr-1',
          callbackUrl:
              FamilyCheckoutContractConstants.defaultSuccessCallbackUrl,
          errorUrl: FamilyCheckoutContractConstants.defaultErrorCallbackUrl,
        );
        final renewalJson = renewalDto.toJson();
        expect(
          renewalJson['clientContractVersion'],
          FamilyCheckoutContractConstants.clientContractVersion,
        );
        expect(
          renewalJson['paymentMethodId'],
          FamilyCheckoutContractConstants.defaultRenewalPaymentMethodId,
        );
        expect(
          renewalJson['callbackUrl'],
          FamilyCheckoutContractConstants.defaultSuccessCallbackUrl,
        );
        expect(
          renewalJson['errorUrl'],
          FamilyCheckoutContractConstants.defaultErrorCallbackUrl,
        );

        const checkoutDto = FamilyCheckoutRequestDto(
          callbackUrl:
              FamilyCheckoutContractConstants.defaultSuccessCallbackUrl,
          errorUrl: FamilyCheckoutContractConstants.defaultErrorCallbackUrl,
        );
        final checkoutJson = checkoutDto.toJson();
        expect(
          checkoutJson['clientContractVersion'],
          FamilyCheckoutContractConstants.clientContractVersion,
        );
      },
    );

    test(
      'FamilySummaryResponseDto with null currencyCode maps to null instead of hardcoded KWD',
      () {
        const dto = FamilySummaryResponseDto(
          subtotal: 50.0,
          finalPrice: 50.0,
          currencyCode: null,
        );
        final entity = dto.toEntity();
        expect(entity.currencyCode, isNull);
      },
    );

    testWidgets(
      'FamilyPaymentScheduleSection renders placeholder when dates and duration are missing',
      (tester) async {
        final vm = _FakeFamilyCheckoutViewModel(
          const FamilyCheckoutState(
            summary: FamilySummaryEntity(
              subtotal: 50,
              familyDiscountPercent: 0,
              familyDiscountAmount: 0,
              finalPrice: 50,
              canCheckout: true,
            ),
            selectedSummaryMemberId: 'm-1',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: BlocProvider<FamilyCheckoutViewModel>.value(
                value: vm,
                child: FamilySubscriptionScheduleSection(state: vm.state),
              ),
            ),
          ),
        );

        // Start date and end date should display '--' when missing from response, rather than fabricated today + 2 or 20 days
        expect(find.text('--'), findsNWidgets(2));
      },
    );

    testWidgets(
      'FamilyMealsTable respects inherited Directionality in both RTL and LTR',
      (tester) async {
        const member = FamilyPlanMemberUiModel(
          name: 'Ahmed',
          imageAsset: '',
          mealChecks: [true, false, true, false],
          mealsCount: '2',
        );

        Widget buildWithDirection(TextDirection direction, Locale locale) {
          return MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Directionality(
              textDirection: direction,
              child: const Scaffold(body: FamilyMealsTable(members: [member])),
            ),
          );
        }

        // Test RTL
        await tester.pumpWidget(
          buildWithDirection(TextDirection.rtl, const Locale('ar')),
        );
        await tester.pumpAndSettle();
        final l10nRtl = AppLocalizations.of(
          tester.element(find.byType(FamilyMealsTable)),
        )!;
        final memberHeaderRtl = tester.getTopLeft(
          find.text(l10nRtl.family_table_member),
        );
        final countHeaderRtl = tester.getTopLeft(
          find.text(l10nRtl.family_table_meals_count),
        );
        expect(memberHeaderRtl.dx, greaterThan(countHeaderRtl.dx));

        // Test LTR
        await tester.pumpWidget(
          buildWithDirection(TextDirection.ltr, const Locale('en')),
        );
        await tester.pumpAndSettle();
        final l10nLtr = AppLocalizations.of(
          tester.element(find.byType(FamilyMealsTable)),
        )!;
        final memberHeaderLtr = tester.getTopLeft(
          find.text(l10nLtr.family_table_member),
        );
        final countHeaderLtr = tester.getTopLeft(
          find.text(l10nLtr.family_table_meals_count),
        );
        expect(memberHeaderLtr.dx, lessThan(countHeaderLtr.dx));
      },
    );

    test('FamilyMemberScheduleDto parses addressLine and maps to entity', () {
      final json = {
        'memberId': 'mem-55',
        'addressLine': 'Kuwait City, Block 3, Street 10',
      };
      final dto = FamilyMemberScheduleDto.fromJson(json);
      expect(dto.addressLine, 'Kuwait City, Block 3, Street 10');

      final entity = dto.toEntity();
      expect(entity.addressLine, 'Kuwait City, Block 3, Street 10');
    });

    testWidgets(
      'FamilyDeliveryAddressSection displays addressLine for active member and updates when member switches',
      (tester) async {
        final vm = _FakeFamilyCheckoutViewModel(
          const FamilyCheckoutState(
            summary: FamilySummaryEntity(
              subtotal: 50,
              familyDiscountPercent: 0,
              familyDiscountAmount: 0,
              finalPrice: 50,
              canCheckout: true,
              memberSchedules: [
                FamilyMemberScheduleEntity(
                  memberId: 'm-1',
                  addressLine: 'Hawally, Street 5',
                ),
                FamilyMemberScheduleEntity(
                  memberId: 'm-2',
                  addressLine: 'Salmiya, Avenue 2',
                ),
              ],
            ),
            selectedSummaryMemberId: 'm-1',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: BlocProvider<FamilyCheckoutViewModel>.value(
                value: vm,
                child: FamilyDeliveryAddressSection(state: vm.state),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Hawally, Street 5'), findsOneWidget);
        expect(find.text('Salmiya, Avenue 2'), findsNothing);

        // Switch to member 2
        vm.emit(vm.state.copyWith(selectedSummaryMemberId: 'm-2'));
        await tester.pumpAndSettle();

        expect(find.text('Salmiya, Avenue 2'), findsOneWidget);
        expect(find.text('Hawally, Street 5'), findsNothing);
      },
    );
  });
}
