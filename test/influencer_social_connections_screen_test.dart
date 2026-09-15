import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/entities/influencer_social_links_entity.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/repo/influencer_social_links_repository.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/usecase/get_influencer_social_profile_usecase.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/usecase/update_influencer_social_links_usecase.dart';
import 'package:meal_meat_user/features/influencer/social_links/presentation/manager/influencer_social_links_view_model.dart';
import 'package:meal_meat_user/features/influencer/social_links/presentation/screens/influencer_social_connections_screen.dart';

class _FakeSocialRepo implements InfluencerSocialLinksRepository {
  InfluencerSocialProfileEntity profile = const InfluencerSocialProfileEntity(
    id: 'inf_1',
    displayName: 'محمد',
    code: 'MOHAMMED20',
    commissionRate: 0.15,
    status: 'ACTIVE',
    isActive: true,
    hasCompletedSocialOnboarding: false,
    links: InfluencerSocialLinksEntity(),
  );

  @override
  Future<ApiResult<InfluencerSocialProfileEntity>> getProfile() async {
    return ApiSuccessResult(data: profile);
  }

  @override
  Future<ApiResult<InfluencerSocialLinksEntity>> updateSocialLinks(
    InfluencerSocialLinksEntity links,
  ) async {
    profile = InfluencerSocialProfileEntity(
      id: profile.id,
      displayName: profile.displayName,
      code: profile.code,
      commissionRate: profile.commissionRate,
      status: profile.status,
      isActive: profile.isActive,
      hasCompletedSocialOnboarding: true,
      links: links,
    );
    return ApiSuccessResult(data: links);
  }
}

void main() {
  late _FakeSocialRepo repo;
  InfluencerSocialLinksViewModel createViewModel() =>
      InfluencerSocialLinksViewModel(
        GetInfluencerSocialProfileUseCase(repo),
        UpdateInfluencerSocialLinksUseCase(repo),
      );

  setUp(() {
    repo = _FakeSocialRepo();
  });

  Widget buildApp({
    Locale locale = const Locale('ar'),
    InfluencerSocialLinksViewModel? vm,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: InfluencerSocialConnectionsScreen(
        showScaffold: true,
        viewModel: vm ?? createViewModel(),
      ),
    );
  }

  testWidgets('renders Figma 2300:9456 social connections screen in Arabic', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Header
    expect(find.text('مرحباً ، محمد'), findsOneWidget);
    expect(find.text('Influencer Partner'), findsOneWidget);

    // Title & Subtitle
    expect(find.text('إضافة وسائل التواصل'), findsOneWidget);
    expect(
      find.text('أضف حساباتك على وسائل التواصل لبدء الشراكة وكسب عمولات أكثر'),
      findsOneWidget,
    );

    // 6 Social Platforms
    expect(find.text('تيك توك'), findsOneWidget);
    expect(find.text('أضف حسابك على تيك توك'), findsOneWidget);

    expect(find.text('إنستغرام'), findsOneWidget);
    expect(find.text('أضف حسابك على إنستغرام'), findsOneWidget);

    expect(find.text('واتساب'), findsOneWidget);
    expect(find.text('أضف رقم واتساب للأعمال'), findsOneWidget);

    expect(find.text('تيليجرام'), findsOneWidget);
    expect(find.text('أضف حسابك على تيليجرام'), findsOneWidget);

    expect(find.text('يوتيوب'), findsOneWidget);
    expect(find.text('أضف قناتك على يوتيوب'), findsOneWidget);

    expect(find.text('سناب شات'), findsOneWidget);
    expect(find.text('أضف حسابك على سناب شات'), findsOneWidget);

    // 6 Add buttons
    expect(find.text('إضافة'), findsNWidgets(6));

    // Privacy Card
    expect(find.text('نحافظ على خصوصية بياناتك'), findsOneWidget);
    expect(
      find.text(
        'نستخدم بياناتك فقط لتحسين فرص الشراكة والتواصل مع العلامات التجارية.',
      ),
      findsOneWidget,
    );

    // Action Buttons
    expect(find.text('حفظ ومتابعة'), findsOneWidget);
    expect(find.text('تخطي الآن'), findsOneWidget);
  });

  testWidgets('allows adding account handle via input sheet', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Tap first 'إضافة' (TikTok)
    await tester.tap(find.text('إضافة').first);
    await tester.pumpAndSettle();

    // Modal sheet appears
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('تأكيد'), findsOneWidget);

    // Enter handle
    await tester.enterText(find.byType(TextFormField), '@my_tiktok_handle');
    await tester.tap(find.text('تأكيد'));
    await tester.pumpAndSettle();

    // Card should now display normalized handle and 'تعديل' button
    expect(find.text('my_tiktok_handle'), findsOneWidget);
    expect(find.text('تعديل'), findsOneWidget);
    expect(find.text('إضافة'), findsNWidgets(5));
  });

  testWidgets('renders Figma 2300:9456 social connections screen in English', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildApp(locale: const Locale('en')));
    await tester.pumpAndSettle();

    // Header
    expect(find.text('Hello, Mohammed'), findsOneWidget);
    expect(find.text('Influencer Partner'), findsOneWidget);

    // Title & Subtitle
    expect(find.text('Add social accounts'), findsOneWidget);
    expect(
      find.text(
        'Add your social accounts to start the partnership and earn more commissions',
      ),
      findsOneWidget,
    );

    // 6 Platforms in English
    expect(find.text('TikTok'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('Telegram'), findsOneWidget);
    expect(find.text('YouTube'), findsOneWidget);
    expect(find.text('Snapchat'), findsOneWidget);

    // Add buttons
    expect(find.text('Add'), findsNWidgets(6));

    // Privacy Card
    expect(find.text('We protect your data privacy'), findsOneWidget);

    // Actions
    expect(find.text('Save and continue'), findsOneWidget);
    expect(find.text('Skip now'), findsOneWidget);
  });
}
