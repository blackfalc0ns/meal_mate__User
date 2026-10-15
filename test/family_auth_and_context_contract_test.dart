import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/auth/data/models/response/login_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_entity.dart';
import 'package:meal_meat_user/features/family_context/data/models/response/family_context_response_dto.dart';
import 'package:meal_meat_user/features/family_context/data/mapper/family_context_mapper.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_capability_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_state.dart';

void main() {
  group('Task 2: Authentication and Family Context Contract Tests', () {
    test('Login result exposes challenge fields without treating challenge tokens as bearer tokens', () {
      final json = {
        'userId': 'usr-123',
        'email': 'member@family.test',
        'phoneNumber': '+96590000001',
        'fullName': 'Family Member',
        'userType': 'Customer',
        'accountStatus': 'Active',
        'roles': ['Customer'],
        'permissions': <String>[],
        'accessToken': null,
        'accessTokenExpiresAtUtc': null,
        'refreshToken': null,
        'refreshTokenExpiresAtUtc': null,
        'nextStep': 'family_verify_otp',
        'loginChallengeToken': 'challenge-token-xyz',
        'loginChallengeExpiresAtUtc': '2026-10-15T10:00:00Z',
        'recoveryCodes': <String>[],
        'isAuthenticated': false,
      };

      final dto = LoginResponseDto.fromJson(json);
      expect(dto.isAuthenticated, isFalse);
      expect(dto.accessToken, isNull);
      expect(dto.refreshToken, isNull);
      expect(dto.loginChallengeToken, 'challenge-token-xyz');
      expect(dto.nextStep, 'family_verify_otp');
      expect(dto.loginChallengeExpiresAtUtc, '2026-10-15T10:00:00Z');

      final entity = LoginEntity(
        userId: dto.userId ?? '',
        email: dto.email,
        phoneNumber: dto.phoneNumber ?? '',
        fullName: dto.fullName ?? '',
        userType: 'Customer',
        accountStatus: 'Active',
        restaurantId: dto.restaurantId,
        roles: dto.roles ?? const [],
        permissions: dto.permissions ?? const [],
        accessToken: dto.accessToken,
        accessTokenExpiresAtUtc: dto.accessTokenExpiresAtUtc,
        refreshToken: dto.refreshToken,
        refreshTokenExpiresAtUtc: dto.refreshTokenExpiresAtUtc,
        nextStep: dto.nextStep,
        loginChallengeToken: dto.loginChallengeToken,
        loginChallengeExpiresAtUtc: dto.loginChallengeExpiresAtUtc,
        recoveryCodes: dto.recoveryCodes ?? const [],
        isAuthenticated: dto.isAuthenticated ?? false,
      );

      expect(entity.isPendingFamilyFirstLogin, isTrue);
      expect(entity.isAuthenticated, isFalse);
    });

    test('FamilyContextResponseDto and Entity expose all required contract fields', () {
      final json = {
        'groupId': 'group-1',
        'isManager': true,
        'memberId': 'mem-1',
        'memberSubscriptionId': null, // null subscription ID supported
        'isDetachedFromFamilyManagement': false,
        'setupStatus': 'Ready',
        'hasSeparateAccount': true,
        'isPaused': false,
        'requiresPasswordSetup': false,
        'accessStatus': 'Enabled',
        'capabilities': [
          {
            'action': 'viewCalendar',
            'allowed': true,
            'reasonCode': null,
            'requiredPermission': null,
          },
          {
            'action': 'selectRestaurant',
            'allowed': false,
            'reasonCode': 'permission_required',
            'requiredPermission': 'selectRestaurant',
          },
        ],
      };

      final dto = FamilyContextResponseDto.fromJson(json);
      expect(dto.groupId, 'group-1');
      expect(dto.isManager, isTrue);
      expect(dto.memberId, 'mem-1');
      expect(dto.memberSubscriptionId, isNull);
      expect(dto.isDetachedFromFamilyManagement, isFalse);
      expect(dto.setupStatus, 'Ready');
      expect(dto.hasSeparateAccount, isTrue);
      expect(dto.isPaused, isFalse);
      expect(dto.requiresPasswordSetup, isFalse);
      expect(dto.accessStatus, 'Enabled');
      expect(dto.capabilities?.length, 2);

      final entity = dto.toEntity();
      expect(entity.groupId, 'group-1');
      expect(entity.isManager, isTrue);
      expect(entity.memberId, 'mem-1');
      expect(entity.memberSubscriptionId, isNull);
      expect(entity.isDetachedFromFamilyManagement, isFalse);
      expect(entity.setupStatus, 'Ready');
      expect(entity.hasSeparateAccount, isTrue);
      expect(entity.isPaused, isFalse);
      expect(entity.requiresPasswordSetup, isFalse);
      expect(entity.accessStatus, 'Enabled');
      expect(entity.can('viewCalendar'), isTrue);
      expect(entity.can('selectRestaurant'), isFalse);
    });

    test('FamilyContextState preserves multiple contexts, paused, and detached contexts', () {
      final activeMgr = const FamilyContextEntity(
        groupId: 'grp-1',
        isManager: true,
        memberId: 'mem-mgr',
        memberSubscriptionId: 'sub-mgr',
        setupStatus: 'Ready',
        isPaused: false,
        isDetachedFromFamilyManagement: false,
        accessStatus: 'Active',
      );

      final pausedMember = const FamilyContextEntity(
        groupId: 'grp-2',
        isManager: false,
        memberId: 'mem-paused',
        memberSubscriptionId: 'sub-paused',
        setupStatus: 'Ready',
        isPaused: true,
        isDetachedFromFamilyManagement: false,
        accessStatus: 'Paused',
      );

      final detachedMember = const FamilyContextEntity(
        groupId: 'grp-3',
        isManager: false,
        memberId: 'mem-detached',
        memberSubscriptionId: 'sub-detached',
        setupStatus: 'Ready',
        isPaused: false,
        isDetachedFromFamilyManagement: true,
        accessStatus: 'Detached',
      );

      final state = FamilyContextState(
        contexts: [activeMgr, pausedMember, detachedMember],
      );

      // Verify that paused/detached contexts are preserved in state, not invalidated
      expect(state.contexts.length, 3);
      expect(state.hasManagerContext, isTrue);
      expect(state.isMember, isTrue);
      expect(state.activeContexts.length, 1);
      expect(state.activeContexts.first.groupId, 'grp-1');
      expect(state.pausedContexts.length, 1);
      expect(state.pausedContexts.first.groupId, 'grp-2');
      expect(state.detachedContexts.length, 1);
      expect(state.detachedContexts.first.groupId, 'grp-3');
    });

    test('Navigation derivation uses server-derived role and capabilities, never prompts user', () {
      // Scenario A: pure manager
      final managerContext = const FamilyContextEntity(
        groupId: 'grp-1',
        isManager: true,
        memberId: 'mem-1',
        capabilities: [
          FamilyCapabilityEntity(action: 'manageFamily', allowed: true),
        ],
      );
      final managerState = FamilyContextState(contexts: [managerContext]);
      expect(managerState.hasManagerContext, isTrue);
      expect(managerState.can('manageFamily'), isTrue);

      // Scenario B: pure member with viewCalendar capability only
      final memberContext = const FamilyContextEntity(
        groupId: 'grp-1',
        isManager: false,
        memberId: 'mem-2',
        memberSubscriptionId: 'sub-2',
        capabilities: [
          FamilyCapabilityEntity(action: 'viewCalendar', allowed: true),
          FamilyCapabilityEntity(action: 'editDailyMeals', allowed: false),
        ],
      );
      final memberState = FamilyContextState(contexts: [memberContext]);
      expect(memberState.hasManagerContext, isFalse);
      expect(memberState.isMember, isTrue);
      expect(memberState.can('viewCalendar'), isTrue);
      expect(memberState.can('editDailyMeals'), isFalse);
    });
  });
}
