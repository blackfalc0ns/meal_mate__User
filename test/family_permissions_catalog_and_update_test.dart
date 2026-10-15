import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/data/mapper/family_member_mapper.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_basic_info_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_view_model.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_permission_info_dialog.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_permission_row.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_failure.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';

class FakeGetDetail implements GetFamilyMemberDetailUseCase {
  @override
  Future<ApiResult<FamilyMemberDetailEntity>> call(String memberId, {String locale = 'ar'}) async =>
      throw UnimplementedError();
}

class FakeGetAccess implements GetFamilyMemberAccessUseCase {
  @override
  Future<ApiResult<FamilyMemberAccessEntity>> call(String memberId) async =>
      throw UnimplementedError();
}

class FakeUpdateAccess implements UpdateFamilyMemberAccessUseCase {
  @override
  Future<ApiResult<FamilyMemberAccessEntity>> call(String memberId, UpdateFamilyMemberAccessRequestDto request) async =>
      throw UnimplementedError();
}

class FakeGetPermissions implements GetFamilyMemberPermissionsUseCase {
  int callCount = 0;
  ApiResult<FamilyMemberPermissionsEntity> Function()? onCall;

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> call(String memberId, {String locale = 'ar'}) async {
    callCount++;
    return onCall?.call() ??
        ApiErrorResult(
          failure: FamilyManagementFailure(errorMessage: 'not set', code: 'error'),
        );
  }
}

class FakeUpdatePermissions implements UpdateFamilyMemberPermissionsUseCase {
  int callCount = 0;
  UpdateFamilyMemberPermissionsRequestDto? lastRequest;
  ApiResult<FamilyMemberPermissionsEntity> Function(UpdateFamilyMemberPermissionsRequestDto req)? onCall;

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> call(
    String memberId,
    UpdateFamilyMemberPermissionsRequestDto request, {
    String locale = 'ar',
  }) async {
    callCount++;
    lastRequest = request;
    return onCall?.call(request) ??
        ApiErrorResult(
          failure: FamilyManagementFailure(errorMessage: 'not set', code: 'error'),
        );
  }
}

class FakeUpdateBasicInfo implements UpdateFamilyMemberBasicInfoUseCase {
  @override
  Future<ApiResult<void>> call(String memberId, FamilyMemberWriteRequestDto request) async =>
      throw UnimplementedError();
}

class FakeRenewSubscription implements RenewFamilyMemberSubscriptionUseCase {
  @override
  Future<ApiResult<void>> call(String renewalPath) async =>
      throw UnimplementedError();
}

