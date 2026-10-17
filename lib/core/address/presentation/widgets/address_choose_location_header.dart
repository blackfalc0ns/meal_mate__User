import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AddressChooseLocationHeader extends StatelessWidget {
  const AddressChooseLocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      children: [
        Container(
          width: Spacing.xxl,
          height: Spacing.xxl,
          decoration: BoxDecoration(
            color: color.secondaryContainer,
            borderRadius: BorderRadius.circular(Spacing.sm),
          ),
          child: Center(
            child: SvgPicture.asset(
              Assets.addressesIconHome,
              width: Spacing.iconMd,
              height: Spacing.iconMd,
              colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                locale.addresses_choose_location_title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size15,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                locale.addresses_choose_location_subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
