import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';

typedef _ApplyManagerBannerData = ({
  bool isVisible,
  bool isChecked,
  String? managerName,
  bool hasManagerAddress,
  bool isApplyingManagerAddress,
});

class FamilyAddressApplyManagerBanner extends StatelessWidget {
  const FamilyAddressApplyManagerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocSelector<
      FamilyAddressesViewModel,
      FamilyAddressesState,
      _ApplyManagerBannerData
    >(
      selector: (state) {
        final manager = state.manager;
        return (
          isVisible: state.members.length > 1,
          isChecked: state.isManagerAddressAppliedToAll,
          managerName: manager?.displayName,
          hasManagerAddress: state.isManagerAddressAvailable,
          isApplyingManagerAddress: state.isApplyingManagerAddress,
        );
      },
      builder: (context, data) {
        if (!data.isVisible) {
          return const SizedBox.shrink();
        }

        return Material(
          color: color.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            onTap: () {
              if (data.isApplyingManagerAddress) return;
              if (!data.hasManagerAddress) {
                CustomSnackbar.showWarning(
                  context: context,
                  message:
                      locale.family_apply_manager_address_no_manager_address,
                );
                return;
              }
              unawaited(
                context
                    .read<FamilyAddressesViewModel>()
                    .toggleApplyManagerAddress(),
              );
            },
            child: Container(
              height: Spacing.familyApplyManagerBannerHeight,
              padding: const EdgeInsetsDirectional.only(
                start: Spacing.md,
                end: Spacing.xs,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spacing.radiusMd),
                border: Border.all(
                  color: data.isChecked
                      ? color.primary.withValues(alpha: 0.35)
                      : color.outlineVariant.withValues(alpha: 0.5),
                  width: Spacing.border,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: Spacing.xl,
                    height: Spacing.xl,
                    decoration: BoxDecoration(
                      color: data.isChecked ? color.primary : color.surface,
                      borderRadius: BorderRadius.circular(Spacing.radiusXs + 2),
                      border: data.isChecked
                          ? null
                          : Border.all(
                              color: color.outline.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                    ),
                    child: data.isApplyingManagerAddress
                        ? Padding(
                            padding: const EdgeInsets.all(Spacing.xxs),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                data.isChecked
                                    ? color.onPrimary
                                    : color.primary,
                              ),
                            ),
                          )
                        : (data.isChecked
                            ? Icon(
                                Icons.check_rounded,
                                size: Spacing.iconSm,
                                color: color.onPrimary,
                              )
                            : null),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.family_apply_manager_address_title,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Spacing.xxs),
                        Text(
                          data.managerName != null &&
                                  data.managerName!.isNotEmpty
                              ? locale.family_apply_manager_address_subtitle(
                                  data.managerName!,
                                )
                              : locale
                                    .family_apply_manager_address_generic_subtitle,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size9,
                            color: color.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    Assets.familyApplyManagerCrown,
                    height: Spacing.familyApplyManagerCrownHeight,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
