import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/usecase/get_my_family_contexts_usecase.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/detach_family_member_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_state.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_view_model.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/screens/family_member_detail_screen.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class _FakeDetachMemberUseCase implements DetachFamilyMemberUseCase {
  int callCount = 0;
  List<String> detachedMemberIds = [];
  ApiResult<void>? result;

  @override
  Future<ApiResult<void>> call(String memberId) async {
    callCount++;
    detachedMemberIds.add(memberId);
    return result ?? const ApiSuccessResult(data: null);
  }
}

class _FakeGetMyFamilyContextsUseCase implements GetMyFamilyContextsUseCase {
  int callCount = 0;
  List<FamilyContextEntity> contexts = [];

  @override
  Future<ApiResult<List<FamilyContextEntity>>> call() async {
    callCount++;
    return ApiSuccessResult(data: contexts);
  }
}

class _FakeGetFamilyMemberDetailUseCase implements GetFamilyMemberDetailUseCase {
  FamilyMemberDetailEntity? detail;

  @override
  Future<ApiResult<FamilyMemberDetailEntity>> call(String memberId, {String? locale}) async {
    return ApiSuccessResult(
      data: detail ??
          FamilyMemberDetailEntity(
            memberId: memberId,
            displayName: 'Test Member',
            role: 2,
            ageYears: 25,
            isPaused: false,
            subscriptionId: 'sub-123',
            programName: 'Weight Loss',
            remainingDays: 20,
            setupStatus: 3,
            canRenew: true,
            hasSeparateAccount: true,
          ),
    );
  }
}

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ar')],
    locale: const Locale('en'),
    home: child,
  );
}

