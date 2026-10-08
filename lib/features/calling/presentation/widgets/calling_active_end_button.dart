import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CallingActiveEndButton extends StatelessWidget {
  const CallingActiveEndButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Spacing.callingActiveEndButtonSize,
            height: Spacing.callingActiveEndButtonSize,
            decoration: BoxDecoration(
              color: color.callEnd,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              Assets.callEnd,
              width: Spacing.callingActiveEndButtonIconSize,
              height: Spacing.callingActiveEndButtonIconSize,
              colorFilter: ColorFilter.mode(
                color.callWhite,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.calling_end_call,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.callEnd,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
