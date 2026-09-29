import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/address_choose_location_screen.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/add_address_button.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_loading_overlay.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_availability_notice.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_loading_skeleton.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/current_address_card.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/saved_addresses_section.dart';

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
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: BlocConsumer<AddressesViewModel, AddressesState>(
                listenWhen: (previous, current) =>
                    previous.action != current.action ||
                    previous.coveragePreview != current.coveragePreview,
                listener: (context, state) async {
                  final errorMessage = state.action.displayErrorMessage;
                  if (errorMessage != null && errorMessage.isNotEmpty) {
                    CustomSnackbar.showError(
                      context: context,
                      message: errorMessage,
                    );
                  }

                  final previewError =
                      state.coveragePreview.displayErrorMessage;
                  if (previewError != null && previewError.isNotEmpty) {
                    CustomSnackbar.showError(
                      context: context,
                      message: previewError,
                    );
                  }

                  final isNewPreviewSuccess =
                      state.coveragePreview.isSuccess &&
                      state.coveragePreview.preview != null;

                  if (isNewPreviewSuccess) {
                    final preview = state.coveragePreview.preview!;
                    await AppWoltModalSheet.show<void>(
                      context: context,
                      hasTopBarLayer: false,
                      showDragHandle: false,
                      child: BlocProvider.value(
                        value: context.read<AddressesViewModel>(),
                        child: BlocBuilder<AddressesViewModel, AddressesState>(
                          builder: (innerContext, innerState) {
                            return AddressCoveragePreviewBottomSheet(
                              preview: preview,
                              isSubmitting: innerState.action.isLoading,
                              confirmButtonText:
                                  locale.address_coverage_confirm_set_default,
                              onConfirm: () {
                                innerContext
                                    .read<AddressesViewModel>()
                                    .doIntent(
                                      const ConfirmPendingAddressActionEvent(),
                                    );
                              },
                              onChooseAnother: () {
                                Navigator.of(innerContext).pop();
                              },
                            );
                          },
                        ),
                      ),
                    );

                    if (context.mounted) {
                      context.read<AddressesViewModel>().doIntent(
                        const ClearCoveragePreviewEvent(),
                      );
                    }
                  }

                  if (!context.mounted) return;

                  if (state.action.isSuccess && state.action.address != null) {
                    CustomSnackbar.showSuccess(
                      context: context,
                      message: locale.addresses_save_success,
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    previous.addresses != current.addresses,
                builder: (context, state) {
                  final addressesState = state.addresses;

                  if (addressesState.isLoading &&
                      addressesState.items.isEmpty) {
                    return const AddressesLoadingSkeleton();
                  }

                  if (addressesState.failure != null &&
                      addressesState.items.isEmpty) {
                    return ApiErrorWidget(
                      exception: addressesState.failure!.exception,
                      onRetry: () => context
                          .read<AddressesViewModel>()
                          .doIntent(const GetCustomerAddressesEvent()),
                    );
                  }

                  return SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                                Spacing.addressesScreenHorizontalPadding,
                          ).copyWith(
                            top: Spacing.addressesContentTopPadding,
                            bottom: Spacing.xxxl,
                          ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (addressesState.currentDeliveryAddress !=
                              null) ...[
                            CurrentAddressCard(
                              address: addressesState.currentDeliveryAddress,
                            ),
                            const SizedBox(height: Spacing.addressesSectionGap),
                          ],
                          SavedAddressesSection(
                            addresses: addressesState.items,
                            onEdit: (address) => _openAddressEditor(
                              context,
                              initialAddress: address,
                            ),
                            onSetDefault: (address) =>
                                context.read<AddressesViewModel>().doIntent(
                                  PreviewExistingAddressCoverageEvent(
                                    address.addressId,
                                  ),
                                ),
                            onDelete: (address) =>
                                context.read<AddressesViewModel>().doIntent(
                                  DeleteCustomerAddressEvent(address.addressId),
                                ),
                          ),
                          const SizedBox(height: Spacing.addressesSectionGap),
                          AddAddressButton(
                            onPressed: () => _openAddressEditor(context),
                          ),
                          const SizedBox(height: Spacing.addressesSectionGap),
                          const AddressesAvailabilityNotice(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            BlocSelector<AddressesViewModel, AddressesState, bool>(
              selector: (state) =>
                  state.action.isLoading || state.coveragePreview.isLoading,
              builder: (context, isLoading) {
                if (!isLoading) return const SizedBox.shrink();
                return const AddressLoadingOverlay();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddressEditor(
    BuildContext context, {
    CustomerAddressEntity? initialAddress,
  }) async {
    final result = await Navigator.of(context).pushNamed(
      AppRoutes.addressChooseLocation,
      arguments: AddressChooseLocationArgs(initialAddress: initialAddress),
    );

    if (!context.mounted) return;

    if (result == true) {
      context.read<AddressesViewModel>().doIntent(
        const GetCustomerAddressesEvent(),
      );
    }
  }
}
