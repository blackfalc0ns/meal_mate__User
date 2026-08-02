import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';

class FamilyPaymentMethodCard extends StatelessWidget {
  const FamilyPaymentMethodCard({super.key, required this.method});

  final FamilyPaymentMethodFakeData method;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.familyPaymentMethodHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familySetupMemberCardRadius,
        ),
        border: Border.all(
          color: method.selected ? color.primary : color.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.sm),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Spacing.familyPaymentMethodAssetWidth,
            height: Spacing.familyPaymentMethodAssetHeight,
            child: method.imageAsset.endsWith('.svg')
                ? SvgPicture.asset(
                    method.imageAsset,
                    semanticsLabel: locale.family_payment_method_title,
                  )
                : Image.asset(method.imageAsset, fit: BoxFit.contain),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            method.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size8,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
