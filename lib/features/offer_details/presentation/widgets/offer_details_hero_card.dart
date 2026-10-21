import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_data.dart';

class OfferDetailsHeroCard extends StatefulWidget {
  const OfferDetailsHeroCard({
    super.key,
    required this.details,
    this.onExpired,
  });

  final OfferDetailsData details;
  final VoidCallback? onExpired;

  @override
  State<OfferDetailsHeroCard> createState() => _OfferDetailsHeroCardState();
}

class _OfferDetailsHeroCardState extends State<OfferDetailsHeroCard> {
  Timer? _timer;
  final Stopwatch _elapsed = Stopwatch();
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _elapsed.start();
    _computeRemaining();
    if (widget.details.endsAt != null) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant OfferDetailsHeroCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.details.endsAt != widget.details.endsAt ||
        oldWidget.details.serverNowUtc != widget.details.serverNowUtc) {
      _elapsed.reset();
      _computeRemaining();
      if (_timer == null && widget.details.endsAt != null) {
        _startTimer();
      }
    }
  }

  void _computeRemaining() {
    final endsAt = widget.details.endsAt;
    if (endsAt == null) return;

    final now = widget.details.serverNowUtc?.add(_elapsed.elapsed) ??
        DateTime.now().toUtc();
    final diff = endsAt.difference(now);
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
        _timer = null;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimerText() {
    if (_remaining == Duration.zero) {
      return '00 : 00 : 00';
    }
    final days = _remaining.inDays;
    final hours = (_remaining.inHours % 24).toString().padLeft(2, '0');
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    if (days > 0) {
      final daysStr = days.toString().padLeft(2, '0');
      return '$daysStr : $hours : $minutes';
    }
    return '$hours : $minutes : $seconds';
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final discountRate = widget.details.discountRate;
    final discountStr = widget.details.discountText ??
        (discountRate != null
            ? '${(discountRate * 100).round()}%'
            : '20%');

    final offerHeading = widget.details.offerHeading ??
        locale.offer_details_hero_heading;
    final offerSubtitle = widget.details.offerSubtitle ??
        locale.offer_details_hero_subtitle;

    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Spacing.offerDetailsHeroRadius),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.35),
          width: Spacing.border,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Meal Plate Visual (End side in layout)
              Expanded(
                flex: 4,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.radiusXl),
                    child: SizedBox(
                      width: 130,
                      height: 130,
                      child: widget.details.heroImageUrl != null &&
                              widget.details.heroImageUrl!.startsWith('http')
                          ? Image.network(
                              widget.details.heroImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Image.asset(
                                'assets/images/meal_details/figma/meal_details_hero.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/meal_details/figma/meal_details_hero.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              // Content side
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured Badge
                    if (widget.details.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: color.secondary,
                          borderRadius: BorderRadius.circular(Spacing.radiusPill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: color.onSecondary,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              locale.offer_details_featured_badge,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: color.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: Spacing.xs),

                    // Discount & Title
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$discountStr ',
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size18,
                              color: color.secondary,
                            ),
                          ),
                          TextSpan(
                            text: offerHeading.replaceAll(RegExp(r'\d+%.*'), '').trim(),
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size16,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Subtitle
                    Text(
                      offerSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),

                    // Countdown Timer Pill
                    if (widget.details.endsAt != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: color.surface,
                          borderRadius:
                              BorderRadius.circular(Spacing.radiusPill),
                          border: Border.all(
                            color: color.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 13,
                              color: color.primary,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              '${locale.offer_details_hero_timer_label} : ${_formatTimerText()}',
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: color.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: Spacing.xs),

                    // Active Code Button/Pill
                    if (widget.details.isCodeActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: color.primary,
                          borderRadius:
                              BorderRadius.circular(Spacing.radiusPill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_offer_rounded,
                              size: 13,
                              color: color.onPrimary,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              locale.offer_details_active_code_badge,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: color.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.base),

          // Bottom 3 Feature Pills
          Row(
            children: [
              Expanded(
                child: _buildBottomPill(
                  context: context,
                  icon: Icons.calendar_today_rounded,
                  text: locale.offer_details_pill_every_month,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: _buildBottomPill(
                  context: context,
                  icon: Icons.track_changes_rounded,
                  text: locale.offer_details_pill_goals,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: _buildBottomPill(
                  context: context,
                  icon: Icons.eco_rounded,
                  text: locale.offer_details_pill_integrated_plans,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPill({
    required BuildContext context,
    required IconData icon,
    required String text,
  }) {
    final color = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusPill),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 12, color: color.primary),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
