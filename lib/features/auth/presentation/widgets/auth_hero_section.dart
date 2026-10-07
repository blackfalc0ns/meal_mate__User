import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

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
    final color = context.colorScheme;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = constraints.maxWidth * 0.62;
          final isInlineSubtitle = title.isEmpty;

          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(
              width: contentWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: isInlineSubtitle
                    ? [_buildInlineMealMateText(context, subtitle)]
                    : [
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size20,
                            color: color.onSurface,
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
                                  color: color.onTertiaryContainer,
                                ),
                              ),
                              TextSpan(
                                text: 'Mate',
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size36,
                                  color: color.primary,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          subtitle,
                          textAlign: TextAlign.start,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
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

  Widget _buildInlineMealMateText(BuildContext context, String text) {
    final color = context.colorScheme;
    const appName = 'MealMate';
    final appNameStart = text.indexOf(appName);
    final style = getBoldStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: FontSize.size20,
      color: color.onSurface,
    );

    if (appNameStart == -1) {
      return Text(text, textAlign: TextAlign.start, style: style);
    }

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, appNameStart)),
          TextSpan(
            text: 'Meal',
            style: style.copyWith(color: color.onTertiaryContainer),
          ),
          TextSpan(
            text: 'Mate',
            style: style.copyWith(color: color.primary),
          ),
          TextSpan(text: text.substring(appNameStart + appName.length)),
        ],
      ),
      textAlign: TextAlign.start,
    );
  }
}
