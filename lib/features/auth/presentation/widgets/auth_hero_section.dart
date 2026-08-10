import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class AuthHeroSection extends StatelessWidget {
  const AuthHeroSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = constraints.maxWidth * 0.62;
          final isInlineSubtitle = title.isEmpty;

          return Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: contentWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: isInlineSubtitle
                    ? [_buildInlineMealMateText(subtitle)]
                    : [
                        Text(
                          title,
                          textAlign: TextAlign.right,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Meal',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size36,
                                  color: AppColors.logoMeal,
                                ),
                              ),
                              TextSpan(
                                text: 'Mate',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size36,
                                  color: AppColors.logoMate,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          subtitle,
                          textAlign: TextAlign.right,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInlineMealMateText(String text) {
    const appName = 'MealMate';
    final appNameStart = text.indexOf(appName);
    final style = getBoldStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: FontSize.size20,
      color: AppColors.textPrimary,
    );

    if (appNameStart == -1) {
      return Text(text, textAlign: TextAlign.right, style: style);
    }

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, appNameStart)),
          TextSpan(
            text: 'Meal',
            style: style.copyWith(color: AppColors.logoMeal),
          ),
          TextSpan(
            text: 'Mate',
            style: style.copyWith(color: AppColors.logoMate),
          ),
          TextSpan(text: text.substring(appNameStart + appName.length)),
        ],
      ),
      textAlign: TextAlign.right,
    );
  }
}
