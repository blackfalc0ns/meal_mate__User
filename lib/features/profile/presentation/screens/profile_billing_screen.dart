import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_invoice_history_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_loading_skeleton.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_payment_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_plan_card.dart';

class ProfileBillingScreen extends StatelessWidget {
  const ProfileBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<ProfileViewModel>(
      create: (_) =>
          getIt<ProfileViewModel>()..doIntent(const GetProfileBillingEvent()),
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          title: locale.profile_billing,
          titleFontSize: FontSize.size17,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: BlocBuilder<ProfileViewModel, ProfileState>(
          buildWhen: (previous, current) => previous.billing != current.billing,
          builder: (context, state) {
            final billingState = state.billing;
            final billing = billingState.data;

            if (billingState.isLoading && billing == null) {
              return const ProfileBillingLoadingSkeleton();
            }

            if (billingState.failure != null && billing == null) {
              return ApiErrorWidget(
                exception: billingState.failure!.exception,
                onRetry: () => context.read<ProfileViewModel>().doIntent(
                  const GetProfileBillingEvent(),
                ),
              );
            }

            final subscription = billing?.current.subscription;
            final paymentMethod = billing?.paymentMethod;
            final freezePolicy = billing?.freezePolicy;
            final freezeMessage = locale.localeName == 'ar'
                ? freezePolicy?.messageAr
                : freezePolicy?.messageEn;

            return SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                  vertical: Spacing.md,
                ),
                child: Column(
                  children: [
                    if (subscription == null)
                      EmptyStateWidget(
                        title: locale.billing_no_subscription_title,
                        description: locale.billing_no_subscription_description,
                        icon: Icons.receipt_long_rounded,
                      )
                    else
                      ProfileBillingPlanCard(subscription: subscription),
                    if (paymentMethod != null &&
                        paymentMethod.hasSavedMethod) ...[
                      const SizedBox(height: Spacing.md),
                      ProfileBillingPaymentCard(paymentMethod: paymentMethod),
                    ],
                    const SizedBox(height: Spacing.md),
                    ProfileBillingInvoiceHistoryCard(
                      invoices: billing?.invoices ?? const [],
                    ),
                    const SizedBox(height: Spacing.md),
                    CustomWarningWidget(
                      icon: Icons.info_rounded,
                      message: freezeMessage?.isEmpty ?? true
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
                        onPressed: subscription == null
                            ? null
                            : () => context.pushNamed(
                                AppRoutes.familySubscriptionSettings,
                              ),
                        height: Spacing.profileBillingButtonHeight,
                        borderRadius: Spacing.radiusPill,
                        color: color.primary,
                        textColor: color.onPrimary,
                        fontSize: FontSize.size12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
