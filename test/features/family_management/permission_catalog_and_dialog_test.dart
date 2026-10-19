import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_management/member/data/mapper/family_member_mapper.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_permission_info_dialog.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_permission_row.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/response/api/family_member_permissions_response_dto.dart';

Widget createTestWidget({
  required Widget child,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  group('Task 4: Permission Catalog and Info Dialog Contract', () {
    test('localizedLabel selects active language and falls back to counterpart', () {
      // 1. Both available
      const both = FamilyPermissionItemEntity(
        key: 'editDailyMeals',
        label: 'Default',
        labelAr: 'تعديل الوجبات اليومية',
        labelEn: 'Edit Daily Meals',
        value: true,
      );
      expect(both.localizedLabel(true), 'تعديل الوجبات اليومية');
      expect(both.localizedLabel(false), 'Edit Daily Meals');

      // 2. Arabic only -> English falls back to Arabic
      const arabicOnly = FamilyPermissionItemEntity(
        key: 'selectRestaurant',
        label: 'Default',
        labelAr: 'اختيار المطعم',
        labelEn: '',
        value: true,
      );
      expect(arabicOnly.localizedLabel(true), 'اختيار المطعم');
      expect(arabicOnly.localizedLabel(false), 'اختيار المطعم');

      // 3. English only -> Arabic falls back to English
      const englishOnly = FamilyPermissionItemEntity(
        key: 'confirmMeals',
        label: 'Default',
        labelAr: '   ',
        labelEn: 'Confirm Meals',
        value: true,
      );
      expect(englishOnly.localizedLabel(true), 'Confirm Meals');
      expect(englishOnly.localizedLabel(false), 'Confirm Meals');
    });

    test('localizedDescription selects active language and falls back to counterpart', () {
      // 1. Both available
      const both = FamilyPermissionItemEntity(
        key: 'viewCalendar',
        label: 'View Calendar',
        descriptionAr: 'يتيح للفرد قراءة أيام وجباته الخاصة في التقويم',
        descriptionEn: 'Allows member to read their own calendar days',
        value: true,
      );
      expect(
        both.localizedDescription(true),
        'يتيح للفرد قراءة أيام وجباته الخاصة في التقويم',
      );
      expect(
        both.localizedDescription(false),
        'Allows member to read their own calendar days',
      );

      // 2. Fallback when Arabic blank
      const enOnly = FamilyPermissionItemEntity(
        key: 'viewCalendar',
        label: 'View Calendar',
        descriptionAr: '',
        descriptionEn: 'English only explanation',
        value: true,
      );
      expect(enOnly.localizedDescription(true), 'English only explanation');
      expect(enOnly.localizedDescription(false), 'English only explanation');

      // 3. Fallback when English blank
      const arOnly = FamilyPermissionItemEntity(
        key: 'viewCalendar',
        label: 'View Calendar',
        descriptionAr: 'شرح عربي فقط',
        descriptionEn: null,
        value: true,
      );
      expect(arOnly.localizedDescription(false), 'شرح عربي فقط');

      // 4. Both null/empty
      const emptyDesc = FamilyPermissionItemEntity(
        key: 'viewCalendar',
        label: 'View Calendar',
        value: true,
      );
      expect(emptyDesc.localizedDescription(true), '');
      expect(emptyDesc.localizedDescription(false), '');
    });

    test('FamilyMemberMapper omits obsolete keys and unsupported permissions', () {
      const dto = FamilyMemberPermissionsResponseDto(
        memberId: 'member-123',
        version: 5,
        groups: [
          FamilyPermissionGroupResponseDto(
            code: 'calendar_group',
            labelAr: 'التقويم',
            labelEn: 'Calendar',
            permissions: [
              FamilyPermissionItemResponseDto(
                key: 'viewCalendar',
                labelAr: 'عرض التقويم',
                labelEn: 'View Calendar',
                descriptionAr: 'وصف التقويم بالعربية',
                descriptionEn: 'Calendar description in English',
                value: true,
                isSupported: true,
                isManagerConfigurable: true,
                requiredPermissions: [],
              ),
              FamilyPermissionItemResponseDto(
                key: 'changeProgram',
                labelAr: 'تغيير البرنامج',
                labelEn: 'Change Program',
                value: false,
                isSupported: true,
              ),
              FamilyPermissionItemResponseDto(
                key: 'changeDeliveryTime',
                labelAr: 'تغيير وقت التوصيل',
                labelEn: 'Change Delivery Time',
                value: false,
                isSupported: true,
              ),
              FamilyPermissionItemResponseDto(
                key: 'unitExchange',
                labelAr: 'تبديل الوحدات',
                labelEn: 'Unit Exchange',
                value: false,
                isSupported: false, // Unsupported in this release
              ),
              FamilyPermissionItemResponseDto(
                key: 'editAddress',
                labelAr: 'تعديل العنوان',
                labelEn: 'Edit Address',
                value: false,
                isSupported: true,
                isManagerConfigurable: false, // Fixed/non-configurable
                requiredPermissions: ['viewAddress'],
              ),
            ],
          ),
        ],
      );

      final entity = FamilyMemberMapper.toPermissionsEntity(dto, locale: 'ar');

      expect(entity.memberId, 'member-123');
      expect(entity.version, 5);
      expect(entity.groups.length, 1);

      final perms = entity.groups.first.permissions;
      // Should only have viewCalendar and editAddress (changeProgram, changeDeliveryTime, unitExchange filtered)
      final keys = perms.map((p) => p.key).toList();
      expect(keys, contains('viewCalendar'));
      expect(keys, contains('editAddress'));
      expect(keys, isNot(contains('changeProgram')));
      expect(keys, isNot(contains('changeDeliveryTime')));
      expect(keys, isNot(contains('unitExchange')));

      final editAddress = perms.firstWhere((p) => p.key == 'editAddress');
      expect(editAddress.isManagerConfigurable, false);
      expect(editAddress.requiredPermissions, ['viewAddress']);
    });

    testWidgets('FamilyPermissionInfoDialog displays API description and metadata in English and RTL/LTR', (tester) async {
      const permission = FamilyPermissionItemEntity(
        key: 'editDailyMeals',
        label: 'Edit Daily Meals',
        labelAr: 'تعديل الوجبات اليومية',
        labelEn: 'Edit Daily Meals',
        descriptionAr: 'يسمح للمستخدم بتعديل وجبات اليوم الفعال',
        descriptionEn: 'Allows the user to customize meals for an active day',
        value: true,
        isSupported: true,
        isManagerConfigurable: true,
        requiredPermissions: ['viewCalendar'],
      );

      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => FamilyPermissionInfoDialog.show(
                context,
                permission: permission,
                currentValue: true,
              ),
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.byType(FamilyPermissionInfoDialog), findsOneWidget);
      expect(find.text('Edit Daily Meals'), findsOneWidget);
      expect(
        find.text('Allows the user to customize meals for an active day'),
        findsOneWidget,
      );
      expect(find.text('Enabled'), findsWidgets);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(FamilyPermissionInfoDialog), findsNothing);
    });

    testWidgets('FamilyPermissionInfoDialog renders correctly in Arabic (RTL)', (tester) async {
      const permission = FamilyPermissionItemEntity(
        key: 'editDailyMeals',
        label: 'Edit Daily Meals',
        labelAr: 'تعديل الوجبات اليومية',
        labelEn: 'Edit Daily Meals',
        descriptionAr: 'يسمح للمستخدم بتعديل وجبات اليوم الفعال',
        descriptionEn: 'Allows the user to customize meals for an active day',
        value: true,
        isSupported: true,
        isManagerConfigurable: false,
        requiredPermissions: ['viewCalendar'],
      );

      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('ar'),
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => FamilyPermissionInfoDialog.show(
                context,
                permission: permission,
                currentValue: true,
              ),
              child: const Text('افتح'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('افتح'));
      await tester.pumpAndSettle();

      expect(find.text('تعديل الوجبات اليومية'), findsOneWidget);
      expect(
        find.text('يسمح للمستخدم بتعديل وجبات اليوم الفعال'),
        findsOneWidget,
      );
      expect(find.text('مفعّل'), findsWidgets);
      expect(find.text('ثابت من النظام (غير قابل للتعديل)'), findsOneWidget);

      // Check Directionality is RTL
      final directionality = tester.widget<Directionality>(
        find.ancestor(
          of: find.byType(FamilyPermissionInfoDialog),
          matching: find.byType(Directionality),
        ).first,
      );
      expect(directionality.textDirection, TextDirection.rtl);

      // Close dialog
      await tester.tap(find.text('إغلاق'));
      await tester.pumpAndSettle();
      expect(find.byType(FamilyPermissionInfoDialog), findsNothing);
    });

    testWidgets('FamilyPermissionRow renders fixed state when isManagerConfigurable is false', (tester) async {
      const fixedPermission = FamilyPermissionItemEntity(
        key: 'editAddress',
        label: 'Edit Address',
        labelAr: 'تعديل العنوان',
        labelEn: 'Edit Address',
        descriptionAr: 'العنوان ثابت مدار من السيرفر',
        descriptionEn: 'Address is fixed and server-managed',
        value: false,
        isSupported: true,
        isManagerConfigurable: false,
      );

      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('en'),
          child: const FamilyPermissionRow(
            permission: fixedPermission,
            value: false,
            isReadOnly: false,
          ),
        ),
      );

      // Should find fixed badge/status
      expect(find.text('Fixed by system (not configurable)'), findsOneWidget);
      expect(find.text('Disabled'), findsOneWidget);
      // Should NOT have an active Switch toggle
      expect(find.byType(Switch), findsNothing);
      // Info icon is present
      expect(find.byKey(const Key('permission_info_editAddress')), findsOneWidget);
    });

    testWidgets('FamilyPermissionRow renders editable Switch when isManagerConfigurable is true', (tester) async {
      const editablePermission = FamilyPermissionItemEntity(
        key: 'confirmMeals',
        label: 'Confirm Meals',
        labelAr: 'تأكيد الوجبات',
        labelEn: 'Confirm Meals',
        descriptionAr: 'تأكيد الوجبات لليوم',
        descriptionEn: 'Confirm meals for the day',
        value: true,
        isSupported: true,
        isManagerConfigurable: true,
      );

      bool? toggledValue;

      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('en'),
          child: FamilyPermissionRow(
            permission: editablePermission,
            value: true,
            isReadOnly: false,
            onChanged: (val) => toggledValue = val,
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(toggledValue, false);
    });
  });
}
