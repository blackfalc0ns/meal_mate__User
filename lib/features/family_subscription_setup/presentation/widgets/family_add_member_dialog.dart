import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_event.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/models/family_member_form_validation.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/models/family_relationship_options.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_member_dialog_actions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_member_dialog_header.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_member_form_fields_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_member_relationship_section.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/widgets/family_relationship_picker_sheet.dart';

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
          BlocProvider<CallingCodesViewModel>(
            create: (_) =>
                getIt<CallingCodesViewModel>()
                  ..doIntent(const LoadCallingCodesEvent()),
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
  String? _relationshipError;
  String? _selectedRelationshipCode;
  bool _phoneLookupBlocked = false;

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    _nameController = TextEditingController(text: member?.displayName ?? '');
    _phoneController = TextEditingController(text: member?.phoneNumber ?? '');
    _resolvedPhone = member?.phoneNumber;
    _relationshipController = TextEditingController();
    _selectedRelationshipCode = member?.relationshipCode;
    _ageController = TextEditingController(
      text: member != null && member.ageYears > 0
          ? member.ageYears.toString()
          : '',
    );
    _gender = member?.gender ?? 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final relationships = context
        .read<FamilySubscriptionSetupViewModel>()
        .state
        .relationships;
    _syncRelationshipName(
      relationships.isNotEmpty ? relationships : widget.relationships,
    );
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
    final setupVm = context.read<FamilySubscriptionSetupViewModel>();
    if (setupVm.state.isMemberSaving) return;

    final locale = context.localization;
    final name = _nameController.text.trim();
    final phone = _resolvedPhone?.trim() ?? '';
    final ageText = _ageController.text.trim();
    final age = int.tryParse(ageText) ?? 0;
    final relationshipCode = _selectedRelationshipCode;
    final stateRelationships = setupVm.state.relationships;
    final options = buildFamilyRelationshipOptions(
      stateRelationships.isNotEmpty ? stateRelationships : widget.relationships,
      selectedCode: relationshipCode,
      includeSelectedRelationship: widget.member != null,
    );
    final relationshipIsInvalid =
        relationshipCode == null ||
        !options.any((option) => option.code == relationshipCode);
    final phoneIsInvalid =
        _phoneController.text.trim().isNotEmpty &&
        validateFamilyMemberPhone(_resolvedPhone) != null;
    final nameIsInvalid = validateFamilyMemberName(name) != null;
    final ageIsInvalid = validateFamilyMemberAge(ageText) != null;

    if (phoneIsInvalid ||
        nameIsInvalid ||
        ageIsInvalid ||
        relationshipIsInvalid) {
      setState(() {
        _phoneError = phoneIsInvalid ? locale.phone_number_is_not_valid : null;
        _nameError = nameIsInvalid ? locale.name_is_required : null;
        _ageError = ageIsInvalid ? locale.family_age_invalid : null;
        _relationshipError = relationshipIsInvalid
            ? locale.family_relation_hint
            : null;
      });
      return;
    }

    if (phone.isNotEmpty && _phoneLookupBlocked) {
      return;
    }

    if (widget.member == null && phone.isNotEmpty) {
      final lookupState = setupVm.state;
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
      relationshipCode: relationshipCode,
      gender: _gender,
      ageYears: age,
      deliveryAddressId: null,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            listener: _handleLookupState,
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
                      FamilyMemberDialogHeader(
                        isEditing: widget.member != null,
                        onClose: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: Spacing.md),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: FamilyMemberFormFieldsSection(
                            nameController: _nameController,
                            phoneController: _phoneController,
                            ageController: _ageController,
                            gender: _gender,
                            isPhoneEnabled: widget.member == null,
                            nameError: _nameError,
                            phoneError: _phoneError,
                            ageError: _ageError,
                            onNameChanged: (_) {
                              if (_nameError == null) return;
                              setState(() => _nameError = null);
                            },
                            onPhoneChanged: _handlePhoneChanged,
                            onPhoneLookup: _lookupPhone,
                            onAgeChanged: (_) {
                              if (_ageError == null) return;
                              setState(() => _ageError = null);
                            },
                            onGenderChanged: (value) =>
                                setState(() => _gender = value),
                            relationshipChild: FamilyMemberRelationshipSection(
                              controller: _relationshipController,
                              errorText: _relationshipError,
                              onTap: _openRelationshipPicker,
                              onRelationshipsChanged: _syncRelationshipName,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      FamilyMemberDialogActions(
                        isEditing: widget.member != null,
                        onSubmit: _handleSubmit,
                        onCancel: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.08, end: 0),
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

  void _handleLookupState(BuildContext context, FamilyPlanState state) {
    final failure = state.memberLookupFailure;
    if (failure != null) {
      setState(() {
        _phoneError = ErrorMessagePresenter.fromFailure(context, failure);
        _phoneLookupBlocked = failure.code == 'family.already_in_family';
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
  }

  Future<void> _openRelationshipPicker() async {
    final viewModel = context.read<FamilySubscriptionSetupViewModel>();
    var relationships = viewModel.state.relationships.isNotEmpty
        ? viewModel.state.relationships
        : widget.relationships;
    if (relationships.isEmpty) {
      if (!viewModel.state.isRelationshipsLoading) {
        viewModel.doIntent(const GetFamilyRelationshipsEvent());
      }
      late final FamilyPlanState state;
      try {
        state = await viewModel.stream.firstWhere(
          (state) => !state.isRelationshipsLoading,
        );
      } on StateError {
        return;
      }
      if (!mounted) return;
      relationships = state.relationships;
      if (relationships.isEmpty) {
        final failure = state.failure;
        if (failure != null) {
          CustomSnackbar.showError(
            context: context,
            message: ErrorMessagePresenter.fromFailure(context, failure),
          );
        }
        return;
      }
    }
    final selected = await FamilyRelationshipPickerSheet.show(
      context: context,
      relationships: relationships,
      selectedCode: _selectedRelationshipCode,
      includeSelectedRelationship: widget.member != null,
    );
    if (!mounted || selected == null) return;
    _selectedRelationshipCode = selected.code;
    _relationshipController.text = selected.name(
      context.localization.localeName,
    );
    if (_relationshipError != null) {
      setState(() => _relationshipError = null);
    }
  }

  void _syncRelationshipName(List<FamilyRelationshipEntity> relationships) {
    final selected = relationships
        .where((relationship) => relationship.code == _selectedRelationshipCode)
        .firstOrNull;
    if (selected == null) return;
    final name = selected.name(context.localization.localeName);
    if (_relationshipController.text != name) {
      _relationshipController.text = name;
    }
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
      CustomSnackbar.showError(
        context: context,
        message: ErrorMessagePresenter.fromFailure(context, failure),
      );
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
