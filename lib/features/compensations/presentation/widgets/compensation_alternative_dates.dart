import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import '../../domain/entities/alternative_date_entity.dart';
import '../../domain/entities/choose_compensation_request_entity.dart';
import '../manager/compensations_view_model.dart';
import '../manager/compensations_state.dart';
import '../manager/compensations_event.dart';

class CompensationAlternativeDates extends StatelessWidget {
  const CompensationAlternativeDates({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final vm = context.read<CompensationsViewModel>();
    return BlocSelector<
      CompensationsViewModel,
      CompensationsState,
      ({
        List<AlternativeDateEntity>? dates,
        String? selected,
        bool loading,
        bool submitting,
      })
    >(
      selector: (s) => (
        dates: s.dates[id],
        selected: s.selectedDates[id],
        loading: s.loadingDates.contains(id),
        submitting: s.submitting.contains(id),
      ),
      builder: (context, state) {
        if (state.loading) {
          return const Padding(
            padding: EdgeInsets.all(Spacing.base),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final dates = state.dates;
        if (dates == null) return const SizedBox.shrink();
        if (!dates.any((d) => d.isAvailable)) {
          return Padding(
            padding: const EdgeInsets.only(top: Spacing.sm),
            child: Text(
              locale.compensations_no_dates,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                color: color.onSurfaceVariant,
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.sm),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.xs,
              children: [
                for (final date in dates)
                  if (DateTime.tryParse(date.date) case final parsed?)
                    ChoiceChip(
                      label: Text(
                        DateFormat.yMMMEd(locale.localeName).format(parsed),
                      ),
                      selected: state.selected == date.date,
                      onSelected: date.isAvailable && !state.submitting
                          ? (_) => vm.doIntent(
                              SelectCompensationDateEvent(id, date.date),
                            )
                          : null,
                    ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            AppButton.filled(
              text: locale.compensations_confirm_day,
              isLoading: state.submitting,
              onPressed: state.selected != null && !state.submitting
                  ? () => vm.doIntent(
                      SubmitCompensationChoiceEvent(
                        id,
                        CompensationChoice.alternativeDay,
                      ),
                    )
                  : null,
            ),
          ],
        );
      },
    );
  }
}
