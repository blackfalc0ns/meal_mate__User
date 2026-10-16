import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';

void main() {
  test('tracks member deletion independently from general flow loading', () {
    const initial = FamilySubscriptionSetupState();
    final loading = initial.copyWith(
      isDeletingMember: true,
      clearDeleteMemberFailure: true,
      deleteMemberSuccess: false,
    );

    expect(loading.isDeletingMember, isTrue);
    expect(loading.isCurrentFlowLoading, isFalse);
    expect(loading.deleteMemberSuccess, isFalse);

    final failure = Failure(errorMessage: 'failed');
    final failed = loading.copyWith(
      isDeletingMember: false,
      deleteMemberFailure: failure,
    );
    expect(failed.deleteMemberFailure, same(failure));

    final succeeded = failed.copyWith(
      deleteMemberSuccess: true,
      clearDeleteMemberFailure: true,
    );
    expect(succeeded.deleteMemberSuccess, isTrue);
    expect(succeeded.deleteMemberFailure, isNull);
  });
}
