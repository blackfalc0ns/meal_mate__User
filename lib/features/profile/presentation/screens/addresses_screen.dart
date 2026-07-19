import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/current_address_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/saved_address_tile.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.profile_addresses,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(
                horizontal: Spacing.addressesScreenHorizontalPadding,
              ).copyWith(
                top: Spacing.addressesContentTopPadding,
                bottom: Spacing.xxxl,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CurrentAddressCard(),
              const SizedBox(height: Spacing.addressesSectionGap),
              Text(
                locale.addresses_saved_section,

                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.sm),
              SavedAddressTile(
                icon: Icons.home_rounded,
                title: locale.addresses_current_home,
                address: locale.addresses_home_address,
              ),
              const SizedBox(height: Spacing.addressesCardGap),
              SavedAddressTile(
                icon: Icons.business_center_rounded,
                title: locale.addresses_work,
                address: locale.addresses_work_address,
              ),
              const SizedBox(height: Spacing.addressesCardGap),
              SavedAddressTile(
                icon: Icons.location_on_rounded,
                title: locale.addresses_other,
                address: locale.addresses_other_address,
              ),
              const SizedBox(height: Spacing.addressesSectionGap),
              // Text(
              //   locale.addresses_delivery_preferences,

              //   style: getBoldStyle(
              //     fontFamily: FontConstant.ibmPlexSansArabic,
              //     fontSize: Spacing.addressesSectionTitleSize,
              //     color: color.onSurface,
              //   ),
              // ),
              // const SizedBox(height: Spacing.sm),
              // const DeliveryPreferencesCard(),
              const SizedBox(height: Spacing.addressesSectionGap),
              SizedBox(
                height: Spacing.addressesAddButtonHeight,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: color.primary,
                    size: Spacing.iconLg,
                  ),
                  label: Text(
                    locale.addresses_add_new,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size12,
                      color: color.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color.primaryContainer),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Spacing.addressesCardRadius,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.addressesSectionGap),
              Container(
                height: Spacing.addressesAvailabilityNoticeHeight,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                decoration: BoxDecoration(
                  color: color.secondaryContainer,
                  borderRadius: BorderRadius.circular(
                    Spacing.addressesCardRadius,
                  ),
                  border: Border.all(color: color.outlineVariant),
                ),
                child: Row(
                  textDirection: locale.localeName == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: color.secondary,
                      size: Spacing.lg,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        locale.addresses_availability_notice,

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxl),
              AppButton.filled(
                text: locale.addresses_save,
                onPressed: () {},
                height: Spacing.addressesSaveButtonHeight,
                borderRadius: Spacing.addressesSaveButtonRadius,
                color: color.primary,
                textColor: color.onPrimary,
                fontSize: FontSize.size13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
