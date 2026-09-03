import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_freeze_date_column.dart';

class ProfileBillingActiveFreezeCard extends StatelessWidget {
  const ProfileBillingActiveFreezeCard({super.key, required this.activeFreeze});

  final ProfileBillingActiveFreezeEntity activeFreeze;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dateFormatter = intl.DateFormat.yMMMd(locale.localeName);
    final startDate = _formatDate(activeFreeze.startDate, dateFormatter);
    final endDate = _formatDate(activeFreeze.endDate, dateFormatter);
    final endDateText = _formatDate(
      activeFreeze.subscriptionEndDate,
      dateFormatter,
    );
    final statusText = activeFreeze.statusNameAr.isNotEmpty
        ? activeFreeze.statusNameAr
        : activeFreeze.status;
    final summary = Directionality.of(context) == TextDirection.rtl
        ? activeFreeze.summaryAr
        : activeFreeze.summaryEn;

    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: color.primary.withValues(alpha: 0.22),
          width: Spacing.border,
        ),
      ),
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: Spacing.iconXl,
                height: Spacing.iconXl,
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.ac_unit_rounded,
                  size: Spacing.iconMd,
                  color: color.primary,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.billing_pending_freeze_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      locale.billing_pending_freeze_days(
                        activeFreeze.freezeDays,
                      ),
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (statusText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Text(
                    statusText,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
              border: Border.all(
                color: color.outlineVariant.withValues(alpha: 0.3),
                width: Spacing.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ProfileBillingFreezeDateColumn(
                    label: locale.billing_pending_freeze_start_date,
                    value: startDate,
                  ),
                ),
                Container(
                  width: Spacing.border,
                  height: Spacing.iconXl,
                  color: color.outlineVariant.withValues(alpha: 0.5),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: ProfileBillingFreezeDateColumn(
                    label: locale.billing_pending_freeze_end_date,
                    value: endDate,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.billing_active_freeze_service_days(
              activeFreeze.frozenServiceDaysCount,
            ),
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.billing_active_freeze_compensation_days(
              activeFreeze.compensationDates.length,
            ),
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurface,
            ),
          ),
          if (activeFreeze.compensationDates.isNotEmpty) ...[
            const SizedBox(height: Spacing.xs),
            Text(
              locale.billing_active_freeze_compensation_dates,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Wrap(
              spacing: Spacing.xs,
              runSpacing: Spacing.xs,
              children: activeFreeze.compensationDates
                  .map(
                    (date) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      child: Text(
                        _formatDate(date, dateFormatter),
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.primary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (endDateText.isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              locale.billing_active_freeze_new_end_date(endDateText),
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurface,
              ),
            ),
          ],
          if (summary.trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              summary.trim(),
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ).copyWith(height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String date, intl.DateFormat formatter) {
    final parsedDate = DateTime.tryParse(date);
    return parsedDate == null ? date : formatter.format(parsedDate);
  }
}
