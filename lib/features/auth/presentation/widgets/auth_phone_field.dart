import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_view_model.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.phone_number,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        AppTextField(
          isGlass: true,
          controller: controller,
          hint: hintText ?? l10n.phone_hint,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(
            Icons.local_phone_outlined,
            color: AppColors.primary,
            size: 23,
          ),
          suffixIcon: BlocBuilder<AuthViewModel, AuthState>(
            buildWhen: (previous, current) =>
                previous.callingCodes.selected != current.callingCodes.selected,
            builder: (context, state) {
              return CountryCodePrefix(
                callingCode: state.callingCodes.selected,
                onTap: () => _openCallingCodesSheet(context),
              );
            },
          ),
          validator:
              validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.phone_number_is_required;
                }
                return null;
              },
        ),
      ],
    );
  }

  Future<void> _openCallingCodesSheet(BuildContext context) async {
    final viewModel = context.read<AuthViewModel>();

    if (viewModel.state.callingCodes.items.isEmpty &&
        !viewModel.state.callingCodes.isLoading) {
      viewModel.doIntent(const GetCallingCodesEvent());
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
