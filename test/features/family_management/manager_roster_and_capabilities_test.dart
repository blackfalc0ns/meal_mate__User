import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/screens/family_member_detail_screen.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/screens/family_member_permissions_screen.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/screens/family_home_screen.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/screens/family_members_screen.dart';

Widget _extractPage(Route<dynamic> route) {
  if (route is PageRouteBuilder) {
    return route.pageBuilder(
      FakeBuildContext(),
      const AlwaysStoppedAnimation(1.0),
      const AlwaysStoppedAnimation(1.0),
    );
  }
  if (route is MaterialPageRoute) {
    return route.builder(FakeBuildContext());
  }
  throw UnimplementedError();
}

void main() {
  group('Task 3: Manager routes wiring', () {
    test('routes /family/home and AppRoutes.familyHome to FamilyHomeScreen', () {
      final route1 = RouteGenerator.getRoute(
        const RouteSettings(name: AppRoutes.familyHome),
      );
      expect(_extractPage(route1), isA<FamilyHomeScreen>());

      final route2 = RouteGenerator.getRoute(
        const RouteSettings(name: '/family/home'),
      );
      expect(_extractPage(route2), isA<FamilyHomeScreen>());
    });

    test('routes /family/members and /family/switcher to FamilyMembersScreen', () {
      final route1 = RouteGenerator.getRoute(
        const RouteSettings(name: AppRoutes.familyMembers),
      );
      expect(_extractPage(route1), isA<FamilyMembersScreen>());

      final route2 = RouteGenerator.getRoute(
        const RouteSettings(name: AppRoutes.familySwitcher),
      );
      expect(_extractPage(route2), isA<FamilyMembersScreen>());

      final route3 = RouteGenerator.getRoute(
        const RouteSettings(name: '/family/switcher'),
      );
      expect(_extractPage(route3), isA<FamilyMembersScreen>());
    });

    test('routes /family/members/{memberId} to FamilyMemberDetailScreen carrying memberId', () {
      final route = RouteGenerator.getRoute(
        const RouteSettings(name: '/family/members/mem_456'),
      );
      final page = _extractPage(route);
      expect(page, isA<FamilyMemberDetailScreen>());
      final detailPage = page as FamilyMemberDetailScreen;
      expect(detailPage.member.memberId, 'mem_456');
    });

    test('routes /family/members/{memberId}/capabilities to FamilyMemberPermissionsScreen', () {
      final route = RouteGenerator.getRoute(
        const RouteSettings(name: '/family/members/mem_789/capabilities'),
      );
      final page = _extractPage(route);
      expect(page, isA<FamilyMemberPermissionsScreen>());
      final permPage = page as FamilyMemberPermissionsScreen;
      expect(permPage.memberId, 'mem_789');
    });
  });

  group('Task 3: Selected-member subscription resolution & lifecycle states', () {
    test('resolves effectiveSubscriptionId with current, upcoming, or fallback priority', () {
      // 1. Current subscription has priority
      const detailWithCurrent = FamilyMemberDetailEntity(
        memberId: 'm1',
        displayName: 'Ahmad',
        role: 2,
        ageYears: 20,
        isPaused: false,
        subscriptionId: 'sub_old',
        currentSubscriptionId: 'sub_active_current',
        upcomingSubscriptionId: 'sub_upcoming',
        programName: 'Program 1',
        remainingDays: 10,
        setupStatus: 2,
        canRenew: false,
      );
      expect(detailWithCurrent.effectiveSubscriptionId, 'sub_active_current');

      // 2. Fallback to subscriptionId
      const detailWithSubId = FamilyMemberDetailEntity(
        memberId: 'm2',
        displayName: 'Sara',
        role: 2,
        ageYears: 18,
        isPaused: false,
        subscriptionId: 'sub_standard',
        currentSubscriptionId: null,
        upcomingSubscriptionId: 'sub_upcoming',
        programName: 'Program 2',
        remainingDays: 5,
        setupStatus: 2,
        canRenew: false,
      );
      expect(detailWithSubId.effectiveSubscriptionId, 'sub_standard');

      // 3. Fallback to upcomingSubscriptionId when current/subscriptionId is null
      const detailWithUpcoming = FamilyMemberDetailEntity(
        memberId: 'm3',
        displayName: 'Khaled',
        role: 2,
        ageYears: 15,
        isPaused: false,
        subscriptionId: null,
        currentSubscriptionId: null,
        upcomingSubscriptionId: 'sub_upcoming_only',
        programName: 'Program 3',
        remainingDays: 0,
        setupStatus: 2,
        canRenew: false,
      );
      expect(detailWithUpcoming.effectiveSubscriptionId, 'sub_upcoming_only');

      // 4. Null when all are empty
      const detailWithNone = FamilyMemberDetailEntity(
        memberId: 'm4',
        displayName: 'NoSub',
        role: 2,
        ageYears: 10,
        isPaused: false,
        subscriptionId: null,
        currentSubscriptionId: null,
        upcomingSubscriptionId: null,
        programName: '',
        remainingDays: 0,
        setupStatus: 0,
        canRenew: false,
      );
      expect(detailWithNone.effectiveSubscriptionId, isNull);
    });

    test('distinguishes lifecycle states accurately: setup-required, detached, paused, disabled, and paid-preparing', () {
      // Setup required
      const setupReq = FamilyMemberDetailEntity(
        memberId: 'm1',
        displayName: 'NewMember',
        role: 2,
        ageYears: 12,
        isPaused: false,
        subscriptionId: null,
        programName: '',
        remainingDays: 0,
        setupStatus: 0,
        canRenew: false,
      );
      expect(setupReq.isSetupRequired, isTrue);

      // Paid-preparing calendar
      const paidPreparing = FamilyMemberDetailEntity(
        memberId: 'm2',
        displayName: 'PaidMember',
        role: 2,
        ageYears: 14,
        isPaused: false,
        subscriptionId: null,
        programName: 'Program',
        remainingDays: 0,
        setupStatus: 2,
        canRenew: false,
        paymentStatus: 'Paid',
        fulfillmentStatus: 'Preparing',
      );
      expect(paidPreparing.isPaidPreparingCalendar, isTrue);

      // Detached
      const detached = FamilyMemberDetailEntity(
        memberId: 'm3',
        displayName: 'DetachedMember',
        role: 2,
        ageYears: 22,
        isPaused: false,
        subscriptionId: 'sub_d',
        programName: 'Program',
        remainingDays: 14,
        setupStatus: 2,
        canRenew: false,
        accessStatus: 'Detached',
      );
      expect(detached.isDetached, isTrue);

      // Disabled
      const disabled = FamilyMemberDetailEntity(
        memberId: 'm4',
        displayName: 'DisabledMember',
        role: 2,
        ageYears: 25,
        isPaused: false,
        subscriptionId: 'sub_dis',
        programName: 'Program',
        remainingDays: 10,
        setupStatus: 2,
        canRenew: false,
        accessStatus: 'Disabled',
      );
      expect(disabled.isDisabled, isTrue);

      // Paused
      const paused = FamilyMemberDetailEntity(
        memberId: 'm5',
        displayName: 'PausedMember',
        role: 2,
        ageYears: 30,
        isPaused: true,
        subscriptionId: 'sub_p',
        programName: 'Program',
        remainingDays: 20,
        setupStatus: 2,
        canRenew: false,
      );
      expect(paused.isPaused, isTrue);
    });
  });

  group('Task 3: Sibling read-only & manager roster visibility flags', () {
    test('FamilyMemberSummaryEntity accurately exposes manager vs member and lifecycle flags', () {
      final summaryManager = FamilyMemberSummaryEntity(
        memberId: 'mgr_1',
        displayName: 'Manager Dad',
        role: 1,
        ageYears: 45,
        isPaused: false,
        subscriptionId: 'sub_mgr',
        programName: 'Fit',
        remainingDays: 30,
        setupStatus: 2,
      );
      expect(summaryManager.isManager, isTrue);

      final summarySibling = FamilyMemberSummaryEntity(
        memberId: 'sib_1',
        displayName: 'Child Sibling',
        role: 2,
        ageYears: 12,
        isPaused: false,
        subscriptionId: 'sub_sib',
        programName: 'Kids',
        remainingDays: 15,
        setupStatus: 2,
        paymentStatus: 'Paid',
        fulfillmentStatus: 'Preparing',
      );
      expect(summarySibling.isManager, isFalse);
      expect(summarySibling.isPaidPreparingCalendar, isTrue);
    });
  });
}

class FakeBuildContext extends Fake implements BuildContext {}
