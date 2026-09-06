import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/address_choose_location_screen.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_notice_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_delivery_notice_dialog.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_loading_skeleton.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/current_address_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/saved_address_tile.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<AddressesViewModel>(
      create: (_) =>
          getIt<AddressesViewModel>()
            ..doIntent(const GetCustomerAddressesEvent()),
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          title: locale.profile_addresses,
          titleFontSize: FontSize.size15,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: BlocConsumer<AddressesViewModel, AddressesState>(
          listenWhen: (previous, current) =>
              previous.action != current.action ||
              previous.coveragePreview != current.coveragePreview,
          listener: (context, state) async {
            final errorMessage = state.action.displayErrorMessage;
            if (errorMessage != null && errorMessage.isNotEmpty) {
              CustomSnackbar.showError(
                context: context,
                message: mapFailureMessage(context, errorMessage),
              );
            }

            final previewError = state.coveragePreview.displayErrorMessage;
            if (previewError != null && previewError.isNotEmpty) {
              CustomSnackbar.showError(
                context: context,
                message: mapFailureMessage(context, previewError),
              );
            }

            final isNewPreviewSuccess =
                state.coveragePreview.isSuccess &&
                state.coveragePreview.preview != null;

            if (isNewPreviewSuccess) {
              final preview = state.coveragePreview.preview!;
              await showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: color.surface,
                builder: (sheetContext) => BlocProvider.value(
                  value: context.read<AddressesViewModel>(),
                  child: BlocBuilder<AddressesViewModel, AddressesState>(
                    builder: (innerContext, innerState) {
                      return AddressCoveragePreviewBottomSheet(
                        preview: preview,
                        isSubmitting: innerState.action.isLoading,
                        confirmButtonText:
                            locale.address_coverage_confirm_set_default,
                        onConfirm: () {
                          innerContext.read<AddressesViewModel>().doIntent(
                            const ConfirmPendingAddressActionEvent(),
                          );
                        },
                        onChooseAnother: () {
                          Navigator.of(sheetContext).pop();
                          innerContext.read<AddressesViewModel>().doIntent(
                            const ClearCoveragePreviewEvent(),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }

            if (state.action.isSuccess) {
              final address = state.action.address;
              final coverageNotice = address?.restaurantCoverageNotice;
              final servingRestaurants =
                  address?.servingRestaurants ?? const [];

              if (coverageNotice != null && coverageNotice.hasContent) {
                if (!context.mounted) return;
                await showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: color.surface,
                  builder: (sheetContext) => AddressCoverageNoticeSheet(
                    notice: coverageNotice,
                    servingRestaurants: servingRestaurants,
                  ),
                );
              } else {
                final deliveryNotice = _deliveryNoticeForAction(state);
                if (deliveryNotice != null) {
                  if (!context.mounted) return;
                  await showDialog<void>(
                    context: context,
                    builder: (context) =>
                        AddressDeliveryNoticeDialog(message: deliveryNotice),
                  );
                }
              }
            }
          },
          buildWhen: (previous, current) =>
              previous.addresses != current.addresses,
          builder: (context, state) {
            final addressesState = state.addresses;

            if (addressesState.isLoading && addressesState.items.isEmpty) {
              return const AddressesLoadingSkeleton();
            }

            if (addressesState.failure != null &&
                addressesState.items.isEmpty) {
              return ApiErrorWidget(
                exception: addressesState.failure!.exception,
                onRetry: () => context.read<AddressesViewModel>().doIntent(
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
                    CurrentAddressCard(
                      address: addressesState.currentDeliveryAddress,
                    ),
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
                    SizedBox(
                      height: Spacing.addressesAddButtonHeight,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.addressChooseLocation),
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

  String? _deliveryNoticeForAction(AddressesState state) {
    final actionNotice = state.action.deliveryChangeNotice;
    if (!state.action.isSuccess ||
        state.action.address == null ||
        actionNotice == null ||
        actionNotice.isEmpty) {
      return null;
    }
    return actionNotice;
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
          canDelete: address.canDelete,
          onEdit: () => Navigator.of(context).pushNamed(
            AppRoutes.addressChooseLocation,
            arguments: AddressChooseLocationArgs(initialAddress: address),
          ),
          onSetDefault: address.addressId.isEmpty || address.isDefault
              ? null
              : () => context.read<AddressesViewModel>().doIntent(
                  PreviewExistingAddressCoverageEvent(address.addressId),
                ),
          onDelete: address.addressId.isEmpty
              ? null
              : () => context.read<AddressesViewModel>().doIntent(
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
    if (label.contains('work') || label.contains('عمل')) {
      return Icons.business_center_rounded;
    }
    if (label.contains('home') || label.contains('منزل')) {
      return Icons.home_rounded;
    }
    return Icons.location_on_rounded;
  }
}
