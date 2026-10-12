import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meal_meat_user/core/services/voice_permission_service.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/features/calling/domain/entities/call_driver_entity.dart';
import 'package:meal_meat_user/features/calling/domain/entities/voice_call_status.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_event.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_state.dart';
import 'package:meal_meat_user/features/calling/presentation/manager/calling_view_model.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_address_card.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_active_controls.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_background_decoration.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_avatar_rings.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_role_badge.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_header_brand.dart';

class ActiveCallScreen extends StatelessWidget {
  const ActiveCallScreen({
    super.key,
    this.driver,
    this.viewModel,
  });

  final CallDriverEntity? driver;
  final CallingViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel != null) {
      return BlocProvider.value(
        value: viewModel!,
        child: _ActiveCallView(driver: driver),
      );
    }

    return BlocProvider(
      create: (_) {
        if (GetIt.instance.isRegistered<CallingViewModel>()) {
          final vm = GetIt.instance<CallingViewModel>();
          if (driver != null) {
            vm.setDriver(driver);
          }
          return vm;
        }
        return CallingViewModel.preview(driver: driver);
      },
      child: _ActiveCallView(driver: driver),
    );
  }
}

class _ActiveCallView extends StatefulWidget {
  const _ActiveCallView({this.driver});

  final CallDriverEntity? driver;

  @override
  State<_ActiveCallView> createState() => _ActiveCallViewState();
}

class _ActiveCallViewState extends State<_ActiveCallView> {
  String? _lastLanguageCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<CallingViewModel>();
      if (vm.state.hasAudioPermissionError) {
        final granted =
            await VoicePermissionService.instance.requestMicrophone();
        if (granted && mounted) {
          unawaited(vm.retryMicrophonePermission());
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLang = Localizations.localeOf(context).languageCode;
    if (_lastLanguageCode != null && _lastLanguageCode != currentLang) {
      context.read<CallingViewModel>().doIntent(
        RefreshCallDisplayEvent(language: currentLang),
      );
    }
    _lastLanguageCode = currentLang;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocConsumer<CallingViewModel, CallingState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isTerminal || state.status == VoiceCallStatus.ended) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      builder: (context, state) {
        final activeDriver = state.driver ?? widget.driver;
        final displayName = state.resolvedDriverName(
          locale.calling_driver_role,
        );
        final displayRole = state.resolvedDriverRole(
          locale.calling_driver_role,
        );
        final avatarUrl = state.resolvedDriverImageUrl(
          NetworkConstants.baseUrl,
        );
        final addressDetails = state.resolvedDeliveryAddress(
          activeDriver?.addressDetails ?? '',
        );

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
                        timerText: state.formattedDuration,
                      ),
                      if (state.hasAudioPermissionError) ...[
                        const SizedBox(height: Spacing.xs),
                        GestureDetector(
                          onTap: () async {
                            final granted =
                                await VoicePermissionService.instance
                                    .requestMicrophone();
                            if (granted && context.mounted) {
                              unawaited(
                                context
                                    .read<CallingViewModel>()
                                    .retryMicrophonePermission(),
                              );
                            } else {
                              unawaited(
                                VoicePermissionService.instance
                                    .openAppSettings(),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.md,
                              vertical: Spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: color.error.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(Spacing.sm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.mic_off,
                                  size: 16,
                                  color: color.error,
                                ),
                                const SizedBox(width: Spacing.xs),
                                Text(
                                  Localizations.localeOf(context).languageCode ==
                                          'ar'
                                      ? 'يرجى تفعيل إذن الميكروفون للتحدث (اضغط هنا)'
                                      : 'Tap to grant microphone permission to speak',
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size12,
                                    color: color.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CallingDriverAvatarRings(
                                  avatarAsset: activeDriver?.avatarAsset ??
                                      Assets.profileAvatar,
                                  avatarUrl: avatarUrl,
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xs),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  displayName,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size26,
                                    color: color.callDriverNameGreen,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: Spacing.xs),
                                CallingDriverRoleBadge(role: displayRole),
                              ],
                            ),
                            const SizedBox(height: Spacing.xs),
                            CallingActiveAddressCard(
                              title:
                                  activeDriver?.addressTitle.isNotEmpty == true
                                      ? activeDriver!.addressTitle
                                      : locale.calling_delivery_request,
                              addressDetails: addressDetails.isNotEmpty
                                  ? addressDetails
                                  : locale.calling_delivery_request,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      CallingActiveControls(
                        isMuted: state.isMuted,
                        isSpeakerOn: state.isSpeakerOn,
                        onToggleMute: () {
                          context.read<CallingViewModel>().doIntent(
                            const ToggleMuteEvent(),
                          );
                        },
                        onToggleSpeaker: () {
                          context.read<CallingViewModel>().doIntent(
                            const ToggleSpeakerEvent(),
                          );
                        },
                        onEndCall: () {
                          context.read<CallingViewModel>().doIntent(
                            const EndCallEvent(),
                          );
                        },
                      ),
                      const SizedBox(height: Spacing.base),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
