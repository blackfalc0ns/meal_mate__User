import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_lookup_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_actions_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_member_form_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_members_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_setup_name_section.dart';

class FamilySubscriptionSetupContent extends StatefulWidget {
  const FamilySubscriptionSetupContent({
    super.key,
    required this.members,
    this.maxMembers = 6,
    this.minMembers = 2,
    required this.relationships,
    required this.isMemberSaving,
    required this.isMemberLookupLoading,
    this.memberLookup,
    this.memberLookupFailure,
    this.memberSaveSuccess = false,
    required this.familyNameController,
    required this.onSaveFamilyName,
  });

  final List<FamilyMemberEntity> members;
  final int maxMembers;
  final int minMembers;
  final List<FamilyRelationshipEntity> relationships;
  final bool isMemberSaving;
  final bool isMemberLookupLoading;
  final FamilyMemberLookupEntity? memberLookup;
  final Failure? memberLookupFailure;
  final bool memberSaveSuccess;
  final TextEditingController familyNameController;
  final VoidCallback onSaveFamilyName;

  @override
  State<FamilySubscriptionSetupContent> createState() =>
      _FamilySubscriptionSetupContentState();
}

class _FamilySubscriptionSetupContentState
    extends State<FamilySubscriptionSetupContent> {
  final GlobalKey<FamilySetupMemberFormSectionState> _formKey =
      GlobalKey<FamilySetupMemberFormSectionState>();
  final ValueNotifier<bool> _hasMemberInput = ValueNotifier<bool>(false);
  String? _selectedMemberId;

  @override
  void dispose() {
    _hasMemberInput.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FamilySubscriptionSetupContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.memberSaveSuccess && widget.memberSaveSuccess) {
      if (_selectedMemberId != null) {
        setState(() => _selectedMemberId = null);
      }
      _hasMemberInput.value = false;
    }
  }

  void _onMemberSelected(FamilyMemberEntity member) {
    setState(() {
      if (_selectedMemberId == member.memberId) {
        _selectedMemberId = null;
        _formKey.currentState?.resetForm();
        _hasMemberInput.value = false;
      } else {
        _selectedMemberId = member.memberId;
      }
    });
  }

  void _onAddMemberTap() {
    if (_selectedMemberId != null) {
      setState(() => _selectedMemberId = null);
    }
    _formKey.currentState?.resetForm();
    _hasMemberInput.value = false;
  }

  void _handleSubmitMember({
    required String phone,
    required String displayName,
    required String relationshipCode,
    required int gender,
    required int ageYears,
  }) {
    final vm = context.read<FamilySubscriptionSetupViewModel>();
    if (_selectedMemberId == null) {
      if (widget.members.length >= widget.maxMembers) {
        CustomSnackbar.showError(
          context: context,
          message: context.localization.family_members_max_reached,
        );
        return;
      }
      vm.doIntent(
        AddFamilyMemberEvent(
          phone: phone,
          displayName: displayName,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: ageYears,
          deliveryAddressId: null,
        ),
      );
    } else {
      vm.doIntent(
        UpdateFamilyMemberEvent(
          memberId: _selectedMemberId!,
          phone: phone,
          displayName: displayName,
          relationshipCode: relationshipCode,
          gender: gender,
          ageYears: ageYears,
          deliveryAddressId: null,
        ),
      );
    }
  }

  void _handleLookupPhone(String phone) {
    context.read<FamilySubscriptionSetupViewModel>().doIntent(
      LookupFamilyMemberEvent(phone),
    );
  }

  Future<void> _onNext() async {
    widget.onSaveFamilyName();
    await context.pushNamed(AppRoutes.familyProgramSetup);
  }

  @override
  Widget build(BuildContext context) {
    final isInFamilyFlow = FamilyFlowScope.isActive(context);
    final selectedMember = widget.members
        .where((m) => m.memberId == _selectedMemberId)
        .firstOrNull;

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
          const SizedBox(height: Spacing.md),
          FamilySetupMembersSection(
            members: widget.members,
            maxMembers: widget.maxMembers,
            selectedMemberId: _selectedMemberId,
            onMemberSelected: _onMemberSelected,
            onAddMemberTap: _onAddMemberTap,
          ),
          if (widget.members.isNotEmpty) const SizedBox(height: Spacing.md),
          FamilySetupMemberFormSection(
            key: _formKey,
            relationships: widget.relationships,
            selectedMember: selectedMember,
            isMemberSaving: widget.isMemberSaving,
            isMemberLookupLoading: widget.isMemberLookupLoading,
            memberLookup: widget.memberLookup,
            memberLookupFailure: widget.memberLookupFailure,
            memberSaveSuccess: widget.memberSaveSuccess,
            onLookupPhone: _handleLookupPhone,
            onSubmitMember: _handleSubmitMember,
            onFormReset: () {
              if (_selectedMemberId != null) {
                setState(() => _selectedMemberId = null);
              }
              _hasMemberInput.value = false;
            },
            onInputChanged: (hasInput) => _hasMemberInput.value = hasInput,
          ),
          const SizedBox(height: Spacing.familySetupSectionGap),
          ValueListenableBuilder<bool>(
            valueListenable: _hasMemberInput,
            builder: (context, hasInput, _) {
              return FamilySetupActionsSection(
                isEditing: _selectedMemberId != null,
                hasMemberInput: hasInput,
                isLimitReached: widget.members.length >= widget.maxMembers,
                canProceed: widget.members.length >= widget.minMembers,
                isMemberSaving: widget.isMemberSaving,
                onAddOrUpdateMember: () => _formKey.currentState?.submit(),
                onNext: _onNext,
              );
            },
          ),
          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}
