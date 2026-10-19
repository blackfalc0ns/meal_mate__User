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
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_state.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_view_model.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_credentials_card.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_deactivate_dialog.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_header.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_independent_card.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_password_dialog.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_permissions_tile.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_access_status_card.dart';

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
  late final FamilyMemberViewModel _viewModel;
  bool? _separateAccount;
  bool? _paused;
  bool _removalRequested = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt.isRegistered<FamilyMemberViewModel>()
        ? getIt<FamilyMemberViewModel>()
        : FamilyMemberViewModel(
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
          );
    _viewModel.doIntent(LoadFamilyMemberAccessEvent(widget.memberId));
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  bool _hasChanges(FamilyMemberState state) {
    final access = state.access;
    if (access == null) return false;
    final accountChanged =
        _separateAccount != null &&
        _separateAccount != access.hasSeparateAccount;
    final pauseChanged = _paused != null && _paused != access.isPaused;
    return accountChanged || pauseChanged || _removalRequested;
  }

  void _showResetConfirmationDialog(BuildContext context) {
    final locale = context.localization;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(locale.family_member_access_explicit_reset_title),
        content: Text(locale.family_member_access_explicit_reset_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(locale.family_member_access_deactivate_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _viewModel.doIntent(
                UpdateFamilyMemberAccessEvent(
                  memberId: widget.memberId,
                  generateTemporaryPassword: true,
                  isRetry: false,
                  isExplicitReset: true,
                ),
              );
            },
            child: Text(locale.family_member_access_explicit_reset_button),
          ),
        ],
      ),
    );
  }

  void _onSave() {
    final access = _viewModel.state.access;
    if (access == null) return;
    _viewModel.doIntent(
      UpdateFamilyMemberAccessEvent(
        memberId: widget.memberId,
        hasSeparateAccount: _separateAccount ?? access.hasSeparateAccount,
        isPaused: _paused ?? access.isPaused,
        removeAccess: _removalRequested,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<FamilyMemberViewModel, FamilyMemberState>(
        buildWhen: (previous, current) =>
            previous.access != current.access ||
            previous.isSaving != current.isSaving ||
            previous.isLoadingAccess != current.isLoadingAccess,
        listenWhen: (previous, current) =>
            previous.saveSuccessCount != current.saveSuccessCount ||
            previous.failure != current.failure ||
            previous.saveFailure != current.saveFailure ||
            previous.requiresExplicitReset != current.requiresExplicitReset,
        listener: (context, state) {
          final failure = state.saveFailure ?? state.failure;
          if (failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(context, failure),
            );
          }
          if (state.saveSuccessCount > 0) {
            CustomSnackbar.showSuccess(
              context: context,
              message: locale.family_member_access_save_success,
            );
            setState(() {
              _separateAccount = null;
              _paused = null;
              _removalRequested = false;
            });
            if (state.access?.generatedPassword != null) {
              showDialog<void>(
                context: context,
                builder: (_) => FamilyMemberAccessPasswordDialog(
                  password: state.access!.generatedPassword!,
                  onDismiss: () =>
                      _viewModel.doIntent(const ClearGeneratedPasswordEvent()),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final access = state.access;
          final effectiveSeparate =
              _separateAccount ?? access?.hasSeparateAccount ?? false;
          final effectivePaused = _paused ?? access?.isPaused ?? false;
          final hasChanges = _hasChanges(state);

          return Stack(
            children: [
              Scaffold(
                backgroundColor: color.surface,
                appBar: CustomAppBar(
                  title: locale.family_member_access_title(widget.memberName),
                  backgroundColor: color.surface,
                ),
                body: state.isLoadingAccess && access == null
                    ? const FamilyMemberAccessLoadingSkeleton()
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.sm,
                        ),
                        children: [
                          FamilyMemberAccessHeader(
                            isPaused: effectivePaused,
                            hasExistingLogin:
                                access?.hasSeparateAccount ?? false,
                          ),
                          const SizedBox(height: Spacing.md),
                          FamilyMemberAccessStatusCard(
                            memberName: widget.memberName,
                            isPaused: effectivePaused,
                            onStatusChanged: (isPaused) => setState(() {
                              _paused = isPaused;
                            }),
                            onDeactivate: () => showDialog<void>(
                              context: context,
                              builder: (_) =>
                                  FamilyMemberAccessDeactivateDialog(
                                    memberName: widget.memberName,
                                    onConfirm: () => setState(() {
                                      _removalRequested = true;
                                      _onSave();
                                    }),
                                  ),
                            ),
                          ),
                          const SizedBox(height: Spacing.md),
                          FamilyMemberAccessIndependentCard(
                            memberName: widget.memberName,
                            hasIndependentAccount: effectiveSeparate,
                            onChanged: (value) => setState(() {
                              _separateAccount = value;
                            }),
                          ),
                          const SizedBox(height: Spacing.md),
                          FamilyMemberAccessCredentialsCard(
                            identifier: access?.phoneNumber,
                            onEditPassword: state.isSaving
                                ? null
                                : () {
                                    if (access?.hasExistingLogin == true ||
                                        state.requiresExplicitReset) {
                                      _showResetConfirmationDialog(context);
                                    } else {
                                      _viewModel.doIntent(
                                        UpdateFamilyMemberAccessEvent(
                                          memberId: widget.memberId,
                                          generateTemporaryPassword: true,
                                          isRetry: false,
                                        ),
                                      );
                                    }
                                  },
                          ),
                          const SizedBox(height: Spacing.md),
                          FamilyMemberAccessPermissionsTile(
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.familyMemberPermissions,
                              arguments: (
                                widget.memberId,
                                widget.isManager,
                                widget.memberName,
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.xl),
                        ],
                      ),
                bottomNavigationBar: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: AppButton(
                      text: locale.family_member_access_save_button,
                      onPressed: hasChanges && !state.isSaving ? _onSave : null,
                    ),
                  ),
                ),
              ),
              if (state.isSaving)
                ColoredBox(
                  color: color.scrim.withValues(alpha: 0.35),
                  child: const Center(child: CustomProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
