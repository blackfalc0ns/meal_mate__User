import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_view_model.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key, required this.profile});

  final CustomerProfileEntity profile;

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _hasChanges = false;
  String _originalName = '';
  String _originalPhone = '';

  @override
  void initState() {
    super.initState();
    _originalName = widget.profile.fullName.trim();
    _originalPhone = (widget.profile.phoneNumber ?? '').trim();
    _nameController.text = _originalName;
    _phoneController.text = _originalPhone;
    _nameController.addListener(_syncHasChanges);
    _phoneController.addListener(_syncHasChanges);
  }

  @override
  void dispose() {
    _nameController.removeListener(_syncHasChanges);
    _phoneController.removeListener(_syncHasChanges);
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<ProfileViewModel>(
      create: (_) => getIt<ProfileViewModel>(),
      child: BlocConsumer<ProfileViewModel, ProfileState>(
        listenWhen: (previous, current) => previous.action != current.action,
        listener: (context, state) {
          if (state.action.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message:
                  state.action.errorMessage ??
                  locale.profile_personal_info_update_error,
            );
          }

          if (state.action.isSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: locale.profile_personal_info_update_success,
            );
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.profile_personal_info,
              titleFontSize: FontSize.size15,
              backgroundColor: color.surface,
              showShadow: false,
            ),
            body: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ).copyWith(top: Spacing.xxxl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.lg,
                          vertical: Spacing.xxl,
                        ),
                        decoration: BoxDecoration(
                          color: color.surface,
                          borderRadius: BorderRadius.circular(Spacing.radiusXl),
                          border: Border.all(color: color.outlineVariant),
                          boxShadow: [
                            BoxShadow(
                              color: color.shadow.withValues(alpha: 0.08),
                              blurRadius: Spacing.xl,
                              offset: const Offset(0, Spacing.sm),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: _nameController,
                              label: locale.auth_name_label,
                              hint: locale.auth_name_hint,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                color: color.primary,
                                size: Spacing.iconLg,
                              ),
                              validator: (value) =>
                                  Validations.validateName(context, value),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Spacing.lg,
                                vertical: Spacing.lg,
                              ),
                              borderRadius: Spacing.radiusXl,
                              borderColor: color.outlineVariant,
                              fillColor: color.surface,
                              textStyle: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size18,
                                color: color.onSurface,
                              ),
                              labelStyle: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: Spacing.xl),
                            AppTextField(
                              controller: _phoneController,
                              label: locale.phone_number,
                              hint: locale.phone_hint,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              prefixIcon: Icon(
                                Icons.local_phone_outlined,
                                color: color.primary,
                                size: Spacing.iconLg,
                              ),
                              validator: (value) =>
                                  Validations.validatePhoneNumber(
                                    context,
                                    value,
                                  ),
                              onSubmitted: (_) => _submit(context),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Spacing.lg,
                                vertical: Spacing.lg,
                              ),
                              borderRadius: Spacing.radiusXl,
                              borderColor: color.outlineVariant,
                              fillColor: color.surface,
                              textStyle: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size18,
                                color: color.onSurface,
                              ),
                              labelStyle: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.xxl),
                      AppButton.filled(
                        text: locale.profile_personal_info_save,
                        isLoading: state.action.isLoading,
                        onPressed: _hasChanges && !state.action.isLoading
                            ? () => _submit(context)
                            : null,
                        height: Spacing.addressesChooseLocationButtonHeight,
                        borderRadius: Spacing.lg,
                        color: color.primary,
                        textColor: color.onPrimary,
                        fontSize: FontSize.size20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _syncHasChanges() {
    final hasChanges =
        _nameController.text.trim() != _originalName ||
        _phoneController.text.trim() != _originalPhone;

    if (hasChanges == _hasChanges) return;
    setState(() => _hasChanges = hasChanges);
  }

  void _submit(BuildContext context) {
    if (!_hasChanges) return;
    if (_formKey.currentState?.validate() != true) return;

    context.read<ProfileViewModel>().doIntent(
      UpdateCustomerProfileEvent(
        UpdateCustomerProfileRequestEntity(
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          preferredLanguage: widget.profile.preferredLanguage,
          defaultRegionId: widget.profile.defaultRegionId,
          deliveryAddressLine: widget.profile.deliveryAddressLine,
          deliveryLatitude: widget.profile.deliveryLatitude,
          deliveryLongitude: widget.profile.deliveryLongitude,
          dateOfBirth: widget.profile.dateOfBirth,
        ),
      ),
    );
  }
}
