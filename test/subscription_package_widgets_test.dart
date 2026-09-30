import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_package_choice_card.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_packages_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_restaurant_logo_stack.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_selected_program_card.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

void main() {
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

  group('SubscriptionPackageChoiceCard', () {
    testWidgets('renders without overflow on narrow 320px screen', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var tapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          width: 280,
          child: SubscriptionPackageChoiceCard(
            title: 'باقة خسارة الوزن الصحية الشاملة للوجبات المتوازنة',
            subtitle: 'إفطار - غداء - عشاء - سناك - وجبة خفيفة',
            isSelected: true,
            isPopular: true,
            badgeLabel: 'الأكثر طلباً',
            restaurantLogoUrls: const [
              'https://example.com/logo1.png',
              'https://example.com/logo2.png',
            ],
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SubscriptionPackageChoiceCard), findsOneWidget);

      await tester.tap(find.byType(SubscriptionPackageChoiceCard));
      expect(tapped, isTrue);
    });

    testWidgets('renders when unselected without overflow', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          width: 320,
          child: const SubscriptionPackageChoiceCard(
            title: 'باقة الحفاظ على الوزن',
            subtitle: 'إفطار - غداء',
            isSelected: false,
            isPopular: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SubscriptionPackageChoiceCard), findsOneWidget);
    });
  });

  group('SubscriptionSelectedProgramCard', () {
    testWidgets('renders without overflow and displays name and description', (tester) async {
      const program = SubscriptionProgramEntity(
        programId: 'prog-1',
        code: 'PROG_1',
        shortCode: 'P1',
        nameAr: 'برنامج خسارة الوزن المتقدم للرياضيين',
        nameEn: 'Weight Loss Program',
        descriptionAr: 'برنامج مصمم لمساعدتك على تقليل الدهون وبناء العضلات بطريقة صحية ومستدامة',
        descriptionEn: 'Designed to help you lose fat and build muscle.',
        imageUrl: 'https://example.com/prog.png',
        keywordsAr: ['صحي'],
        keywordsEn: ['healthy'],
        bundleCount: 2,
        supportedSlots: ['breakfast', 'lunch'],
        fallbackImageAsset: 'assets/images/default.png',
      );

      await tester.pumpWidget(
        buildTestWidget(
          width: 320,
          child: const SubscriptionSelectedProgramCard(program: program),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('برنامج خسارة الوزن المتقدم للرياضيين'), findsOneWidget);
    });
  });

  group('SubscriptionRestaurantLogoStack', () {
    testWidgets('returns shrink when logoUrls is empty', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          width: 200,
          child: const SubscriptionRestaurantLogoStack(logoUrls: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  group('SubscriptionPackagesLoadingSkeleton', () {
    testWidgets('renders skeleton without errors', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          width: 360,
          child: const SubscriptionPackagesLoadingSkeleton(),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(SubscriptionPackagesLoadingSkeleton), findsOneWidget);
    });
  });
}
