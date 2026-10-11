import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permissions_confirm_dialog.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permissions_loading_skeleton.dart';

class FamilyMemberPermissionsScreen extends StatefulWidget {
  const FamilyMemberPermissionsScreen({
    super.key,
    required this.memberId,
    required this.isManager,
    required this.memberName,
  });
  final String memberId;
  final bool isManager;
  final String memberName;
  @override
  State<FamilyMemberPermissionsScreen> createState() =>
      _FamilyMemberPermissionsScreenState();
}

class _FamilyMemberPermissionsScreenState
    extends State<FamilyMemberPermissionsScreen> {
  late final FamilyManagementViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = getIt<FamilyManagementViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel.state.permissions == null) {
      _viewModel.doIntent(
        LoadFamilyMemberPermissionsEvent(
          widget.memberId,
          context.localization.localeName,
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  bool _hasChanges(FamilyManagementState state) {
    final original = state.permissions?.values;
    if (original == null) return false;
    for (final entry in original.entries) {
      if (state.permissionValues[entry.key] != entry.value) {
        return true;
      }
    }
    return false;
  }

  void _showConfirmationDialog(BuildContext context, String localeName) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => FamilyMemberPermissionsConfirmDialog(
        memberName: widget.memberName,
        onConfirm: () {
          _viewModel.doIntent(
            UpdateFamilyMemberPermissionsEvent(
              widget.memberId,
              _viewModel.state.permissionValues,
              localeName,
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
          if (state.saveSuccessCount > 0) {
            CustomSnackbar.showSuccess(
              context: context,
              message: locale.family_member_permissions_save_success,
            );
          }
        },
        builder: (context, state) {
          final permissions = state.permissions;
          final hasChanges = _hasChanges(state);

          return Stack(
            children: [
              Scaffold(
                backgroundColor: color.surface,
                appBar: CustomAppBar(
                  title: locale.family_member_permissions_title(
                    widget.memberName,
                  ),
                  backgroundColor: color.surface,
                ),
                body: permissions == null
                    ? const FamilyMemberPermissionsLoadingSkeleton()
                    : ListView(
                        padding: const EdgeInsets.all(Spacing.md),
                        children: [
                          Text(
                            locale.family_member_permissions_subtitle(
                              widget.memberName,
                            ),
                          ),
                          const SizedBox(height: Spacing.md),
                          for (final group in permissions.groups) ...[
                            Text(group.label),
                            const SizedBox(height: Spacing.xs),
                            Card(
                              color: color.surface,
                              child: Column(
                                children: [
                                  for (final permission in group.permissions)
                                    SwitchListTile(
                                      title: Text(permission.label),
                                      value:
                                          state.permissionValues[permission
                                              .key] ??
                                          permission.value,
                                      onChanged:
                                          widget.isManager || state.isSaving
                                          ? null
                                          : (value) => _viewModel.doIntent(
                                              ToggleFamilyPermissionEvent(
                                                permission.key,
                                                value,
                                              ),
                                            ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Spacing.md),
                          ],
                        ],
                      ),
                bottomNavigationBar: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: permissions == null
                        ? const ShimmerPlaceholder.rect(
                            height: Spacing.buttonHeight,
                            borderRadius: Spacing.buttonRadius,
                          )
                        : AppButton(
                            text: locale.family_member_permissions_save,
                            onPressed:
                                !hasChanges ||
                                    widget.isManager ||
                                    state.isSaving
                                ? null
                                : () => _showConfirmationDialog(
                                    context,
                                    locale.localeName,
                                  ),
                          ),
                  ),
                ),
              ),
              if (state.isSaving)
                Positioned.fill(
                  child: AbsorbPointer(
                    child: Container(
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
