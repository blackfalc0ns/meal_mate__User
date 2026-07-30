import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeReminderCard extends StatelessWidget {
  const HomeReminderCard({
    super.key,
    required this.editLabel,
    required this.title,
    required this.reminder,
    required this.subtitle,
  });
  final String editLabel;
  final String title;
  final String reminder;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.homeHorizontalPadding,
      ),
      child: SizedBox(
        height: Spacing.homeReminderHeight,
        child: Card(
          color: color.secondaryContainer,
          child: Stack(
            children: [
              PositionedDirectional(
                start: Spacing.xxxl,
                child: Image.asset(
                  Assets.homeReminder,
                  height: Spacing.homeReminderHeight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Spacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs,
                      ),
                      color: color.secondary,
                      child: Text(
                        reminder,
                        style: AppTextStyles.overline.copyWith(
                          color: color.onSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      title,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        editLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: color.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
