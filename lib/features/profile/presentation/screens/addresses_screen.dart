import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/current_address_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/saved_address_tile.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<ProfileViewModel>(
      create: (_) =>
          getIt<ProfileViewModel>()
            ..doIntent(const GetCustomerAddressesEvent()),
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          title: locale.profile_addresses,
          titleFontSize: FontSize.size15,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: BlocBuilder<ProfileViewModel, ProfileState>(
          buildWhen: (previous, current) =>
              previous.addresses != current.addresses,
          builder: (context, state) {
            final addressesState = state.addresses;

            if (addressesState.isLoading && addressesState.items.isEmpty) {
              return const LoadingWidget.fullScreen();
            }

            if (addressesState.failure != null &&
                addressesState.items.isEmpty) {
              return ApiErrorWidget(
                exception: addressesState.failure!.exception,
                onRetry: () => context.read<ProfileViewModel>().doIntent(
                  const GetCustomerAddressesEvent(),
                ),
              );
            }

            return SafeArea(
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
                    CurrentAddressCard(address: addressesState.defaultAddress),
                    const SizedBox(height: Spacing.addressesSectionGap),
                    Text(
                      locale.addresses_saved_section,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    if (addressesState.items.isEmpty)
                      EmptyStateWidget(
                        title: locale.addresses_saved_section,
                        description: locale.addresses_add_new,
                        icon: Icons.location_off_rounded,
                      )
                    else
                      ..._buildAddressTiles(context, addressesState.items),
                    const SizedBox(height: Spacing.addressesSectionGap),
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
                            fontFamily: FontConstant.alexandria,
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
                    CustomWarningWidget(
                      icon: Icons.info_rounded,
                      message: locale.addresses_availability_notice,
                      isWarning: true,
                      height: Spacing.addressesAvailabilityNoticeHeight,
                      backgroundColor: color.secondaryContainer,
                      borderColor: color.outlineVariant,
                      horizontalPadding: Spacing.md,
                      iconSize: Spacing.lg,
                      iconTextSpacing: Spacing.sm,
                      messageFontSize: FontSize.size12,
                      maxMessageLines: 1,
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
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildAddressTiles(
    BuildContext context,
    List<CustomerAddressEntity> addresses,
  ) {
    final children = <Widget>[];

    for (var index = 0; index < addresses.length; index++) {
      final address = addresses[index];
      children.add(
        SavedAddressTile(
          icon: _iconForAddress(address),
          title: address.label,
          address: address.addressLine,
          onDelete: address.addressId.isEmpty
              ? null
              : () => context.read<ProfileViewModel>().doIntent(
                  DeleteCustomerAddressEvent(address.addressId),
                ),
        ),
      );
      if (index != addresses.length - 1) {
        children.add(const SizedBox(height: Spacing.addressesCardGap));
      }
    }

    return children;
  }

  IconData _iconForAddress(CustomerAddressEntity address) {
    final label = address.label.toLowerCase();
    if (label.contains('work')) {
      return Icons.business_center_rounded;
    }
    if (label.contains('home')) {
      return Icons.home_rounded;
    }
    return Icons.location_on_rounded;
  }
}
