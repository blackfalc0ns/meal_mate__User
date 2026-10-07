import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class ProfileFaqItem extends StatelessWidget {
  const ProfileFaqItem({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: isExpanded
              ? color.primary.withValues(alpha: 0.3)
              : color.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: isExpanded ? color.primary : color.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Spacing.iconMd,
                        color: isExpanded
                            ? color.primary
                            : color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: Spacing.sm),
                  const Divider(height: 1),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    answer,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
