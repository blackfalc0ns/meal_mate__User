import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_view_model.dart';

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
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.family_member_permissions_title(widget.memberName),
              backgroundColor: color.surface,
            ),
            body: permissions == null
                ? Center(child: CircularProgressIndicator(color: color.primary))
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
                                      state.permissionValues[permission.key] ??
                                      permission.value,
                                  onChanged: widget.isManager
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
                      AppButton(
                        text: locale.family_member_permissions_save,
                        onPressed: widget.isManager || state.isSaving
                            ? null
                            : () => _viewModel.doIntent(
                                UpdateFamilyMemberPermissionsEvent(
                                  widget.memberId,
                                  state.permissionValues,
                                  locale.localeName,
                                ),
                              ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
