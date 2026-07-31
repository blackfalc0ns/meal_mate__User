import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
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
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size8,
                          color: color.onSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Semantics(
                        label: locale.home_edit_meals,
                        button: true,
                        child: Text(
                          editLabel,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size10,
                            color: color.primary,
                          ),
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
