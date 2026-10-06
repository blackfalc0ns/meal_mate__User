import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';

class NotificationsLoadingSkeleton extends StatelessWidget {
  const NotificationsLoadingSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: Spacing.xs,
        bottom: Spacing.xxxl,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, index) => const _NotificationCardSkeleton(),
    );
  }
}

class NotificationsLoadMoreSkeleton extends StatelessWidget {
  const NotificationsLoadMoreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NotificationCardSkeleton(),
        ],
      ),
    );
  }
}

class _NotificationCardSkeleton extends StatelessWidget {
  const _NotificationCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.xxs,
      ),
      child: Material(
        color: color.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          side: BorderSide(
            color: color.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerPlaceholder.rect(
                width: Spacing.avatarSm + 4,
                height: Spacing.avatarSm + 4,
                borderRadius: Spacing.radiusSm,
              ),
              SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShimmerPlaceholder.rect(width: 130, height: 12),
                    SizedBox(height: Spacing.xxs),
                    ShimmerPlaceholder.rect(width: 210, height: 10),
                    SizedBox(height: Spacing.xxs),
                    ShimmerPlaceholder.rect(width: 60, height: 9),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
