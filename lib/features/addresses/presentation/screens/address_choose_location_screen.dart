import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_loading_overlay.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/sections/address_choose_location_map_section.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/sections/address_choose_location_stepper_section.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';

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
    final initialAddress = widget.args?.initialAddress;

    return BlocProvider<AddressesViewModel>(
      create: (_) => _createViewModel(initialAddress),
      child: Scaffold(
        backgroundColor: color.surfaceContainerHighest,
        drawerScrimColor: color.scrim,
        body: Stack(
          fit: StackFit.expand,
          children: [
            BlocConsumer<AddressesViewModel, AddressesState>(
              listenWhen: (previous, current) =>
                  previous.action != current.action ||
                  previous.coveragePreview != current.coveragePreview,
              listener: _handleState,
              buildWhen: (previous, current) =>
                  previous.locations != current.locations ||
                  previous.action != current.action ||
                  previous.coveragePreview != current.coveragePreview,
              builder: (context, state) {
                return AddressChooseLocationMapSection(
                  locations: state.locations,
                  isSubmitting:
                      state.action.isLoading || state.coveragePreview.isLoading,
                  initialAddress: initialAddress,
                );
              },
            ),
            if (widget.args?.familyMemberId != null)
              const AddressChooseLocationStepperSection(),
            CustomBackButton(
              top: MediaQuery.paddingOf(context).top + Spacing.xs,
              end: Spacing.sm,
              onPressed: () => Navigator.maybePop(context),
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

  AddressesViewModel _createViewModel(CustomerAddressEntity? initialAddress) {
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
  }

  Future<void> _handleState(BuildContext context, AddressesState state) async {
    final locale = context.localization;

    if (_completed) return;
    if (state.action.isSuccess) {
      _completed = true;
      final navigator = Navigator.of(context);
      final message = locale.addresses_save_success;
      if (widget.args?.familyMemberId != null) {
        navigator.pop(true);
        return;
      }
      if (navigator.canPop()) {
        navigator.pop(true);
      } else {
        var foundAddresses = false;
        navigator.popUntil((route) {
          foundAddresses = route.settings.name == AppRoutes.addresses;
          return foundAddresses || route.isFirst;
        });
        if (!foundAddresses) {
          navigator.pushNamed(AppRoutes.addresses);
        }
      }
      CustomSnackbar.showSuccess(context: navigator.context, message: message);
      return;
    }

    final actionError = state.action.displayErrorMessage;
    if (actionError != null && actionError.isNotEmpty) {
      CustomSnackbar.showError(context: context, message: actionError);
    }

    final previewError = state.coveragePreview.displayErrorMessage;
    if (previewError != null && previewError.isNotEmpty) {
      CustomSnackbar.showError(context: context, message: previewError);
    }

    final isNewPreviewSuccess =
        state.coveragePreview.isSuccess &&
        !identical(_shownPreview, state.coveragePreview.preview) &&
        state.coveragePreview.preview != null &&
        !state.action.isLoading &&
        !state.action.isSuccess;

    if (isNewPreviewSuccess) {
      final preview = state.coveragePreview.preview!;
      _shownPreview = preview;
      await AppWoltModalSheet.show<void>(
        context: context,
        hasTopBarLayer: false,
        showDragHandle: false,
        child: BlocProvider.value(
          value: context.read<AddressesViewModel>(),
          child: BlocBuilder<AddressesViewModel, AddressesState>(
            builder: (sheetContext, innerState) {
              return AddressCoveragePreviewBottomSheet(
                preview: preview,
                isSubmitting: innerState.action.isLoading,
                confirmButtonText: locale.address_coverage_confirm_save,
                onConfirm: () {
                  final viewModel = sheetContext.read<AddressesViewModel>();
                  viewModel.doIntent(const ConfirmPendingAddressActionEvent());
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
