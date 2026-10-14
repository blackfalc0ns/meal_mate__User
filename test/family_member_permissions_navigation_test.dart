import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('member details opens access management before member permissions', () {
    final source = File(
      'lib/features/family_management/member/presentation/screens/'
      'family_member_detail_screen.dart',
    ).readAsStringSync();
    final permissionsShortcutStart = source.indexOf(
      'type: ui.FamilyMemberDetailShortcutType.permissions,',
    );
    final permissionsShortcutEnd = source.indexOf(
      '),\n      ],',
      permissionsShortcutStart,
    );

    expect(permissionsShortcutStart, isNonNegative);
    expect(permissionsShortcutEnd, isNonNegative);

    final permissionsShortcut = source.substring(
      permissionsShortcutStart,
      permissionsShortcutEnd,
    );

    expect(permissionsShortcut, contains('AppRoutes.familyMemberAccess'));
    expect(
      permissionsShortcut,
      isNot(contains('AppRoutes.familyMemberPermissions')),
    );
  });
}
