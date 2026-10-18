import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_lookup_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_relationship_picker_sheet.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_form_card.dart';

typedef OnSubmitMemberCallback =
    void Function({
      required String phone,
      required String displayName,
      required String relationshipCode,
      required int gender,
      required int ageYears,
    });

class FamilySetupMemberFormSection extends StatefulWidget {
  const FamilySetupMemberFormSection({
    super.key,
    required this.relationships,
    this.selectedMember,
    required this.isMemberSaving,
    required this.isMemberLookupLoading,
    this.memberLookup,
    this.memberLookupFailure,
    this.memberSaveSuccess = false,
    required this.onLookupPhone,
    required this.onSubmitMember,
    this.onFormReset,
    this.onInputChanged,
  });

  final List<FamilyRelationshipEntity> relationships;
  final FamilyMemberEntity? selectedMember;
  final bool isMemberSaving;
  final bool isMemberLookupLoading;
  final FamilyMemberLookupEntity? memberLookup;
  final Failure? memberLookupFailure;
  final bool memberSaveSuccess;
  final ValueChanged<String> onLookupPhone;
  final OnSubmitMemberCallback onSubmitMember;
  final VoidCallback? onFormReset;
  final ValueChanged<bool>? onInputChanged;

  @override
  State<FamilySetupMemberFormSection> createState() =>
      FamilySetupMemberFormSectionState();
}

