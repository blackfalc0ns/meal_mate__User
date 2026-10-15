import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_loading_skeleton.dart';

/// Horizontal list of serving restaurants with pagination scroll listener,
/// trailing shimmer loading placeholder, and inline error presentation.
class AddressCoverageRestaurantsList extends StatefulWidget {
  const AddressCoverageRestaurantsList({
    super.key,
    required this.restaurants,
    this.isLoadingMore = false,
    this.hasMoreRestaurants = false,
    this.loadMoreFailure,
    this.onLoadMoreRestaurants,
  });

  final List<ServingRestaurantEntity> restaurants;
  final bool isLoadingMore;
  final bool hasMoreRestaurants;
  final Failure? loadMoreFailure;
  final VoidCallback? onLoadMoreRestaurants;

  @override
  State<AddressCoverageRestaurantsList> createState() =>
      _AddressCoverageRestaurantsListState();
}

class _AddressCoverageRestaurantsListState
    extends State<AddressCoverageRestaurantsList> {
  late final ScrollController _scrollController;
  int? _lastRequestedCount;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    if (widget.hasMoreRestaurants &&
        !widget.isLoadingMore &&
        widget.loadMoreFailure == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _checkViewportContinuation();
      });
    }
  }

  @override
  void didUpdateWidget(AddressCoverageRestaurantsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.restaurants.length != oldWidget.restaurants.length ||
        widget.loadMoreFailure != oldWidget.loadMoreFailure) {
      _lastRequestedCount = null;
    }
    if (widget.hasMoreRestaurants &&
        !widget.isLoadingMore &&
        widget.loadMoreFailure == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _checkViewportContinuation();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) return;
    if (position.extentAfter <= position.viewportDimension) {
      _triggerLoadMore();
    }
  }

  void _checkViewportContinuation() {
    if (!mounted || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    if (position.extentAfter <= position.viewportDimension) {
      _triggerLoadMore();
    }
  }

  void _triggerLoadMore() {
    if (!widget.hasMoreRestaurants ||
        widget.isLoadingMore ||
        widget.loadMoreFailure != null ||
        widget.onLoadMoreRestaurants == null) {
      return;
    }
    if (_lastRequestedCount == widget.restaurants.length) {
      return;
    }
    _lastRequestedCount = widget.restaurants.length;
    widget.onLoadMoreRestaurants!();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final totalCount =
        widget.restaurants.length + (widget.isLoadingMore ? 1 : 0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 115,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: totalCount,
            separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
            itemBuilder: (context, index) {
              if (index < widget.restaurants.length) {
                final restaurant = widget.restaurants[index];
                return _buildRestaurantCard(context, color, locale, restaurant);
              }
              return const AddressCoverageLoadingSkeleton(
                restaurantsOnly: true,
              );
            },
          ),
        ),
        if (widget.loadMoreFailure != null) ...[
          const SizedBox(height: Spacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 380),
            child: ApiErrorWidget(
              exception: widget.loadMoreFailure!.exception,
              onRetry: widget.onLoadMoreRestaurants,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRestaurantCard(
    BuildContext context,
    ColorScheme color,
    dynamic locale,
    ServingRestaurantEntity restaurant,
  ) {
    final name = restaurant.name(locale.localeName);
    final logoUrl = restaurant.logoUrl;
    final rating = restaurant.rating;

    return Container(
      width: 104,
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.hairline,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppCachedNetworkImage(
            imageUrl: logoUrl,
            width: 38,
            height: 38,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size10,
              color: color.onSurface,
            ),
          ),
          if (rating != null && rating > 0) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rounded, color: color.primary, size: 14),
                const SizedBox(width: 2),
                Text(
                  rating.toStringAsFixed(1),
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
