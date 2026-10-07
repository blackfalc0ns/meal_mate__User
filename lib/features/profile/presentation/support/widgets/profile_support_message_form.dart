import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/profile/data/fake/profile_support_fake_data.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_message_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/support/manager/profile_support_form_state.dart';
import 'package:meal_meat_user/features/profile/presentation/support/manager/profile_support_form_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/support/widgets/profile_support_demo_result_sheet.dart';

class ProfileSupportMessageForm extends StatefulWidget {
  const ProfileSupportMessageForm({super.key, required this.kind});

  final ProfileSupportMessageKind kind;

  @override
  State<ProfileSupportMessageForm> createState() =>
      _ProfileSupportMessageFormState();
}

class _ProfileSupportMessageFormState extends State<ProfileSupportMessageForm> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _messageFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  String? _selectedCategory;
  String? _subjectError;
  String? _messageError;
  String? _emailError;

  static final RegExp _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    if (widget.kind == ProfileSupportMessageKind.complaint) {
      _selectedCategory = ProfileSupportFakeData.complaintCategories.first.id;
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _emailController.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _resetForm() {
    _subjectController.clear();
    _messageController.clear();
    _emailController.clear();
    setState(() {
      _subjectError = null;
      _messageError = null;
      _emailError = null;
      if (widget.kind == ProfileSupportMessageKind.complaint) {
        _selectedCategory = ProfileSupportFakeData.complaintCategories.first.id;
      }
    });
    context.read<ProfileSupportFormViewModel>().reset();
  }

  void _submit() {
    final locale = context.localization;
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    final email = _emailController.text.trim();

    var hasError = false;

    if (subject.isEmpty) {
      setState(() => _subjectError = locale.profile_support_subject_error);
      hasError = true;
    } else {
      setState(() => _subjectError = null);
    }

    if (message.isEmpty) {
      setState(() => _messageError = locale.profile_support_message_error);
      hasError = true;
    } else {
      setState(() => _messageError = null);
    }

    if (email.isNotEmpty && !_emailRegExp.hasMatch(email)) {
      setState(() => _emailError = locale.profile_support_email_error);
      hasError = true;
    } else {
      setState(() => _emailError = null);
    }

    if (hasError) return;

    final request = ProfileSupportMessageEntity(
      kind: widget.kind,
      subject: subject,
      message: message,
      replyEmail: email.isEmpty ? null : email,
      category: _selectedCategory,
    );

    unawaited(context.read<ProfileSupportFormViewModel>().submit(request));
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocConsumer<ProfileSupportFormViewModel, ProfileSupportFormState>(
      listenWhen: (previous, current) =>
          previous.result != current.result ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          CustomSnackbar.showError(
            context: context,
            message: state.errorMessage!,
          );
        } else if (state.result != null) {
          context.read<ProfileSupportFormViewModel>().consumeResult();
          unawaited(
            ProfileSupportDemoResultSheet.show(
              context: context,
              onResetForm: _resetForm,
            ),
          );
        }
      },
      builder: (context, state) {
        final isBusy = state.isSubmitting;

        return Container(
          padding: const EdgeInsets.all(Spacing.cardPadding),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.kind == ProfileSupportMessageKind.complaint) ...[
                Text(
                  locale.profile_support_category_label,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Wrap(
                  spacing: Spacing.sm,
                  runSpacing: Spacing.xs,
                  children: ProfileSupportFakeData.complaintCategories.map((
                    cat,
                  ) {
                    final isSelected = _selectedCategory == cat.id;
                    return ChoiceChip(
                      selected: isSelected,
                      label: Text(
                        cat.label(locale),
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: isSelected ? color.onPrimary : color.onSurface,
                        ),
                      ),
                      selectedColor: color.primary,
                      backgroundColor: color.surface,
                      side: BorderSide(
                        color: isSelected
                            ? color.primary
                            : color.outlineVariant.withValues(alpha: 0.6),
                      ),
                      onSelected: isBusy
                          ? null
                          : (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = cat.id;
                                });
                              }
                            },
                    );
                  }).toList(),
                ),
                const SizedBox(height: Spacing.md),
              ],
              Text(
                locale.profile_support_subject_label,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              AppTextField(
                controller: _subjectController,
                focusNode: _subjectFocus,
                hint: locale.profile_support_subject_hint,
                errorText: _subjectError,
                enabled: !isBusy,
                onChanged: (_) {
                  if (_subjectError != null) {
                    setState(() => _subjectError = null);
                  }
                },
              ),
              const SizedBox(height: Spacing.md),
              Text(
                locale.profile_support_message_label,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              AppTextField(
                controller: _messageController,
                focusNode: _messageFocus,
                hint: locale.profile_support_message_hint,
                errorText: _messageError,
                maxLines: 5,
                enabled: !isBusy,
                onChanged: (_) {
                  if (_messageError != null) {
                    setState(() => _messageError = null);
                  }
                },
              ),
              const SizedBox(height: Spacing.md),
              Text(
                locale.profile_support_email_label,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              AppTextField(
                controller: _emailController,
                focusNode: _emailFocus,
                hint: locale.profile_support_email_hint,
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
                enabled: !isBusy,
                onChanged: (_) {
                  if (_emailError != null) {
                    setState(() => _emailError = null);
                  }
                },
              ),
              const SizedBox(height: Spacing.lg),
              AppButton.filled(
                text: isBusy
                    ? locale.profile_support_submitting
                    : locale.profile_support_submit_button,
                onPressed: isBusy ? null : _submit,
                isLoading: isBusy,
                height: Spacing.buttonHeight,
                borderRadius: Spacing.buttonRadius,
                color: color.primary,
                textColor: color.onPrimary,
                fontSize: FontSize.size13,
              ),
            ],
          ),
        );
      },
    );
  }
}
