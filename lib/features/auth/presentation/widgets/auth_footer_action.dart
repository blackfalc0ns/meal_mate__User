import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AuthFooterAction extends StatelessWidget {
  const AuthFooterAction({
    super.key,
    required this.prompt,
    required this.actionText,
    required this.onTap,
    this.promptColor,
    this.actionColor,
  });

  final String prompt;
  final String actionText;
  final VoidCallback onTap;
  final Color? promptColor;
  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final resolvedPromptColor = promptColor ?? color.onSurface;
    final resolvedActionColor = actionColor ?? color.primary;

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Spacing.xs,
        children: [
          Text(
            prompt,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: resolvedPromptColor,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: resolvedActionColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
