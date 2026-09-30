import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_item.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_option.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector_skeleton.dart';

class _FakeDuration implements SubscriptionDurationItem {
  const _FakeDuration({
    required this.isCustom,
    this.durationDays,
    this.minDays,
    this.maxDays,
    this.totalServiceDays = 0,
    required this.title,
  });

  @override
  final bool isCustom;
  @override
  final int? durationDays;
  @override
  final int? minDays;
  @override
  final int? maxDays;
  @override
  final int totalServiceDays;
  final String title;

  @override
  String name(String localeName) => title;
}

void main() {
  const durations = <SubscriptionDurationItem>[
    _FakeDuration(
      isCustom: false,
      durationDays: 7,
      totalServiceDays: 6,
      title: 'أسبوع',
    ),
    _FakeDuration(
      isCustom: false,
      durationDays: 14,
      totalServiceDays: 12,
      title: 'نصف شهر',
    ),
    _FakeDuration(
      isCustom: false,
      durationDays: 30,
      totalServiceDays: 26,
      title: 'شهر',
    ),
    _FakeDuration(
      isCustom: true,
      minDays: 5,
      maxDays: 60,
      title: 'تخصيص',
    ),
  ];

  Widget buildTestWidget({
    required double width,
    required Widget child,
  }) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('SubscriptionDurationSelector does not overflow on narrow screens (360px)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestWidget(
        width: 336, // 360 screen with 12px margin on each side
        child: SubscriptionDurationSelector(
          selectedIndex: 0,
          onSelected: (_) {},
          includesFriday: false,
          onFridayChanged: (_) {},
          customDurationDays: 20,
          onCustomDurationChanged: (_) {},
          durations: durations,
          isFridayEnabled: true,
          isLoading: false,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SubscriptionDurationSelector), findsOneWidget);
  });

  testWidgets('SubscriptionDurationSelectorSkeleton does not overflow on narrow screens (360px)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestWidget(
        width: 336,
        child: const SubscriptionDurationSelectorSkeleton(),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SubscriptionDurationSelectorSkeleton), findsOneWidget);
  });

  testWidgets('SubscriptionDurationSelector does not overflow on extra narrow screens (320px)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestWidget(
        width: 296, // 320 screen with 12px margin on each side
        child: SubscriptionDurationSelector(
          selectedIndex: 0,
          onSelected: (_) {},
          includesFriday: false,
          onFridayChanged: (_) {},
          customDurationDays: 20,
          onCustomDurationChanged: (_) {},
          durations: durations,
          isFridayEnabled: true,
          isLoading: false,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SubscriptionDurationSelector), findsOneWidget);
  });

  testWidgets('SubscriptionDurationOption icon does not overlap with days text', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        width: 360,
        child: SubscriptionDurationSelector(
          selectedIndex: 0,
          onSelected: (_) {},
          includesFriday: false,
          onFridayChanged: (_) {},
          customDurationDays: 20,
          onCustomDurationChanged: (_) {},
          durations: durations,
          isFridayEnabled: true,
          isLoading: false,
        ),
      ),
    );

    final text26 = find.text('26');
    expect(text26, findsOneWidget);
    final textRect = tester.getRect(text26);

    // Find the icon associated with 26
    // The option with '26' is the 3rd preset option
    final options = find.byType(SubscriptionDurationOption);
    expect(options, findsNWidgets(3));
    final option3 = options.at(2);
    final icon = find.descendant(of: option3, matching: find.byType(Icon));
    expect(icon, findsOneWidget);
    final iconRect = tester.getRect(icon);

    // Assert that the text does not overlap with the icon
    expect(textRect.overlaps(iconRect), isFalse);
    expect(textRect.top, greaterThanOrEqualTo(iconRect.bottom));
  });

  testWidgets('preset duration labels update when includesFriday is toggled', (tester) async {
    const testDurations = <SubscriptionDurationItem>[
      _FakeDuration(
        isCustom: false,
        durationDays: 7,
        totalServiceDays: 6,
        title: '6 أيام',
      ),
      _FakeDuration(
        isCustom: false,
        durationDays: 14,
        totalServiceDays: 12,
        title: '12 يوماً',
      ),
      _FakeDuration(
        isCustom: false,
        durationDays: 30,
        totalServiceDays: 26,
        title: '26 يوماً',
      ),
    ];

    // 1. When includesFriday is false
    await tester.pumpWidget(
      buildTestWidget(
        width: 360,
        child: SubscriptionDurationSelector(
          selectedIndex: 0,
          onSelected: (_) {},
          includesFriday: false,
          onFridayChanged: (_) {},
          customDurationDays: null,
          onCustomDurationChanged: (_) {},
          durations: testDurations,
          isFridayEnabled: true,
          isLoading: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('6 أيام'), findsOneWidget);
    expect(find.text('12 يوماً'), findsOneWidget);
    expect(find.text('26 يوماً'), findsOneWidget);

    // 2. When includesFriday is toggled to true
    await tester.pumpWidget(
      buildTestWidget(
        width: 360,
        child: SubscriptionDurationSelector(
          selectedIndex: 0,
          onSelected: (_) {},
          includesFriday: true,
          onFridayChanged: (_) {},
          customDurationDays: null,
          onCustomDurationChanged: (_) {},
          durations: testDurations,
          isFridayEnabled: true,
          isLoading: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('7 أيام'), findsOneWidget);
    expect(find.text('14 يوماً'), findsOneWidget);
    expect(find.text('30 يوماً'), findsOneWidget);
  });
}
