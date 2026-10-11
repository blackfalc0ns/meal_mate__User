import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_view_model.dart';

class CallingCodesBottomSheet extends StatelessWidget {
  const CallingCodesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: context.height * 0.55),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Spacing.lg),
              Container(
                width: Spacing.searchFilterSheetHandleWidth,
                height: Spacing.searchFilterSheetHandleHeight,
                decoration: BoxDecoration(
                  color: color.outlineVariant,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
              const SizedBox(height: Spacing.md),
              Flexible(
                child: BlocBuilder<CallingCodesViewModel, CallingCodesState>(
                  builder: (context, state) {
                    if (state.items.isEmpty && state.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(color: color.primary),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.items.length,
                      separatorBuilder: (context, index) => Divider(
                        height: Spacing.border,
                        color: color.outlineVariant,
                      ),
                      itemBuilder: (context, index) {
                        final callingCode = state.items[index];
                        final isSelected =
                            callingCode.countryCode ==
                            state.selected?.countryCode;
                        final isArabic = Localizations.localeOf(
                          context,
                        ).languageCode.startsWith('ar');
                        final countryName = isArabic
                            ? callingCode.nameAr
                            : callingCode.nameEn;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CountryFlag.fromCountryCode(
                            callingCode.countryCode,
                            theme: const ImageTheme(
                              width: Spacing.iconLg,
                              height: Spacing.iconMd,
                              shape: RoundedRectangle(Spacing.radiusXs),
                            ),
                          ),
                          title: Text(
                            countryName,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size14,
                              color: color.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            callingCode.dialCode,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: color.primary,
                                  size: Spacing.iconMd,
                                )
                              : null,
                          onTap: () => _selectCallingCode(context, callingCode),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: Spacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  void _selectCallingCode(BuildContext context, CallingCodeEntity callingCode) {
    context.read<CallingCodesViewModel>().doIntent(
      SelectCallingCodeEvent(callingCode),
    );
    Navigator.pop(context);
  }
}
