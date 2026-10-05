import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/address_entry_flow_controller.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_loading_skeleton.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/address_choose_location_map_view.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_loading_skeleton.dart';

class FamilyAddressLocationStage extends StatefulWidget {
  const FamilyAddressLocationStage({
    super.key,
    required this.memberId,
    required this.onSaved,
    this.initialAddress,
  });

  final String memberId;
  final VoidCallback onSaved;
  final CustomerAddressEntity? initialAddress;

  @override
  State<FamilyAddressLocationStage> createState() =>
      _FamilyAddressLocationStageState();
}

class _FamilyAddressLocationStageState
    extends State<FamilyAddressLocationStage> {
  late final AddressesViewModel _viewModel;
  int? _shownSessionId;
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
      );
    unawaited(
      _viewModel.doIntent(
        GetLocationsCatalogEvent(initialAddress: widget.initialAddress),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant FamilyAddressLocationStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memberId == widget.memberId) return;

    _shownSessionId = null;
    _entryFlowController.chooseLocation();
    _viewModel.invalidateFamilyMemberOperations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || oldWidget.memberId == widget.memberId) return;
      _viewModel.configureFamilyMember(
        widget.memberId,
        previewAddress: getIt<PreviewFamilyMemberAddressUseCase>(),
        addAddress: getIt<AddFamilyMemberAddressUseCase>(),
      );
      unawaited(
        _viewModel.doIntent(
          GetLocationsCatalogEvent(initialAddress: widget.initialAddress),
        ),
      );
    });
  }

  @override
  void dispose() {
    unawaited(_viewModel.close());
    _entryFlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider<AddressesViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<AddressesViewModel, AddressesState>(
        listenWhen: (previous, current) =>
            previous.action != current.action ||
            previous.coveragePreview != current.coveragePreview,
        listener: (context, state) {
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

          final previewFailure = state.coveragePreview.failure;
          if (previewFailure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                previewFailure,
              ),
            );
            _shownSessionId = null;
            _entryFlowController.chooseLocation();
          }

          final preview = state.coveragePreview.preview;
          final sessionId = state.coveragePreview.sessionId;
          final isNewCoverageSession =
              sessionId != 0 &&
              _shownSessionId != sessionId &&
              (state.coveragePreview.isLoading ||
                  (state.coveragePreview.isSuccess && preview != null));

          if (isNewCoverageSession) {
            _shownSessionId = sessionId;
            _entryFlowController.showCoveragePreview();
          }
        },
        builder: (context, state) {
          if (state.locations.isLoading && state.locations.data == null) {
            return const FamilyAddressLocationLoadingSkeleton();
          }

          final preview = state.coveragePreview.preview;

          return Stack(
            children: [
              AddressChooseLocationMapView(
                key: ValueKey(widget.memberId),
                locations: state.locations,
                flowController: _entryFlowController,
                initialAddress: widget.initialAddress,
                showInitialAddressDetails: false,
                isSubmitting: state.action.isLoading,
              ),
              if (state.coveragePreview.isLoading && preview == null)
                const PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: AddressCoverageLoadingSkeleton(),
                )
              else if (state.coveragePreview.isSuccess && preview != null)
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(state.coveragePreview.sessionId),
                    tween: Tween<double>(begin: 1, end: 0),
                    duration: AppDurations.normal,
                    curve: Curves.easeOutCubic,
                    builder: (context, progress, child) =>
                        FractionalTranslation(
                          translation: Offset(Spacing.zero, progress),
                          child: child,
                        ),
                    child: AddressCoveragePreviewBottomSheet(
                      key: ValueKey(state.coveragePreview.sessionId),
                      preview: preview,
                      isSubmitting: state.action.isLoading,
                      confirmButtonText: locale.address_coverage_confirm_save,
                      popOnConfirm: false,
                      requireFamilyCoverage: true,
                      isLoadingMore: state.coveragePreview.isLoadingMore,
                      hasMoreRestaurants: state.coveragePreview.canLoadMore,
                      loadMoreFailure: state.coveragePreview.loadMoreFailure,
                      onLoadMoreRestaurants: () => unawaited(
                        context.read<AddressesViewModel>().doIntent(
                          const LoadMoreAddressCoverageRestaurantsEvent(),
                        ),
                      ),
                      onConfirm: () {
                        if (!preview.canSetAsDefault ||
                            preview.resolvedRegionId == null ||
                            preview.conflictMessage != null ||
                            preview.servingRestaurants.isEmpty) {
                          return;
                        }
                        unawaited(
                          context.read<AddressesViewModel>().doIntent(
                            const ConfirmPendingAddressActionEvent(),
                          ),
                        );
                      },
                      onChooseAnother: () {
                        _shownSessionId = null;
                        _entryFlowController.chooseLocation();
                        unawaited(
                          context.read<AddressesViewModel>().doIntent(
                            const ClearCoveragePreviewEvent(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
