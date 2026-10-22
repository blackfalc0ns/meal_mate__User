import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CompensationCountdownText extends StatelessWidget {
  const CompensationCountdownText({
    super.key,
    required this.seconds,
    required this.enabled,
  });
  final ValueListenable<int> seconds;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return ValueListenableBuilder<int>(
      valueListenable: seconds,
      builder: (context, value, child) {
        final hours = (value ~/ 3600).toString().padLeft(2, '0');
        final minutes = ((value ~/ 60) % 60).toString().padLeft(2, '0');
        final secs = (value % 60).toString().padLeft(2, '0');
        return Text(
          enabled
              ? locale.compensations_remaining('$hours:$minutes:$secs')
              : locale.compensations_waiting_update,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            color: color.onSurface,
          ),
        );
      },
    );
  }
}
