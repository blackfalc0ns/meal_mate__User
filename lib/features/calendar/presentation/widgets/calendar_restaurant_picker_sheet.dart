import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
part 'calendar_restaurant_search_field.dart';
part 'calendar_restaurant_option_card.dart';
part 'calendar_arrow_bubble.dart';
part 'calendar_rating.dart';
part 'calendar_restaurant_copy.dart';
part 'calendar_restaurant_picker_logo.dart';
part 'calendar_circle_text_logo.dart';
part 'calendar_restaurant_picker_loading_skeleton.dart';
part 'calendar_restaurant_picker_empty.dart';

class CalendarRestaurantPickerSheet extends StatefulWidget {
  const CalendarRestaurantPickerSheet({
    super.key,
    this.date,
    required this.restaurants,
    required this.onRestaurantSelected,
    required this.onSearchChanged,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.loadMoreFailure,
    this.hasNextPage = false,
    this.onLoadMore,
    this.onRetryLoadMore,
  });

  final DateTime? date;
  final List<CalendarRestaurantOptionEntity> restaurants;
  final ValueChanged<CalendarRestaurantOptionEntity> onRestaurantSelected;
  final ValueChanged<String> onSearchChanged;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;
  final bool hasNextPage;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRetryLoadMore;

  @override
  State<CalendarRestaurantPickerSheet> createState() =>
      _CalendarRestaurantPickerSheetState();
}

class _CalendarRestaurantPickerSheetState
    extends State<CalendarRestaurantPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: color.outline, width: 0.8),
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              top: 11,
              end: 17,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 25,
                  height: 25,
                ),
                icon: Icon(
                  Icons.cancel_rounded,
                  color: color.outline,
                  size: 25,
                ),
              ),
            ),
            PositionedDirectional(
              top: 11,
              start: 0,
              end: 0,
              child: Center(
                child: SizedBox(
                  width: 31,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color.outline,
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    ),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: 30,
              start: 0,
              end: 0,
              child: Column(
                children: [
                  Text(
                    locale.calendar_browse_restaurants,
                    textAlign: TextAlign.center,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: 14,
                      color: color.onSurface,
                    ).copyWith(height: 20 / 14, letterSpacing: 0),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Builder(
                    builder: (context) {
                      final effectiveDate = widget.date ?? DateTime.now();
                      final formattedDate = DateFormat(
                        'EEEE d MMMM',
                        locale.localeName,
                      ).format(effectiveDate);

                      return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: 10,
                            color: color.onSurface.withValues(alpha: 0.64),
                          ).copyWith(height: 2, letterSpacing: 0),
                          children: [
                            TextSpan(
                              text: locale.calendar_choose_restaurant_for_day,
                            ),
                            TextSpan(
                              text: formattedDate,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: 10,
                                color: color.tertiary,
                              ).copyWith(height: 2, letterSpacing: 0),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: 85,
              start: 19,
              end: 20,
              child: CalendarRestaurantSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
            ),
            PositionedDirectional(
              top: 143,
              start: 19,
              end: 20,
              bottom: 24,
              child: widget.isLoading
                  ? const CalendarRestaurantPickerLoadingSkeleton()
                  : widget.restaurants.isEmpty
                  ? CalendarRestaurantPickerEmpty(
                      onClear: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                      },
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (widget.hasNextPage &&
                            !widget.isLoading &&
                            !widget.isLoadingMore &&
                            widget.loadMoreFailure == null &&
                            notification.metrics.extentAfter <= 200) {
                          widget.onLoadMore?.call();
                        }
                        return false;
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount:
                            widget.restaurants.length +
                            (widget.isLoadingMore ||
                                    widget.loadMoreFailure != null
                                ? 1
                                : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 9.2),
                        itemBuilder: (context, index) {
                          if (index >= widget.restaurants.length) {
                            if (widget.isLoadingMore) {
                              return const CalendarRestaurantPickerLoadMoreSkeleton();
                            }
                            if (widget.loadMoreFailure != null) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Spacing.sm,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          ErrorMessagePresenter.fromFailure(
                                            context,
                                            widget.loadMoreFailure!,
                                          ),
                                          textAlign: TextAlign.center,
                                          style: getRegularStyle(
                                            fontFamily: FontConstant.alexandria,
                                            fontSize: 12,
                                            color: color.error,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: Spacing.xs),
                                      IconButton(
                                        icon: const Icon(Icons.refresh_rounded),
                                        color: color.primary,
                                        onPressed: widget.onRetryLoadMore,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }
                          final restaurant = widget.restaurants[index];
                          final delayMs = (index * 60).clamp(0, 480);
                          return CalendarRestaurantOptionCard(
                                key: ValueKey(restaurant.id),
                                restaurant: restaurant,
                                onTap: () =>
                                    widget.onRestaurantSelected(restaurant),
                              )
                              .animate()
                              .fadeIn(
                                duration: 300.ms,
                                delay: delayMs.ms,
                                curve: Curves.easeOut,
                              )
                              .slideY(
                                begin: 0.12,
                                end: 0,
                                duration: 300.ms,
                                delay: delayMs.ms,
                                curve: Curves.easeOutCubic,
                              );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
