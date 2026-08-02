import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyPaymentNoteCard extends StatelessWidget {
  const FamilyPaymentNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      constraints: const BoxConstraints(
        minHeight: Spacing.familyPaymentNoteHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest.withValues(alpha: 0.18),
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.sm),
      ),
      child: Row(
        children: [
          Transform.rotate(
            angle: -0.18,
            child: Icon(
              Icons.eco_rounded,
              color: color.primary,
              size: Spacing.iconLg,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(
              locale.family_payment_note,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,

              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
