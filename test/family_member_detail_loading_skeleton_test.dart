import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_loading_skeleton.dart';

void main() {
  testWidgets('FamilyMemberDetailLoadingSkeleton renders all 5 card skeletons with shimmer placeholders', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: FamilyMemberDetailLoadingSkeleton()),
      ),
    );

    expect(find.byType(FamilyMemberDetailLoadingSkeleton), findsOneWidget);
    expect(find.byType(ShimmerPlaceholder), findsWidgets);
  });
}
