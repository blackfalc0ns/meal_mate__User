import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import '../../domain/entities/compensation_entity.dart';
import '../../domain/entities/choose_compensation_request_entity.dart';
import '../manager/compensations_view_model.dart';
import '../manager/compensations_state.dart';
import '../manager/compensations_event.dart';
import 'compensation_alternative_dates.dart';
import 'compensation_countdown_text.dart';

class CompensationChoiceActions extends StatefulWidget {
  const CompensationChoiceActions({super.key, required this.item});
  final CompensationEntity item;
  @override
  State<CompensationChoiceActions> createState() =>
      _CompensationChoiceActionsState();
}

class _CompensationChoiceActionsState extends State<CompensationChoiceActions> {
  late final ValueNotifier<int> _seconds;
  late final ValueNotifier<bool> _active;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _seconds = ValueNotifier(
      context.read<CompensationsViewModel>().remainingSeconds(widget.item.id),
    );
    _active = ValueNotifier(_seconds.value > 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final vm = context.read<CompensationsViewModel>();
    final seconds = vm.remainingSeconds(widget.item.id);
    if (_seconds.value != seconds) _seconds.value = seconds;
    if (_active.value != (seconds > 0)) _active.value = seconds > 0;
    if (seconds == 0 && widget.item.canChoose) {
      vm.doIntent(CompensationDeadlineReachedEvent(widget.item.id));
    }
  }

  @override
  void didUpdateWidget(covariant CompensationChoiceActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    _seconds.value = context.read<CompensationsViewModel>().remainingSeconds(
      widget.item.id,
    );
    _active.value = _seconds.value > 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _seconds.dispose();
    _active.dispose();
    super.dispose();
  }

  Future<void> _confirmRefund() async {
    final locale = context.localization;
    final vm = context.read<CompensationsViewModel>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(locale.compensations_refund),
        content: Text(locale.compensations_refund_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(locale.billing_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(locale.compensations_refund),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      vm.doIntent(
        SubmitCompensationChoiceEvent(
          widget.item.id,
          CompensationChoice.cashRefund,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final vm = context.read<CompensationsViewModel>();
    final id = widget.item.id;
    return BlocSelector<
      CompensationsViewModel,
      CompensationsState,
      ({bool submitting, bool blocked, bool ineligible})
    >(
      selector: (s) => (
        submitting: s.submitting.contains(id),
        blocked: s.blockedChoices.contains(id),
        ineligible: s.alternativeIneligible.contains(id),
      ),
      builder: (context, state) => ValueListenableBuilder<bool>(
        valueListenable: _active,
        builder: (context, active, child) {
          final enabled = widget.item.canChoose && active && !state.blocked;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompensationCountdownText(seconds: _seconds, enabled: enabled),
              const SizedBox(height: Spacing.sm),
              Text(
                locale.compensations_deadline_note,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.base),
              AppButton.outlined(
                text: locale.compensations_refund,
                isLoading: state.submitting,
                onPressed: enabled && !state.submitting ? _confirmRefund : null,
              ),
              if (widget.item.eligibleForAlternativeDay &&
                  !state.ineligible) ...[
                const SizedBox(height: Spacing.sm),
                AppButton.filled(
                  text: locale.compensations_alternative,
                  onPressed: enabled && !state.submitting
                      ? () => vm.doIntent(LoadCompensationDatesEvent(id))
                      : null,
                ),
              ],
              if (enabled && !state.ineligible)
                CompensationAlternativeDates(id: id),
            ],
          );
        },
      ),
    );
  }
}
