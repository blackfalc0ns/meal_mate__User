import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_event.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_state.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_editor_view_model.dart';
import 'package:meal_meat_user/core/address/presentation/manager/address_entry_flow_controller.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_loading_skeleton.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_preview_bottom_sheet.dart';
import 'package:meal_meat_user/core/constants/durations.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyAddressCoverageSection extends StatelessWidget {
  const FamilyAddressCoverageSection({
    super.key,
    required this.flowController,
    required this.onResetShownSession,
  });

  final AddressEntryFlowController flowController;
  final VoidCallback onResetShownSession;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      AddressEditorViewModel,
      AddressEditorState,
      AddressCoveragePreviewState
    >(
      selector: (state) => state.coveragePreview,
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
              builder: (context, progress, child) => FractionalTranslation(
                translation: Offset(Spacing.zero, progress),
                child: child,
              ),
              child:
                  BlocSelector<
                    AddressEditorViewModel,
                    AddressEditorState,
                    bool
                  >(
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
                          onResetShownSession();
                          flowController.chooseLocation();
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
    );
  }
}
