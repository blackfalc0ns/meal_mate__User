import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';

class SubscriptionSummaryRestaurantsSheet extends StatelessWidget {
  const SubscriptionSummaryRestaurantsSheet({
    super.key,
    this.initialRestaurants = const [],
    this.totalCount = 0,
  });

  final List<SubscriptionSummaryRestaurantEntity> initialRestaurants;
  final int totalCount;

  static Future<void> show({
    required BuildContext context,
    List<SubscriptionSummaryRestaurantEntity> restaurants = const [],
    int totalCount = 0,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;

    SubscriptionSummaryViewModel? viewModel;
    try {
      viewModel = context.read<SubscriptionSummaryViewModel>();
    } catch (_) {
      viewModel = null;
    }

    final effectiveTotal = totalCount > 0
        ? totalCount
        : (viewModel?.state.summary?.restaurantCount ?? restaurants.length);

    final titleWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            locale.subscription_summary_all_restaurants,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size18,
              color: color.onSurface,
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xxs,
          ),
          decoration: BoxDecoration(
            color: color.tertiaryContainer,
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
          ),
          child: Text(
            '$effectiveTotal',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.primary,
            ),
          ),
        ),
      ],
    );

    final sheetContent = SubscriptionSummaryRestaurantsSheet(
      initialRestaurants: restaurants,
      totalCount: effectiveTotal,
    );

    return AppWoltModalSheet.show<void>(
      context: context,
      titleWidget: titleWidget,
      child: viewModel != null
          ? BlocProvider.value(
              value: viewModel,
              child: sheetContent,
            )
          : sheetContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionSummaryViewModel? viewModel;
    try {
      viewModel = context.watch<SubscriptionSummaryViewModel>();
    } catch (_) {
      viewModel = null;
    }

    if (viewModel != null) {
      return BlocBuilder<SubscriptionSummaryViewModel, SubscriptionSummaryState>(
        builder: (context, state) {
          final restaurants = state.summary?.restaurants ?? initialRestaurants;
          final hasNextPage =
              state.summary?.restaurantsPagination?.hasNextPage ?? false;
          final isLoadingMore = state.isLoadingMoreRestaurants;
          final appendFailure = state.restaurantsAppendFailure;

          return _buildList(
            context: context,
            restaurants: restaurants,
            hasNextPage: hasNextPage,
            isLoadingMore: isLoadingMore,
            appendFailure: appendFailure,
            onLoadMore: () {
              if (hasNextPage && !isLoadingMore) {
                context
                    .read<SubscriptionSummaryViewModel>()
                    .doIntent(const LoadMoreSubscriptionSummaryRestaurantsEvent());
              }
            },
            onRetryAppend: () {
              context
                  .read<SubscriptionSummaryViewModel>()
                  .doIntent(const RetrySubscriptionSummaryRestaurantsEvent());
            },
          );
        },
      );
    }

    return _buildList(
      context: context,
      restaurants: initialRestaurants,
      hasNextPage: false,
      isLoadingMore: false,
      appendFailure: null,
      onLoadMore: null,
      onRetryAppend: null,
    );
  }

  Widget _buildList({
    required BuildContext context,
    required List<SubscriptionSummaryRestaurantEntity> restaurants,
    required bool hasNextPage,
    required bool isLoadingMore,
    required dynamic appendFailure,
    required VoidCallback? onLoadMore,
    required VoidCallback? onRetryAppend,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.75;

    final extraCount = (isLoadingMore || appendFailure != null) ? 1 : 0;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.base,
          vertical: Spacing.sm,
        ),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 100) {
              onLoadMore?.call();
            }
            return false;
          },
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: restaurants.length + extraCount,
            separatorBuilder: (_, _) => Divider(
              height: Spacing.border,
              thickness: Spacing.border,
              color: color.outlineVariant,
            ),
            itemBuilder: (context, index) {
              if (index >= restaurants.length) {
                if (isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: Spacing.md),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
                }
                if (appendFailure != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                    child: InlineApiErrorWidget(
                      failure: appendFailure,
                      onRetry: onRetryAppend,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final restaurant = restaurants[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Row(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: Spacing.avatarSm,
                        height: Spacing.avatarSm,
                        child: restaurant.logoUrl == null
                            ? Icon(
                                Icons.restaurant_rounded,
                                color: color.primary,
                                size: Spacing.iconMd,
                              )
                            : AppCachedNetworkImage(
                                imageUrl: restaurant.logoUrl!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Text(
                        restaurant.name(locale.localeName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
