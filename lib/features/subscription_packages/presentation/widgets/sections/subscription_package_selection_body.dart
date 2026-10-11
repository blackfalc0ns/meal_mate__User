import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_state.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/sections/subscription_package_list_section.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/sections/subscription_package_program_header_section.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_packages_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionPackageSelectionBody extends StatelessWidget {
  const SubscriptionPackageSelectionBody({
    super.key,
    required this.state,
    required this.selectedProgram,
    required this.selectedPackageNotifier,
    required this.onPackageSelected,
    required this.onRetry,
    this.onLoadMore,
    this.onRetryLoadMore,
  });

  final SubscriptionPackagesState state;
  final SubscriptionProgramEntity? selectedProgram;
  final ValueListenable<int?> selectedPackageNotifier;
  final ValueChanged<int> onPackageSelected;
  final VoidCallback onRetry;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    if (selectedProgram == null) {
      return EmptyStateWidget(
        title: locale.subscription_program_title,
        description: locale.subscription_program_subtitle,
        icon: Icons.restaurant_menu_rounded,
      );
    }

    if (state.isLoading && state.bundles.isEmpty) {
      return const SubscriptionPackagesLoadingSkeleton();
    }

    if (state.failure != null && state.bundles.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: onRetry,
      );
    }

    if (state.isSuccess && state.bundles.isEmpty) {
      return EmptyStateWidget(
        title: locale.subscription_packages_empty_title,
        description: locale.subscription_packages_empty_description,
        icon: Icons.restaurant_menu_rounded,
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200 &&
            state.pagination?.hasNextPage == true &&
            !state.isLoadingMore) {
          onLoadMore?.call();
        }
        return false;
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SubscriptionPackageProgramHeaderSection(program: selectedProgram!),
          SubscriptionPackageListSection(
            bundles: state.bundles,
            selectedProgram: selectedProgram!,
            selectedPackageNotifier: selectedPackageNotifier,
            onPackageSelected: onPackageSelected,
          ),
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(Spacing.md),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            ),
          if (state.loadMoreFailure != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.sm,
                ),
                child: InlineApiErrorWidget(
                  failure: state.loadMoreFailure!,
                  onRetry: onRetryLoadMore,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
