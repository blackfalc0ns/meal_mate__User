import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
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
        if (getIt.isRegistered<CallingViewModel>()) {
          final vm = getIt<CallingViewModel>();
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
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
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
