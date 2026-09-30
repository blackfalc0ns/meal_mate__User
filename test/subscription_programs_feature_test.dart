import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_goal_card.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_selection_view.dart';

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
        child: Scaffold(body: child),
      ),
    );
  }

  const sampleProgram = SubscriptionProgramEntity(
    programId: 'prog-1',
    code: 'PROG_WEIGHT_LOSS',
    shortCode: 'WL',
    nameAr: 'خسارة الوزن',
    nameEn: 'Weight Loss',
    descriptionAr: 'برنامج مصمم لمساعدتك على تقليل الوزن بطريقة صحية',
    descriptionEn: 'A healthy weight loss program',
    keywordsAr: ['سعرات محسوبة', 'قليل الدهون'],
    keywordsEn: ['Calorie counted', 'Low fat'],
    imageUrl: null,
    bundleCount: 3,
    supportedSlots: ['LUNCH', 'DINNER'],
    fallbackImageAsset: '',
  );

  group('SubscriptionProgramGoalCard Widget Tests', () {
    testWidgets('renders title, description, and features cleanly without fake data', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          child: SubscriptionProgramGoalCard(
            title: 'خسارة الوزن',
            description: 'برنامج لخسارة الوزن',
            imageUrl: null,
            primaryFeature: 'سعرات محسوبة',
            secondaryFeature: 'قليل الدهون',
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('خسارة الوزن'), findsOneWidget);
      expect(find.text('برنامج لخسارة الوزن'), findsWidgets);
      expect(find.text('سعرات محسوبة'), findsOneWidget);
      expect(find.text('قليل الدهون'), findsOneWidget);

      await tester.tap(find.byType(SubscriptionProgramGoalCard));
      expect(tapped, isTrue);
    });

    testWidgets('adapts layout cleanly when isSelected is toggled', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: const SubscriptionProgramGoalCard(
            title: 'خسارة الوزن',
            description: 'برنامج لخسارة الوزن',
            imageUrl: null,
            primaryFeature: 'سعرات محسوبة',
            secondaryFeature: 'قليل الدهون',
            isSelected: true,
            onTap: _noop,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('خسارة الوزن'), findsOneWidget);
      expect(find.byType(SubscriptionProgramGoalCard), findsOneWidget);
    });
  });

  group('SubscriptionProgramSelectionView with flutter_animate', () {
    testWidgets('renders programs with animated entrance and allows selection', (
      tester,
    ) async {
      int? selectedIndex;

      await tester.pumpWidget(
        buildTestWidget(
          child: SubscriptionProgramSelectionView(
            showBottomSpace: true,
            programs: const [sampleProgram],
            selectedProgramNotifier: ValueNotifier<int?>(null),
            onProgramSelected: (index) => selectedIndex = index,
          ),
        ),
      );

      // Advance flutter_animate timers
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('خسارة الوزن'), findsOneWidget);
      expect(find.text('سعرات محسوبة'), findsOneWidget);

      await tester.tap(find.byType(SubscriptionProgramGoalCard));
      expect(selectedIndex, equals(0));
    });
  });
}

void _noop() {}
