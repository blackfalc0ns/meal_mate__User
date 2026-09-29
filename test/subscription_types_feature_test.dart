import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_types/domain/repo/subscription_types_repository.dart';
import 'package:meal_meat_user/features/subscription_types/domain/usecase/convert_from_individual_usecase.dart';
import 'package:meal_meat_user/features/subscription_types/domain/usecase/get_subscription_conversion_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_types/domain/usecase/get_subscription_types_usecase.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_event.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_view_model.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_type_card.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_types_action_section.dart';

class _FakeSubscriptionTypesRepository implements SubscriptionTypesRepository {
  _FakeSubscriptionTypesRepository({
    this.typesResult,
  });

  final ApiResult<List<SubscriptionTypeEntity>>? typesResult;

  @override
  Future<ApiResult<List<SubscriptionTypeEntity>>> getSubscriptionTypes() async {
    return typesResult ?? ApiSuccessResult(data: const []);
  }

  @override
  Future<ApiResult<ConversionOptionsModel>>
  getSubscriptionConversionOptions() async {
    return ApiSuccessResult(
      data: const ConversionOptionsModel(
        subscriptionId: 'sub-1',
        status: 'ACTIVE',
        options: [],
      ),
    );
  }
}

class _FakeFamilySubscriptionSetupRepository
    implements FamilySubscriptionSetupRepository {
  @override
  Future<ApiResult<FamilyFlowCurrentEntity>> convertFromIndividual({
    String? name,
    String? familyPackageId,
  }) async {
    return ApiSuccessResult(
      data: const FamilyFlowCurrentEntity(
        currentStep: 1,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildTestWidget({
    required Widget child,
    Locale locale = const Locale('ar'),
    TextDirection textDirection = TextDirection.rtl,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  const sampleType = SubscriptionTypeEntity(
    code: 'INDIVIDUAL',
    nameAr: 'اشتراك فردي',
    nameEn: 'Individual Plan',
    descriptionAr: 'وجبات يومية مخصصة لك',
    descriptionEn: 'Daily meals tailored for you',
    maxMembers: 1,
    isAvailable: true,
    membersConfiguredAfterPayment: false,
    requiresConversion: false,
    imageAsset: Assets.subscriptionTypeIndividualProduct,
  );

  group('SubscriptionTypesViewModel Draft Session', () {
    setUp(FamilyConversionDraftSession.clearConvertedFamilyDraft);

    test('getSubscriptionTypes does not mark converted family draft', () async {
      final repo = _FakeSubscriptionTypesRepository(
        typesResult: ApiSuccessResult(data: const [sampleType]),
      );
      final viewModel = SubscriptionTypesViewModel(
        GetSubscriptionTypesUseCase(repo),
        GetSubscriptionConversionOptionsUseCase(repo),
        ConvertFromIndividualUseCase(_FakeFamilySubscriptionSetupRepository()),
      );

      viewModel.doIntent(const GetSubscriptionTypesEvent());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(viewModel.state.isSuccess, isTrue);
      expect(FamilyConversionDraftSession.isConvertedFamilyDraft, isFalse);
    });

    test('convertFromIndividual marks converted family draft on success', () async {
      final repo = _FakeSubscriptionTypesRepository();
      final viewModel = SubscriptionTypesViewModel(
        GetSubscriptionTypesUseCase(repo),
        GetSubscriptionConversionOptionsUseCase(repo),
        ConvertFromIndividualUseCase(_FakeFamilySubscriptionSetupRepository()),
      );

      const option = ConversionOptionModel(
        code: 'CONVERT_TO_FAMILY_MANAGER',
        available: true,
        titleAr: 'تحويل',
        titleEn: 'Convert',
      );

      viewModel.doIntent(const SelectConversionOptionEvent(option));
      viewModel.doIntent(const ConvertFromIndividualEvent());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(viewModel.state.isConvertFromIndividualSuccess, isTrue);
      expect(FamilyConversionDraftSession.isConvertedFamilyDraft, isTrue);
    });
  });

  group('SubscriptionTypeCard Dynamic Feature List', () {
    testWidgets('renders safely with fewer than 3 features (no RangeError)', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: SubscriptionTypeCard(
            type: sampleType,
            title: 'اشتراك تجريبي',
            description: 'وصف تجريبي',
            features: const ['ميزة 1', 'ميزة 2'],
            icons: const [Icons.star, Icons.check],
            isSelected: false,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ميزة 1'), findsOneWidget);
      expect(find.text('ميزة 2'), findsOneWidget);
    });
  });

  group('SubscriptionTypesActionSection Directional Chevron', () {
    testWidgets('renders chevron_left in RTL', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          textDirection: TextDirection.rtl,
          child: SubscriptionTypesActionSection(
            selectedType: sampleType,
            isLoading: false,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
    });

    testWidgets('renders chevron_right in LTR', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          textDirection: TextDirection.ltr,
          child: SubscriptionTypesActionSection(
            selectedType: sampleType,
            isLoading: false,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });
  });
}
