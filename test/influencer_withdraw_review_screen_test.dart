import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/influencer/presentation/screens/influencer_withdraw_review_screen.dart';

void main() {
  testWidgets(
    'influencer withdraw review screen renders Figma 2300:9338 components (Arabic)',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            AppRoutes.influencerWallet: (_) =>
                const Scaffold(body: Text('wallet route')),
          },
          home: const InfluencerWithdrawReviewScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Top Bar (without notification icon, with back button and avatar)
      expect(find.textContaining('مرحباً'), findsOneWidget);
      expect(find.text('Influencer Partner'), findsOneWidget);

      // Title Block
      expect(find.text('مراجعة طلب السحب'), findsOneWidget);
      expect(find.text('راجع بيانات الطلب قبل تأكيد السحب'), findsOneWidget);

      // Hero Amount Card
      expect(find.text('845.000'), findsOneWidget);

      // Transfer Details Card
      expect(find.text('بيانات التحويل'), findsOneWidget);
      expect(find.text('طريقة السحب'), findsOneWidget);
      expect(find.text('تحويل بنكي'), findsOneWidget);
      expect(find.text('بنك الكويت الوطني'), findsOneWidget);
      expect(find.text('محمد أحمد'), findsOneWidget);
      expect(find.text('رقم الحساب'), findsOneWidget);
      expect(find.text('**** **** **** 1234'), findsOneWidget);

      // Summary Card
      expect(find.text('ملخص العملية'), findsOneWidget);
      expect(find.text('المبلغ المطلوب سحبه'), findsOneWidget);
      expect(find.text('رسوم التحويل'), findsOneWidget);
      expect(find.text('0.000 KWD'), findsOneWidget);
      expect(find.text('المبلغ النهائي المستلم'), findsOneWidget);

      // Note Card
      expect(find.text('معلومة هامة'), findsOneWidget);

      // Action Buttons
      expect(find.text('تأكيد طلب السحب'), findsOneWidget);
      expect(find.text('رجوع'), findsOneWidget);
    },
  );

  testWidgets(
    'influencer withdraw review screen renders components in English locale',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            AppRoutes.influencerWallet: (_) =>
                const Scaffold(body: Text('wallet route')),
          },
          home: const InfluencerWithdrawReviewScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Review withdrawal request'), findsOneWidget);
      expect(
        find.text('Review your request details before confirming'),
        findsOneWidget,
      );
      expect(find.text('Transfer Details'), findsOneWidget);
      expect(find.text('Bank Transfer'), findsOneWidget);
      expect(find.text('Operation Summary'), findsOneWidget);
      expect(find.text('Confirm withdrawal request'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
    },
  );
}
