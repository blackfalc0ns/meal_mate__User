import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_view_model.dart';

class FamilyMemberEditBottomSheet extends StatefulWidget {
  const FamilyMemberEditBottomSheet({
    super.key,
    required this.viewModel,
    required this.detail,
  });

  final FamilyMemberViewModel viewModel;
  final FamilyMemberDetailEntity detail;

  static Future<void> show(
    BuildContext context, {
    required FamilyMemberViewModel viewModel,
    required FamilyMemberDetailEntity detail,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Spacing.lg)),
      ),
      builder: (_) => FamilyMemberEditBottomSheet(
        viewModel: viewModel,
        detail: detail,
      ),
    );
  }

  @override
  State<FamilyMemberEditBottomSheet> createState() =>
      _FamilyMemberEditBottomSheetState();
}

class _FamilyMemberEditBottomSheetState
    extends State<FamilyMemberEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneController;
  late String _relationshipCode;
  late int _gender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.detail.displayName);
    _ageController =
        TextEditingController(text: widget.detail.ageYears?.toString() ?? '');
    _phoneController =
        TextEditingController(text: widget.detail.phoneNumber ?? '');
    _relationshipCode = widget.detail.relationshipCode ?? 'child';
    _gender = 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    final request = FamilyMemberWriteRequestDto(
      displayName: _nameController.text.trim(),
      relationshipCode: _relationshipCode,
      gender: _gender,
      ageYears: int.tryParse(_ageController.text.trim()) ?? 0,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
    );

    widget.viewModel.doIntent(
      UpdateFamilyMemberBasicInfoEvent(widget.detail.memberId, request),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: EdgeInsets.only(
        left: Spacing.md,
        right: Spacing.md,
        top: Spacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + Spacing.md,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                locale.family_edit_member,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.md),
              AppTextField(
                controller: _nameController,
                label: locale.auth_name_label,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return locale.name_is_required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.sm),
              AppTextField(
                controller: _ageController,
                label: locale.localeName == 'ar' ? 'العمر' : 'Age',
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return locale.name_is_required;
                  }
                  final n = int.tryParse(val.trim());
                  if (n == null || n < 1 || n > 120) {
                    return locale.family_age_invalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.sm),
              AppTextField(
                controller: _phoneController,
                label: locale.phone_number,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: Spacing.md),
              AppButton(
                text: locale.profile_personal_info_save,
                onPressed: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
