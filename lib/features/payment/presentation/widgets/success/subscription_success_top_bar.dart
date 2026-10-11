import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

/// Top bar implementing PreferredSizeWidget as an AppBar with leading NotificationButton, centered AppLogo, and trailing close button.
class SubscriptionSuccessTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SubscriptionSuccessTopBar({
    super.key,
    this.onNotificationPressed,
    this.onClosePressed,
  });

  final VoidCallback? onNotificationPressed;
  final VoidCallback? onClosePressed;

  @override
  Size get preferredSize => const Size.fromHeight(Spacing.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: Spacing.zero,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const AppLogo(
        size: Spacing.xxl,
        alignment: CrossAxisAlignment.center,
      ),
      leadingWidth: Spacing.screenH + Spacing.avatarSm + Spacing.unit,

      actions: const [NotificationButton()],
    );
  }
}
