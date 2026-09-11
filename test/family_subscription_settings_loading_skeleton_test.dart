import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_meals_status_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_quick_access_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_settings_loading_skeleton.dart';

void main() {
  testWidgets(
    'FamilySubscriptionSettingsLoadingSkeleton renders all section skeletons with shimmer placeholders',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: FamilySubscriptionSettingsLoadingSkeleton(),
          ),
        ),
      );

      expect(
        find.byType(FamilySubscriptionSettingsLoadingSkeleton),
        findsOneWidget,
      );
      expect(find.byType(ShimmerPlaceholder), findsWidgets);
    },
  );

  testWidgets(
    'FamilySubscriptionMealsStatusCard triggers onCompleteMealsTap when button is tapped',
    (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FamilySubscriptionMealsStatusCard(
              statuses: const [
                FamilySubscriptionMealStatusEntity(
                  memberName: 'Ali',
                  memberImageAsset: Assets.profileAvatar,
                  mealsLabel: '0/4',
                  statusLabel: 'لم يبدأ',
                  progress: 0.0,
                  status: FamilySubscriptionMealStatus.missing,
                ),
              ],
              onCompleteMealsTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      final buttonFinder = find.text('إكمال الوجبات الناقصة');
      expect(buttonFinder, findsOneWidget);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    },
  );

  testWidgets(
    'FamilySubscriptionQuickAccessSection renders meals, subscription, permissions and triggers onActionTap',
    (tester) async {
      String? tappedCode;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FamilySubscriptionQuickAccessSection(
              actions: const [
                FamilySubscriptionQuickActionEntity(
                  code: 'meals',
                  label: 'الوجبات',
                  iconAsset: Assets.familyManageMeals,
                ),
                FamilySubscriptionQuickActionEntity(
                  code: 'subscription',
                  label: 'الاشتراك',
                  iconAsset: Assets.familyManageSubscription,
                ),
                FamilySubscriptionQuickActionEntity(
                  code: 'permissions',
                  label: 'الصلاحيات',
                  iconAsset: Assets.familyManagePermissions,
                ),
              ],
              onActionTap: (action) {
                tappedCode = action.code;
              },
            ),
          ),
        ),
      );

      expect(find.text('الوجبات'), findsOneWidget);
      expect(find.text('الاشتراك'), findsOneWidget);
      expect(find.text('الصلاحيات'), findsOneWidget);

      await tester.tap(find.text('الوجبات'));
      await tester.pumpAndSettle();
      expect(tappedCode, 'meals');

      await tester.tap(find.text('الاشتراك'));
      await tester.pumpAndSettle();
      expect(tappedCode, 'subscription');

      await tester.tap(find.text('الصلاحيات'));
      await tester.pumpAndSettle();
      expect(tappedCode, 'permissions');
    },
  );
}
