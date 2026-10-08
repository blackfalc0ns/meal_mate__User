import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CallingActiveControlButton extends StatelessWidget {
  const CallingActiveControlButton({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: Spacing.callingActionSmallButtonSize,
            height: Spacing.callingActionSmallButtonSize,
            decoration: BoxDecoration(
              color: isActive ? color.callActionIcon : color.callActionBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              iconAsset,
              width: Spacing.callingActionSmallButtonIconSize,
              height: Spacing.callingActionSmallButtonIconSize,
              colorFilter: ColorFilter.mode(
                isActive ? color.callWhite : color.callActionIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.callBlack,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
