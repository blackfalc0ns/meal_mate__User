import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OfferCountdownTimerWidget extends StatefulWidget {
  const OfferCountdownTimerWidget({
    super.key,
    required this.endsAt,
    this.onExpired,
  });

  final DateTime endsAt;
  final VoidCallback? onExpired;

  @override
  State<OfferCountdownTimerWidget> createState() =>
      _OfferCountdownTimerWidgetState();
}

class _OfferCountdownTimerWidgetState extends State<OfferCountdownTimerWidget> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _computeRemaining();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant OfferCountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endsAt != widget.endsAt) {
      _computeRemaining();
    }
  }

  void _computeRemaining() {
    final diff = widget.endsAt.difference(DateTime.now().toUtc());
    if (diff.isNegative || diff == Duration.zero) {
      _remaining = Duration.zero;
      widget.onExpired?.call();
    } else {
      _remaining = diff;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(_computeRemaining);
      if (_remaining == Duration.zero) {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final days = _remaining.inDays.toString().padLeft(2, '0');
    final hours = (_remaining.inHours % 24).toString().padLeft(2, '0');
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    final isExpired = _remaining == Duration.zero;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: isExpired
            ? color.errorContainer
            : color.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(
          color: isExpired
              ? color.error.withValues(alpha: 0.3)
              : color.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isExpired ? Icons.timer_off_rounded : Icons.timer_outlined,
            size: 20,
            color: isExpired ? color.error : color.primary,
          ),
          const SizedBox(width: Spacing.sm),
          Text(
            isExpired
                ? locale.offer_countdown_expired
                : '${locale.offer_countdown_prefix}: $days : $hours : $minutes : $seconds',
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: isExpired ? color.error : color.primary,
            ),
          ),
        ],
      ),
    );
  }
}
