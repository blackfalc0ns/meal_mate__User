import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';

typedef _ApplyManagerBannerData = ({
  bool isVisible,
  bool isChecked,
  String? managerName,
  bool hasManagerAddress,
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
        );
      },
      builder: (context, data) {
        if (!data.isVisible) {
          return const SizedBox.shrink();
        }

        return Material(
          color: color.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          child: InkWell(
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            onTap: () {
              if (!data.hasManagerAddress) {
                CustomSnackbar.showWarning(
                  context: context,
                  message:
                      locale.family_apply_manager_address_no_manager_address,
                );
                return;
              }
              context
                  .read<FamilyAddressesViewModel>()
                  .toggleApplyManagerAddress();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xss,
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
                    width: Spacing.lg,
                    height: Spacing.lg,
                    decoration: BoxDecoration(
                      color: data.isChecked ? color.primary : color.surface,
                      borderRadius: BorderRadius.circular(Spacing.radiusXs),
                      border: Border.all(
                        color: data.isChecked
                            ? color.primary
                            : color.outline.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                    ),
                    child: data.isChecked
                        ? Icon(
                            Icons.check_rounded,
                            size: Spacing.iconSm,
                            color: color.onPrimary,
                          )
                        : null,
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
                            fontSize: FontSize.size11,
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
                  const SizedBox(width: Spacing.xs),
                  Container(
                    width: Spacing.avatarSm,
                    height: Spacing.xl,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.primary,
                          color.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      boxShadow: [
                        BoxShadow(
                          color: color.primary.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        size: Spacing.iconXs,
                        color: color.onPrimary,
                      ),
                    ),
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
