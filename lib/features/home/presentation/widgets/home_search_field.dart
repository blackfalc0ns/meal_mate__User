import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Container(
      height: Spacing.homeSearchHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.homeSearchRadius),
        border: Border.all(color: color.outline),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.homeSearchLine,
            width: Spacing.homeSearchIconSize,
            height: Spacing.homeSearchIconSize,
          ),
          const SizedBox(width: Spacing.sm),

          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                locale.home_search_hint,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
