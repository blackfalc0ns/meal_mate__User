import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OfferDealCountdownBar extends StatefulWidget {
  const OfferDealCountdownBar({
    super.key,
    required this.endsAt,
    this.serverNowUtc,
    this.serverObservedAtUtc,
    this.promoCode,
    required this.accentColor,
    required this.onAccentColor,
    this.bottomRadius = Spacing.offersDealCardRadius,
  });

  final DateTime? endsAt;
  final DateTime? serverNowUtc;
  final DateTime? serverObservedAtUtc;
  final String? promoCode;
  final Color accentColor;
  final Color onAccentColor;
  final double bottomRadius;

  @override
  State<OfferDealCountdownBar> createState() => _OfferDealCountdownBarState();
}

class _OfferDealCountdownBarState extends State<OfferDealCountdownBar> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _calculateRemaining();
    if (_remaining > Duration.zero) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant OfferDealCountdownBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endsAt != widget.endsAt ||
        oldWidget.serverNowUtc != widget.serverNowUtc ||
        oldWidget.serverObservedAtUtc != widget.serverObservedAtUtc) {
      _timer?.cancel();
      _remaining = _calculateRemaining();
      if (_remaining > Duration.zero) {
        _startTimer();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  DateTime get _currentServerTime {
    final observed = widget.serverObservedAtUtc;
    if (widget.serverNowUtc == null || observed == null) {
      return DateTime.now().toUtc();
    }
    return widget.serverNowUtc!.add(
      DateTime.now().toUtc().difference(observed),
    );
  }

  Duration _calculateRemaining() {
    if (widget.endsAt == null) return Duration.zero;
    final diff = widget.endsAt!.difference(_currentServerTime);
    return diff.isNegative ? Duration.zero : diff;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        _timer?.cancel();
        setState(() {
          _remaining = Duration.zero;
        });
      } else {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      }
    });
  }

  String _formatDuration(Duration d, BuildContext context) {
    if (d.inDays >= 1) {
      final totalSeconds = (d.inMilliseconds / 1000).ceil();
      final totalMinutes = (totalSeconds / 60).ceil();
      final days = totalMinutes ~/ (24 * 60);
      final hours = (totalMinutes % (24 * 60)) ~/ 60;
      final hoursStr = hours.toString().padLeft(2, '0');
      final lang = Localizations.localeOf(context).languageCode;
      if (lang == 'ar') {
        return hours > 0 ? '$days يوم : $hoursStr س' : '$days يوم';
      }
      return hours > 0 ? '$days days : ${hoursStr}h' : '$days days';
    }

    final totalSeconds = (d.inMilliseconds / 1000).ceil();
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    final hasTimer = _remaining > Duration.zero;
    final hasPromo = widget.promoCode != null && widget.promoCode!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: widget.accentColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(widget.bottomRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hasTimer
                    ? Icons.access_time_rounded
                    : (hasPromo
                        ? Icons.confirmation_number_outlined
                        : Icons.access_time_rounded),
                size: Spacing.iconXs,
                color: widget.onAccentColor.withValues(alpha: 0.9),
              ),
              const SizedBox(width: Spacing.xxs),
              Flexible(
                child: Text(
                  hasTimer
                      ? locale.offers_countdown_label
                      : (hasPromo
                          ? locale.offers_coupon_highlight
                          : locale.offers_countdown_label),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: widget.onAccentColor.withValues(alpha: 0.95),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            hasTimer
                ? _formatDuration(_remaining, context)
                : (hasPromo ? widget.promoCode! : '00:00:00'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: widget.onAccentColor,
            ),
          ),
        ],
      ),
    );
  }
}
