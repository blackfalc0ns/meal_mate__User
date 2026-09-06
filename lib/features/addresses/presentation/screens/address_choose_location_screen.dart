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
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
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
        body: Stack(
          children: [
            Semantics(
              label: locale.addresses_choose_location_title,
              child: BlocConsumer<AddressesViewModel, AddressesState>(
                listenWhen: (previous, current) =>
                    previous.action != current.action ||
                    previous.coveragePreview != current.coveragePreview,
                listener: (context, state) async {
                  final actionError = state.action.displayErrorMessage;
                  if (actionError != null && actionError.isNotEmpty) {
                    CustomSnackbar.showError(
                      context: context,
                      message: mapFailureMessage(context, actionError),
                    );
                  }

                  final previewError =
                      state.coveragePreview.displayErrorMessage;
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
                                  locale.address_coverage_confirm_save,
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
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  }
                },
                buildWhen: (previous, current) =>
                    previous.locations != current.locations ||
                    previous.action != current.action ||
                    previous.coveragePreview != current.coveragePreview,
                builder: (context, state) {
                  return AddressesFigmaFrame(
                    locations: state.locations,
                    isSubmitting: state.action.isLoading ||
                        state.coveragePreview.isLoading,
                    initialAddress: initialAddress,
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: Spacing.sm,
                  top: Spacing.xs,
                ),
                child: CustomBackButton(
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ),
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
