import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CallingActiveAddressCard extends StatelessWidget {
  const CallingActiveAddressCard({
    super.key,
    required this.title,
    required this.addressDetails,
  });

  final String title;
  final String addressDetails;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: Spacing.callingAddressCardWidth,
      constraints: const BoxConstraints(
        minHeight: Spacing.callingAddressCardMinHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.callingAddressCardRadius),
        border: Border.all(
          color: color.callCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: color.callShadowSoft,
            offset: const Offset(1, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: color.callShadowSoft,
            offset: const Offset(2, 18),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.callActionIcon,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              SvgPicture.asset(
                Assets.callLocationPin,
                width: Spacing.callingLocationPinSize,
                height: Spacing.callingLocationPinSize,
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            addressDetails,
            style: getLightStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.callBlack,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
