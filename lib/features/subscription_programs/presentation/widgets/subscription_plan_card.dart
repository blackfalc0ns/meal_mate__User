import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    this.onTap,
  });

  final SubscriptionPlanEntity plan;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;

    return Material(
      color: color.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: Spacing.subscriptionPlanCardWidth,
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: plan.gradientColors,
              stops: const [0, 0.85, 1],
            ),
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
            border: Border.all(
              color: isSelected
                  ? plan.accentColor
                  : color.shadow.withValues(alpha: 0.03),
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: isSelected ? 0.10 : 0.04),
                offset: const Offset(0, 8),
                blurRadius: isSelected ? 18 : 12,
              ),
            ],
          ),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: _DiscountBadge(plan: plan),
              ),
              SizedBox(
                height: Spacing.subscriptionPlanImageHeight,
                child: Image.asset(plan.imageAsset, fit: BoxFit.contain),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                plan.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size15,
                  color: plan.accentColor,
                ),
              ),
              const SizedBox(height: Spacing.xss),
              _FeatureLine(
                icon: Icons.calendar_month_outlined,
                text: plan.duration,
              ),
              _FeatureLine(
                icon: Icons.restaurant_rounded,
                text: plan.mealsPerDay,
              ),
              _FeatureLine(icon: Icons.eco_rounded, text: plan.description),
              _FeatureLine(
                icon: Icons.local_shipping_outlined,
                text: plan.delivery,
              ),
              // const Spacer(),
              Divider(height: 7, color: color.outlineVariant),
              Text(
                '${plan.originalPrice} ${l10n.currency}',
                textAlign: TextAlign.center,
                style:
                    getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size8,
                      color: color.onSurfaceVariant,
                    ).copyWith(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: color.error,
                    ),
              ),
              Text(
                '${plan.discountedPrice} ${l10n.currency}',
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size12,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                plan.periodLabel,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size9,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.xss),
              _ChooseButton(color: plan.accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.plan});

  final SubscriptionPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: plan.badgeBackgroundColor,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
      ),
      child: Text(
        plan.discountLabel,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size6,
          color: plan.accentColor,
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: Spacing.xs,
        start: Spacing.md,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 10, color: color.onSurfaceVariant),
          const SizedBox(width: Spacing.xs),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size7,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChooseButton extends StatelessWidget {
  const _ChooseButton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: Spacing.subscriptionChooseButtonWidth,
      height: Spacing.subscriptionChooseButtonHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.20), color],
        ),
        border: Border.all(color: color.withValues(alpha: 0.78), width: 0.8),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        context.localization.subscription_choose_plan_button,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size10,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
