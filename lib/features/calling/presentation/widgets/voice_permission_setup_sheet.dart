import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../config/theme/font_manager.dart';
import '../../../../config/theme/spacing.dart';
import '../../../../config/theme/styles_manager.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_wolt_modal_sheet.dart';
import '../manager/voice_permission_setup_event.dart';
import '../manager/voice_permission_setup_state.dart';
import '../manager/voice_permission_setup_view_model.dart';

class VoicePermissionSetupSheet extends StatelessWidget {
  const VoicePermissionSetupSheet({
    super.key,
    this.onGranted,
    this.onDismissed,
  });

  final VoidCallback? onGranted;
  final VoidCallback? onDismissed;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onGranted,
    VoidCallback? onDismissed,
  }) {
    return AppWoltModalSheet.show<void>(
      context: context,
      hasTopBarLayer: false,
      showDragHandle: true,
      child: BlocProvider(
        create: (_) {
          final vm = GetIt.instance<VoicePermissionSetupViewModel>();
          vm.add(const CheckPermissionEvent());
          return vm;
        },
        child: VoicePermissionSetupSheet(
          onGranted: onGranted,
          onDismissed: onDismissed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocConsumer<VoicePermissionSetupViewModel, VoicePermissionSetupState>(
      listenWhen: (previous, current) =>
          previous.permission != current.permission ||
          previous.isDeferred != current.isDeferred,
      listener: (context, state) {
        if (state.isGranted) {
          Navigator.of(context).pop();
          onGranted?.call();
        } else if (state.isDeferred) {
          Navigator.of(context).pop();
          onDismissed?.call();
        }
      },
      builder: (context, state) {
        final isPermanentlyDenied = state.isPermanentlyDenied;

        return Padding(
          padding: const EdgeInsetsDirectional.only(
            top: Spacing.xs,
            start: Spacing.base,
            end: Spacing.base,
            bottom: Spacing.base,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Spacing.sm),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic_rounded,
                  size: 36,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: Spacing.md),
              Text(
                locale.calling_permission_title,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size16,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                locale.calling_permission_desc,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.lg),
              AppButton(
                text: isPermanentlyDenied
                    ? locale.calling_permission_settings
                    : locale.calling_permission_enable,
                isLoading: state.isLoading,
                onPressed: () {
                  final vm = context.read<VoicePermissionSetupViewModel>();
                  if (isPermanentlyDenied) {
                    vm.add(const OpenPermissionSettingsEvent());
                  } else {
                    vm.add(const RequestPermissionEvent());
                  }
                },
                height: Spacing.buttonSmallHeight,
                borderRadius: Spacing.buttonRadius,
                color: color.primary,
                textColor: color.onPrimary,
                fontSize: FontSize.size14,
              ),
              const SizedBox(height: Spacing.xs),
              SizedBox(
                width: double.infinity,
                height: Spacing.buttonSmallHeight,
                child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<VoicePermissionSetupViewModel>()
                        .add(const DismissPermissionExplainerEvent());
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: color.outlineVariant.withValues(alpha: 0.7),
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Spacing.buttonRadius),
                    ),
                  ),
                  child: Text(
                    locale.calling_permission_later,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurfaceVariant,
                    ),
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
