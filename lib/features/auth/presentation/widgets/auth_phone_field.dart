import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/helpers/validators.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_view_model.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/calling_codes_bottom_sheet.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/country_code_prefix.dart';

class AuthPhoneField extends StatelessWidget {
  const AuthPhoneField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          locale.phone_number,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppTextField(
          isGlass: true,
          controller: controller,
          hint: hintText ?? locale.phone_hint,
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(
            Icons.local_phone_outlined,
            color: color.primary,
            size: Spacing.iconMd,
          ),
          suffixIcon:
              BlocSelector<
                CallingCodesViewModel,
                CallingCodesState,
                CallingCodeEntity?
              >(
                selector: (state) => state.selected,
                builder: (context, selected) {
                  return CountryCodePrefix(
                    callingCode: selected,
                    onTap: () => _openCallingCodesSheet(context),
                  );
                },
              ),
          validator:
              validator ??
              (value) => Validations.validatePhoneNumber(context, value),
        ),
      ],
    );
  }

  Future<void> _openCallingCodesSheet(BuildContext context) async {
    final viewModel = context.read<CallingCodesViewModel>();

    if (viewModel.state.items.isEmpty && !viewModel.state.isLoading) {
      viewModel.doIntent(const LoadCallingCodesEvent());
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
  }
}
