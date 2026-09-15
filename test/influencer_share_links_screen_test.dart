import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_api_entity.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/repo/influencer_dashboard_repository.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/usecase/get_influencer_home_usecase.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/usecase/get_influencer_links_usecase.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/manager/influencer_dashboard_view_model.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/screens/influencer_share_links_screen.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/entities/influencer_social_links_entity.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/repo/influencer_social_links_repository.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/usecase/get_influencer_social_profile_usecase.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/usecase/update_influencer_social_links_usecase.dart';
import 'package:meal_meat_user/features/influencer/social_links/presentation/manager/influencer_social_links_view_model.dart';
import 'package:meal_meat_user/features/influencer/social_links/presentation/widgets/influencer_social_title_section.dart';

void main() {
  setUp(() {
    final repository = _DashboardRepository();
    final socialRepository = _SocialLinksRepository();
    getIt.registerFactory(
      () => InfluencerDashboardViewModel(
        GetInfluencerHomeUseCase(repository),
        GetInfluencerLinksUseCase(repository),
      ),
    );
    getIt.registerFactory(
      () => InfluencerSocialLinksViewModel(
        GetInfluencerSocialProfileUseCase(socialRepository),
        UpdateInfluencerSocialLinksUseCase(socialRepository),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('social accounts button opens the social connections page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          AppRoutes.influencerSocialConnections: (_) => const Scaffold(
            body: SizedBox(key: ValueKey('social-connections-page')),
          ),
        },
        home: const Scaffold(
          body: InfluencerShareLinksScreen(showScaffold: false),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppButton), findsOneWidget);
    expect(find.text('تعديل حسابات التواصل'), findsOneWidget);
    expect(find.text('تيك توك'), findsOneWidget);
    final socialSection = find.byType(InfluencerSocialTitleSection);
    expect(
      find.descendant(of: socialSection, matching: find.text('شارك الآن')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: socialSection,
        matching: find.text('شارك بسهولة عبر منصات التواصل'),
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byType(AppButton));
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('social-connections-page')),
      findsOneWidget,
    );
  });
}

class _SocialLinksRepository implements InfluencerSocialLinksRepository {
  @override
  Future<ApiResult<InfluencerSocialProfileEntity>> getProfile() async {
    return ApiSuccessResult(data: _socialProfile);
  }

  @override
  Future<ApiResult<InfluencerSocialLinksEntity>> updateSocialLinks(
    InfluencerSocialLinksEntity links,
  ) async {
    return ApiSuccessResult(data: links);
  }
}

class _DashboardRepository implements InfluencerDashboardRepository {
  @override
  Future<ApiResult<InfluencerLinksEntity>> getLinks() async {
    return ApiSuccessResult(
      data: InfluencerLinksEntity(
        influencerCode: 'YA6B96',
        referralLink: 'https://mealmate.com/ref/YA6B96',
        qrCodeData: 'https://mealmate.com/ref/YA6B96',
        kpis: _kpis,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _kpis = InfluencerDashboardKpisEntity(
  registeredCustomers: 0,
  completedSubscriptions: 0,
  linkClicks: 0,
  conversionRate: 0,
  registeredCustomersDiff: 0,
  completedSubscriptionsDiff: 0,
  linkClicksDiff: 0,
  conversionRateDiff: 0,
);

const _socialProfile = InfluencerSocialProfileEntity(
  id: 'profile-id',
  displayName: 'Yahya',
  code: 'YA6B96',
  commissionRate: 10,
  status: 'active',
  isActive: true,
  hasCompletedSocialOnboarding: true,
  links: InfluencerSocialLinksEntity(tiktok: 'saved_tiktok'),
);