void main() {
  group('Task 8: Detachment and Post-Detachment Authorization Tests', () {
    test('Detachment is blocked when financial intent is pending', () async {
      final fakeDetach = _FakeDetachMemberUseCase();
      final vm = FamilyMemberViewModel(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        fakeDetach,
      );

      vm.emit(
        const FamilyMemberState(
          detail: FamilyMemberDetailEntity(
            memberId: 'mem-pending',
            displayName: 'Pending Member',
            role: 2,
            ageYears: 20,
            isPaused: false,
            subscriptionId: 'sub-1',
            programName: 'Keto',
            remainingDays: 10,
            setupStatus: 3,
            canRenew: true,
            hasSeparateAccount: true,
            checkoutSelected: true,
            paymentStatus: 'pending',
          ),
        ),
      );

      vm.doIntent(const DetachFamilyMemberEvent('mem-pending'));
      await pumpEventQueue();

      expect(fakeDetach.callCount, equals(0));
      expect(vm.state.saveFailure, isNotNull);
      expect(vm.state.saveFailure!.code, equals('family.detach_blocked_financial_intent'));
      expect(vm.state.isDetached, isFalse);
    });

    test('Detachment is blocked when member does not have active account login setup', () async {
      final fakeDetach = _FakeDetachMemberUseCase();
      final vm = FamilyMemberViewModel(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        fakeDetach,
      );

      vm.emit(
        const FamilyMemberState(
          detail: FamilyMemberDetailEntity(
            memberId: 'mem-no-login',
            displayName: 'No Login Member',
            role: 2,
            ageYears: 20,
            isPaused: false,
            subscriptionId: 'sub-1',
            programName: 'Keto',
            remainingDays: 10,
            setupStatus: 1,
            canRenew: false,
            hasSeparateAccount: false,
          ),
          access: FamilyMemberAccessEntity(
            memberId: 'mem-no-login',
            hasSeparateAccount: false,
            isPaused: false,
            hasExistingLogin: false,
          ),
        ),
      );

      vm.doIntent(const DetachFamilyMemberEvent('mem-no-login'));
      await pumpEventQueue();

      expect(fakeDetach.callCount, equals(0));
      expect(vm.state.saveFailure, isNotNull);
      expect(vm.state.saveFailure!.code, equals('family.detach_requires_active_account'));
      expect(vm.state.isDetached, isFalse);
    });

    test('Successful detachment calls detachMember and triggers context refresh', () async {
      final fakeDetach = _FakeDetachMemberUseCase();
      final fakeContexts = _FakeGetMyFamilyContextsUseCase();
      final contextVm = FamilyContextViewModel(fakeContexts);

      if (getIt.isRegistered<FamilyContextViewModel>()) {
        getIt.unregister<FamilyContextViewModel>();
      }
      getIt.registerSingleton<FamilyContextViewModel>(contextVm);

      final vm = FamilyMemberViewModel(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        fakeDetach,
      );

      vm.emit(
        const FamilyMemberState(
          detail: FamilyMemberDetailEntity(
            memberId: 'mem-valid',
            displayName: 'Valid Member',
            role: 2,
            ageYears: 20,
            isPaused: false,
            subscriptionId: 'sub-1',
            programName: 'Keto',
            remainingDays: 10,
            setupStatus: 3,
            canRenew: true,
            hasSeparateAccount: true,
          ),
          access: FamilyMemberAccessEntity(
            memberId: 'mem-valid',
            hasSeparateAccount: true,
            isPaused: false,
            hasExistingLogin: true,
          ),
        ),
      );

      vm.doIntent(const DetachFamilyMemberEvent('mem-valid'));
      await pumpEventQueue();

      expect(fakeDetach.callCount, equals(1));
      expect(fakeDetach.detachedMemberIds.first, equals('mem-valid'));
      expect(vm.state.isDetached, isTrue);
      expect(vm.state.saveSuccessCount, equals(1));
      expect(fakeContexts.callCount, equals(1));

      getIt.unregister<FamilyContextViewModel>();
    });

    test('Detachment is idempotent and can be safely retried', () async {
      final fakeDetach = _FakeDetachMemberUseCase();
      final vm = FamilyMemberViewModel(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        fakeDetach,
      );

      vm.emit(
        const FamilyMemberState(
          detail: FamilyMemberDetailEntity(
            memberId: 'mem-idempotent',
            displayName: 'Idempotent Member',
            role: 2,
            ageYears: 20,
            isPaused: false,
            subscriptionId: 'sub-1',
            programName: 'Keto',
            remainingDays: 10,
            setupStatus: 3,
            canRenew: true,
            hasSeparateAccount: true,
            accessStatus: 'detached',
          ),
          isDetached: true,
        ),
      );

      vm.doIntent(const DetachFamilyMemberEvent('mem-idempotent'));
      await pumpEventQueue();

      expect(fakeDetach.callCount, equals(1));
      expect(vm.state.isDetached, isTrue);
    });

    test('Historical and detached contexts coexist and preserve member ownership', () {
      const activeContext = FamilyContextEntity(
        groupId: 'grp-1',
        isManager: true,
        memberId: 'mem-mgr',
        memberSubscriptionId: 'sub-mgr',
        isDetachedFromFamilyManagement: false,
        setupStatus: 'Ready',
        hasSeparateAccount: true,
        isPaused: false,
        requiresPasswordSetup: false,
        accessStatus: 'active',
        capabilities: [
          FamilyCapabilityEntity(action: 'viewCalendar', allowed: true),
          FamilyCapabilityEntity(action: 'editDailyMeals', allowed: true),
        ],
      );

      const detachedContext = FamilyContextEntity(
        groupId: 'grp-1',
        isManager: false,
        memberId: 'mem-detached',
        memberSubscriptionId: 'sub-member-retained',
        isDetachedFromFamilyManagement: true,
        setupStatus: 'Ready',
        hasSeparateAccount: true,
        isPaused: false,
        requiresPasswordSetup: false,
        accessStatus: 'detached',
        capabilities: [
          FamilyCapabilityEntity(action: 'viewCalendar', allowed: true),
          FamilyCapabilityEntity(action: 'editDailyMeals', allowed: true),
          FamilyCapabilityEntity(action: 'confirmMeals', allowed: true),
        ],
      );

      expect(detachedContext.isDetachedFromFamilyManagement, isTrue);
      expect(detachedContext.memberSubscriptionId, equals('sub-member-retained'));
      expect(
        detachedContext.capabilities.any((c) => c.action == 'confirmMeals'),
        isTrue,
      );
      expect(activeContext.isDetachedFromFamilyManagement, isFalse);
    });
  });

  group('Task 8: UI Gating for Detached Members', () {
    testWidgets('Former manager sees read-only info and blocked controls for detached member', (tester) async {
      final fakeDetail = _FakeGetFamilyMemberDetailUseCase();
      fakeDetail.detail = const FamilyMemberDetailEntity(
        memberId: 'mem-detached-ui',
        displayName: 'Detached Member',
        role: 2,
        ageYears: 28,
        isPaused: false,
        subscriptionId: 'sub-detached',
        programName: 'Healthy Diet',
        remainingDays: 15,
        setupStatus: 3,
        canRenew: true,
        accessStatus: 'detached',
        hasSeparateAccount: true,
      );

      if (getIt.isRegistered<FamilyMemberViewModel>()) {
        getIt.unregister<FamilyMemberViewModel>();
      }
      getIt.registerFactory<FamilyMemberViewModel>(
        () => FamilyMemberViewModel(fakeDetail),
      );

      final summary = const FamilyMemberSummaryEntity(
        memberId: 'mem-detached-ui',
        displayName: 'Detached Member',
        role: 2,
        ageYears: 28,
        isPaused: false,
        subscriptionId: 'sub-detached',
        programName: 'Healthy Diet',
        remainingDays: 15,
        setupStatus: 3,
        accessStatus: 'detached',
      );

      await tester.pumpWidget(
        _wrap(
          FamilyMemberDetailScreen(
            member: summary,
          ),
        ),
      );
      // Pump frame without pumpAndSettle to avoid any animation loop
      await tester.pump(const Duration(milliseconds: 100));

      // Detached label is shown
      expect(find.text('Detached'), findsOneWidget);

      // Detach icon button is hidden
      expect(find.byIcon(Icons.link_off_outlined), findsNothing);

      // Edit info icon button is hidden
      expect(find.byIcon(Icons.edit_outlined), findsNothing);

      // Permissions shortcut tile is hidden
      expect(find.text('Permissions'), findsNothing);

      // Read-only info remains visible
      expect(find.text('Detached Member'), findsWidgets);
      expect(find.text('Healthy Diet'), findsOneWidget);
    });
  });
}
