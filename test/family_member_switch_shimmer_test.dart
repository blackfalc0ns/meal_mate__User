import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('package and days keeps members visible while member data shimmers', () {
    final source = File(
      'lib/features/family_package_days/presentation/widgets/'
      'family_package_days_content.dart',
    ).readAsStringSync();

    expect(source, contains('final isMemberSwitchLoading ='));
    expect(source, contains('FamilyPackageDaysMemberSection('));
    expect(source, contains('showSummary: !isMemberSwitchLoading'));
    expect(source, contains('FamilyMemberContentLoadingSkeleton'));
  });

  test('payment keeps members visible while selected summary shimmers', () {
    final source = File(
      'lib/features/family_checkout/presentation/widgets/'
      'family_payment_content.dart',
    ).readAsStringSync();
    final membersSource = File(
      'lib/features/family_checkout/presentation/widgets/'
      'family_payment_members_section.dart',
    ).readAsStringSync();

    expect(source, contains('FamilyPaymentMembersSection(state: state)'));
    expect(source, contains('if (state.isSummaryLoading)'));
    expect(source, contains('FamilyMemberContentLoadingSkeleton'));
    expect(membersSource, contains('onSelectMember: state.isSummaryLoading'));
    expect(membersSource, contains('? null'));
  });
}
