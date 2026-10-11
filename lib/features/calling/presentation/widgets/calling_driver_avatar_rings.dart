import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CallingDriverAvatarRings extends StatelessWidget {
  const CallingDriverAvatarRings({super.key, required this.avatarAsset});

  final String avatarAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      width: Spacing.callingRipple4Size,
      height: Spacing.callingRipple4Size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: Spacing.callingRipple4Size,
            height: Spacing.callingRipple4Size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.callRippleStroke),
            ),
          ),
          Container(
            width: Spacing.callingRipple3Size,
            height: Spacing.callingRipple3Size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.callRippleStroke),
            ),
          ),
          Container(
            width: Spacing.callingRipple2Size,
            height: Spacing.callingRipple2Size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.callRippleStroke),
            ),
          ),
          Container(
            width: Spacing.callingRipple1Size,
            height: Spacing.callingRipple1Size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color.callRippleStroke),
            ),
          ),
          ClipOval(
            child: Image.asset(
              avatarAsset,
              width: Spacing.callingAvatarSize,
              height: Spacing.callingAvatarSize,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
