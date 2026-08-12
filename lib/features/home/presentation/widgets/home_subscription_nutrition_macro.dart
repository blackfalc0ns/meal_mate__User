import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/home/presentation/widgets/home_subscription_progress_painter.dart';

class HomeSubscriptionNutritionMacro extends StatelessWidget {
  const HomeSubscriptionNutritionMacro({
    required this.width,
    required this.label,
    required this.value,
    required this.goal,
    required this.progressColor,
    super.key,
  });

  final double width;
  final String label;
  final String value;
  final String goal;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return SizedBox(
      width: width,
      height: 75,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SizedBox(
            width: width,
            height: Spacing.homeNutritionMacroLabelHeight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurface,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.homeNutritionMacroValueTop,
            child: SizedBox(
              width: width,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size15,
                    color: color.onSurface,
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.homeNutritionMacroGoalTop,
            child: SizedBox(
              width: width,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  goal,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurface,
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: Spacing.homeNutritionMacroRingTop,
            child: SizedBox(
              width: Spacing.homeNutritionMacroRingSize,
              height: Spacing.homeNutritionMacroRingSize,
              child: CustomPaint(
                painter: HomeSubscriptionProgressPainter(
                  progress: Spacing.homeNutritionMacroProgress,
                  trackColor: color.primaryContainer,
                  progressColor: progressColor,
                  strokeWidth: Spacing.homeNutritionMacroStroke,
                  gapAngle: Spacing.homeNutritionMacroGapAngle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
