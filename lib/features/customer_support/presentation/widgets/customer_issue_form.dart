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
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_state.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_view_model.dart';
import 'package:meal_meat_user/features/customer_support/presentation/widgets/customer_issue_category_bottom_sheet.dart';

class CustomerIssueForm extends StatefulWidget {
  const CustomerIssueForm({super.key, this.initialBox});

  final DeliveredBoxEntity? initialBox;

  @override
  State<CustomerIssueForm> createState() => _CustomerIssueFormState();
}

class _CustomerIssueFormState extends State<CustomerIssueForm> {
  final _subject = TextEditingController();
  final _description = TextEditingController();
  String? _typeCode;
  DeliveredBoxEntity? _box;
  String? _subjectError;
  String? _descriptionError;
  String? _typeCodeError;

  @override
  void initState() {
    super.initState();
    _box = widget.initialBox;
  }

  @override
  void dispose() {
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    final locale = context.localization;
    final subject = _subject.text.trim();
    final description = _description.text.trim();
    final typeCode = _typeCode;

    setState(() {
      _typeCodeError = typeCode == null
          ? locale.customer_support_category_error
          : null;
      _subjectError = subject.isEmpty
          ? locale.profile_support_subject_error
          : null;
      _descriptionError = description.isEmpty
          ? locale.profile_support_message_error
          : null;
    });

    if (subject.isEmpty || description.isEmpty || typeCode == null) return;

    unawaited(
      context.read<CustomerSupportViewModel>().createIssue(
        typeCode: typeCode,
        subject: subject,
        description: description,
        box: _box,
      ),
    );
  }

  void _openCategoryPicker(
    BuildContext context,
    List<CustomerSupportOptionEntity> options,
  ) {
    unawaited(
      CustomerIssueCategoryBottomSheet.show(
        context: context,
        options: options,
        selectedTypeCode: _typeCode,
        onSelected: (option) {
          setState(() {
            _typeCode = option.value;
            _typeCodeError = null;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocConsumer<CustomerSupportViewModel, CustomerSupportState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.createdIssue != current.createdIssue,
      listener: (context, state) {
        if (state.errorMessage case final String error) {
          CustomSnackbar.showError(context: context, message: error);
        }
        if (state.createdIssue != null) {
          CustomSnackbar.showSuccess(
            context: context,
            message: locale.customer_support_created,
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final selectedOption = state.options
            .where((opt) => opt.value == _typeCode)
            .firstOrNull;

        return Container(
          padding: const EdgeInsets.all(Spacing.cardPadding),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.03),
                blurRadius: Spacing.md,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Category Field
              Text(
                locale.profile_support_category_label,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),

              if (state.loading && state.options.isEmpty)
                ShimmerWidget(
                  child: Container(
                    height: Spacing.inputHeight,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(Spacing.inputRadius),
                    ),
                  ),
                )
              else if (state.options.isEmpty)
                AppButton.outlined(
                  text: locale.customer_support_retry,
                  onPressed: () =>
                      context.read<CustomerSupportViewModel>().loadOptions(),
                )
              else ...[
                InkWell(
                  onTap: state.submitting
                      ? null
                      : () => _openCategoryPicker(context, state.options),
                  borderRadius: BorderRadius.circular(Spacing.inputRadius),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.base,
                      vertical: Spacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(Spacing.inputRadius),
                      border: Border.all(
                        color: _typeCodeError != null
                            ? color.error
                            : color.outlineVariant.withValues(alpha: 0.8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: Spacing.iconSm,
                          color: selectedOption != null
                              ? color.primary
                              : color.onSurfaceVariant,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            selectedOption?.label ??
                                locale.customer_support_choose_category_hint,
                            style: selectedOption != null
                                ? getMediumStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size13,
                                    color: color.onSurface,
                                  )
                                : getRegularStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size13,
                                    color: color.onSurfaceVariant,
                                  ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: Spacing.iconMd,
                          color: color.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_typeCodeError != null) ...[
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    _typeCodeError!,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.error,
                    ),
                  ),
                ],
              ],

              // 2. Linked Delivery Box (Only displayed when initiated from an order)
              if (widget.initialBox != null && _box != null) ...[
                const SizedBox(height: Spacing.base),
                Text(
                  locale.customer_support_linked_order,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                    border: Border.all(
                      color: color.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: Spacing.avatarSm,
                        height: Spacing.avatarSm,
                        decoration: BoxDecoration(
                          color: color.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.restaurant_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _box!.restaurantNameAr ??
                                  _box!.restaurantNameEn ??
                                  locale.customer_orders_delivered_box,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size12,
                                color: color.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: Spacing.xxs),
                            Row(
                              children: [
                                if (_box!.orderCode != null) ...[
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                      _box!.orderCode!,
                                      style: getMediumStyle(
                                        fontFamily: FontConstant.alexandria,
                                        fontSize: FontSize.size11,
                                        color: color.primary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' • ',
                                    style: TextStyle(
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                                Text(
                                  _box!.serviceDate,
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size11,
                                    color: color.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: Spacing.base),

              // 3. Subject Field
              Text(
                locale.profile_support_subject_label,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              AppTextField(
                controller: _subject,
                hint: locale.profile_support_subject_hint,
                errorText: _subjectError,
                enabled: !state.submitting,
              ),

              const SizedBox(height: Spacing.base),

              // 4. Message Field
              Text(
                locale.profile_support_message_label,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              AppTextField(
                controller: _description,
                hint: locale.profile_support_message_hint,
                errorText: _descriptionError,
                maxLines: 5,
                enabled: !state.submitting,
              ),

              const SizedBox(height: Spacing.xl),

              // 5. Submit Button
              AppButton.filled(
                text: state.submitting
                    ? locale.profile_support_submitting
                    : locale.profile_support_submit_button,
                onPressed:
                    state.submitting ||
                        state.options.isEmpty ||
                        _typeCode == null
                    ? null
                    : _submit,
                isLoading: state.submitting,
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
