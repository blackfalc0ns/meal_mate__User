import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/screens/influencer_withdraw_screen.dart';

void main() {
  testWidgets(
    'influencer withdraw screen renders Figma 2300:8865 components (Arabic)',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            AppRoutes.influencerWithdrawReview: (_) =>
                const Scaffold(body: Text('review route')),
          },
          home: const InfluencerWithdrawScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Top Bar
      expect(find.textContaining('محمد'), findsOneWidget);
      expect(find.text('Influencer Partner'), findsOneWidget);

      // Title Block
      expect(find.text('سحب الأرباح'), findsOneWidget);
      expect(find.text('اختر طريقة السحب وأدخل البيانات'), findsOneWidget);

      // Balance Card
      expect(find.text('الرصيد المتاح للسحب'), findsOneWidget);
      expect(find.text('845'), findsOneWidget);

      // Method Selection
      expect(find.text('اختر طريقة السحب'), findsOneWidget);
      expect(find.text('تحويل بنكي'), findsOneWidget);
      expect(find.text('تحويل إلى حسابك البنكي'), findsOneWidget);
      expect(find.text('محفظة إلكترونية'), findsOneWidget);
      expect(find.text('تحويل إلى محفظة إلكترونية'), findsOneWidget);

      // Bank Details
      expect(find.text('بيانات التحويل البنكي'), findsOneWidget);
      expect(find.text('اسم صاحب الحساب'), findsOneWidget);
      expect(find.text('رقم الآيبان'), findsOneWidget);
      expect(find.text('اسم البنك'), findsOneWidget);

      // Amount Card
      expect(find.text('مبلغ السحب'), findsOneWidget);
      expect(find.text('845.000'), findsOneWidget);

      // Button
      expect(find.text('طلب سحب الأرباح'), findsOneWidget);
    },
  );

  testWidgets(
    'influencer withdraw screen renders components in English locale',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            AppRoutes.influencerWithdrawReview: (_) =>
                const Scaffold(body: Text('review route')),
          },
          home: const InfluencerWithdrawScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Withdraw Profits'), findsOneWidget);
      expect(find.text('Available balance for withdrawal'), findsOneWidget);
      expect(find.text('Bank Transfer'), findsOneWidget);
      expect(find.text('Electronic Wallet'), findsOneWidget);
      expect(find.text('Bank Transfer Details'), findsOneWidget);
      expect(find.text('Request withdrawal'), findsOneWidget);
    },
  );
}
