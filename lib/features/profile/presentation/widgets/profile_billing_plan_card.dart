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
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_action.dart';

class ProfileBillingPlanCard extends StatelessWidget {
  const ProfileBillingPlanCard({
    required this.subscription,
    this.isActionLoading = false,
    this.onRenew,
    this.onFreeze,
    this.onCancel,
    super.key,
  });

  final ProfileBillingSubscriptionEntity subscription;
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
    final restaurantLogoUrl = _absoluteUrl(subscription.restaurant.logoUrl);

    return Container(
      height: Spacing.profileBillingPlanHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.primaryContainer.withValues(alpha: 0.6),
            color.secondaryContainer,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(Spacing.profileBillingCardRadius),
        border: Border.all(color: color.surface),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: Spacing.xxl,
            left: Spacing.xs,
            child: Image.asset(
              Assets.profileBillingPlanBottle,
              width: Spacing.xxxl * 2,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: Spacing.md,
            right: Spacing.sm,
            child: Container(
              width: Spacing.iconMd,
              height: Spacing.iconMd,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(Spacing.radiusXs),
              ),
              child: AppCachedNetworkImage(
                imageUrl: restaurantLogoUrl,
                width: Spacing.iconSm,
                height: Spacing.iconSm,
                fit: BoxFit.contain,
                semanticLabel: locale.profile_billing,
                backgroundColor: color.surface,
                errorWidget: SvgPicture.asset(
                  Assets.logo,
                  width: Spacing.iconSm,
                  height: Spacing.iconSm,
                ),
              ),
            ),
          ),
          Positioned(
            top: Spacing.md,
            left: Spacing.xxxl * 2 + Spacing.md,
            right: Spacing.xxxl + Spacing.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bundleName.isEmpty ? locale.billing_plan_name : bundleName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size15,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xss),
                Text(
                  tierName.isEmpty ? locale.billing_plan_tier : tierName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: Spacing.xss,
                  ),
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      SvgPicture.asset(
                        Assets.profileBillingCheck,
                        width: Spacing.md,
                        height: Spacing.md,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        subscription.statusNameAr.isEmpty
                            ? locale.billing_active
                            : subscription.statusNameAr,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    SvgPicture.asset(
                      Assets.profileBillingCalendar,
                      width: Spacing.iconSm,
                      height: Spacing.iconSm,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        locale.billing_renewal_date_value(renewalDateText),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: Spacing.xl),
                  child: Text(
                    locale.billing_days_remaining_value(
                      subscription.remainingServiceDays,
                    ),
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Spacing.base,
            right: Spacing.base,
            bottom: Spacing.xl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(height: Spacing.xs, color: color.outlineVariant),
                const SizedBox(height: Spacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.billing_plan_usage,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: subscription.completedServiceDays.toString(),
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.primary,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: locale.billing_plan_usage_remaining_value(
                              subscription.totalServiceDays,
                            ),
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: Spacing.xss,
                    color: color.primary,
                    backgroundColor: color.surface,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: ProfileBillingAction(
                        iconAsset: Assets.profileBillingUpgradeTier,
                        label: locale.billing_upgrade_tier,
                        actionColor: color.primary,
                        onTap: () {
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
                            final message = switch (rawReason) {
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
                          context.pushNamed(
                            AppRoutes.restaurantTierUpgrade,
                            arguments: RestaurantTierUpgradeArgs(
                              subscriptionId: subscription.subscriptionId,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: ProfileBillingAction(
                        iconAsset: Assets.profileBillingFreeze,
                        label: locale.billing_freeze,
                        actionColor: color.tertiary,
                        onTap: () {
                          if (isActionLoading) {
                            return;
                          }
                          if (!subscription.actions.canFreeze &&
                              subscription.pendingFreeze == null &&
                              subscription.activeFreeze == null) {
                            CustomSnackbar.showWarning(
                              context: context,
                              message: locale.billing_action_unavailable,
                            );
                            return;
                          }
                          onFreeze?.call();
                        },
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: ProfileBillingAction(
                        iconAsset: Assets.profileBillingRenew,
                        label: locale.billing_renew,
                        actionColor: color.primary,
                        onTap: () {
                          if (isActionLoading) {
                            return;
                          }
                          if (!subscription.actions.canRenew) {
                            CustomSnackbar.showWarning(
                              context: context,
                              message: locale.billing_action_unavailable,
                            );
                            return;
                          }
                          onRenew?.call();
                        },
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: ProfileBillingAction(
                        iconAsset: Assets.profileBillingCancel,
                        label: locale.billing_cancel,
                        actionColor: color.error,
                        onTap: () {
                          if (isActionLoading) {
                            return;
                          }
                          if (!subscription.actions.canCancel) {
                            CustomSnackbar.showWarning(
                              context: context,
                              message: locale.billing_action_unavailable,
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
          ),
        ],
      ),
    );
  }

  String _absoluteUrl(String url) {
    if (url.isEmpty) {
      return '';
    }
    if (url.startsWith('http')) {
      return url;
    }
    return '${NetworkConstants.baseUrl}$url';
  }
}
