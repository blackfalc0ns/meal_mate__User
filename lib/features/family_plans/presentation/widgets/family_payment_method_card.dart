import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';

class FamilyPaymentMethodCard extends StatelessWidget {
  const FamilyPaymentMethodCard({
    super.key,
    required this.method,
    this.onTap,
  });

  final FamilyPaymentMethodUiModel method;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      button: true,
      selected: method.selected,
      label: method.label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: Spacing.familyPaymentMethodHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: method.selected
                ? color.primary.withValues(alpha: 0.05)
                : color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.familySetupMemberCardRadius,
            ),
            border: Border.all(
              color: method.selected ? color.primary : color.outlineVariant,
              width: method.selected ? 1.5 : 1.0,
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
                child: _buildIcon(context, locale.family_payment_method_title),
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
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, String semanticLabel) {
    final color = context.colorScheme;
    if (method.imageAsset.endsWith('.svg')) {
      return SvgPicture.asset(
        method.imageAsset,
        semanticsLabel: semanticLabel,
      );
    }
    if (method.imageAsset.isNotEmpty) {
      return Image.asset(method.imageAsset, fit: BoxFit.contain);
    }
    return Icon(
      Icons.credit_card_rounded,
      color: method.selected ? color.primary : color.onSurfaceVariant,
      size: 20,
    );
  }
}
