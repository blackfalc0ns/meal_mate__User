import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_button.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_hold_clock.dart';

class PaymentHoldNotice extends StatefulWidget {
  const PaymentHoldNotice({
    super.key,
    required this.clock,
    this.onRenew,
    this.isRenewing = false,
    this.onExpired,
    this.onCancel,
    this.isFullScreen = false,
  });

  final PaymentHoldClock clock;
  final VoidCallback? onRenew;
  final bool isRenewing;
  final VoidCallback? onExpired;
  final VoidCallback? onCancel;
  final bool isFullScreen;

  @override
  State<PaymentHoldNotice> createState() => _PaymentHoldNoticeState();
}

class _PaymentHoldNoticeState extends State<PaymentHoldNotice> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        if (widget.clock.isExpired) {
          _timer?.cancel();
          widget.onExpired?.call();
        }
        setState(() {});
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
    final isExpired = widget.clock.isExpired;

    if (widget.isFullScreen || isExpired) {
      return _buildFullScreenView(color, locale);
    }

    return _buildBottomBarNotice(color, locale);
  }

  Widget _buildFullScreenView(ColorScheme color, dynamic locale) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
        child: Column(
          children: [
            const Spacer(flex: 3),
            Lottie.asset(
              Assets.hourglassAnimation,
              width: 140,
              height: 140,
              repeat: true,
            ),
            const SizedBox(height: Spacing.xl),
            Text(
              locale.payment_hold_expired,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size18,
                color: color.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
              child: Text(
                locale.payment_hold_expired_desc,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurfaceVariant,
                ).copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 4),
            if (widget.onRenew != null) ...[
              CustomAppButton(
                text: locale.payment_hold_renew,
                isLoading: widget.isRenewing,
                onPressed: widget.isRenewing ? null : widget.onRenew,
              ),
            ],
            if (widget.onCancel != null) ...[
              const SizedBox(height: Spacing.sm),
              TextButton(
                onPressed: widget.isRenewing ? null : widget.onCancel,
                style: TextButton.styleFrom(
                  foregroundColor: color.onSurfaceVariant,
                ),
                child: Text(
                  locale.payment_hold_return_to_summary,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            const SizedBox(height: Spacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarNotice(ColorScheme color, dynamic locale) {
    final remaining = widget.clock.remaining;
    final seconds = (remaining.inMilliseconds / 1000).ceil();
    final time =
        '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        border: Border(
          top: BorderSide(
            color: color.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_rounded,
              size: Spacing.iconSm,
              color: color.primary,
            ),
            const SizedBox(width: Spacing.xs),
            Text(
              locale.payment_hold_remaining(time),
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
