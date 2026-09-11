import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_view_model.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/models/family_member_form_validation.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_gender_option.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_member_phone_field.dart';

class FamilyAddMemberDialog extends StatefulWidget {
  const FamilyAddMemberDialog({
    super.key,
    this.member,
    this.relationships = const [],
    this.addresses = const [],
    this.onSubmit,
  });

  final FamilyMemberEntity? member;
  final List<FamilyRelationshipEntity> relationships;
  final List<CustomerAddressEntity> addresses;
  final void Function({
    required String phone,
    required String displayName,
    String? occupation,
    required String relationshipCode,
    required int gender,
    required int ageYears,
    String? deliveryAddressId,
  })?
  onSubmit;

  static Future<void> show({
    required BuildContext context,
    FamilyMemberEntity? member,
    List<FamilyRelationshipEntity> relationships = const [],
    List<CustomerAddressEntity> addresses = const [],
    void Function({
      required String phone,
      required String displayName,
      String? occupation,
      required String relationshipCode,
      required int gender,
      required int ageYears,
      String? deliveryAddressId,
    })?
    onSubmit,
  }) {
    final color = context.colorScheme;
    final viewModel = context.read<FamilySubscriptionSetupViewModel>();

    return showModalBottomSheet<void>(
      context: context,
      barrierColor: color.scrim,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: color.surface.withValues(alpha: 0),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<FamilySubscriptionSetupViewModel>.value(
            value: viewModel,
          ),
          BlocProvider<AuthViewModel>(
            create: (_) =>
                getIt<AuthViewModel>()..doIntent(const GetCallingCodesEvent()),
          ),
        ],
        child: FamilyAddMemberDialog(
          member: member,
          relationships: relationships,
          addresses: addresses,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  @override
  State<FamilyAddMemberDialog> createState() => _FamilyAddMemberDialogState();
}

class _FamilyAddMemberDialogState extends State<FamilyAddMemberDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _ageController;
  int _gender = 1; // 1 Male, 2 Female
  String? _resolvedPhone;
  String? _phoneError;
  String? _nameError;
  String? _ageError;
  bool _phoneLookupBlocked = false;

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    _nameController = TextEditingController(text: member?.displayName ?? '');
    _phoneController = TextEditingController(text: member?.phoneNumber ?? '');
    _resolvedPhone = member?.phoneNumber;
    _relationshipController = TextEditingController(
      text: member?.relationshipCode ?? '',
    );
    _ageController = TextEditingController(
      text: member != null && member.ageYears > 0
          ? member.ageYears.toString()
          : '',
    );
    _gender = member?.gender ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final locale = context.localization;
    final name = _nameController.text.trim();
    final phone = _resolvedPhone?.trim() ?? '';
    final ageText = _ageController.text.trim();
    final age = int.tryParse(ageText) ?? 0;
    final relationship = _relationshipController.text.trim();
    final relCode = _resolveRelationshipCode(relationship);
    final phoneIsInvalid = validateFamilyMemberPhone(_resolvedPhone) != null;
    final nameIsInvalid = validateFamilyMemberName(name) != null;
    final ageIsInvalid = validateFamilyMemberAge(ageText) != null;

    if (phoneIsInvalid || nameIsInvalid || ageIsInvalid) {
      setState(() {
        _phoneError = phoneIsInvalid ? locale.phone_number_is_not_valid : null;
        _nameError = nameIsInvalid ? locale.name_is_required : null;
        _ageError = ageIsInvalid ? locale.family_age_invalid : null;
      });
      return;
    }

    if (_phoneLookupBlocked) {
      return;
    }

    if (widget.member == null) {
      final lookupState = context
          .read<FamilySubscriptionSetupViewModel>()
          .state;
      final lookupIsCurrent =
          lookupState.memberLookupPhone == phone &&
          lookupState.memberLookup != null &&
          lookupState.memberLookupFailure == null;
      if (!lookupIsCurrent) {
        if (!lookupState.isMemberLookupLoading) _lookupPhone(phone);
        return;
      }
    }

    widget.onSubmit?.call(
      phone: phone,
      displayName: name,
      occupation: null,
      relationshipCode: relCode,
      gender: _gender,
      ageYears: age,
      deliveryAddressId: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final panelHeight = math.min(680.0, screenHeight - 24);
    return BlocConsumer<FamilySubscriptionSetupViewModel, FamilyPlanState>(
      listenWhen: (previous, current) =>
          previous.memberSaveSuccess != current.memberSaveSuccess ||
          previous.memberSaveFailure != current.memberSaveFailure,
      listener: _handleMemberSaveState,
      buildWhen: (previous, current) =>
          previous.isMemberSaving != current.isMemberSaving,
      builder: (context, saveState) => Stack(
        children: [
          BlocListener<FamilySubscriptionSetupViewModel, FamilyPlanState>(
            listenWhen: (previous, current) =>
                previous.memberLookup != current.memberLookup ||
                previous.memberLookupFailure != current.memberLookupFailure ||
                previous.isMemberLookupLoading != current.isMemberLookupLoading,
            listener: (context, state) {
              final failure = state.memberLookupFailure;
              if (failure != null) {
                setState(() {
                  _phoneError = mapFailureMessage(context, failure.code);
                  _phoneLookupBlocked =
                      failure.code == 'family.already_in_family';
                });
                return;
              }
              if (state.isMemberLookupLoading) {
                if (_phoneError != null || _phoneLookupBlocked) {
                  setState(() {
                    _phoneError = null;
                    _phoneLookupBlocked = false;
                  });
                }
                return;
              }
              final lookup = state.memberLookup;
              if (lookup == null) return;
              setState(() {
                _phoneError = null;
                _phoneLookupBlocked = false;
                if (lookup.found) {
                  if (lookup.displayName != null) {
                    _nameController.text = lookup.displayName!;
                  }
                  if (lookup.ageYears != null) {
                    _ageController.text = lookup.ageYears.toString();
                  }
                  if (lookup.gender != null) _gender = lookup.gender!;
                }
              });
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: panelHeight,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.bottomSheetRadius,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenH,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: CircleAvatar(
                              radius: 12,
                              backgroundColor: color.surfaceContainerHighest,
                              child: Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: color.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.person_add_alt_1_rounded,
                        color: color.primary,
                        size: 48,
                      ),
                      const SizedBox(height: Spacing.xss),
                      Text(
                        widget.member == null
                            ? l10n.family_add_member
                            : l10n.family_edit_member,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          color: color.onSurface,
                          fontSize: FontSize.size17,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        l10n.family_add_member_dialog_subtitle,
                        textAlign: TextAlign.center,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          color: color.onSurfaceVariant,
                          fontSize: FontSize.size10,
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.family_phone_number,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size11,
                                  color: color.onSurface,
                                ),
                              ),
                              const SizedBox(height: Spacing.xs),
                              BlocSelector<
                                FamilySubscriptionSetupViewModel,
                                FamilyPlanState,
                                bool
                              >(
                                selector: (state) =>
                                    state.isMemberLookupLoading,
                                builder: (context, isLoading) =>
                                    FamilyMemberPhoneField(
                                      controller: _phoneController,
                                      enabled: widget.member == null,
                                      isLoading: isLoading,
                                      errorText: _phoneError,
                                      onPhoneChanged: _handlePhoneChanged,
                                      onLookup: _lookupPhone,
                                    ),
                              ),
                              const SizedBox(height: Spacing.md),
                              // Full name
                              Text(
                                l10n.family_full_name,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size11,
                                  color: color.onSurface,
                                ),
                              ),
                              const SizedBox(height: Spacing.xs),
                              AppTextField(
                                controller: _nameController,
                                hint: l10n.family_full_name_hint,
                                errorText: _nameError,
                                onChanged: (_) {
                                  if (_nameError == null) return;
                                  setState(() => _nameError = null);
                                },
                                prefixIcon: Icon(
                                  Icons.person_outline_rounded,
                                  color: color.onSurfaceVariant,
                                  size: Spacing.iconSm,
                                ),
                              ),
                              const SizedBox(height: Spacing.md),

                              // Relationship and Age
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.family_relation,
                                          style: getBoldStyle(
                                            fontFamily: FontConstant.alexandria,
                                            fontSize: FontSize.size11,
                                            color: color.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: Spacing.xs),
                                        AppTextField(
                                          controller: _relationshipController,
                                          hint: l10n.family_relation_input_hint,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.family_age,
                                          style: getBoldStyle(
                                            fontFamily: FontConstant.alexandria,
                                            fontSize: FontSize.size11,
                                            color: color.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: Spacing.xs),
                                        AppTextField(
                                          controller: _ageController,
                                          hint: l10n.family_age_hint,
                                          errorText: _ageError,
                                          onChanged: (_) {
                                            if (_ageError == null) return;
                                            setState(() => _ageError = null);
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          prefixIcon: Icon(
                                            Icons.calendar_month_outlined,
                                            color: color.onSurfaceVariant,
                                            size: Spacing.iconSm,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Spacing.md),

                              // Gender
                              Text(
                                l10n.family_gender,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size11,
                                  color: color.onSurface,
                                ),
                              ),
                              const SizedBox(height: Spacing.xs),
                              Row(
                                children: [
                                  Expanded(
                                    child: FamilyGenderOption(
                                      label: l10n.family_gender_male,
                                      isSelected: _gender == 1,
                                      onTap: () => setState(() => _gender = 1),
                                    ),
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Expanded(
                                    child: FamilyGenderOption(
                                      label: l10n.family_gender_female,
                                      isSelected: _gender == 2,
                                      onTap: () => setState(() => _gender = 2),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Spacing.md),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      AppButton.filled(
                        text: widget.member == null
                            ? l10n.family_add_member_button
                            : l10n.profile_personal_info_save,
                        onPressed: _handleSubmit,
                        borderRadius: Spacing.radiusPill,
                        textColor: color.onPrimary,
                        fontSize: FontSize.size13,
                      ),
                      const SizedBox(height: Spacing.xs),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l10n.family_cancel,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            color: color.onSurface,
                            fontSize: FontSize.size12,
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (saveState.isMemberSaving)
            Positioned.fill(
              child: AbsorbPointer(
                child: ColoredBox(
                  color: color.scrim.withValues(alpha: 0.2),
                  child: const CustomProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _resolveRelationshipCode(String value) {
    if (value.isEmpty) return 'other';
    final normalizedValue = value.toLowerCase();
    for (final relationship in widget.relationships) {
      if (relationship.code.toLowerCase() == normalizedValue ||
          relationship.nameAr.toLowerCase() == normalizedValue ||
          relationship.nameEn.toLowerCase() == normalizedValue) {
        return relationship.code;
      }
    }
    return value;
  }

  void _handleMemberSaveState(BuildContext context, FamilyPlanState state) {
    if (state.memberSaveSuccess) {
      final locale = context.localization;
      CustomSnackbar.showSuccess(
        context: context,
        message: widget.member == null
            ? locale.family_add_member_success
            : locale.family_update_member_success,
      );
      Navigator.pop(context);
      return;
    }
    final failure = state.memberSaveFailure;
    if (failure != null) {
      CustomSnackbar.showError(context: context, message: failure.errorMessage);
    }
  }

  void _lookupPhone(String phone) {
    context.read<FamilySubscriptionSetupViewModel>().doIntent(
      LookupFamilyMemberEvent(phone),
    );
  }

  void _handlePhoneChanged(String? phone) {
    _resolvedPhone = phone;
    if (_phoneError == null && !_phoneLookupBlocked) return;
    setState(() {
      _phoneError = null;
      _phoneLookupBlocked = false;
    });
  }
}
