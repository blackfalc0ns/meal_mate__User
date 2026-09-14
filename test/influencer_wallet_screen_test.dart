import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/screens/influencer_wallet_screen.dart';

void main() {
  testWidgets('influencer wallet renders figma wallet sections', (
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
          AppRoutes.influencerWithdraw: (_) =>
              const Scaffold(body: Text('withdraw route')),
          AppRoutes.influencerWithdrawHistory: (_) =>
              const Scaffold(body: Text('history route')),
        },
        home: const Scaffold(body: InfluencerWalletScreen(showScaffold: false)),
      ),
    );

    expect(find.text('محفظتي'), findsOneWidget);
    expect(find.text('إدارة أرباحك وحركاتك المالية'), findsOneWidget);
    expect(find.text('الرصيد المتاح'), findsOneWidget);
    expect(find.text('845'), findsWidgets);
    expect(find.text('1.245'), findsOneWidget);
    expect(find.text('سحب الارباح'), findsOneWidget);
    expect(find.text('سجل العمليات'), findsOneWidget);
    expect(find.text('ملخص هذا الشهر'), findsOneWidget);
    expect(find.text('إجمالي الأرباح'), findsOneWidget);
    expect(find.text('تم السحب'), findsOneWidget);
    expect(find.text('أحدث المعاملات'), findsOneWidget);
    expect(find.text('عرض الكل'), findsOneWidget);
    expect(find.text('+120 KWD'), findsWidgets);
    expect(find.text('-120 KWD'), findsOneWidget);
    expect(find.text('25 مايو 2025'), findsWidgets);
  });
}
