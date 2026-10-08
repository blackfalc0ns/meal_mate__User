import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class CallingBackgroundDecoration extends StatelessWidget {
  const CallingBackgroundDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      bottom: Spacing.callingBgDoodleBottom,
      start: Spacing.callingBgDoodleStart,
      child: IgnorePointer(
        child: SvgPicture.asset(
          Assets.callingBgDoodle,
          width: Spacing.callingBgDoodleWidth,
          height: Spacing.callingBgDoodleHeight,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
