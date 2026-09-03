import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AppDateRangePicker extends StatefulWidget {
  const AppDateRangePicker({
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.firstDate,
    required this.lastDate,
    this.initialStartDate,
    this.initialEndDate,
    super.key,
  });

  final String title;
  final String confirmText;
  final String cancelText;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  static Future<DateTimeRange?> show({
    required BuildContext context,
    required String title,
    required String confirmText,
    required String cancelText,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    bool barrierDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    bool useSafeArea = true,
  }) {
    final color = context.colorScheme;

    return WoltModalSheet.show<DateTimeRange>(
      context: context,
      useSafeArea: useSafeArea,
      barrierDismissible: barrierDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      modalBarrierColor: color.scrim,
      modalTypeBuilder: (_) => WoltModalType.bottomSheet(),
      pageListBuilder: (_) => [
        WoltModalSheetPage(
          backgroundColor: color.surface,
          surfaceTintColor: color.surface,
          child: AppDateRangePicker(
            title: title,
            confirmText: confirmText,
            cancelText: cancelText,
            firstDate: firstDate,
            lastDate: lastDate,
            initialStartDate: initialStartDate,
            initialEndDate: initialEndDate,
          ),
        ),
      ],
    );
  }

  @override
  State<AppDateRangePicker> createState() => _AppDateRangePickerState();
}

class _AppDateRangePickerState extends State<AppDateRangePicker> {
  late List<DateTime?> _selectedDates;

  @override
  void initState() {
    super.initState();
    _selectedDates = [
      widget.initialStartDate == null
          ? null
          : DateUtils.dateOnly(widget.initialStartDate!),
      widget.initialEndDate == null
          ? null
          : DateUtils.dateOnly(widget.initialEndDate!),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final textStyle = getRegularStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: FontSize.size13,
      color: color.onSurface,
    );
    final selectedTextStyle = getBoldStyle(
      fontFamily: FontConstant.alexandria,
      fontSize: FontSize.size13,
      color: color.onPrimary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size17,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
              firstDate: DateUtils.dateOnly(widget.firstDate),
              lastDate: DateUtils.dateOnly(widget.lastDate),
              currentDate: DateUtils.dateOnly(DateTime.now()),
              firstDayOfWeek: MaterialLocalizations.of(
                context,
              ).firstDayOfWeekIndex,
              rangeBidirectional: true,
              disableModePicker: true,
              centerAlignModePicker: true,
              controlsHeight: Spacing.buttonSmallHeight,
              controlsTextStyle: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
              weekdayLabelTextStyle: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurfaceVariant,
              ),
              dayTextStyle: textStyle,
              todayTextStyle: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.primary,
              ),
              disabledDayTextStyle: textStyle.copyWith(
                color: color.onSurfaceVariant.withValues(alpha: 0.45),
              ),
              selectedDayTextStyle: selectedTextStyle,
              selectedRangeDayTextStyle: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.primary,
              ),
              selectedDayHighlightColor: color.primary,
              selectedRangeHighlightColor: color.primary.withValues(
                alpha: 0.12,
              ),
              dayBorderRadius: BorderRadius.circular(Spacing.radiusPill),
              lastMonthIcon: Icon(
                Icons.chevron_left_rounded,
                color: color.onSurface,
              ),
              nextMonthIcon: Icon(
                Icons.chevron_right_rounded,
                color: color.onSurface,
              ),
              modePickerTextHandler: ({required monthDate, isMonthPicker}) {
                return DateFormat.yMMMM(locale.localeName).format(monthDate);
              },
            ),
            value: _selectedDates,
            onValueChanged: (dates) {
              setState(() {
                _selectedDates = dates;
              });
            },
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  text: widget.cancelText,
                  height: Spacing.buttonSmallHeight,
                  borderRadius: Spacing.radiusPill,
                  color: color.outline,
                  textColor: color.onSurfaceVariant,
                  fontSize: FontSize.size12,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: AppButton.filled(
                  text: widget.confirmText,
                  height: Spacing.buttonSmallHeight,
                  borderRadius: Spacing.radiusPill,
                  color: color.primary,
                  textColor: color.onPrimary,
                  fontSize: FontSize.size12,
                  onPressed: _canSubmit
                      ? () => Navigator.of(context).pop(_selectedRange)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool get _canSubmit => _selectedDates.length >= 2 && _selectedRange != null;

  DateTimeRange? get _selectedRange {
    if (_selectedDates.length < 2) {
      return null;
    }

    final start = _selectedDates[0];
    final end = _selectedDates[1];
    if (start == null || end == null) {
      return null;
    }

    if (end.isBefore(start)) {
      return DateTimeRange(start: end, end: start);
    }
    return DateTimeRange(start: start, end: end);
  }
}
