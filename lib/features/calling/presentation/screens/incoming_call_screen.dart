import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
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
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_background_decoration.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_avatar_rings.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_role_badge.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_header_brand.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_incoming_actions.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({
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
        child: _IncomingCallView(driver: driver),
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
      child: _IncomingCallView(driver: driver),
    );
  }
}

class _IncomingCallView extends StatefulWidget {
  const _IncomingCallView({this.driver});

  final CallDriverEntity? driver;

  @override
  State<_IncomingCallView> createState() => _IncomingCallViewState();
}

class _IncomingCallViewState extends State<_IncomingCallView> {
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
        } else if (state.status == VoiceCallStatus.accepted ||
            state.status == VoiceCallStatus.connecting ||
            state.status == VoiceCallStatus.active) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            unawaited(
              context.pushReplacementNamed(
                AppRoutes.activeCall,
                arguments: state.driver ?? widget.driver,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final activeDriver = state.driver ?? widget.driver;
        final displayName = state.resolvedDriverName(locale.calling_driver_role);
        final displayRole = state.resolvedDriverRole(locale.calling_driver_role);
        final avatarUrl = state.resolvedDriverImageUrl(NetworkConstants.baseUrl);

        return Scaffold(
          backgroundColor: color.surface,
          body: Stack(
            children: [
              const CallingBackgroundDecoration(),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: Spacing.xs),
                    CallingHeaderBrand(title: locale.calling_incoming_title),
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              width: Spacing.callingRipple4Size,
                              height: 310.0,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  CallingDriverAvatarRings(
                                    avatarAsset: activeDriver?.avatarAsset ??
                                        Assets.profileAvatar,
                                    avatarUrl: avatarUrl,
                                  ),
                                  Positioned(
                                    top: 220.0,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          displayName,
                                          style: getBoldStyle(
                                            fontFamily: FontConstant.alexandria,
                                            fontSize: FontSize.size28,
                                            color: color.callDriverNameGreen,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: Spacing.md),
                                        CallingDriverRoleBadge(
                                          role: displayRole,
                                        ),
                                        const SizedBox(height: Spacing.sm),
                                        Text(
                                          locale.calling_calling_now,
                                          style: getRegularStyle(
                                            fontFamily: FontConstant.alexandria,
                                            fontSize: FontSize.size14,
                                            color: color.callSubtitleGrey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    CallingIncomingActions(
                      isLoading: state.isLoading,
                      onAccept: () {
                        if (state.isLoading) return;
                        context
                            .read<CallingViewModel>()
                            .doIntent(const AnswerCallEvent());
                      },
                      onDecline: () {
                        if (state.isLoading) return;
                        context
                            .read<CallingViewModel>()
                            .doIntent(const RejectCallEvent());
                      },
                    ),
                    const SizedBox(height: Spacing.xl),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
