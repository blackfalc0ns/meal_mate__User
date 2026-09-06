import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_notice_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_delivery_notice_dialog.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_figma_frame.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';

class AddressChooseLocationScreen extends StatelessWidget {
  const AddressChooseLocationScreen({super.key, this.args});

  final AddressChooseLocationArgs? args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final initialAddress = args?.initialAddress;

    return BlocProvider<AddressesViewModel>(
      create: (_) => getIt<AddressesViewModel>()
        ..doIntent(GetLocationsCatalogEvent(initialAddress: initialAddress)),
      child: Scaffold(
        backgroundColor: color.surfaceContainerHighest,
        drawerScrimColor: color.scrim,
        extendBody: true,
        body: Stack(
          children: [
            Column(
              children: [
                const SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: Spacing.addressesChooseLocationScreenTopGap,
                  ),
                ),
                Expanded(
                  child: Semantics(
                    label: locale.addresses_choose_location_title,
                    child: BlocConsumer<AddressesViewModel, AddressesState>(
                      listenWhen: (previous, current) =>
                          previous.action != current.action,
                      listener: (context, state) async {
                        final errorMessage = state.action.displayErrorMessage;
                        if (errorMessage != null && errorMessage.isNotEmpty) {
                          CustomSnackbar.showError(
                            context: context,
                            message: mapFailureMessage(context, errorMessage),
                          );
                        }

                        if (state.action.isSuccess) {
                          final address = state.action.address;
                          final coverageNotice =
                              address?.restaurantCoverageNotice;
                          final servingRestaurants =
                              address?.servingRestaurants ?? const [];

                          if (coverageNotice != null &&
                              coverageNotice.hasContent) {
                            await showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: color.surface,
                              builder: (sheetContext) =>
                                  AddressCoverageNoticeSheet(
                                notice: coverageNotice,
                                servingRestaurants: servingRestaurants,
                              ),
                            );
                          } else {
                            final notice = state.action.deliveryChangeNotice;
                            if (notice != null && notice.isNotEmpty) {
                              await showDialog<void>(
                                context: context,
                                builder: (context) =>
                                    AddressDeliveryNoticeDialog(
                                  message: notice,
                                ),
                              );
                            }
                          }
                          if (context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        }
                      },
                      buildWhen: (previous, current) =>
                          previous.locations != current.locations ||
                          previous.action != current.action,
                      builder: (context, state) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final scale =
                                constraints.maxWidth /
                                Spacing.addressesChooseLocationDesignWidth;
                            final contentHeight =
                                AddressesFigmaFrame.frameHeight * scale;

                            return SingleChildScrollView(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.paddingOf(context).bottom,
                              ),
                              child: SizedBox(
                                width: constraints.maxWidth,
                                height: contentHeight,
                                child: FittedBox(
                                  alignment: Alignment.topCenter,
                                  fit: BoxFit.fitWidth,
                                  child: SizedBox(
                                    width: Spacing
                                        .addressesChooseLocationDesignWidth,
                                    height: AddressesFigmaFrame.frameHeight,
                                    child: AddressesFigmaFrame(
                                      locations: state.locations,
                                      isSubmitting: state.action.isLoading,
                                      initialAddress: initialAddress,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            CustomBackButton(onPressed: () => Navigator.maybePop(context)),
          ],
        ),
      ),
    );
  }
}

class AddressChooseLocationArgs {
  const AddressChooseLocationArgs({
    this.subscriptionFlowArgs,
    this.initialAddress,
  });

  final SubscriptionFlowArgs? subscriptionFlowArgs;
  final CustomerAddressEntity? initialAddress;
}
