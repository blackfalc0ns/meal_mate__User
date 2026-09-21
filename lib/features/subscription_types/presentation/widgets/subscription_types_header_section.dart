import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class SubscriptionTypesHeaderSection extends StatelessWidget {
  const SubscriptionTypesHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        const Center(
          child: AppLogo(
            size: Spacing.subscriptionTypeLogoHeight,
            alignment: CrossAxisAlignment.center,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            Spacing.subscriptionProgramCardRadius,
          ),
          child: Image.asset(
            width: double.infinity,
            height: 130,
            Assets.subscriptionTypeHero,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          locale.subscription_type_title,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size20,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          locale.subscription_type_subtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: getRegularStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
