import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
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
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_permission_row.dart';
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
  late final FamilyMemberViewModel _viewModel;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel.state.permissions == null) {
      _viewModel.doIntent(
        LoadFamilyMemberPermissionsEvent(
          widget.memberId,
          locale: context.localization.localeName,
        ),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  bool _hasChanges(FamilyMemberState state) {
    final original = state.permissions?.values;
    if (original == null) return false;
    for (final entry in state.permissionValues.entries) {
      if (entry.key == 'changeProgram' || entry.key == 'changeDeliveryTime') {
        continue;
      }
      if ((original[entry.key] ?? false) != entry.value) {
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
              locale: localeName,
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<FamilyMemberViewModel, FamilyMemberState>(
        buildWhen: (previous, current) =>
            previous.permissions != current.permissions ||
            previous.permissionValues != current.permissionValues ||
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
                            Text(
                              group.localizedLabel(isArabic),
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurface,
                              ),
                            ),
                            const SizedBox(height: Spacing.xs),
                            Card(
                              color: color.surface,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                                side: BorderSide(
                                  color: color.outlineVariant.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  for (final permission in group.permissions)
                                    FamilyPermissionRow(
                                      permission: permission,
                                      value: state.permissionValues[permission.key] ??
                                          permission.value,
                                      isReadOnly: widget.isManager || state.isSaving,
                                      onChanged: (value) => _viewModel.doIntent(
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
                    child: AppButton(
                      text: locale.family_member_permissions_save,
                      onPressed:
                          hasChanges && !state.isSaving && !widget.isManager
                          ? () => _showConfirmationDialog(
                              context,
                              locale.localeName,
                            )
                          : null,
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
