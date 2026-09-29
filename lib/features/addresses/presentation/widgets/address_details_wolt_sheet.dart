import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddressDetailsWoltSheet extends StatelessWidget {
  const AddressDetailsWoltSheet({
    super.key,
    required this.content,
    required this.isLoading,
    required this.onConfirm,
  });

  final Widget content;
  final bool isLoading;
  final VoidCallback onConfirm;

  static Future<void> show({
    required BuildContext context,
    required Widget content,
    required bool isLoading,
    required VoidCallback onConfirm,
  }) {
    final color = context.colorScheme;

    return WoltModalSheet.show<void>(
      context: context,
      useSafeArea: true,
      modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
      modalBarrierColor: color.scrim.withValues(alpha: 0.08),
      pageListBuilder: (_) => [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          navBarHeight: Spacing.zero,
          backgroundColor: color.surface,
          surfaceTintColor: color.surface,
          stickyActionBar: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              Spacing.addressesChooseLocationCardPadding,
              Spacing.sm,
              Spacing.addressesChooseLocationCardPadding,
              Spacing.md,
            ),
            child: AppButton(
              fontSize: FontSize.size11,
              height: Spacing.buttonSmallHeight,
              onPressed: isLoading ? null : onConfirm,
              isLoading: false,
              text: context.localization.address_preview_check_button,
            ),
          ),
          child: AddressDetailsWoltSheet(
            content: content,
            isLoading: isLoading,
            onConfirm: onConfirm,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        Spacing.addressesChooseLocationCardPadding,
        Spacing.md,
        Spacing.addressesChooseLocationCardPadding,
        Spacing.addressesChooseLocationButtonHeight + Spacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: Spacing.addressesChooseLocationHeroIconSize,
                height: Spacing.addressesChooseLocationHeroIconSize,
                decoration: BoxDecoration(
                  color: color.secondaryContainer,
                  borderRadius: BorderRadius.circular(
                    Spacing.addressesChooseLocationCardRadius,
                  ),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  Assets.addressesIconHome,
                  width: Spacing.iconMd,
                  height: Spacing.iconMd,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.addresses_choose_location_title,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size16,
                        color: color.primary,
                      ),
                    ),
                    Text(
                      locale.addresses_choose_location_subtitle,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Divider(color: color.outlineVariant),
          const SizedBox(height: Spacing.md),
          content,
        ],
      ),
    );
  }
}
