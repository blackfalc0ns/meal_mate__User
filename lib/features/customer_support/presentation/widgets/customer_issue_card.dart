import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';

class CustomerIssueCard extends StatelessWidget {
  const CustomerIssueCard({
    super.key,
    required this.issue,
    required this.onTap,
  });

  final CustomerIssueEntity issue;
  final VoidCallback onTap;

  (String label, Color color, IconData icon) _resolveStatus(
    BuildContext context,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;
    final rawStatus = issue.status.toLowerCase().trim();

    if (rawStatus.contains('resolved') ||
        rawStatus.contains('تم') ||
        rawStatus.contains('محلول')) {
      return (
        locale.customer_support_status_resolved,
        color.primary,
        Icons.check_circle_rounded,
      );
    }
    if (rawStatus.contains('inprogress') ||
        rawStatus.contains('in_progress') ||
        rawStatus.contains('pending') ||
        rawStatus.contains('معالجة')) {
      return (
        locale.customer_support_status_in_progress,
        color.tertiary,
        Icons.hourglass_top_rounded,
      );
    }
    if (rawStatus.contains('closed') || rawStatus.contains('مغلق')) {
      return (
        locale.customer_support_status_closed,
        color.outline,
        Icons.lock_outline_rounded,
      );
    }
    if (rawStatus.contains('cancel') ||
        rawStatus.contains('reject') ||
        rawStatus.contains('ملغ')) {
      return (
        locale.customer_support_status_cancelled,
        color.error,
        Icons.cancel_outlined,
      );
    }
    if (rawStatus.contains('open') ||
        rawStatus.contains('new') ||
        rawStatus.contains('جديد')) {
      return (
        locale.customer_support_status_open,
        color.secondary,
        Icons.mark_chat_unread_outlined,
      );
    }

    return (issue.status, color.tertiary, Icons.info_outline_rounded);
  }

  (String label, IconData icon) _resolveCategory(BuildContext context) {
    final locale = context.localization;
    final typeCode = issue.typeCode?.toLowerCase().trim() ?? '';

    if (typeCode.contains('account')) {
      return (
        locale.customer_support_category_account,
        Icons.person_outline_rounded,
      );
    }
    if (typeCode.contains('wrongitem')) {
      return (
        locale.customer_support_category_wrong_items,
        Icons.takeout_dining_outlined,
      );
    }
    if (typeCode.contains('foodquality') || typeCode.contains('quality')) {
      return (
        locale.customer_support_category_food_quality,
        Icons.restaurant_rounded,
      );
    }
    if (typeCode.contains('latedelivery') || typeCode.contains('delay')) {
      return (
        locale.customer_support_category_late_delivery,
        Icons.schedule_rounded,
      );
    }
    if (typeCode.contains('packaging')) {
      return (
        locale.customer_support_category_packaging,
        Icons.inventory_2_outlined,
      );
    }
    if (typeCode.contains('missingitem')) {
      return (
        locale.customer_support_category_missing_items,
        Icons.remove_shopping_cart_outlined,
      );
    }

    return (
      locale.customer_support_category_other,
      Icons.support_agent_rounded,
    );
  }

  String? _formatDate(BuildContext context, String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;
    final parsed = DateTime.tryParse(rawDate)?.toLocal();
    if (parsed == null) return null;
    final locale = context.localization;
    return intl.DateFormat(
      'd MMMM yyyy • hh:mm a',
      locale.localeName,
    ).format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final (statusLabel, statusColor, statusIcon) = _resolveStatus(context);
    final (categoryLabel, categoryIcon) = _resolveCategory(context);
    final formattedDate = _formatDate(context, issue.createdAtUtc);

    final subjectText = issue.subject?.trim().isNotEmpty == true
        ? issue.subject!
        : categoryLabel;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: Spacing.md,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Avatar Circle + Title & Category + Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Spacing.avatarSm,
                      height: Spacing.avatarSm,
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        categoryIcon,
                        size: Spacing.iconSm,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subjectText,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size13,
                              color: color.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: Spacing.xxs),
                          Text(
                            categoryLabel,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Spacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: Spacing.iconXs,
                            color: statusColor,
                          ),
                          const SizedBox(width: Spacing.xxs),
                          Text(
                            statusLabel,
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Spacing.sm),

                // 2. Metadata: Ticket ID badge (LTR isolated) & Date
                Row(
                  children: [
                    if (formattedDate != null) ...[
                      const SizedBox(width: Spacing.sm),
                      Icon(
                        Icons.access_time_rounded,
                        size: Spacing.iconXs,
                        color: color.onSurfaceVariant,
                      ),
                      const SizedBox(width: Spacing.xxs),
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: Spacing.sm),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: color.outlineVariant.withValues(alpha: 0.35),
                ),
                const SizedBox(height: Spacing.sm),

                // 3. Footer: View details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.customer_support_view_details,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.primary,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: Spacing.iconXs,
                      color: color.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
