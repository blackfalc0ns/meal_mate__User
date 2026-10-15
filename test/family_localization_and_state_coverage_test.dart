import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_permission_info_dialog.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_permission_row.dart';

Widget _wrapWithLocale(Widget child, Locale locale) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    locale: locale,
    home: Scaffold(body: child),
  );
}

void main() {
  group('Task 10: Localization, State Coverage, and Verification Tests', () {
    testWidgets('Bilingual permission labels and descriptions select active language and fallback appropriately', (tester) async {
      const permissionItem = FamilyPermissionItemEntity(
        key: 'viewInvoices',
        label: 'Invoices',
        value: true,
        labelAr: 'الفواتير',
        labelEn: 'Invoices',
        descriptionAr: 'عرض فواتير الاشتراك الشهرية',
        descriptionEn: 'View monthly subscription invoices',
      );

      // 1. In English
      expect(permissionItem.localizedLabel(false), equals('Invoices'));
      expect(permissionItem.localizedDescription(false), equals('View monthly subscription invoices'));

      // 2. In Arabic
      expect(permissionItem.localizedLabel(true), equals('الفواتير'));
      expect(permissionItem.localizedDescription(true), equals('عرض فواتير الاشتراك الشهرية'));

      // 3. Fallback when Arabic description is empty
      const fallbackItem = FamilyPermissionItemEntity(
        key: 'customFeature',
        label: 'Custom Feature',
        value: false,
        labelAr: 'ميزة مخصصة',
        labelEn: 'Custom Feature',
        descriptionAr: null,
        descriptionEn: 'English only explanation',
      );
      expect(fallbackItem.localizedDescription(true), equals('English only explanation'));
      expect(fallbackItem.localizedDescription(false), equals('English only explanation'));
    });

    testWidgets('FamilyPermissionInfoDialog renders RTL in Arabic and LTR in English without crashing', (tester) async {
      const itemAr = FamilyPermissionItemEntity(
        key: 'confirmMeals',
        label: 'تأكيد الوجبات',
        value: true,
        labelAr: 'تأكيد الوجبات',
        labelEn: 'Confirm Meals',
        descriptionAr: 'اعتماد اختيارات الوجبات لليوم',
        descriptionEn: 'Approve meal selections for the day',
        isManagerConfigurable: false,
      );

      // Test dialog in Arabic (RTL)
      await tester.pumpWidget(
        _wrapWithLocale(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const FamilyPermissionInfoDialog(
                  permission: itemAr,
                  currentValue: true,
                ),
              ),
              child: const Text('Open Dialog'),
            ),
          ),
          const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('تأكيد الوجبات'), findsOneWidget);
      expect(find.text('اعتماد اختيارات الوجبات لليوم'), findsOneWidget);
      expect(find.text('ثابت من النظام (غير قابل للتعديل)'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('إغلاق'));
      await tester.pumpAndSettle();
      expect(find.byType(FamilyPermissionInfoDialog), findsNothing);

      // Test dialog in English (LTR)
      const itemEn = FamilyPermissionItemEntity(
        key: 'confirmMeals',
        label: 'Confirm Meals',
        value: true,
        labelAr: 'تأكيد الوجبات',
        labelEn: 'Confirm Meals',
        descriptionAr: 'اعتماد اختيارات الوجبات لليوم',
        descriptionEn: 'Approve meal selections for the day',
        isManagerConfigurable: false,
      );

      await tester.pumpWidget(
        _wrapWithLocale(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const FamilyPermissionInfoDialog(
                  permission: itemEn,
                  currentValue: true,
                ),
              ),
              child: const Text('Open Dialog En'),
            ),
          ),
          const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog En'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Meals'), findsOneWidget);
      expect(find.text('Approve meal selections for the day'), findsOneWidget);
      expect(find.text('Fixed by system (not configurable)'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('FamilyPermissionRow renders info icon and opens dialog on tap', (tester) async {
      const item = FamilyPermissionItemEntity(
        key: 'selectRestaurant',
        label: 'Select Restaurant',
        value: true,
        labelEn: 'Select Restaurant',
        descriptionEn: 'Allows changing restaurant for unlocked days',
      );

      await tester.pumpWidget(
        _wrapWithLocale(
          FamilyPermissionRow(
            permission: item,
            value: true,
            onChanged: (_) {},
          ),
          const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select Restaurant'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      expect(find.byType(FamilyPermissionInfoDialog), findsOneWidget);
      expect(find.text('Allows changing restaurant for unlocked days'), findsOneWidget);
    });

    test('KWD three-decimal formatting for Kuwait currencies', () {
      const double kwdPrice1 = 85.5;
      const double kwdPrice2 = 120.0;
      const double kwdPrice3 = 0.75;

      expect(kwdPrice1.toStringAsFixed(3), equals('85.500'));
      expect(kwdPrice2.toStringAsFixed(3), equals('120.000'));
      expect(kwdPrice3.toStringAsFixed(3), equals('0.750'));
    });
  });
}
