import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_actions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_relationship_picker_sheet.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_form_card.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_name_section.dart';

class FamilySubscriptionSetupContent extends StatefulWidget {
  const FamilySubscriptionSetupContent({
    super.key,
    required this.state,
    required this.familyNameController,
    required this.onSaveFamilyName,
  });

  final FamilyPlanState state;
  final TextEditingController familyNameController;
  final VoidCallback onSaveFamilyName;

  @override
  State<FamilySubscriptionSetupContent> createState() =>
      _FamilySubscriptionSetupContentState();
}

class _FamilySubscriptionSetupContentState
    extends State<FamilySubscriptionSetupContent> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ageController;
  String? _selectedRelationshipCode;
  String? _selectedMemberId;
  int? _gender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _ageController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant FamilySubscriptionSetupContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.isMemberSaving &&
        !widget.state.isMemberSaving &&
        widget.state.memberSaveSuccess) {
      _resetMemberForm();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _resetMemberForm() {
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _ageController.clear();
      _selectedRelationshipCode = null;
      _selectedMemberId = null;
      _gender = null;
    });
  }

  void _onMemberSelected(FamilyMemberEntity member) {
    if (_selectedMemberId == member.memberId) {
      _resetMemberForm();
      return;
    }
    setState(() {
      _selectedMemberId = member.memberId;
      _nameController.text = member.displayName;
      _phoneController.text = member.phoneNumber ?? '';
      _ageController.text = member.ageYears > 0
          ? member.ageYears.toString()
          : '';
      _gender = member.gender;
      _selectedRelationshipCode = member.relationshipCode;
    });
  }

  Future<void> _onPickRelationship(BuildContext context) async {
    final relationships = widget.state.relationships;
    if (relationships.isEmpty) return;

    final selected = await FamilyRelationshipPickerSheet.show(
      context: context,
      relationships: relationships,
      selectedCode: _selectedRelationshipCode,
      includeSelectedRelationship: _selectedMemberId != null,
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedRelationshipCode = selected.code;
      });
    }
  }

  String _resolveAvatar(int gender, int index) {
    if (gender == 2) {
      return index % 2 == 0
          ? AssetsFake.familyMemberSarah
          : AssetsFake.familyMemberMariam;
    }
    return index % 2 == 0
        ? AssetsFake.familyMemberAhmed
        : AssetsFake.familyMemberYousef;
  }

  void _onAddOrUpdateMember() {
    final locale = context.localization;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
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
        _selectedRelationshipCode ??
        widget.state.relationships.firstOrNull?.code;
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

    final vm = context.read<FamilySubscriptionSetupViewModel>();

    if (_selectedMemberId == null) {
      vm.doIntent(
        AddFamilyMemberEvent(
          phone: phone,
          displayName: name,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: age,
          deliveryAddressId: null,
        ),
      );
    } else {
      vm.doIntent(
        UpdateFamilyMemberEvent(
          memberId: _selectedMemberId!,
          phone: phone,
          displayName: name,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: age,
          deliveryAddressId: null,
        ),
      );
    }
  }

  Future<void> _onNext() async {
    widget.onSaveFamilyName();
    await context.pushNamed(AppRoutes.familyProgramSetup);
  }

  String _getRelationshipDisplayName(BuildContext context) {
    if (_selectedRelationshipCode == null) return '';
    final locale = context.localization;
    final match = widget.state.relationships.firstWhere(
      (r) => r.code == _selectedRelationshipCode,
      orElse: () => FamilyRelationshipEntity(
        code: _selectedRelationshipCode!,
        nameAr: '',
        nameEn: '',
        forDependents: true,
        isPrimary: false,
      ),
    );
    return match.name(locale.localeName);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    final memberUiModels = widget.state.members.asMap().entries.map((entry) {
      final index = entry.key;
      final member = entry.value;
      final isSelected = _selectedMemberId == member.memberId;
      return FamilyProgramMemberUiModel(
        name: member.displayName,
        imageAsset: _resolveAvatar(member.gender, index),
        status: locale.family_member_completed,
        isSelected: isSelected,
        isInProgress: false,
      );
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.familySetupHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isInFamilyFlow) ...[
            const SizedBox(height: Spacing.md),
            const FamilyProgramStepper(
              currentStep: 0,
              completedSteps: 1,
              includeFamilyCreationStep: true,
            ),
            const SizedBox(height: Spacing.lg),
          ] else ...[
            const SizedBox(height: Spacing.sm),
          ],
          FamilySetupNameSection(
            controller: widget.familyNameController,
            onSubmitted: widget.onSaveFamilyName,
          ),
          const SizedBox(height: Spacing.sm),
          if (memberUiModels.isNotEmpty) ...[
            FamilyProgramMemberStrip(
              members: memberUiModels,
              onSelectMember: (index) =>
                  _onMemberSelected(widget.state.members[index]),
            ),
            const SizedBox(height: Spacing.sm),
          ],
          FamilySetupFormCard(
            nameController: _nameController,
            phoneController: _phoneController,
            ageController: _ageController,
            relationshipText: _getRelationshipDisplayName(context),
            onRelationshipTap: () => _onPickRelationship(context),
            gender: _gender,
            onGenderChanged: (value) => setState(() => _gender = value),
          ),
          const SizedBox(height: Spacing.familySetupSectionGap),
          FamilyFlowActions(
            secondaryText: _selectedMemberId != null
                ? locale.profile_personal_info_save
                : locale.family_add_member_button,
            secondaryIcon: _selectedMemberId != null
                ? Icons.check_rounded
                : Icons.add_rounded,
            onSecondaryPressed: _onAddOrUpdateMember,
            isSecondaryLoading: widget.state.isMemberSaving,
            primaryText: locale.family_next_program,
            primaryIcon: Icons.chevron_right_rounded,
            onPrimaryPressed: _onNext,
          ),
          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}
