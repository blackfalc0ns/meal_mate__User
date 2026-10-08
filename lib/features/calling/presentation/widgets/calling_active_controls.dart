import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_control_button.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_end_button.dart';

class CallingActiveControls extends StatelessWidget {
  const CallingActiveControls({
    super.key,
    required this.isMuted,
    required this.isSpeakerOn,
    required this.onToggleMute,
    required this.onToggleSpeaker,
    required this.onEndCall,
  });

  final bool isMuted;
  final bool isSpeakerOn;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onEndCall;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CallingActiveControlButton(
              iconAsset: Assets.callMicMute,
              label: locale.calling_mute_mic,
              isActive: isMuted,
              onTap: onToggleMute,
            ),
            const SizedBox(width: Spacing.callingActiveActionsSpacing),
            CallingActiveControlButton(
              iconAsset: Assets.callSpeaker,
              label: locale.calling_speaker,
              isActive: isSpeakerOn,
              onTap: onToggleSpeaker,
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        CallingActiveEndButton(
          onTap: onEndCall,
        ),
      ],
    );
  }
}
