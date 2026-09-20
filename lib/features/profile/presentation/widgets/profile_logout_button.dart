import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_logout_confirmation_sheet.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({
    super.key,
    required this.onConfirmLogout,
    this.isLoading = false,
  });

  final VoidCallback onConfirmLogout;
  final bool isLoading;

  Future<void> _showConfirmation(BuildContext context) async {
    final confirmed = await context.showAppBottomSheet<bool>(
      builder: (_) => const ProfileLogoutConfirmationSheet(),
    );
    if (confirmed == true && context.mounted) {
      onConfirmLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: double.infinity,
      height: Spacing.profileLogoutHeight,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : () => _showConfirmation(context),
        icon: Icon(Icons.logout_rounded, size: Spacing.lg),
        label: Text(
          locale.drawer_logout,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: Spacing.profileSettingsTitleFontSize,
            color: color.error,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: color.error,
          side: BorderSide(color: color.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Spacing.profileLogoutRadius),
          ),
        ),
      ),
    );
  }
}
