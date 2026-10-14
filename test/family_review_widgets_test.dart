import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_nutrition_totals_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/screens/family_review_member_meals_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_actions_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_cutoff_banner.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_header_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_instructions_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_macros_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_review_meal_slot_card.dart';

void main() {
  Widget buildTestable(Widget child) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  testWidgets('FamilyReviewLoadingSkeleton renders correctly', (tester) async {
    await tester.pumpWidget(buildTestable(const FamilyReviewLoadingSkeleton()));

    expect(
      find.byKey(const ValueKey('family-review-loading-skeleton')),
      findsOneWidget,
    );
  });

  testWidgets('FamilyReviewHeaderCard renders date, goal, and status', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestable(
        const FamilyReviewHeaderCard(
          memberName: 'أحمد',
          statusLabel: 'جاهز للتأكيد',
          dateLabel: 'الأحد 15 مارس',
          goalLabel: 'متوازن',
        ),
      ),
    );

    expect(find.text('جاهز للتأكيد'), findsOneWidget);
    expect(find.text('الأحد 15 مارس'), findsOneWidget);
    expect(find.text('متوازن'), findsOneWidget);
  });

  testWidgets('FamilyReviewMealSlotCard renders meal info and edit button', (
    tester,
  ) async {
    const meal = CalendarMealEntity(
      id: 'meal_1',
      title: 'دجاج مشوي بالأعشاب',
      description: 'دجاج مشوي متبل بالأعشاب مع أرز بني وخضار مشكلة',
      calories: '480',
      carbs: '48',
      protein: '42',
      fat: '12',
      mealType: 'غداء',
      time: '12:00',
      actionLabel: 'اختيار',
      imageAsset: '',
      ingredients: [],
      allergens: [],
      selected: true,
    );

    bool onEditTapped = false;

    await tester.pumpWidget(
      buildTestable(
        FamilyReviewMealSlotCard(
          meal: meal,
          restaurantName: 'مطعم هيلثي لايف',
          onEdit: () {
            onEditTapped = true;
          },
        ),
      ),
    );

    expect(find.text('دجاج مشوي بالأعشاب'), findsOneWidget);
    expect(find.text('مطعم هيلثي لايف'), findsOneWidget);

    final editBtn = find.byType(InkWell);
    expect(editBtn, findsWidgets);
    await tester.tap(editBtn.first);
    expect(onEditTapped, isTrue);
  });

  testWidgets('FamilyReviewMacrosCard renders macro metrics correctly', (
    tester,
  ) async {
    const nutrition = CalendarNutritionTotalsEntity(
      calories: 1420,
      proteinG: 89,
      carbsG: 210,
      fatG: 58,
    );

    await tester.pumpWidget(
      buildTestable(const FamilyReviewMacrosCard(nutrition: nutrition)),
    );

    expect(find.text('1420'), findsOneWidget);
    expect(find.text('89'), findsOneWidget);
    expect(find.text('210'), findsOneWidget);
    expect(find.text('58'), findsOneWidget);
  });

  testWidgets('FamilyReviewInstructionsCard renders instructions and note', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestable(
        const FamilyReviewInstructionsCard(
          instructions: ['لا طعام حار', 'يفضل الأرز البني', 'بدون مكسرات'],
          note: 'سيتم مراعاة تفضيلاته في حال احتاج استبدال لأي وجبة',
        ),
      ),
    );

    expect(find.text('لا طعام حار'), findsOneWidget);
    expect(find.text('يفضل الأرز البني'), findsOneWidget);
    expect(find.text('بدون مكسرات'), findsOneWidget);
    expect(
      find.text('سيتم مراعاة تفضيلاته في حال احتاج استبدال لأي وجبة'),
      findsOneWidget,
    );
  });

  testWidgets(
    'FamilyReviewCutoffBanner renders countdown, title, and disclaimer',
    (tester) async {
      await tester.pumpWidget(
        buildTestable(
          const FamilyReviewCutoffBanner(
            title: 'يمكنك تعديل وجبات اليوم حتى وقت القفل',
            description: 'بمجرد وصول وقت القفل سيتم تجهيز الوجبات',
            remainingTime: '22 ساعة و 18 دقيقة',
            disclaimer: 'في حال لم يكتمل الاختيار سيتم التعيين تلقائيا',
          ),
        ),
      );

      expect(
        find.text('يمكنك تعديل وجبات اليوم حتى وقت القفل'),
        findsOneWidget,
      );
      expect(
        find.text('بمجرد وصول وقت القفل سيتم تجهيز الوجبات'),
        findsOneWidget,
      );
      expect(
        find.text('في حال لم يكتمل الاختيار سيتم التعيين تلقائيا'),
        findsOneWidget,
      );
    },
  );

  testWidgets('FamilyReviewActionsBar triggers edit and confirm callbacks', (
    tester,
  ) async {
    bool editCalled = false;
    bool confirmCalled = false;

    await tester.pumpWidget(
      buildTestable(
        FamilyReviewActionsBar(
          memberName: 'أحمد',
          onEdit: () => editCalled = true,
          onConfirm: () => confirmCalled = true,
        ),
      ),
    );

    expect(find.text('تعديل الوجبات'), findsOneWidget);
    expect(find.text('تأكيد وجبات أحمد'), findsOneWidget);

    await tester.tap(find.text('تعديل الوجبات'));
    expect(editCalled, isTrue);

    await tester.tap(find.text('تأكيد وجبات أحمد'));
    expect(confirmCalled, isTrue);
  });

  testWidgets(
    'FamilyReviewMemberMealsScreen renders empty state without args',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FamilyReviewMemberMealsScreen(),
        ),
      );

      expect(find.byType(FamilyReviewMemberMealsScreen), findsOneWidget);
    },
  );
}
