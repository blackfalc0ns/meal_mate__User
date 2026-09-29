import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';

class AddressesAvailabilityNotice extends StatelessWidget {
  const AddressesAvailabilityNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return CustomWarningWidget(
      icon: Icons.info_rounded,
      message: locale.addresses_availability_notice,
      isWarning: true,
      height: Spacing.addressesAvailabilityNoticeHeight,
      backgroundColor: color.secondaryContainer,
      borderColor: color.outlineVariant,
      horizontalPadding: Spacing.md,
      iconSize: Spacing.lg,
      iconTextSpacing: Spacing.sm,
      messageFontSize: FontSize.size12,
      maxMessageLines: 1,
    );
  }
}
