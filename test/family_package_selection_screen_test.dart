import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_package_hero_card.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_package_section_header.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_package_selection_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_size_package_card.dart';

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
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  const samplePackage1 = FamilySizePackageEntity(
    id: 'pkg-1',
    nameAr: 'عائلة صغيرة',
    nameEn: 'Small Family',
    minMembers: 2,
    maxMembers: 3,
    discountPercent: 0.08,
    sortOrder: 1,
  );

  const samplePackage2 = FamilySizePackageEntity(
    id: 'pkg-2',
    nameAr: 'عائلة متوسطة',
    nameEn: 'Medium Family',
    minMembers: 4,
    maxMembers: 5,
    discountPercent: 0.10,
    sortOrder: 2,
  );

  group('FamilyPackageHeroCard', () {
    testWidgets('renders badge, title, and subtitle correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(child: const FamilyPackageHeroCard()),
      );
      await tester.pumpAndSettle();

      expect(find.text('وجبات تكفي الجميع'), findsOneWidget);
      expect(find.text('خطط متكاملة من 2 إلى 8 أفراد'), findsOneWidget);
      expect(find.text('بأشتراكات مناسبة وتوصيل سريع'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('FamilyPackageSectionHeader', () {
    testWidgets('renders section title and group icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(child: const FamilyPackageSectionHeader()),
      );
      await tester.pumpAndSettle();

      expect(find.text('اختر نوع الاشتراك'), findsOneWidget);
      expect(find.byIcon(Icons.groups_rounded), findsOneWidget);
    });
  });

  group('FamilySizePackageCard', () {
    testWidgets(
      'renders package details, discount badge, bottom row, and selected checkmark',
      (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            child: FamilySizePackageCard(
              package: samplePackage1,
              isSelected: true,
              onTap: () => tapped = true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('عائلة صغيرة'), findsOneWidget);
        expect(find.text('من 2 إلى 3 أفراد'), findsOneWidget);
        expect(find.text('خصم 8%'), findsOneWidget);
        expect(find.text('2-4 وجبات'), findsOneWidget);
        expect(find.text('2-3 أفراد'), findsOneWidget);
        expect(find.byIcon(Icons.check_rounded), findsOneWidget);

        await tester.tap(find.byType(FamilySizePackageCard));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      },
    );

    testWidgets('renders unselected state with neutral indicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: FamilySizePackageCard(
            package: samplePackage2,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('عائلة متوسطة'), findsOneWidget);
      expect(find.text('خصم 10%'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNothing);
    });

    testWidgets('renders English translations correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          locale: const Locale('en'),
          textDirection: TextDirection.ltr,
          child: FamilySizePackageCard(
            package: samplePackage1,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Small Family'), findsOneWidget);
      expect(find.text('From 2 to 3 members'), findsOneWidget);
      expect(find.text('8% discount'), findsOneWidget);
      expect(find.text('2-4 meals'), findsOneWidget);
      expect(find.text('2-3 members'), findsOneWidget);
    });
  });

  group('FamilyPackageSelectionLoadingSkeleton', () {
    testWidgets('renders all skeleton blocks properly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(child: const FamilyPackageSelectionLoadingSkeleton()),
      );
      await tester.pump();

      expect(
        find.byType(FamilyPackageSelectionLoadingSkeleton),
        findsOneWidget,
      );
    });
  });
}
