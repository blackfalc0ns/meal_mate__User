import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/subscription_plan_entity.dart';

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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 111,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: plan.gradientColors,
              stops: const [0, 0.85, 1],
            ),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: isSelected ? plan.accentColor : const Color(0x08000000),
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.10 : 0.04),
                offset: const Offset(0, 8),
                blurRadius: isSelected ? 18 : 12,
              ),
            ],
          ),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: _DiscountBadge(plan: plan),
              ),
              SizedBox(
                height: 78,
                child: Image.asset(plan.imageAsset, fit: BoxFit.contain),
              ),
              const SizedBox(height: 3),
              Text(
                plan.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 15,
                  color: plan.accentColor,
                ),
              ),
              const SizedBox(height: 5),
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
              const Spacer(),
              const Divider(height: 13, color: Color(0x36C0B8B8)),
              Text(
                '${plan.originalPrice} ${l10n.currency}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 8,
                  color: const Color(0xFF818583),
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.error,
                ),
              ),
              Text(
                '${plan.discountedPrice} ${l10n.currency}',
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 12.2,
                  color: const Color(0xFF1B8E2F),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                plan.periodLabel,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: 9,
                  color: const Color(0xFF555558),
                ),
              ),
              const SizedBox(height: 6),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: plan.badgeBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        plan.discountLabel,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: 6,
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
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 2, start: 12),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 10, color: const Color(0xFF555558)),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size7,
                color: const Color(0xFF555558),
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
    return Container(
      width: 96,
      height: 29,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.20), color],
        ),
        border: Border.all(color: color.withValues(alpha: 0.78), width: 0.8),
        borderRadius: BorderRadius.circular(9),
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
          fontSize: 10,
          color: AppColors.white,
        ),
      ),
    );
  }
}
