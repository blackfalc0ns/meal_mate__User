import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
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
          final password = state.access?.generatedPassword;
          if (_removalRequested && state.saveSuccessCount > 0) {
            _removalRequested = false;
            Navigator.of(context).popUntil(
              (route) =>
                  route.settings.name == AppRoutes.familySubscriptionMembers,
            );
            return;
          }
          if (password?.isNotEmpty == true) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                title: Text(
                  locale.family_member_access_generated_password_title,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      locale.family_member_access_generated_password_message,
                    ),
                    const SizedBox(height: Spacing.md),
                    SelectableText(password!),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: password)),
                    child: Text(locale.family_member_access_copy),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _viewModel.doIntent(const ClearGeneratedPasswordEvent());
                    },
                    child: Text(
                      MaterialLocalizations.of(context).okButtonLabel,
                    ),
                  ),
                ],
              ),
            );
          } else if (state.saveSuccessCount > 0 &&
              state.access?.hasExistingLogin == true) {
            CustomSnackbar.showInfo(
              context: context,
              message: locale.family_member_access_existing_login,
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
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.family_member_access_title(widget.memberName),
              backgroundColor: color.surface,
            ),
            body: access == null
                ? Center(child: CircularProgressIndicator(color: color.primary))
                : ListView(
                    padding: const EdgeInsets.all(Spacing.md),
                    children: [
                      ListTile(
                        title: Text(locale.family_member_access_phone_label),
                        subtitle: Text(access.phoneNumber ?? ''),
                      ),
                      SwitchListTile(
                        value: hasSeparateAccount,
                        onChanged: (value) =>
                            setState(() => _separateAccount = value),
                        title: Text(
                          locale.family_member_access_independent_title,
                        ),
                      ),
                      SwitchListTile(
                        value: isPaused,
                        onChanged: (value) => setState(() => _paused = value),
                        title: Text(locale.family_member_access_pause_label),
                      ),
                      ListTile(
                        title: Text(
                          locale.family_member_access_permissions_tile_title,
                        ),
                        subtitle: Text(
                          locale.family_member_access_permissions_tile_subtitle,
                        ),
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
                      const SizedBox(height: Spacing.md),
                      AppButton(
                        text: locale.family_member_access_save_button,
                        onPressed: state.isSaving || !hasChanges
                            ? null
                            : () => _viewModel.doIntent(
                                UpdateFamilyMemberAccessEvent(
                                  memberId: widget.memberId,
                                  hasSeparateAccount:
                                      hasSeparateAccount ==
                                          access.hasSeparateAccount
                                      ? null
                                      : hasSeparateAccount,
                                  isPaused: isPaused == access.isPaused
                                      ? null
                                      : isPaused,
                                ),
                              ),
                      ),
                      if (!widget.isManager) ...[
                        const SizedBox(height: Spacing.md),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: color.error,
                          ),
                          onPressed: state.isSaving
                              ? null
                              : () {
                                  _removalRequested = true;
                                  _viewModel.doIntent(
                                    UpdateFamilyMemberAccessEvent(
                                      memberId: widget.memberId,
                                      remove: true,
                                    ),
                                  );
                                },
                          child: Text(locale.family_member_access_remove_label),
                        ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}
