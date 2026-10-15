import 'dart:async';
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
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/address_choose_location_screen.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_loading_skeleton.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_loading_overlay.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_loading_skeleton.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/sections/addresses_content_section.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  bool _isCoverageSheetOpen = false;
  int? _activeCoverageSessionId;

  bool _canEditAddress() {
    if (getIt.isRegistered<FamilyContextViewModel>()) {
      final state = getIt<FamilyContextViewModel>().state;
      if (state.isMember && !state.isManager) {
        final ctx = state.primaryContext;
        if (ctx != null) {
          return ctx.can('editAddress');
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final canEdit = _canEditAddress();

    return BlocProvider<AddressesViewModel>(
      create: (_) {
        final viewModel = getIt<AddressesViewModel>();
        unawaited(viewModel.doIntent(const GetCustomerAddressesEvent()));
        return viewModel;
      },
      child: Scaffold(
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
                listener: _handleState,
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

                  return AddressesContentSection(
                    currentDeliveryAddress:
                        addressesState.currentDeliveryAddress,
                    addresses: addressesState.items,
                    canEdit: canEdit,
                    onEdit: (address) =>
                        _openAddressEditor(context, initialAddress: address),
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
                    onAddAddress: () => _openAddressEditor(context),
                  );
                },
              ),
            ),
            BlocSelector<AddressesViewModel, AddressesState, bool>(
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

  Future<void> _handleState(BuildContext context, AddressesState state) async {
    final locale = context.localization;
    final errorMessage = state.action.displayErrorMessage;
    if (errorMessage != null && errorMessage.isNotEmpty) {
      CustomSnackbar.showError(context: context, message: errorMessage);
    }

    final isNewSessionLoading =
        state.coveragePreview.isLoading &&
        state.coveragePreview.sessionId != 0 &&
        state.coveragePreview.sessionId != _activeCoverageSessionId;

    if (isNewSessionLoading) {
      _openCoverageModal(context, state.coveragePreview.sessionId);
    }

    if (!context.mounted) return;

    if (state.action.isSuccess && state.action.address != null) {
      CustomSnackbar.showSuccess(
        context: context,
        message: locale.addresses_save_success,
      );
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
          value: context.read<AddressesViewModel>(),
          child: BlocBuilder<AddressesViewModel, AddressesState>(
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
                        .read<AddressesViewModel>()
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
                confirmButtonText: sheetContext
                    .localization
                    .address_coverage_confirm_set_default,
                isLoadingMore: coverage.isLoadingMore,
                hasMoreRestaurants: coverage.canLoadMore,
                loadMoreFailure: coverage.loadMoreFailure,
                onLoadMoreRestaurants: () => unawaited(
                  sheetContext.read<AddressesViewModel>().doIntent(
                    const LoadMoreAddressCoverageRestaurantsEvent(),
                  ),
                ),
                onConfirm: () {
                  unawaited(
                    sheetContext.read<AddressesViewModel>().doIntent(
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
            .read<AddressesViewModel>()
            .state
            .coveragePreview
            .sessionId;
        if (currentSession == _activeCoverageSessionId) {
          context.read<AddressesViewModel>().doIntent(
            const ClearCoveragePreviewEvent(),
          );
        }
      }
    }
  }

  Future<void> _openAddressEditor(
    BuildContext context, {
    CustomerAddressEntity? initialAddress,
  }) async {
    if (!_canEditAddress()) {
      CustomSnackbar.showWarning(
        context: context,
        message: context.localization.localeName == 'ar'
            ? 'تعديل العناوين مقفل من قِبل مدير العائلة'
            : 'Address editing is locked by the family manager',
      );
      return;
    }
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