Widget buildLocalizedApp(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  group('Task 4: Permission Catalog and Info Dialog Tests', () {
    test('Bilingual labels and descriptions select active language with counterpart fallback', () {
      const itemWithBoth = FamilyPermissionItemEntity(
        key: 'viewCalendar',
        label: 'View Calendar',
        value: true,
        labelAr: 'عرض التقويم',
        labelEn: 'View Calendar',
        descriptionAr: 'يتيح للعضو استعراض التقويم',
        descriptionEn: 'Allows member to view the calendar',
      );

      expect(itemWithBoth.localizedLabel(true), 'عرض التقويم');
      expect(itemWithBoth.localizedLabel(false), 'View Calendar');
      expect(itemWithBoth.localizedDescription(true), 'يتيح للعضو استعراض التقويم');
      expect(itemWithBoth.localizedDescription(false), 'Allows member to view the calendar');

      // Test fallback to English when Arabic is blank
      const itemArabicBlank = FamilyPermissionItemEntity(
        key: 'selectRestaurant',
        label: 'Select Restaurant',
        value: false,
        labelAr: '',
        labelEn: 'Select Restaurant',
        descriptionAr: '',
        descriptionEn: 'Allows restaurant selection',
      );

      expect(itemArabicBlank.localizedLabel(true), 'Select Restaurant');
      expect(itemArabicBlank.localizedDescription(true), 'Allows restaurant selection');

      // Test fallback to Arabic when English is blank
      const itemEnglishBlank = FamilyPermissionItemEntity(
        key: 'editDailyMeals',
        label: 'تعديل الوجبات اليومية',
        value: false,
        labelAr: 'تعديل الوجبات اليومية',
        labelEn: '',
        descriptionAr: 'يتيح تعديل وجبات اليوم',
        descriptionEn: '',
      );

      expect(itemEnglishBlank.localizedLabel(false), 'تعديل الوجبات اليومية');
      expect(itemEnglishBlank.localizedDescription(false), 'يتيح تعديل وجبات اليوم');
    });

    test('Mapper omits obsolete permissions and unsupported permissions from catalog', () {
      final dto = FamilyMemberPermissionsResponseDto(
        memberId: 'mem-101',
        version: 3,
        groups: [
          FamilyPermissionGroupResponseDto(
            code: 'meals',
            labelAr: 'الوجبات',
            labelEn: 'Meals',
            permissions: [
              const FamilyPermissionItemResponseDto(
                key: 'changeProgram', // Obsolete
                labelAr: 'تغيير البرنامج',
                labelEn: 'Change Program',
                value: false,
                isSupported: true,
                isManagerConfigurable: true,
              ),
              const FamilyPermissionItemResponseDto(
                key: 'changeDeliveryTime', // Obsolete
                labelAr: 'تغيير وقت التوصيل',
                labelEn: 'Change Delivery Time',
                value: false,
                isSupported: true,
                isManagerConfigurable: true,
              ),
              const FamilyPermissionItemResponseDto(
                key: 'unitExchange',
                labelAr: 'تبديل الوحدات',
                labelEn: 'Unit Exchange',
                value: false,
                isSupported: false, // Unsupported in this release
                isManagerConfigurable: true,
              ),
              const FamilyPermissionItemResponseDto(
                key: 'editDailyMeals',
                labelAr: 'تعديل الوجبات اليومية',
                labelEn: 'Edit Daily Meals',
                descriptionAr: 'وصف عربي للوجبات',
                descriptionEn: 'English meal description',
                value: true,
                isSupported: true,
                isManagerConfigurable: true,
              ),
              const FamilyPermissionItemResponseDto(
                key: 'viewProgram',
                labelAr: 'عرض البرنامج',
                labelEn: 'View Program',
                value: true,
                isSupported: true,
                isManagerConfigurable: false, // Non-configurable
              ),
            ],
          ),
        ],
      );

      final entity = FamilyMemberMapper.toPermissionsEntity(dto, locale: 'en');

      expect(entity.memberId, 'mem-101');
      expect(entity.version, 3);
      expect(entity.groups.length, 1);

      final group = entity.groups.first;
      final keys = group.permissions.map((p) => p.key).toList();

      // Obsolete and unsupported keys must be omitted
      expect(keys.contains('changeProgram'), isFalse);
      expect(keys.contains('changeDeliveryTime'), isFalse);
      expect(keys.contains('unitExchange'), isFalse);

      // Supported keys must remain
      expect(keys.contains('editDailyMeals'), isTrue);
      expect(keys.contains('viewProgram'), isTrue);

      final viewProgram = group.permissions.firstWhere((p) => p.key == 'viewProgram');
      expect(viewProgram.isManagerConfigurable, isFalse);
    });

    testWidgets('FamilyPermissionInfoDialog renders API description, value badge, and prerequisite grants', (tester) async {
      const permission = FamilyPermissionItemEntity(
        key: 'confirmMeals',
        label: 'Confirm Meals',
        value: true,
        labelAr: 'تأكيد الوجبات',
        labelEn: 'Confirm Meals',
        descriptionAr: 'يتيح تأكيد الوجبات لليوم المحدد',
        descriptionEn: 'Allows confirming meals for the scheduled day',
        isSupported: true,
        isManagerConfigurable: false,
        requiredPermissions: ['viewCalendar', 'selectRestaurant'],
      );

      await tester.pumpWidget(
        buildLocalizedApp(
          const FamilyPermissionInfoDialog(
            permission: permission,
            currentValue: true,
          ),
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      // Verified API description is rendered
      expect(find.text('Allows confirming meals for the scheduled day'), findsOneWidget);
      // Verified current value enabled
      expect(find.text('Enabled'), findsOneWidget);
      // Verified non-configurable indicator
      expect(find.text('Fixed by system (not configurable)'), findsOneWidget);
      // Verified prerequisite grants chips
      expect(find.text('viewCalendar'), findsOneWidget);
      expect(find.text('selectRestaurant'), findsOneWidget);

      // Tap close button pops dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(FamilyPermissionInfoDialog), findsNothing);
    });

    testWidgets('FamilyPermissionRow renders non-configurable permission as fixed badge, not switch', (tester) async {
      const permission = FamilyPermissionItemEntity(
        key: 'viewProgram',
        label: 'View Program',
        value: true,
        labelAr: 'عرض البرنامج',
        labelEn: 'View Program',
        isSupported: true,
        isManagerConfigurable: false,
      );

      await tester.pumpWidget(
        buildLocalizedApp(
          const FamilyPermissionRow(
            permission: permission,
            value: true,
          ),
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      // No Switch should be present for non-configurable items
      expect(find.byType(Switch), findsNothing);
      // Enabled badge is present
      expect(find.text('Enabled'), findsOneWidget);
      // Info icon is present
      expect(find.byIcon(Icons.info_outline), findsOneWidget);

      // Tapping info icon opens dialog
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();
      expect(find.byType(FamilyPermissionInfoDialog), findsOneWidget);
    });
  });

  group('Task 5: Versioned Permission Updates and Conflict Handling Tests', () {
    test('Update request builds nullable patch with changed keys only and omits unchanged keys', () {
      const request = UpdateFamilyMemberPermissionsRequestDto(
        expectedVersion: 4,
        patch: {
          'editDailyMeals': true,
          'viewInvoices': false,
        },
      );

      final json = request.toJson();
      expect(json['expectedVersion'], 4);
      expect(json['editDailyMeals'], true);
      expect(json['viewInvoices'], false);

      // Unchanged keys must NOT be present in json
      expect(json.containsKey('changePassword'), isFalse);
      expect(json.containsKey('viewProgram'), isFalse);
      expect(json.containsKey('editAddress'), isFalse);

      // Obsolete keys must NEVER be present
      expect(json.containsKey('changeProgram'), isFalse);
      expect(json.containsKey('changeDeliveryTime'), isFalse);
    });

    test('ViewModel savePermissions emits conflict and re-fetches catalog on 409 conflict', () async {
      final mockGetDetail = FakeGetDetail();
      final mockGetAccess = FakeGetAccess();
      final mockUpdateAccess = FakeUpdateAccess();
      final mockGetPermissions = FakeGetPermissions();
      final mockUpdatePermissions = FakeUpdatePermissions();
      final mockUpdateBasicInfo = FakeUpdateBasicInfo();
      final mockRenew = FakeRenewSubscription();

      const initialPermissions = FamilyMemberPermissionsEntity(
        memberId: 'mem-101',
        version: 2,
        values: {
          'viewCalendar': false,
          'editDailyMeals': false,
        },
        groups: [
          FamilyPermissionGroupEntity(
            code: 'general',
            label: 'General',
            permissions: [
              FamilyPermissionItemEntity(
                key: 'viewCalendar',
                label: 'View Calendar',
                value: false,
              ),
              FamilyPermissionItemEntity(
                key: 'editDailyMeals',
                label: 'Edit Daily Meals',
                value: false,
              ),
            ],
          ),
        ],
      );

      const refreshedPermissions = FamilyMemberPermissionsEntity(
        memberId: 'mem-101',
        version: 3,
        values: {
          'viewCalendar': true,
          'editDailyMeals': false,
        },
        groups: [
          FamilyPermissionGroupEntity(
            code: 'general',
            label: 'General',
            permissions: [
              FamilyPermissionItemEntity(
                key: 'viewCalendar',
                label: 'View Calendar',
                value: true,
              ),
            ],
          ),
        ],
      );

      mockGetPermissions.onCall = () => const ApiSuccessResult(data: refreshedPermissions);

      mockUpdatePermissions.onCall = (req) => ApiErrorResult(
        failure: FamilyManagementFailure(
          errorMessage: 'Permissions were updated by another session',
          code: 'family.permissions_changed',
          statusCode: 409,
          isPermissionConflict: true,
        ),
      );

      final viewModel = FamilyMemberViewModel(
        mockGetDetail,
        mockGetAccess,
        mockUpdateAccess,
        mockGetPermissions,
        mockUpdatePermissions,
        mockUpdateBasicInfo,
        mockRenew,
      );

      // Pre-seed state with initial permissions
      viewModel.emit(
        viewModel.state.copyWith(
          permissions: initialPermissions,
          permissionValues: {
            'viewCalendar': true, // Changed from false to true
            'editDailyMeals': false,
          },
        ),
      );

      // Trigger update
      viewModel.doIntent(
        const UpdateFamilyMemberPermissionsEvent('mem-101', locale: 'en'),
      );

      await pumpEventQueue();

      // Verified update was called with expectedVersion = 2 and changed key
      expect(mockUpdatePermissions.callCount, 1);
      final sentRequest = mockUpdatePermissions.lastRequest!;
      expect(sentRequest.expectedVersion, 2);
      expect(sentRequest.patch['viewCalendar'], true);
      expect(sentRequest.patch.containsKey('editDailyMeals'), isFalse);

      // Verified that on 409 conflict, permissions are re-fetched from server
      expect(mockGetPermissions.callCount, 1);

      // Verified state has refreshed permissions and discarded stale toggle
      expect(viewModel.state.permissions?.version, 3);
      expect(viewModel.state.permissionValues['viewCalendar'], true);
      expect(viewModel.state.saveFailure, isNotNull);
      final failure = viewModel.state.saveFailure as FamilyManagementFailure;
      expect(failure.isPermissionConflict, isTrue);

      viewModel.close();
    });
  });
}
