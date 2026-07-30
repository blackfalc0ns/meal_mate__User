import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionInfoNote extends StatelessWidget {
  const SubscriptionInfoNote({
    super.key,
    required this.text,
    required this.highlightedText,
  });

  final String text;
  final String highlightedText;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
      child: Container(
        height: Spacing.subscriptionInfoHeight,
        decoration: BoxDecoration(
          color: color.tertiaryContainer,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            const SizedBox(width: Spacing.md),
            Icon(
              Icons.info_outline_rounded,
              color: color.onTertiaryContainer,
              size: 20,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ).copyWith(height: 1.55),
                  children: [
                    TextSpan(text: text.split(highlightedText).first),
                    TextSpan(
                      text: highlightedText,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        color: color.primary,
                      ),
                    ),
                    TextSpan(
                      text: text.contains(highlightedText)
                          ? text.split(highlightedText).last
                          : '',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 76,
              height: Spacing.subscriptionInfoHeight,
              child: Image.asset(
                Assets.subscriptionNoteMeal,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
