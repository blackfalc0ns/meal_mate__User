import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class CallingIncomingActionButton extends StatelessWidget {
  const CallingIncomingActionButton({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.backgroundColor,
    required this.labelColor,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final Color backgroundColor;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Spacing.callingActionBigButtonSize,
            height: Spacing.callingActionBigButtonSize,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              iconAsset,
              width: Spacing.callingActionBigButtonIconSize,
              height: Spacing.callingActionBigButtonIconSize,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            label,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: labelColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
