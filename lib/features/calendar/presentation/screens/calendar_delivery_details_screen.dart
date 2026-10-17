import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/delivery/calendar_delivery_details_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/delivery/calendar_delivery_details_view_model.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_actions.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_info_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_status_hero.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_support_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_timeline.dart';

class CalendarDeliveryDetailsScreen extends StatefulWidget {
  const CalendarDeliveryDetailsScreen({
    super.key,
    required this.subscriptionDayId,
    this.viewModel,
  });

  final String subscriptionDayId;
  final CalendarDeliveryDetailsViewModel? viewModel;

  @override
  State<CalendarDeliveryDetailsScreen> createState() =>
      _CalendarDeliveryDetailsScreenState();
}

class _CalendarDeliveryDetailsScreenState
    extends State<CalendarDeliveryDetailsScreen> {
  late final CalendarDeliveryDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<CalendarDeliveryDetailsViewModel>();
    unawaited(_viewModel.loadDetails(widget.subscriptionDayId));
  }

  @override
  void dispose() {
    if (widget.viewModel == null) {
      unawaited(_viewModel.close());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<CalendarDeliveryDetailsViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: AppBar(
          backgroundColor: color.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: color.onSurface,
              size: Spacing.iconSm,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            locale.calendar_delivery_details_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
        ),
        body: BlocBuilder<CalendarDeliveryDetailsViewModel,
            CalendarDeliveryDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: color.primary),
              );
            }

            final deliveryItem = state.deliveryItem;
            if (deliveryItem == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delivery_dining_outlined,
                        size: Spacing.iconLg * 2,
                        color: color.onSurfaceVariant,
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        locale.calendar_error_day_unavailable,
                        textAlign: TextAlign.center,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      AppButton(
                        text: locale.calendar_confirmed_sheet_back_to_calendar,
                        onPressed: () => Navigator.of(context).pop(),
                        height: Spacing.buttonSmallHeight,
                        borderRadius: Spacing.buttonSmallRadius,
                        color: color.primary,
                        textColor: color.onPrimary,
                        fontSize: FontSize.size13,
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.screenH,
                vertical: Spacing.md,
              ),
              child: Column(
                children: [
                  const SizedBox(height: Spacing.sm),
                  CalendarDeliveryDetailsStatusHero(deliveryItem: deliveryItem),
                  const SizedBox(height: Spacing.xl),
                  CalendarDeliveryDetailsInfoCard(deliveryItem: deliveryItem),
                  const SizedBox(height: Spacing.base),
                  CalendarDeliveryDetailsTimeline(deliveryItem: deliveryItem),
                  const SizedBox(height: Spacing.base),
                  const CalendarDeliveryDetailsSupportCard(),
                  const SizedBox(height: Spacing.xl),
                  CalendarDeliveryDetailsActions(
                    onBackToCalendar: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: Spacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
