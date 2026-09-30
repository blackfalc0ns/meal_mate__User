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
            textAlign: TextAlign.start,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size17,
              color: color.onSurface,
            ),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Container(
          height: Spacing.subscriptionProgramCardHeight,
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      locale.subscription_selected_program_label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      program.name(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size15,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      program.description(locale.localeName),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurfaceVariant,
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
}
