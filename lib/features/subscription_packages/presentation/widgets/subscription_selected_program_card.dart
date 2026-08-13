import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionSelectedProgramCard extends StatelessWidget {
  const SubscriptionSelectedProgramCard({super.key, required this.program});

  final SubscriptionProgramEntity program;

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
              fontFamily: FontConstant.alexandria,
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
                            _badgeIconForProgram(program),
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
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                program.name(locale.localeName),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
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
                        start: Spacing.xxl,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: SizedBox(
                          width: Spacing.xxxl * 2.75,
                          child: Text(
                            program.description(locale.localeName),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.xl,
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Icon(
                            _primaryFeatureIconForProgram(program),
                            size: Spacing.iconSm,
                            color: color.primary,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            _featureAt(program.keywords(locale.localeName), 0),
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
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
                            _secondaryFeatureIconForProgram(program),
                            size: Spacing.iconSm,
                            color: color.primary,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            _featureAt(program.keywords(locale.localeName), 1),
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
                    child: AppCachedNetworkImage(
                      imageUrl: program.imageUrl,
                      shape: BoxShape.circle,
                      fit: BoxFit.cover,
                      semanticLabel: program.name(locale.localeName),
                     
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

  String _featureAt(List<String> keywords, int index) {
    if (index >= keywords.length) return '';
    return keywords[index];
  }

  IconData _badgeIconForProgram(SubscriptionProgramEntity program) {
    return switch (program.code) {
      'PROG_WEIGHT_LOSS' => Icons.monitor_weight_outlined,
      'PROG_MUSCLE_GAIN' => Icons.fitness_center_rounded,
      'PROG_ATHLETE' => Icons.directions_run_rounded,
      'PROG_KETO' => Icons.water_drop_rounded,
      'PROG_BALANCED' => Icons.favorite_border_rounded,
      'PROG_LOW_CARB' => Icons.eco_rounded,
      _ => Icons.restaurant_menu_rounded,
    };
  }

  IconData _primaryFeatureIconForProgram(SubscriptionProgramEntity program) {
    return switch (program.code) {
      'PROG_WEIGHT_LOSS' => Icons.bar_chart_rounded,
      'PROG_BALANCED' => Icons.eco_rounded,
      'PROG_ATHLETE' => Icons.bolt_rounded,
      _ => Icons.bolt_rounded,
    };
  }

  IconData _secondaryFeatureIconForProgram(SubscriptionProgramEntity program) {
    return switch (program.code) {
      'PROG_MUSCLE_GAIN' => Icons.sync_rounded,
      'PROG_ATHLETE' => Icons.sync_rounded,
      'PROG_LOW_CARB' => Icons.tune_rounded,
      _ => Icons.my_location_rounded,
    };
  }
}