class FamilySetupMemberFormSectionState
    extends State<FamilySetupMemberFormSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ageController;
  late final TextEditingController _relationshipController;

  String? _selectedRelationshipCode;
  int? _gender;
  Timer? _phoneDebounce;
  String? _lastLookedUpPhone;
  String? _phoneError;
  bool _lastHasInput = false;

  bool _computeHasInput() {
    return _nameController.text.trim().isNotEmpty ||
        _phoneController.text.trim().isNotEmpty ||
        _ageController.text.trim().isNotEmpty ||
        _relationshipController.text.trim().isNotEmpty ||
        _selectedRelationshipCode != null ||
        _gender != null;
  }

  void _checkInputChanged() {
    final current = _computeHasInput();
    if (_lastHasInput != current) {
      _lastHasInput = current;
      widget.onInputChanged?.call(current);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _ageController = TextEditingController();
    _relationshipController = TextEditingController();
    _populateFromMember(widget.selectedMember);
    _nameController.addListener(_checkInputChanged);
    _phoneController.addListener(_checkInputChanged);
    _ageController.addListener(_checkInputChanged);
    _relationshipController.addListener(_checkInputChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncRelationshipText();
  }

  void _syncRelationshipText() {
    if (_selectedRelationshipCode == null) {
      if (_relationshipController.text.isNotEmpty) {
        _relationshipController.clear();
      }
      return;
    }
    final match = widget.relationships
        .where((r) => r.code == _selectedRelationshipCode)
        .firstOrNull;
    if (match != null) {
      final name = match.name(context.localization.localeName);
      if (_relationshipController.text != name) {
        _relationshipController.text = name;
      }
    }
  }

  @override
  void didUpdateWidget(covariant FamilySetupMemberFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedMember?.memberId != widget.selectedMember?.memberId) {
      _populateFromMember(widget.selectedMember);
      _syncRelationshipText();
    } else if (oldWidget.relationships != widget.relationships) {
      _syncRelationshipText();
    }

    if (oldWidget.onInputChanged != widget.onInputChanged) {
      widget.onInputChanged?.call(_computeHasInput());
    }

    if (!oldWidget.memberSaveSuccess && widget.memberSaveSuccess) {
      resetForm();
    }

    if (oldWidget.memberLookup != widget.memberLookup &&
        widget.memberLookup != null) {
      final lookup = widget.memberLookup!;
      if (lookup.found) {
        if (lookup.displayName != null && lookup.displayName!.isNotEmpty) {
          _nameController.text = lookup.displayName!;
        } else {
          _nameController.clear();
        }
        if (lookup.ageYears != null && lookup.ageYears! > 0) {
          _ageController.text = lookup.ageYears.toString();
        }
        if (lookup.gender != null) {
          _gender = lookup.gender;
        }
        _phoneError = null;
        setState(() {});
      } else {
        _nameController.clear();
        _ageController.clear();
        _gender = null;
        setState(() {});
      }
      _checkInputChanged();
    }

    if (oldWidget.memberLookupFailure != widget.memberLookupFailure &&
        widget.memberLookupFailure != null) {
      _nameController.clear();
      _ageController.clear();
      _gender = null;
      setState(() {
        _phoneError = ErrorMessagePresenter.fromFailure(
          context,
          widget.memberLookupFailure!,
        );
      });
      _checkInputChanged();
    }
  }

  void _populateFromMember(FamilyMemberEntity? member) {
    _phoneDebounce?.cancel();
    _lastLookedUpPhone = null;
    _phoneError = null;

    if (member != null) {
      _nameController.text = member.displayName;
      _phoneController.text = member.phoneNumber ?? '';
      _ageController.text = member.ageYears > 0
          ? member.ageYears.toString()
          : '';
      _gender = member.gender;
      _selectedRelationshipCode = member.relationshipCode;
    } else {
      _nameController.clear();
      _phoneController.clear();
      _ageController.clear();
      _relationshipController.clear();
      _gender = null;
      _selectedRelationshipCode = null;
    }
    setState(() {});
    _checkInputChanged();
  }

  @override
  void dispose() {
    _phoneDebounce?.cancel();
    _nameController.removeListener(_checkInputChanged);
    _phoneController.removeListener(_checkInputChanged);
    _ageController.removeListener(_checkInputChanged);
    _relationshipController.removeListener(_checkInputChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void resetForm() {
    _phoneDebounce?.cancel();
    _lastLookedUpPhone = null;
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _ageController.clear();
      _relationshipController.clear();
      _selectedRelationshipCode = null;
      _gender = null;
      _phoneError = null;
    });
    _checkInputChanged();
    widget.onFormReset?.call();
  }

  void _onPhoneChanged(String value) {
    if (_phoneError != null) {
      setState(() => _phoneError = null);
    }
    _phoneDebounce?.cancel();

    if (widget.selectedMember != null) return;

    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 8) {
      _phoneDebounce = Timer(const Duration(milliseconds: 600), () {
        _triggerPhoneLookup(value);
      });
    }
  }

  void _triggerPhoneLookup(String rawPhone) {
    final formattedPhone = CallingCodeEntity.kuwaitFallback
        .formatInternationalPhone(rawPhone);
    if (formattedPhone == _lastLookedUpPhone) return;
    _lastLookedUpPhone = formattedPhone;
    widget.onLookupPhone(formattedPhone);
  }

  Future<void> _onPickRelationship(BuildContext context) async {
    final relationships = widget.relationships;
    if (relationships.isEmpty) return;

    final selected = await FamilyRelationshipPickerSheet.show(
      context: context,
      relationships: relationships,
      selectedCode: _selectedRelationshipCode,
      includeSelectedRelationship: widget.selectedMember != null,
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedRelationshipCode = selected.code;
        _relationshipController.text = selected.name(
          context.localization.localeName,
        );
      });
      _checkInputChanged();
    }
  }

  void submit() {
    final locale = context.localization;
    final name = _nameController.text.trim();
    final rawPhone = _phoneController.text.trim();
    if (rawPhone.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: locale.phone_number_is_required,
      );
      return;
    }
    final phone = CallingCodeEntity.kuwaitFallback.formatInternationalPhone(
      rawPhone,
    );
    final ageText = _ageController.text.trim();
    final age = int.tryParse(ageText) ?? 0;

    if (name.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: locale.name_is_required,
      );
      return;
    }

    if (age <= 0 || age > 120) {
      CustomSnackbar.showError(
        context: context,
        message: locale.family_age_invalid,
      );
      return;
    }

    final relationshipCode =
        _selectedRelationshipCode ?? widget.relationships.firstOrNull?.code;
    if (relationshipCode == null) {
      CustomSnackbar.showError(
        context: context,
        message: locale.family_relation_hint,
      );
      return;
    }

    final gender = _gender;
    if (gender == null) {
      CustomSnackbar.showError(context: context, message: locale.family_gender);
      return;
    }

    widget.onSubmitMember(
      phone: phone,
      displayName: name,
      relationshipCode: relationshipCode,
      gender: gender,
      ageYears: age,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FamilySetupFormCard(
      nameController: _nameController,
      phoneController: _phoneController,
      ageController: _ageController,
      relationshipController: _relationshipController,
      onRelationshipTap: () => _onPickRelationship(context),
      gender: _gender,
      onGenderChanged: (value) {
        setState(() => _gender = value);
        _checkInputChanged();
      },
      isPhoneLoading: widget.isMemberLookupLoading,
      phoneError: _phoneError,
      onPhoneChanged: _onPhoneChanged,
    );
  }
}
