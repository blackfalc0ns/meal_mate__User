import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_incoming_action_button.dart';

class CallingIncomingActions extends StatelessWidget {
  const CallingIncomingActions({
    super.key,
    required this.onAccept,
    required this.onDecline,
  });

  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CallingIncomingActionButton(
          iconAsset: Assets.callAccept,
          label: locale.calling_accept,
          backgroundColor: color.callAccept,
          labelColor: color.callAccept,
          onTap: onAccept,
        ),
        CallingIncomingActionButton(
          iconAsset: Assets.callEnd,
          label: locale.calling_decline,
          backgroundColor: color.callDecline,
          labelColor: color.callDecline,
          onTap: onDecline,
        ),
      ],
    );
  }
}
