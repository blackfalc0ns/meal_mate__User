import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance.dart';

class SubscriptionBillingManagementSection extends StatelessWidget {
  const SubscriptionBillingManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isArabic = locale.localeName == 'ar';

    return BlocSelector<
      SubscriptionBillingViewModel,
      SubscriptionBillingState,
      ({
        bool hasSubscription,
        SubscriptionBillingFreezePolicyEntity? freezePolicy,
      })
    >(
      selector: (state) => (
        hasSubscription: state.billing.data?.current.subscription != null,
        freezePolicy: state.billing.data?.freezePolicy,
      ),
      builder: (context, data) {
        if (!data.hasSubscription) {
          return const SizedBox.shrink();
        }

        final policy = data.freezePolicy;
        final freezeMessage = isArabic
            ? (policy?.messageAr.trim().isNotEmpty == true
                  ? policy!.messageAr
                  : policy?.messageEn)
            : (policy?.messageEn.trim().isNotEmpty == true
                  ? policy!.messageEn
                  : policy?.messageAr);

        return SubscriptionBillingEntrance(
          sectionKey: 'manage_footer',
          delay: const Duration(milliseconds: 200),
          child: Column(
            children: [
              const SizedBox(height: Spacing.md),
              CustomWarningWidget(
                icon: Icons.info_rounded,
                message: (freezeMessage?.isEmpty ?? true)
                    ? locale.billing_notice
                    : freezeMessage!,
                isWarning: true,
                height: Spacing.profileBillingNoticeHeight,
                backgroundColor: color.secondary.withValues(alpha: 0.06),
                borderColor: color.secondary.withValues(alpha: 0.25),
                horizontalPadding: Spacing.sm,
                iconTextSpacing: Spacing.sm,
                borderRadius: Spacing.radiusMd,
                messageFontSize: FontSize.size11,
                maxMessageLines: 3,
              ),
              const SizedBox(height: Spacing.lg),
              SizedBox(
                width: double.infinity,
                height: Spacing.profileBillingButtonHeight,
                child: AppButton(
                  text: locale.billing_manage_subscription,
                  onPressed: () =>
                      context.pushNamed(AppRoutes.familySubscriptionSettings),
                  height: Spacing.profileBillingButtonHeight,
                  borderRadius: Spacing.radiusPill,
                  color: color.primary,
                  textColor: color.onPrimary,
                  fontSize: FontSize.size12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
