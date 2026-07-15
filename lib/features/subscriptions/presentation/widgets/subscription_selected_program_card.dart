import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionSelectedProgramCard extends StatelessWidget {
  const SubscriptionSelectedProgramCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
          child: Text(
            locale.subscription_selected_program_label,
            textAlign: TextAlign.right,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size17,
              color: color.onSurface,
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Container(
          height: Spacing.subscriptionProgramCardHeight + Spacing.xs,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.md,
          ),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.subscriptionProgramCardRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.05),
                blurRadius: Spacing.lg,
                offset: const Offset(0, Spacing.xss),
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          width: Spacing.xxl,
                          height: Spacing.xxl,
                          decoration: BoxDecoration(
                            color: color.primaryContainer.withValues(
                              alpha: 0.7,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.monitor_weight_outlined,
                            size: Spacing.iconSm,
                            color: color.primary,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.subscription_selected_program_label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size7,
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                locale.subscription_weight_loss_title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size15,
                                  color: color.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.iconSm + Spacing.sm,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: SizedBox(
                          width: Spacing.xxxl * 2.75,
                          child: Text(
                            locale.subscription_weight_loss_description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: getRegularStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size9,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(
                          Icons.bolt_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          locale.subscription_less_calories,
                          style: getRegularStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size8,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        SizedBox(
                          height: Spacing.base,
                          child: VerticalDivider(
                            width: Spacing.border,
                            color: color.outlineVariant,
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        Icon(
                          Icons.bar_chart_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          locale.subscription_effective_results,
                          style: getRegularStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size8,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.md),
              SizedBox(
                width: Spacing.xxxl * 2,
                height: Spacing.xxxl * 1.72,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.shadow.withValues(alpha: 0.11),
                        blurRadius: Spacing.lg,
                        offset: const Offset(0, Spacing.xs),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      Assets.subscriptionWeightLossProgram,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0.1, 0.32),
                      semanticLabel: locale.subscription_weight_loss_title,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
