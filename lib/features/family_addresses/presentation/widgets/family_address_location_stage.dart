import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/address_entry_flow_controller.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_figma_frame.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_loading_skeleton.dart';

class FamilyAddressLocationStage extends StatefulWidget {
  const FamilyAddressLocationStage({
    super.key,
    required this.memberId,
    required this.onSaved,
  });

  final String memberId;
  final VoidCallback onSaved;

  @override
  State<FamilyAddressLocationStage> createState() =>
      _FamilyAddressLocationStageState();
}

class _FamilyAddressLocationStageState
    extends State<FamilyAddressLocationStage> {
  late final AddressesViewModel _viewModel;
  Object? _shownPreview;
  final AddressEntryFlowController _entryFlowController =
      AddressEntryFlowController();
  final AddressActionSuccessTracker _successTracker =
      AddressActionSuccessTracker();

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<AddressesViewModel>()
      ..configureFamilyMember(
        widget.memberId,
        previewAddress: getIt<PreviewFamilyMemberAddressUseCase>(),
        addAddress: getIt<AddFamilyMemberAddressUseCase>(),
      )
      ..doIntent(const GetLocationsCatalogEvent());
  }

  @override
  void didUpdateWidget(covariant FamilyAddressLocationStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memberId == widget.memberId) return;

    _shownPreview = null;
    _viewModel.invalidateFamilyMemberOperations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || oldWidget.memberId == widget.memberId) return;
      _viewModel.configureFamilyMember(
        widget.memberId,
        previewAddress: getIt<PreviewFamilyMemberAddressUseCase>(),
        addAddress: getIt<AddFamilyMemberAddressUseCase>(),
      );
    });
  }

  @override
  void dispose() {
    _viewModel.close();
    _entryFlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<AddressesViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<AddressesViewModel, AddressesState>(
        listenWhen: (previous, current) =>
            previous.action != current.action ||
            previous.coveragePreview != current.coveragePreview,
        listener: (context, state) async {
          if (_successTracker.shouldHandle(
            state.action,
            isSuccess: state.action.isSuccess,
          )) {
            _entryFlowController.addressSaved();
            widget.onSaved();
            return;
          }

          final actionError = state.action.displayErrorMessage;
          if (actionError != null && actionError.isNotEmpty) {
            CustomSnackbar.showError(
              context: context,
              message: mapFailureMessage(context, actionError),
            );
          }

          final previewError = state.coveragePreview.displayErrorMessage;
          if (previewError != null && previewError.isNotEmpty) {
            CustomSnackbar.showError(
              context: context,
              message: mapFailureMessage(context, previewError),
            );
          }

          final preview = state.coveragePreview.preview;
          final showPreview =
              state.coveragePreview.isSuccess &&
              preview != null &&
              !identical(_shownPreview, preview) &&
              !state.action.isLoading;
          if (!showPreview) return;

          _shownPreview = preview;
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: color.surface,
            builder: (sheetContext) => BlocProvider.value(
              value: context.read<AddressesViewModel>(),
              child: BlocBuilder<AddressesViewModel, AddressesState>(
                builder: (innerContext, innerState) =>
                    AddressCoveragePreviewBottomSheet(
                      preview: preview,
                      isSubmitting: innerState.action.isLoading,
                      confirmButtonText: locale.address_coverage_confirm_save,
                      onConfirm: () => innerContext
                          .read<AddressesViewModel>()
                          .doIntent(const ConfirmPendingAddressActionEvent()),
                      onChooseAnother: () {
                        Navigator.of(sheetContext).pop();
                        innerContext.read<AddressesViewModel>().doIntent(
                          const ClearCoveragePreviewEvent(),
                        );
                      },
                    ),
              ),
            ),
          );
        },
        builder: (context, state) {
          if (state.locations.isLoading && state.locations.data == null) {
            return const FamilyAddressLocationLoadingSkeleton();
          }

          return AddressesFigmaFrame(
            key: ValueKey(widget.memberId),
            locations: state.locations,
            flowController: _entryFlowController,
            isSubmitting:
                state.action.isLoading || state.coveragePreview.isLoading,
          );
        },
      ),
    );
  }
}
