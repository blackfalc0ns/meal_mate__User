import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/family_management_repository.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_family_home_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_family_member_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/get_family_members_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/manage_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/manage_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_permissions_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permissions_confirm_dialog.dart';

class _FakeRepo implements FamilyManagementRepository {
  Completer<ApiResult<FamilyMemberPermissionsEntity>>? updateCompleter;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> getPermissions(
    String memberId,
    String localeName,
  ) async {
    return ApiSuccessResult(
      data: const FamilyMemberPermissionsEntity(
        memberId: 'm-1',
        values: {'edit_meals': true, 'edit_address': false},
        groups: [
          FamilyPermissionGroupEntity(
            code: 'meals',
            label: 'الوجبات',
            permissions: [
              FamilyPermissionItemEntity(
                key: 'edit_meals',
                label: 'تعديل الوجبات اليومية',
                value: true,
              ),
            ],
          ),
          FamilyPermissionGroupEntity(
            code: 'delivery',
            label: 'التوصيل',
            permissions: [
              FamilyPermissionItemEntity(
                key: 'edit_address',
                label: 'تعديل العنوان',
                value: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> updatePermissions({
    required String memberId,
    required Map<String, bool> values,
    required String localeName,
  }) async {
    if (updateCompleter != null) {
      return updateCompleter!.future;
    }
    return ApiSuccessResult(
      data: FamilyMemberPermissionsEntity(
        memberId: memberId,
        values: values,
        groups: const [],
      ),
    );
  }
}

void main() {
  late _FakeRepo repo;

  setUp(() async {
    await getIt.reset();
    repo = _FakeRepo();
    getIt.registerFactory<FamilyManagementViewModel>(
      () => FamilyManagementViewModel(
        GetFamilyHomeUseCase(repo),
        GetFamilyMembersUseCase(repo),
        GetFamilyMemberUseCase(repo),
        ManageFamilyMemberAccessUseCase(repo),
        ManageFamilyMemberPermissionsUseCase(repo),
        RenewFamilyMemberSubscriptionUseCase(repo),
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'FamilyMemberPermissionsScreen full flow: inactive save, active on change, confirm dialog, CustomProgressIndicator, and success snackbar',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FamilyMemberPermissionsScreen(
            memberId: 'm-1',
            isManager: false,
            memberName: 'أحمد',
          ),
        ),
      );

      // Initially loads permissions
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('الوجبات'), findsOneWidget);
      expect(find.text('التوصيل'), findsOneWidget);
      expect(find.text('تعديل الوجبات اليومية'), findsOneWidget);

      // Save button is initially inactive because no changes were made
      final buttonFinder = find.byType(AppButton);
      expect(buttonFinder, findsOneWidget);
      final appButton = tester.widget<AppButton>(buttonFinder);
      expect(appButton.onPressed, isNull);

      // Toggle switch to change value
      final switchFinder = find.byType(SwitchListTile).first;
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Now save button is active
      final activeAppButton = tester.widget<AppButton>(buttonFinder);
      expect(activeAppButton.onPressed, isNotNull);

      // Tap save button -> confirmation dialog appears
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(FamilyMemberPermissionsConfirmDialog), findsOneWidget);
      expect(find.text('تأكيد حفظ الصلاحيات'), findsOneWidget);

      // Set completer so update stays in flight
      repo.updateCompleter = Completer();

      // Confirm save in dialog
      await tester.tap(find.text('تأكيد'));
      await tester.pump();

      // While saving, CustomProgressIndicator overlay is rendered
      expect(find.byType(CustomProgressIndicator), findsOneWidget);

      // Now complete the save operation
      repo.updateCompleter!.complete(
        ApiSuccessResult(
          data: const FamilyMemberPermissionsEntity(
            memberId: 'm-1',
            values: {'edit_meals': false, 'edit_address': false},
            groups: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Indicator removed and snackbar displayed
      expect(find.byType(CustomProgressIndicator), findsNothing);
      expect(find.text('تم حفظ الصلاحيات بنجاح'), findsOneWidget);
    },
  );
}
