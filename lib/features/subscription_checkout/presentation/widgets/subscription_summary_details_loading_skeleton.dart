import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

/// Full-widget shimmer loading skeleton that precisely mirrors the layout,
/// containers, borders, and visual hierarchy of [SubscriptionSummaryDetailsCard]
/// without rendering static text or solid icons.
class SubscriptionSummaryDetailsLoadingSkeleton extends StatelessWidget {
  const SubscriptionSummaryDetailsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.subscription_summary_title,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Spacing.subscriptionSummaryDetailsWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Plan Summary Card Skeleton ──
            _buildCard(
              color: color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildPlaceholderRect(
                        color: color,
                        width: Spacing.avatarSm,
                        height: Spacing.avatarSm,
                        borderRadius: Spacing.radiusSm,
                      ),
                      const SizedBox(width: Spacing.sm),
                      _buildPlaceholderRect(
                        color: color,
                        width: 140,
                        height: 18,
                        borderRadius: Spacing.radiusXs,
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTileSkeleton(
                          color: color,
                          labelWidth: 50,
                          valueWidth: 70,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: _buildTileSkeleton(
                          color: color,
                          labelWidth: 45,
                          valueWidth: 80,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                  _buildTileSkeleton(
                    color: color,
                    labelWidth: 65,
                    valueWidth: 95,
                  ),
                  const SizedBox(height: Spacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.md,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color.outlineVariant,
                        width: Spacing.border,
                      ),
                      borderRadius: BorderRadius.circular(Spacing.radiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildPlaceholderRect(
                              color: color,
                              width: Spacing.avatarSm,
                              height: Spacing.avatarSm,
                              borderRadius: Spacing.radiusSm,
                            ),
                            const SizedBox(width: Spacing.sm),
                            _buildPlaceholderRect(
                              color: color,
                              width: 70,
                              height: 14,
                              borderRadius: Spacing.radiusXs,
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.md),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeatureSkeleton(color: color, labelWidth: 42),
                            _buildDivider(color),
                            _buildFeatureSkeleton(color: color, labelWidth: 46),
                            _buildDivider(color),
                            _buildFeatureSkeleton(color: color, labelWidth: 40),
                            _buildDivider(color),
                            _buildFeatureSkeleton(color: color, labelWidth: 44),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),

            // ── 2. Participating Restaurants Card Skeleton ──
            _buildCard(
              color: color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildPlaceholderRect(
                        color: color,
                        width: Spacing.avatarSm,
                        height: Spacing.avatarSm,
                        borderRadius: Spacing.radiusSm,
                      ),
                      const SizedBox(width: Spacing.sm),
                      _buildPlaceholderRect(
                        color: color,
                        width: 130,
                        height: 14,
                        borderRadius: Spacing.radiusXs,
                      ),
                      const Spacer(),
                      _buildPlaceholderRect(
                        color: color,
                        width: 65,
                        height: 24,
                        borderRadius: Spacing.radiusPill,
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.base),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (_) => _buildPlaceholderCircle(
                        color: color,
                        size: Spacing.avatarMd,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),

            // ── 3. Total Price Card Skeleton ──
            _buildCard(
              color: color,
              child: Row(
                children: [
                  _buildPlaceholderRect(
                    color: color,
                    width: Spacing.avatarSm,
                    height: Spacing.avatarSm,
                    borderRadius: Spacing.radiusSm,
                  ),
                  const SizedBox(width: Spacing.md),
                  _buildPlaceholderRect(
                    color: color,
                    width: 85,
                    height: 14,
                    borderRadius: Spacing.radiusXs,
                  ),
                  const Spacer(),
                  _buildPlaceholderRect(
                    color: color,
                    width: 90,
                    height: 26,
                    borderRadius: Spacing.radiusSm,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),

            // ── 4. Dates Row Skeleton ──
            Row(
              children: [
                Expanded(
                  child: _buildDateCardSkeleton(
                    color: color,
                    isEditable: false,
                  ),
                ),
                const SizedBox(width: Spacing.xss),
                Expanded(
                  child: _buildDateCardSkeleton(color: color, isEditable: true),
                ),
                const SizedBox(width: Spacing.xss),
                Expanded(
                  child: _buildDateCardSkeleton(
                    color: color,
                    isEditable: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required ColorScheme color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: child,
    );
  }

  Widget _buildTileSkeleton({
    required ColorScheme color,
    required double labelWidth,
    required double valueWidth,
  }) {
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant, width: Spacing.border),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Row(
        children: [
          _buildPlaceholderRect(
            color: color,
            width: Spacing.avatarSm,
            height: Spacing.avatarSm,
            borderRadius: Spacing.radiusSm,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPlaceholderRect(
                  color: color,
                  width: labelWidth,
                  height: 11,
                  borderRadius: Spacing.radiusXs,
                ),
                const SizedBox(height: Spacing.xs),
                _buildPlaceholderRect(
                  color: color,
                  width: valueWidth,
                  height: 14,
                  borderRadius: Spacing.radiusXs,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSkeleton({
    required ColorScheme color,
    required double labelWidth,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPlaceholderRect(
            color: color,
            width: 24,
            height: 24,
            borderRadius: Spacing.radiusXs,
          ),
          const SizedBox(height: Spacing.xs),
          _buildPlaceholderRect(
            color: color,
            width: labelWidth,
            height: 10,
            borderRadius: Spacing.radiusXs,
          ),
          const SizedBox(height: Spacing.xxs),
          _buildPlaceholderRect(
            color: color,
            width: labelWidth * 0.75,
            height: 8,
            borderRadius: Spacing.radiusXs,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme color) {
    return Container(
      width: Spacing.border,
      height: Spacing.xxl,
      color: color.outlineVariant,
    );
  }

  Widget _buildDateCardSkeleton({
    required ColorScheme color,
    required bool isEditable,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xss,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(
          color: isEditable
              ? color.primary.withValues(alpha: 0.45)
              : color.outlineVariant,
          width: Spacing.border,
        ),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _buildPlaceholderRect(
                color: color,
                width: 14,
                height: 14,
                borderRadius: Spacing.radiusXs,
              ),
              const SizedBox(width: Spacing.xxs),
              Expanded(
                child: Center(
                  child: _buildPlaceholderRect(
                    color: color,
                    width: 45,
                    height: 10,
                    borderRadius: Spacing.radiusXs,
                  ),
                ),
              ),
              if (isEditable) ...[
                const SizedBox(width: Spacing.xxs),
                _buildPlaceholderCircle(color: color, size: Spacing.iconSm),
              ],
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Spacing.xxs,
              horizontal: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: _buildPlaceholderRect(
              color: color,
              width: 58,
              height: 12,
              borderRadius: Spacing.radiusXs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderRect({
    required ColorScheme color,
    double? width,
    required double height,
    required double borderRadius,
  }) {
    return ShimmerWidget(
      baseColor: color.surfaceContainerHighest,
      highlightColor: color.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCircle({
    required ColorScheme color,
    required double size,
  }) {
    return ShimmerWidget(
      baseColor: color.surfaceContainerHighest,
      highlightColor: color.surface,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
