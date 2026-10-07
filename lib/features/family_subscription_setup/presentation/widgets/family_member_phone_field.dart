import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/calling_codes_bottom_sheet.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/country_code_prefix.dart';

class FamilyMemberPhoneField extends StatefulWidget {
  const FamilyMemberPhoneField({
    super.key,
    required this.controller,
    required this.onPhoneChanged,
    required this.onLookup,
    this.enabled = true,
    this.isLoading = false,
    this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String?> onPhoneChanged;
  final ValueChanged<String> onLookup;
  final bool enabled;
  final bool isLoading;
  final String? errorText;

  @override
  State<FamilyMemberPhoneField> createState() => _FamilyMemberPhoneFieldState();
}

class _FamilyMemberPhoneFieldState extends State<FamilyMemberPhoneField> {
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  String? _lastLookedUpPhone;
  CallingCodeEntity? _selectedCallingCode;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocBuilder<CallingCodesViewModel, CallingCodesState>(
      buildWhen: (previous, current) =>
          previous.items != current.items || previous.selected != current.selected,
      builder: (context, state) {
        final callingCode = _resolveCallingCode(state);
        return AppTextField(
          controller: widget.controller,
          focusNode: _focusNode,
          hint: locale.family_phone_number_hint,
          errorText: widget.errorText,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.search,
          enabled: widget.enabled,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-()]')),
          ],
          onChanged: (value) => _handleChanged(callingCode, value),
          onSubmitted: (_) => _lookup(callingCode),
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: color.onSurfaceVariant,
            size: Spacing.iconSm,
          ),
          suffixIcon: widget.isLoading
              ? Padding(
                  padding: const EdgeInsets.all(Spacing.sm),
                  child: CircularProgressIndicator(
                    strokeWidth: Spacing.border * 2,
                    color: color.primary,
                  ),
                )
              : CountryCodePrefix(
                  callingCode: callingCode,
                  onTap: widget.enabled
                      ? () => _openCallingCodesSheet(context)
                      : null,
                ),
        );
      },
    );
  }

  void _handleChanged(CallingCodeEntity callingCode, String value) {
    _debounce?.cancel();
    _lastLookedUpPhone = null;
    final isComplete = callingCode.hasCompleteLocalPhone(value);
    widget.onPhoneChanged(
      isComplete ? callingCode.formatInternationalPhone(value) : null,
    );
    if (isComplete) {
      _debounce = Timer(
        const Duration(milliseconds: 600),
        () => _lookup(callingCode),
      );
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus || !widget.enabled) return;
    final callingCode = _resolveCallingCode(
      context.read<CallingCodesViewModel>().state,
    );
    _lookup(callingCode);
  }

  void _lookup(CallingCodeEntity callingCode) {
    _debounce?.cancel();
    final rawPhone = widget.controller.text;
    if (!callingCode.hasCompleteLocalPhone(rawPhone)) return;
    final phone = callingCode.formatInternationalPhone(rawPhone);
    if (phone == _lastLookedUpPhone) return;
    _lastLookedUpPhone = phone;
    widget.onPhoneChanged(phone);
    widget.onLookup(phone);
  }

  Future<void> _openCallingCodesSheet(BuildContext context) async {
    final viewModel = context.read<CallingCodesViewModel>();
    if (viewModel.state.items.isEmpty &&
        !viewModel.state.isLoading) {
      viewModel.doIntent(const LoadCallingCodesEvent());
    }
    final currentCallingCode = _resolveCallingCode(viewModel.state);
    if (viewModel.state.selected?.countryCode !=
        currentCallingCode.countryCode) {
      viewModel.doIntent(SelectCallingCodeEvent(currentCallingCode));
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (_) => BlocProvider.value(
        value: viewModel,
        child: const CallingCodesBottomSheet(),
      ),
    );
    if (!mounted) return;
    final selected = viewModel.state.selected;
    if (selected != null) {
      setState(() => _selectedCallingCode = selected);
      _handleChanged(selected, widget.controller.text);
    }
  }

  CallingCodeEntity _resolveCallingCode(CallingCodesState state) {
    final selected = _selectedCallingCode ?? state.selected;
    if (selected != null) return selected;
    return state.items
            .where((code) => code.countryCode == 'KW')
            .firstOrNull ??
        (state.items.isNotEmpty ? state.items.first : CallingCodeEntity.kuwaitFallback);
  }
}
