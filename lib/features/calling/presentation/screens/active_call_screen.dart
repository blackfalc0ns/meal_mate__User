import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calling/data/fake/calling_fake_data.dart';
import 'package:meal_meat_user/features/calling/domain/entities/call_driver_entity.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_address_card.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_controls.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_background_decoration.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_avatar_rings.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_role_badge.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_header_brand.dart';

class ActiveCallScreen extends StatefulWidget {
  const ActiveCallScreen({
    super.key,
    this.driver = CallingFakeData.defaultDriver,
  });

  final CallDriverEntity driver;

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  Timer? _timer;
  int _secondsElapsed = 24;
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _endCall() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      body: Stack(
        children: [
          const CallingBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Column(
                children: [
                  const SizedBox(height: Spacing.xs),
                  CallingHeaderBrand(
                    title: locale.calling_active_title,
                    timerText: _formattedTime,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CallingDriverAvatarRings(
                              avatarAsset: widget.driver.avatarAsset,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.driver.name,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size26,
                                color: color.callDriverNameGreen,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Spacing.xs),
                            CallingDriverRoleBadge(role: widget.driver.role),
                          ],
                        ),
                        const SizedBox(height: Spacing.xs),
                        CallingActiveAddressCard(
                          title: widget.driver.addressTitle,
                          addressDetails: widget.driver.addressDetails,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  CallingActiveControls(
                    isMuted: _isMuted,
                    isSpeakerOn: _isSpeakerOn,
                    onToggleMute: _toggleMute,
                    onToggleSpeaker: _toggleSpeaker,
                    onEndCall: _endCall,
                  ),
                  const SizedBox(height: Spacing.base),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
