import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AuthOtpCountdown extends StatefulWidget {
  const AuthOtpCountdown({
    super.key,
    required this.retryAvailableAtUtc,
    required this.onResend,
    required this.isResending,
    this.now = DateTime.now,
  });

  final DateTime retryAvailableAtUtc;
  final VoidCallback onResend;
  final bool isResending;
  final DateTime Function() now;

  @override
  State<AuthOtpCountdown> createState() => _AuthOtpCountdownState();
}

class _AuthOtpCountdownState extends State<AuthOtpCountdown> {
  Timer? _timer;
  late int _secondsLeft;

  @override
  void initState() {
    super.initState();
    _secondsLeft = _calculateRemainingSeconds();
    _initTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant AuthOtpCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.retryAvailableAtUtc != widget.retryAvailableAtUtc) {
      _timer?.cancel();
      _secondsLeft = _calculateRemainingSeconds();
      _initTimerIfNeeded();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _calculateRemainingSeconds() {
    final nowUtc = widget.now().toUtc();
    final diff = widget.retryAvailableAtUtc.toUtc().difference(nowUtc).inSeconds;
    return diff > 0 ? diff : 0;
  }

  void _initTimerIfNeeded() {
    if (_secondsLeft <= 0) {
      return;
    }
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final remaining = _calculateRemainingSeconds();
      if (remaining <= 0) {
        timer.cancel();
        if (_secondsLeft != 0) {
          setState(() {
            _secondsLeft = 0;
          });
        }
      } else if (remaining != _secondsLeft) {
        setState(() {
          _secondsLeft = remaining;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final canResend = _secondsLeft == 0 && !widget.isResending;

    final text = canResend
        ? locale.auth_resend_code
        : '${locale.auth_resend_code_in} $_secondsLeft ${locale.auth_seconds_label}';

    final textColor = canResend
        ? color.primary
        : color.onSurfaceVariant;

    return Center(
      child: GestureDetector(
        onTap: canResend ? widget.onResend : null,
        child: Text(
          text,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
