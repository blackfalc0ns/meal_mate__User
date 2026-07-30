import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class AuthFooterAction extends StatelessWidget {
  const AuthFooterAction({
    super.key,
    required this.prompt,
    required this.actionText,
    required this.onTap,
    this.promptColor = AppColors.textPrimary,
    this.actionColor = AppColors.primary,
  });

  final String prompt;
  final String actionText;
  final VoidCallback onTap;
  final Color promptColor;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            prompt,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: promptColor,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: actionColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
