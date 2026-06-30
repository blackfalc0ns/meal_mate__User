import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'الإشعارات',
      child: Tooltip(
        message: 'الإشعارات',
        child: InkResponse(
          onTap: onTap,
          radius: 22,
          child: SizedBox.square(
            dimension: 44,
            child: Center(
              child: SvgPicture.asset(
                Assets.notificationBold,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
