import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/models/family_relationship_options.dart';

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
      builder: (_) => BlocProvider<FamilySubscriptionSetupViewModel>.value(
        value: viewModel,
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
  late final TextEditingController _occupationController;
  late final TextEditingController _ageController;
  String? _selectedRelationshipCode;
  String? _selectedAddressId;
  int _gender = 1; // 1 Male, 2 Female

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    _nameController = TextEditingController(text: member?.displayName ?? '');
    _phoneController = TextEditingController(text: member?.phoneNumber ?? '');
    _occupationController = TextEditingController(
      text: member?.occupation ?? '',
    );
    _ageController = TextEditingController(
      text: member != null && member.ageYears > 0
          ? member.ageYears.toString()
          : '',
    );
    _gender = member?.gender ?? 1;

    final memberRelationshipCode = member?.relationshipCode;
    final availableRelationships = buildFamilyRelationshipOptions(
      widget.relationships,
      selectedCode: memberRelationshipCode,
      includeSelectedRelationship: member != null,
    );
    _selectedRelationshipCode = resolveFamilyRelationshipSelection(
      availableRelationships,
      selectedCode: memberRelationshipCode,
    );

    _selectedAddressId =
        member?.deliveryAddressId ??
        (widget.addresses.isNotEmpty ? widget.addresses.first.addressId : null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _occupationController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final relCode = _selectedRelationshipCode ?? 'other';

    if (phone.isEmpty || name.isEmpty || age < 1 || age > 120) {
      return;
    }

    widget.onSubmit?.call(
      phone: phone,
      displayName: name,
      occupation: _occupationController.text.trim().isEmpty
          ? null
          : _occupationController.text.trim(),
      relationshipCode: relCode,
      gender: _gender,
      ageYears: age,
      deliveryAddressId: _selectedAddressId,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final panelHeight = math.min(680.0, screenHeight - 24);
    final availableRelationships = buildFamilyRelationshipOptions(
      widget.relationships,
      selectedCode: _selectedRelationshipCode,
      includeSelectedRelationship: widget.member != null,
    );
    final selectedRelationshipCode = resolveFamilyRelationshipSelection(
      availableRelationships,
      selectedCode: _selectedRelationshipCode,
    );

    return BlocListener<FamilySubscriptionSetupViewModel, FamilyPlanState>(
      listenWhen: (previous, current) =>
          previous.memberLookup != current.memberLookup,
      listener: (context, state) {
        final lookup = state.memberLookup;
        if (lookup == null) return;
        setState(() {
          _nameController.text = lookup.found ? lookup.displayName ?? '' : '';
          _ageController.text = lookup.found
              ? lookup.ageYears?.toString() ?? ''
              : '';
          _gender = lookup.found ? lookup.gender ?? 1 : 1;
        });
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: panelHeight,
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.bottomSheetRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
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
                        AppTextField(
                          controller: _phoneController,
                          hint: l10n.family_phone_number_hint,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.search,
                          enabled: widget.member == null,
                          onSubmitted: (_) => _lookupPhone(),
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: color.onSurfaceVariant,
                            size: Spacing.iconSm,
                          ),
                          suffixIcon: IconButton(
                            tooltip: l10n.family_phone_lookup,
                            onPressed: widget.member == null
                                ? _lookupPhone
                                : null,
                            icon: const Icon(Icons.search_rounded),
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
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: color.onSurfaceVariant,
                            size: Spacing.iconSm,
                          ),
                        ),
                        const SizedBox(height: Spacing.md),

                        Text(
                          l10n.family_occupation,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        AppTextField(
                          controller: _occupationController,
                          hint: l10n.family_occupation_hint,
                          prefixIcon: Icon(
                            Icons.work_outline_rounded,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(
                                        Spacing.radiusMd,
                                      ),
                                      border: Border.all(
                                        color: color.outlineVariant,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: selectedRelationshipCode,
                                        dropdownColor: color.surface,
                                        items: availableRelationships.map((r) {
                                          return DropdownMenuItem<String>(
                                            value: r.code,
                                            child: Text(
                                              r.name(l10n.localeName),
                                              style: getRegularStyle(
                                                fontFamily:
                                                    FontConstant.alexandria,
                                                fontSize: FontSize.size11,
                                                color: color.onSurface,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            setState(
                                              () => _selectedRelationshipCode =
                                                  val,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
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
                          l10n.family_relation,
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
                              child: _GenderOption(
                                label: l10n.family_gender_male,
                                isSelected: _gender == 1,
                                onTap: () => setState(() => _gender = 1),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            Expanded(
                              child: _GenderOption(
                                label: l10n.family_gender_female,
                                isSelected: _gender == 2,
                                onTap: () => setState(() => _gender = 2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.md),

                        // Delivery address
                        if (widget.addresses.isNotEmpty) ...[
                          Text(
                            l10n.family_address_select,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: color.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(
                                Spacing.radiusMd,
                              ),
                              border: Border.all(color: color.outlineVariant),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedAddressId,
                                dropdownColor: color.surface,
                                items: widget.addresses.map((a) {
                                  final title = a.label.isNotEmpty
                                      ? a.label
                                      : a.addressLine;
                                  return DropdownMenuItem<String>(
                                    value: a.addressId,
                                    child: Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: getRegularStyle(
                                        fontFamily: FontConstant.alexandria,
                                        fontSize: FontSize.size11,
                                        color: color.onSurface,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() => _selectedAddressId = val);
                                },
                              ),
                            ),
                          ),
                        ],
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
    );
  }

  void _lookupPhone() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    context.read<FamilySubscriptionSetupViewModel>().doIntent(
      LookupFamilyMemberEvent(phone),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? color.primary.withValues(alpha: 0.08)
              : color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          border: Border.all(
            color: isSelected ? color.primary : color.outlineVariant,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: isSelected ? color.primary : color.onSurface,
          ),
        ),
      ),
    );
  }
}
