import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_event.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_view_model.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_entry_flow_controller.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_choose_location_map_view.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_loading_skeleton.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/failuer_mapper.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_address_editor_operations.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_loading_skeleton.dart';

class FamilyAddressLocationStage extends StatefulWidget {
  const FamilyAddressLocationStage({
    super.key,
    required this.memberId,
    this.onSaved,
    this.onAddressSaved,
    this.initialAddress,
  });

  final String memberId;
  final VoidCallback? onSaved;
  final void Function({String? memberId, CustomerAddressEntity? savedAddress})? onAddressSaved;
  final CustomerAddressEntity? initialAddress;

  @override
  State<FamilyAddressLocationStage> createState() =>
      _FamilyAddressLocationStageState();
}

class _FamilyAddressLocationStageState
    extends State<FamilyAddressLocationStage> {
  late AddressEditorViewModel _viewModel;
  int? _shownSessionId;
  final AddressEntryFlowController _entryFlowController =
      AddressEntryFlowController();
  final AddressActionSuccessTracker _successTracker =
      AddressActionSuccessTracker();

  @override
  void initState() {
    super.initState();
    _viewModel = _createViewModel(widget.memberId);
    unawaited(
      _viewModel.doIntent(
        GetLocationsCatalogEvent(initialAddress: widget.initialAddress),
      ),
    );
  }

  AddressEditorViewModel _createViewModel(String memberId) {
    return AddressEditorViewModel(
      operations: FamilyAddressEditorOperations(
        memberId: memberId,
        previewFamilyMemberAddressUseCase:
            getIt<PreviewFamilyMemberAddressUseCase>(),
        addFamilyMemberAddressUseCase:
            getIt<AddFamilyMemberAddressUseCase>(),
      ),
      getLocationsCatalogUseCase: getIt<GetLocationsCatalogUseCase>(),
      geocodeAddressUseCase: getIt<GeocodeAddressUseCase>(),
      reverseGeocodeLocationUseCase: getIt<ReverseGeocodeLocationUseCase>(),
    );
  }

  @override
  void didUpdateWidget(covariant FamilyAddressLocationStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memberId == widget.memberId) return;

    _shownSessionId = null;
    _entryFlowController.chooseLocation();
    final oldVm = _viewModel;
    unawaited(oldVm.close());
    _viewModel = _createViewModel(widget.memberId);
    unawaited(
      _viewModel.doIntent(
        GetLocationsCatalogEvent(initialAddress: widget.initialAddress),
      ),
    );
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

    return BlocProvider<AddressEditorViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<AddressEditorViewModel, AddressEditorState>(
        listenWhen: (previous, current) =>
            previous.action != current.action ||
            previous.coveragePreview != current.coveragePreview,
        listener: (context, state) {
          if (_successTracker.shouldHandle(
            state.action,
            isSuccess: state.action.isSuccess,
          )) {
            _entryFlowController.addressSaved();
            if (widget.onAddressSaved != null) {
              widget.onAddressSaved!(
                memberId: widget.memberId,
                savedAddress: state.action.address,
              );
            }
            widget.onSaved?.call();
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

          return Stack(
            children: [
              BlocSelector<AddressEditorViewModel, AddressEditorState, ({LocationsCatalogState locations, bool isSubmitting})>(
                selector: (s) => (
                  locations: s.locations,
                  isSubmitting: s.action.isLoading,
                ),
                builder: (context, mapData) {
                  return AddressChooseLocationMapView(
                    key: ValueKey(widget.memberId),
                    locations: mapData.locations,
                    flowController: _entryFlowController,
                    initialAddress: widget.initialAddress,
                    showInitialAddressDetails: false,
                    isSubmitting: mapData.isSubmitting,
                  );
                },
              ),
              BlocSelector<AddressEditorViewModel, AddressEditorState, AddressCoveragePreviewState>(
                selector: (s) => s.coveragePreview,
                builder: (context, coverage) {
                  final preview = coverage.preview;
                  if (coverage.isLoading && preview == null) {
                    return const PositionedDirectional(
                      start: 0,
                      end: 0,
                      bottom: 0,
                      child: AddressCoverageLoadingSkeleton(),
                    );
                  }
                  if (coverage.isSuccess && preview != null) {
                    return PositionedDirectional(
                      start: 0,
                      end: 0,
                      bottom: 0,
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey(coverage.sessionId),
                        tween: Tween<double>(begin: 1, end: 0),
                        duration: AppDurations.normal,
                        curve: Curves.easeOutCubic,
                        builder: (context, progress, child) =>
                            FractionalTranslation(
                          translation: Offset(Spacing.zero, progress),
                          child: child,
                        ),
                        child: BlocSelector<AddressEditorViewModel, AddressEditorState, bool>(
                          selector: (s) => s.action.isLoading,
                          builder: (context, isSubmitting) {
                            return AddressCoveragePreviewBottomSheet(
                              key: ValueKey(coverage.sessionId),
                              preview: preview,
                              isSubmitting: isSubmitting,
                              confirmButtonText: locale.address_coverage_confirm_save,
                              popOnConfirm: false,
                              requireFamilyCoverage: true,
                              isLoadingMore: coverage.isLoadingMore,
                              hasMoreRestaurants: coverage.canLoadMore,
                              loadMoreFailure: coverage.loadMoreFailure,
                              onLoadMoreRestaurants: () => unawaited(
                                context.read<AddressEditorViewModel>().doIntent(
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
                                  context.read<AddressEditorViewModel>().doIntent(
                                    const ConfirmPendingAddressActionEvent(),
                                  ),
                                );
                              },
                              onChooseAnother: () {
                                _shownSessionId = null;
                                _entryFlowController.chooseLocation();
                                unawaited(
                                  context.read<AddressEditorViewModel>().doIntent(
                                    const ClearCoveragePreviewEvent(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
