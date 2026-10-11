import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_hero_summary.dart';

class TestAssetBundle extends CachingAssetBundle {
  static final Uint8List _transparentPng = Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]);

  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('.png') || key.endsWith('.jpg') || key.endsWith('.jpeg')) {
      return ByteData.view(_transparentPng.buffer);
    }
    try {
      return await rootBundle.load(key);
    } catch (_) {
      return ByteData.view(_transparentPng.buffer);
    }
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key.endsWith('.svg')) {
      return '<svg viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg"><rect width="10" height="10"/></svg>';
    }
    try {
      return await rootBundle.loadString(key, cache: cache);
    } catch (_) {
      return '';
    }
  }
}

void main() {
  Widget buildTestWidget({required double width, required Widget child}) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: Scaffold(
          body: Center(
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );
  }

  const samplePlan = MonthlyPlanDetailsEntity(
    titlePrefix: 'باقة الشهر',
    titleHighlight: 'نمط حياة متوازن',
    duration: '',
    mealsPerDay: '',
    discountLabel: '',
    subscribeLabel: '',
    price: '',
    currency: '',
    heroImageAsset: 'assets/images/home_burger.png',
    description: '',
    features: [],
    packageTiers: [],
    filters: [],
    restaurants: [],
    meals: [],
  );

  testWidgets(
    'MonthlyPlanHeroSection renders title and durationSelector without overlap',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestWidget(
          width: 390,
          child: MonthlyPlanHeroSection(
            plan: samplePlan,
            imageAsset: 'assets/images/home_burger.png',
            durationSelector: Container(
              key: const ValueKey('durationSelector'),
              height: 145,
              color: Colors.white,
            ),
            onBack: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MonthlyPlanHeroSummary), findsOneWidget);
      expect(find.text('باقة الشهر'), findsOneWidget);
      expect(find.text('نمط حياة متوازن'), findsOneWidget);

      final summaryRect = tester.getRect(find.byType(MonthlyPlanHeroSummary));
      final durationRect = tester.getRect(
        find.byKey(const ValueKey('durationSelector')),
      );

      // Assert that the summary ends strictly before the duration selector begins
      expect(summaryRect.bottom, lessThan(durationRect.top));
    },
  );

  testWidgets(
    'MonthlyPlanHeroSection renders title and durationSelector without overlap on 320px screen',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestWidget(
          width: 320,
          child: MonthlyPlanHeroSection(
            plan: samplePlan,
            imageAsset: 'assets/images/home_burger.png',
            durationSelector: Container(
              key: const ValueKey('durationSelector'),
              height: 145,
              color: Colors.white,
            ),
            onBack: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MonthlyPlanHeroSummary), findsOneWidget);
      expect(find.text('باقة الشهر'), findsOneWidget);
      expect(find.text('نمط حياة متوازن'), findsOneWidget);

      final summaryRect = tester.getRect(find.byType(MonthlyPlanHeroSummary));
      final durationRect = tester.getRect(
        find.byKey(const ValueKey('durationSelector')),
      );

      expect(summaryRect.bottom, lessThan(durationRect.top));
    },
  );
}
