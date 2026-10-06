import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/usecase/geocode_address_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/get_locations_catalog_usecase.dart';
import 'package:meal_meat_user/core/address/domain/usecase/reverse_geocode_location_usecase.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_event.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_view_model.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_loading_skeleton.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_loading_overlay.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/address/domain/contracts/address_editor_operations.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/customer_address_editor_operations.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/sections/address_choose_location_map_section.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/sections/address_choose_location_stepper_section.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_flow_args.dart';

class AddressChooseLocationScreen extends StatefulWidget {
  const AddressChooseLocationScreen({
    super.key,
    this.args,
    this.operations,
  });

  final AddressChooseLocationArgs? args;
  final AddressEditorOperations? operations;

  @override
  State<AddressChooseLocationScreen> createState() =>
      _AddressChooseLocationScreenState();
}

class _AddressChooseLocationScreenState
    extends State<AddressChooseLocationScreen> {
  bool _completed = false;
  bool _isCoverageSheetOpen = false;
  int? _activeCoverageSessionId;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final initialAddress = widget.args?.initialAddress;

    return BlocProvider<AddressEditorViewModel>(
      create: (_) => _createViewModel(initialAddress),
      child: Scaffold(
        backgroundColor: color.surfaceContainerHighest,
        drawerScrimColor: color.scrim,
        body: Stack(
          fit: StackFit.expand,
          children: [
            BlocConsumer<AddressEditorViewModel, AddressEditorState>(
              listenWhen: (previous, current) =>
                  previous.action != current.action ||
                  previous.coveragePreview != current.coveragePreview,
              listener: _handleState,
              buildWhen: (previous, current) =>
                  previous.locations != current.locations ||
                  previous.action != current.action,
              builder: (context, state) {
                return AddressChooseLocationMapSection(
                  locations: state.locations,
                  isSubmitting: state.action.isLoading,
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
            BlocSelector<AddressEditorViewModel, AddressEditorState, bool>(
              selector: (state) => state.action.isLoading,
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

  AddressEditorViewModel _createViewModel(
      CustomerAddressEntity? initialAddress) {
    final operations =
        widget.operations ?? getIt<CustomerAddressEditorOperations>();

    final viewModel = AddressEditorViewModel(
      operations: operations,
      getLocationsCatalogUseCase: getIt<GetLocationsCatalogUseCase>(),
      geocodeAddressUseCase: getIt<GeocodeAddressUseCase>(),
      reverseGeocodeLocationUseCase: getIt<ReverseGeocodeLocationUseCase>(),
    );
    unawaited(
      viewModel.doIntent(
        GetLocationsCatalogEvent(initialAddress: initialAddress),
      ),
    );
    return viewModel;
  }

  Future<void> _handleState(
      BuildContext context, AddressEditorState state) async {
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

    final isNewSessionLoading = !_isCoverageSheetOpen &&
        (state.coveragePreview.isLoading ||
            (state.coveragePreview.isSuccess &&
                state.coveragePreview.preview != null)) &&
        state.coveragePreview.sessionId != 0 &&
        state.coveragePreview.sessionId != _activeCoverageSessionId;

    if (isNewSessionLoading) {
      _openCoverageModal(context, state.coveragePreview.sessionId);
    }
  }

  Future<void> _openCoverageModal(BuildContext context, int sessionId) async {
    if (_isCoverageSheetOpen) {
      _activeCoverageSessionId = sessionId;
      return;
    }
    _isCoverageSheetOpen = true;
    _activeCoverageSessionId = sessionId;

    try {
      await AppWoltModalSheet.show<void>(
        context: context,
        hasTopBarLayer: false,
        showDragHandle: false,
        child: BlocProvider.value(
          value: context.read<AddressEditorViewModel>(),
          child: BlocBuilder<AddressEditorViewModel, AddressEditorState>(
            builder: (sheetContext, innerState) {
              final coverage = innerState.coveragePreview;

              if (coverage.sessionId != _activeCoverageSessionId &&
                  coverage.sessionId == 0) {
                return const SizedBox.shrink();
              }

              if (coverage.isLoading && coverage.preview == null) {
                return const AddressCoverageLoadingSkeleton();
              }

              if (coverage.failure != null && coverage.preview == null) {
                return Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: ApiErrorWidget(
                    exception: coverage.failure!.exception,
                    onRetry: () => sheetContext
                        .read<AddressEditorViewModel>()
                        .doIntent(const RetryAddressCoveragePreviewEvent()),
                  ),
                );
              }

              final preview = coverage.preview;
              if (preview == null) {
                return const SizedBox.shrink();
              }

              return AddressCoveragePreviewBottomSheet(
                key: ValueKey(coverage.sessionId),
                preview: preview,
                isSubmitting: innerState.action.isLoading,
                confirmButtonText:
                    sheetContext.localization.address_coverage_confirm_save,
                isLoadingMore: coverage.isLoadingMore,
                hasMoreRestaurants: coverage.canLoadMore,
                loadMoreFailure: coverage.loadMoreFailure,
                onLoadMoreRestaurants: () => unawaited(
                  sheetContext.read<AddressEditorViewModel>().doIntent(
                        const LoadMoreAddressCoverageRestaurantsEvent(),
                      ),
                ),
                onConfirm: () {
                  final viewModel =
                      sheetContext.read<AddressEditorViewModel>();
                  unawaited(
                    viewModel.doIntent(
                      const ConfirmPendingAddressActionEvent(),
                    ),
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
    } finally {
      _isCoverageSheetOpen = false;
      if (context.mounted) {
        final currentSession = context
            .read<AddressEditorViewModel>()
            .state
            .coveragePreview
            .sessionId;
        if (currentSession == _activeCoverageSessionId) {
          context.read<AddressEditorViewModel>().doIntent(
                const ClearCoveragePreviewEvent(),
              );
        }
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
