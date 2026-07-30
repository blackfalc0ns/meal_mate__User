import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeShortcuts extends StatelessWidget {
  const HomeShortcuts({super.key});
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    const entries = [
      (Icons.card_giftcard_rounded, 'العروض'),
      (Icons.eco_rounded, 'الحساسية'),
      (Icons.workspace_premium_rounded, 'اشتراكي'),
      (Icons.calendar_month_rounded, 'وجباتي'),
    ];
    return SizedBox(
      height: Spacing.homeShortcutHeight,
      child: Row(
        children: entries
            .map(
              (entry) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(entry.$1, color: color.primary),
                        Text(
                          entry.$2,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
