import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_map_view.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';

class AddressChooseLocationScreen extends StatefulWidget {
  const AddressChooseLocationScreen({super.key, this.args});

  final AddressChooseLocationArgs? args;

  @override
  State<AddressChooseLocationScreen> createState() =>
      _AddressChooseLocationScreenState();
}

class _AddressChooseLocationScreenState
    extends State<AddressChooseLocationScreen> {
  Object? _shownPreview;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final initialAddress = widget.args?.initialAddress;

    return BlocProvider<AddressesViewModel>(
      create: (_) {
        final viewModel = getIt<AddressesViewModel>();
        final familyMemberId = widget.args?.familyMemberId;
        if (familyMemberId != null) {
          viewModel.configureFamilyMember(
            familyMemberId,
            previewAddress: getIt<PreviewFamilyMemberAddressUseCase>(),
            addAddress: getIt<AddFamilyMemberAddressUseCase>(),
          );
        }
        viewModel.doIntent(
          GetLocationsCatalogEvent(initialAddress: initialAddress),
        );
        return viewModel;
      },
      child: Scaffold(
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
                  if (_completed) return;
                  if (state.action.isSuccess) {
                    _completed = true;
                    final navigator = Navigator.of(context);
                    final message = locale.addresses_save_success;
                    if (widget.args?.familyMemberId != null) {
                      navigator.pop(true);
                      return;
                    }
                    var foundAddresses = false;
                    navigator.popUntil((route) {
                      foundAddresses =
                          route.settings.name == AppRoutes.addresses;
                      return foundAddresses || route.isFirst;
                    });
                    if (!foundAddresses) {
                      navigator.pushNamed(AppRoutes.addresses);
                    }
                    CustomSnackbar.showSuccess(
                      context: navigator.context,
                      message: message,
                    );
                    return;
                  }
                  final actionError = state.action.displayErrorMessage;
                  if (actionError != null && actionError.isNotEmpty) {
                    CustomSnackbar.showError(
                      context: context,
                      message: actionError,
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
                      !identical(
                        _shownPreview,
                        state.coveragePreview.preview,
                      ) &&
                      state.coveragePreview.preview != null &&
                      !state.action.isLoading &&
                      !state.action.isSuccess;

                  if (isNewPreviewSuccess) {
                    final preview = state.coveragePreview.preview!;
                    _shownPreview = preview;
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
                                final viewModel = innerContext
                                    .read<AddressesViewModel>();
                                viewModel.doIntent(
                                  const ConfirmPendingAddressActionEvent(),
                                );
                              },
                              onChooseAnother: () {
                                Navigator.of(sheetContext).pop();
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
                },
                buildWhen: (previous, current) =>
                    previous.locations != current.locations ||
                    previous.action != current.action ||
                    previous.coveragePreview != current.coveragePreview,
                builder: (context, state) {
                  return AddressChooseLocationMapView(
                    locations: state.locations,
                    isSubmitting:
                        state.action.isLoading ||
                        state.coveragePreview.isLoading,
                    initialAddress: initialAddress,
                  );
                },
              ),
            ),
            if (widget.args?.familyMemberId != null)
              PositionedDirectional(
                top: Spacing.familySetupContentTop,
                start: Spacing.familySetupHorizontalPadding,
                end: Spacing.familySetupHorizontalPadding,
                child: ColoredBox(
                  color: color.surface,
                  child: const FamilyProgramStepper(
                    currentStep: 2,
                    includeFamilyCreationStep: true,
                  ),
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
    this.familyMemberId,
  });

  final SubscriptionFlowArgs? subscriptionFlowArgs;
  final CustomerAddressEntity? initialAddress;
  final String? familyMemberId;
}
