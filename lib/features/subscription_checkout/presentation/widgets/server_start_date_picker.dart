import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import '../manager/start_dates_view_model.dart';
import '../manager/start_dates_state.dart';
import '../manager/start_dates_event.dart';
import 'eligible_start_date_calendar.dart';

class ServerStartDatePicker extends StatelessWidget {
  const ServerStartDatePicker({
    super.key,
    required this.includeFriday,
    this.initialDate,
    this.title,
  });

  final bool includeFriday;
  final String? initialDate;
  final String? title;

  static Future<String?> show({
    required BuildContext context,
    required bool includeFriday,
    String? initialDate,
    String? title,
    List<String>? eligibleDates,
  }) => showDialog<String>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) {
        final vm = getIt<StartDatesViewModel>();
        if (eligibleDates != null && eligibleDates.isNotEmpty) {
          vm.setInitialDates(
            dates: eligibleDates,
            includeFriday: includeFriday,
          );
        } else {
          vm.doIntent(LoadStartDatesEvent(includeFriday: includeFriday));
        }
        return vm;
      },
      child: ServerStartDatePicker(
        includeFriday: includeFriday,
        initialDate: initialDate,
        title: title,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AlertDialog(
      backgroundColor: color.surface,
      surfaceTintColor: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.bottomSheetRadius),
      ),
      titlePadding: const EdgeInsets.only(
        top: Spacing.xl,
        left: Spacing.xl,
        right: Spacing.xl,
        bottom: Spacing.xs,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.xs,
      ),
      actionsPadding: const EdgeInsets.only(
        left: Spacing.xl,
        right: Spacing.xl,
        bottom: Spacing.base,
      ),
      actionsAlignment: MainAxisAlignment.center,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? locale.subscription_start_date,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size18,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            locale.start_dates_title,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
      scrollable: true,
      content: BlocBuilder<StartDatesViewModel, StartDatesState>(
        buildWhen: (a, b) =>
            a.isLoading != b.isLoading ||
            a.data != b.data ||
            a.failure != b.failure,
        builder: (context, state) {
          if (state.isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: Spacing.xxl),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.failure case final failure?) {
            return ApiErrorWidget(
              exception: failure.exception,
              onRetry: () => context.read<StartDatesViewModel>().doIntent(
                LoadStartDatesEvent(includeFriday: includeFriday),
              ),
            );
          }
          final data = state.data;
          if (data == null || data.dates.isEmpty) {
            return EmptyStateWidget(
              title: locale.start_dates_unavailable,
              description: locale.start_dates_unavailable_description,
              icon: Icons.event_busy_rounded,
            );
          }
          return EligibleStartDateCalendar(
            dates: data.dates,
            includeFriday: data.includeFriday,
            initialDate: initialDate,
            onSelected: (date) => Navigator.of(context).pop(date),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            locale.billing_cancel,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.primary,
            ),
          ),
        ),
      ],
    );
  }
}
