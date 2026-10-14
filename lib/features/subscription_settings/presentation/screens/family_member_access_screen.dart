import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_credentials_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_deactivate_dialog.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_header.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_independent_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_password_dialog.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_permissions_tile.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_status_card.dart';

class FamilyMemberAccessScreen extends StatefulWidget {
  const FamilyMemberAccessScreen({
    super.key,
    required this.memberId,
    required this.isManager,
    required this.memberName,
  });

  final String memberId;
  final bool isManager;
  final String memberName;

  @override
  State<FamilyMemberAccessScreen> createState() =>
      _FamilyMemberAccessScreenState();
}

class _FamilyMemberAccessScreenState extends State<FamilyMemberAccessScreen> {
  late final FamilyManagementViewModel _viewModel;
  bool? _separateAccount;
  bool? _paused;
  bool _removalRequested = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<FamilyManagementViewModel>()
      ..doIntent(LoadFamilyMemberAccessEvent(widget.memberId));
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  void _onSave(
    FamilyMemberAccessEntityV2 access,
    bool hasSeparateAccount,
    bool isPaused,
  ) {
    _viewModel.doIntent(
      UpdateFamilyMemberAccessEvent(
        memberId: widget.memberId,
        hasSeparateAccount: hasSeparateAccount == access.hasSeparateAccount
            ? null
            : hasSeparateAccount,
        isPaused: isPaused == access.isPaused ? null : isPaused,
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => FamilyMemberAccessDeactivateDialog(
        memberName: widget.memberName,
        onConfirm: () {
          _removalRequested = true;
          _viewModel.doIntent(
            UpdateFamilyMemberAccessEvent(
              memberId: widget.memberId,
              remove: true,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<FamilyManagementViewModel, FamilyManagementState>(
        buildWhen: (previous, current) =>
            previous.access != current.access ||
            previous.isSaving != current.isSaving,
        listenWhen: (previous, current) =>
            previous.saveSuccessCount != current.saveSuccessCount ||
            previous.failure != current.failure ||
            previous.saveFailure != current.saveFailure,
        listener: (context, state) {
          final failure = state.saveFailure ?? state.failure;
          if (failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(context, failure),
            );
          }

          if (_removalRequested && state.saveSuccessCount > 0) {
            _removalRequested = false;
            CustomSnackbar.showSuccess(
              context: context,
              message: locale.family_member_access_save_success,
            );
            Navigator.of(context).popUntil(
              (route) =>
                  route.settings.name == AppRoutes.familySubscriptionMembers ||
                  route.isFirst,
            );
            return;
          }

          final password = state.access?.generatedPassword;
          if (password?.isNotEmpty == true) {
            setState(() {
              _separateAccount = null;
              _paused = null;
            });
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => FamilyMemberAccessPasswordDialog(
                password: password!,
                onDismiss: () {
                  _viewModel.doIntent(const ClearGeneratedPasswordEvent());
                },
              ),
            );
          } else if (state.saveSuccessCount > 0) {
            setState(() {
              _separateAccount = null;
              _paused = null;
            });
            CustomSnackbar.showSuccess(
              context: context,
              message: locale.family_member_access_save_success,
            );
          }
        },
        builder: (context, state) {
          final access = state.access;
          final hasSeparateAccount =
              _separateAccount ?? access?.hasSeparateAccount ?? false;
          final isPaused = _paused ?? access?.isPaused ?? false;
          final hasChanges =
              access != null &&
              (hasSeparateAccount != access.hasSeparateAccount ||
                  isPaused != access.isPaused);

          return Stack(
            children: [
              Scaffold(
                backgroundColor: color.surface,
                appBar: CustomAppBar(
                  title: locale.family_member_access_title(widget.memberName),
                  backgroundColor: color.surface,
                ),
                body: access == null
                    ? const FamilyMemberAccessLoadingSkeleton()
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.screenH,
                          vertical: Spacing.md,
                        ),
                        children: [
                          FamilyMemberAccessHeader(
                            isPaused: isPaused,
                            hasExistingLogin: access.hasExistingLogin,
                          ),
                          const SizedBox(height: Spacing.md),
                          FamilyMemberAccessCredentialsCard(
                            identifier: access.phoneNumber,
                          ),
                          const SizedBox(height: Spacing.md),
                          FamilyMemberAccessIndependentCard(
                            memberName: widget.memberName,
                            hasIndependentAccount: hasSeparateAccount,
                            onChanged: (value) =>
                                setState(() => _separateAccount = value),
                          ),
                          const SizedBox(height: Spacing.md),
                          FamilyMemberAccessStatusCard(
                            memberName: widget.memberName,
                            isPaused: isPaused,
                            canDeactivate: !widget.isManager,
                            onStatusChanged: (value) =>
                                setState(() => _paused = value),
                            onDeactivate: () => _showDeactivateDialog(context),
                          ),
                          const SizedBox(height: Spacing.md),
                          FamilyMemberAccessPermissionsTile(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.familyMemberPermissions,
                              arguments: (
                                widget.memberId,
                                widget.isManager,
                                widget.memberName,
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.sm),
                        ],
                      ),
                bottomNavigationBar: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.screenH,
                      vertical: Spacing.sm,
                    ),
                    child: access == null
                        ? const ShimmerPlaceholder.rect(
                            height: Spacing.buttonHeight,
                            borderRadius: Spacing.buttonRadius,
                          )
                        : AppButton(
                            text: locale.family_member_access_save_button,
                            onPressed: state.isSaving || !hasChanges
                                ? null
                                : () => _onSave(
                                    access,
                                    hasSeparateAccount,
                                    isPaused,
                                  ),
                          ),
                  ),
                ),
              ),
              if (state.isSaving)
                Positioned.fill(
                  child: AbsorbPointer(
                    child: ColoredBox(
                      color: color.scrim.withValues(alpha: 0.35),
                      child: const Center(child: CustomProgressIndicator()),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
