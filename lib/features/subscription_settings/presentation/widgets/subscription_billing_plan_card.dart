import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_action.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';

class SubscriptionBillingPlanCard extends StatelessWidget {
  const SubscriptionBillingPlanCard({
    required this.subscription,
    this.isActionLoading = false,
    this.onRenew,
    this.onFreeze,
    this.onCancel,
    super.key,
  });

  final SubscriptionBillingSubscriptionEntity subscription;
  final bool isActionLoading;
  final VoidCallback? onRenew;
  final VoidCallback? onFreeze;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isArabic = locale.localeName == 'ar';
    final dateFormatter = intl.DateFormat.yMMMd(locale.localeName);
    final nextRenewalDate = DateTime.tryParse(subscription.nextRenewalDate);
    final renewalDateText = nextRenewalDate == null
        ? subscription.nextRenewalDate
        : dateFormatter.format(nextRenewalDate);
    final progressValue = (subscription.progressPercentage / 100)
        .clamp(0, 1)
        .toDouble();
    final bundleName = isArabic
        ? subscription.bundleNameAr
        : subscription.bundleNameEn;
    final tierName = isArabic
        ? subscription.tierNameAr
        : subscription.tierNameEn;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.primaryContainer.withValues(alpha: 0.35),
            color.secondaryContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(Spacing.radiusXl),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Spacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top section: Details column (Start) + Bottle illustration (End)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Assets.logo,
                          width: Spacing.iconMd,
                          height: Spacing.iconMd,
                        ),
                        const SizedBox(width: Spacing.xs),

                        Expanded(
                          child: Text(
                            bundleName.isEmpty
                                ? locale.billing_plan_name
                                : bundleName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size16,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xss),
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.profileBillingUpgradeTier,
                          width: Spacing.sm,
                          height: Spacing.sm,
                          colorFilter: ColorFilter.mode(
                            color.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: Spacing.xss),
                        Flexible(
                          child: Text(
                            tierName.isEmpty
                                ? locale.billing_plan_tier
                                : tierName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xs,
                        vertical: Spacing.xss,
                      ),
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            Assets.profileBillingCheck,
                            width: Spacing.sm,
                            height: Spacing.sm,
                          ),
                          const SizedBox(width: Spacing.xss),
                          Text(
                            isArabic
                                ? (subscription.statusNameAr.isNotEmpty
                                      ? subscription.statusNameAr
                                      : (subscription.status.toLowerCase() ==
                                                'active'
                                            ? locale.billing_active
                                            : subscription.status))
                                : (subscription.status.toLowerCase() == 'active'
                                      ? locale.billing_active
                                      : (subscription.status.isNotEmpty
                                            ? subscription.status
                                            : locale.billing_active)),
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.profileBillingCalendar,
                          width: Spacing.sm,
                          height: Spacing.sm,
                          colorFilter: ColorFilter.mode(
                            color.onSurfaceVariant,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: Spacing.xss),
                        Expanded(
                          child: Text(
                            locale.billing_renewal_date_value(renewalDateText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xss),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: isArabic ? 'متبقي ' : 'Remaining ',
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text: '${subscription.remainingServiceDays}',
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.primary,
                            ),
                          ),
                          TextSpan(
                            text: isArabic ? ' أيام' : ' days',
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                flex: 45,
                child: Image.asset(
                  Assets.profileBillingPlanBottle,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.base),
          // Middle section: Usage Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.billing_plan_usage,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurfaceVariant,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: subscription.completedServiceDays.toString(),
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.primary,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ${locale.billing_plan_usage_remaining_value(subscription.totalServiceDays)}',
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: Spacing.xss * 1.5,
              color: color.primary,
              backgroundColor: color.primary.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: Spacing.base),
          // Bottom section: 4 Action buttons
          Row(
            children: [
              Expanded(
                child: SubscriptionBillingAction(
                  iconAsset: Assets.profileBillingUpgradeTier,
                  label: locale.billing_upgrade_tier,
                  actionColor: const Color(0xFF2563EB),
                  onTap: () async {
                    if (isActionLoading) {
                      return;
                    }
                    if (!subscription.actions.canUpgrade &&
                        subscription
                            .actions
                            .upgradeUnavailableReason
                            .isNotEmpty) {
                      final rawReason =
                          subscription.actions.upgradeUnavailableReason;
                      final mapped = mapFailureMessage(context, rawReason);
                      final message = (mapped != rawReason)
                          ? mapped
                          : switch (rawReason) {
                              'upgrade_not_available_for_status' =>
                                'الترقية متاحة فقط للاشتراكات النشطة (Active).',
                              'already_elite' =>
                                'أنت مشترك بالفعل في أعلى تصنيف متاح.',
                              'upgrade_request_pending' =>
                                'يوجد طلب ترقية معلق قيد المتابعة حالياً.',
                              'upgrade_no_remaining_days' =>
                                'لا توجد أيام متبقية في الاشتراك لإجراء الترقية.',
                              'pricing.unavailable' =>
                                'خدمة التسعير غير متوفرة حالياً.',
                              _ => rawReason,
                            };
                      CustomSnackbar.showWarning(
                        context: context,
                        message: message,
                      );
                      return;
                    }
                    await context.pushNamed(
                      AppRoutes.restaurantTierUpgrade,
                      arguments: RestaurantTierUpgradeArgs(
                        subscriptionId: subscription.subscriptionId,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: SubscriptionBillingAction(
                  iconAsset: Assets.profileBillingFreeze,
                  label: locale.billing_freeze,
                  actionColor: const Color(0xFFE67E22),
                  onTap: () {
                    if (isActionLoading) {
                      return;
                    }
                    if (!subscription.actions.canFreeze &&
                        subscription.pendingFreeze == null &&
                        subscription.activeFreeze == null) {
                      final reason =
                          subscription.actions.freezeUnavailableReason;
                      final message = (reason.isNotEmpty && reason != 'unknown')
                          ? mapFailureMessage(context, reason)
                          : locale.billing_action_unavailable;
                      CustomSnackbar.showWarning(
                        context: context,
                        message: message,
                      );
                      return;
                    }
                    onFreeze?.call();
                  },
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: SubscriptionBillingAction(
                  iconAsset: Assets.profileBillingRenew,
                  label: locale.billing_renew,
                  actionColor: color.primary,
                  onTap: () {
                    if (isActionLoading) {
                      return;
                    }
                    if (!subscription.actions.canRenew) {
                      final reason =
                          subscription.actions.renewUnavailableReason;
                      final message = (reason.isNotEmpty && reason != 'unknown')
                          ? mapFailureMessage(context, reason)
                          : locale.billing_action_unavailable;
                      CustomSnackbar.showWarning(
                        context: context,
                        message: message,
                      );
                      return;
                    }
                    onRenew?.call();
                  },
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: SubscriptionBillingAction(
                  iconAsset: Assets.profileBillingCancel,
                  label: locale.billing_cancel,
                  actionColor: const Color(0xFFEF4444),
                  onTap: () {
                    if (isActionLoading) {
                      return;
                    }
                    if (!subscription.actions.canCancel) {
                      final reason =
                          subscription.actions.cancelUnavailableReason;
                      final message = (reason.isNotEmpty && reason != 'unknown')
                          ? mapFailureMessage(context, reason)
                          : locale.billing_action_unavailable;
                      CustomSnackbar.showWarning(
                        context: context,
                        message: message,
                      );
                      return;
                    }
                    onCancel?.call();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
