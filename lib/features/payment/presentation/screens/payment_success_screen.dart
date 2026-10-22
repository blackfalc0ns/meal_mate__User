import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_next_step_banner.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_payment_confirmed_banner.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_action_buttons.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_hero_header.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_summary_card.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_referral_share_banner.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_top_bar.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_home_usecase.dart';

import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_family_members_row.dart';

/// Screen displayed after a successful subscription payment / activation.
/// Conforms to Figma M-06.08 - Subscription / Success (node 3356:7428).
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key, this.args});

  final PaymentSuccessArgs? args;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  int _selectedMemberIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final resolvedArgs =
        widget.args ??
        PaymentSuccessArgs(
          subscriptionId: '',
          packageName: locale.subscription_healthy_balanced,
          durationDays: 30,
          durationLabel: '30 ${locale.subscription_day}',
          restaurantTier: locale.subscription_summary_restaurant_tier_value,
          paymentDate: DateTime.now().toIso8601String().split('T').first,
          startDate: DateTime.now()
              .add(const Duration(days: 1))
              .toIso8601String()
              .split('T')
              .first,
          endDate: DateTime.now()
              .add(const Duration(days: 31))
              .toIso8601String()
              .split('T')
              .first,
        );

    final hasMembers = resolvedArgs.members.isNotEmpty;
    final activeMember = hasMembers &&
            _selectedMemberIndex < resolvedArgs.members.length
        ? resolvedArgs.members[_selectedMemberIndex]
        : null;
    final cardArgs = activeMember != null
        ? resolvedArgs.forMember(activeMember)
        : resolvedArgs;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
        );
      },
      child: Scaffold(
        backgroundColor: color.surface,
        body: SafeArea(
          child: Column(
            children: [
              SubscriptionSuccessTopBar(
                onNotificationPressed: () {
                  unawaited(
                    Navigator.of(context).pushNamed(AppRoutes.notifications),
                  );
                },
                onClosePressed: () {
                  unawaited(
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                  );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    key: const ValueKey('subscription-success-content'),
                    children: [
                      const SubscriptionSuccessHeroHeader(),
                      if (resolvedArgs.isFamily) ...[
                        if (hasMembers) ...[
                          SubscriptionSuccessFamilyMembersRow(
                            members: resolvedArgs.members,
                            selectedIndex: _selectedMemberIndex,
                            onMemberSelected: (index) {
                              setState(() => _selectedMemberIndex = index);
                            },
                          ),
                          const SizedBox(height: Spacing.xs),
                        ] else ...[
                          FutureBuilder(
                            future: getIt<GetFamilyHomeUseCase>()(),
                            builder: (context, snapshot) {
                              final result = snapshot.data;
                              if (result == null || result is! ApiSuccessResult) {
                                return const SizedBox.shrink();
                              }
                              final data = (result as ApiSuccessResult).data;
                              final apiMembers = data.members;

                              final list = <PaymentSuccessMemberArgs>[
                                PaymentSuccessMemberArgs(
                                  memberId: resolvedArgs.subscriptionId,
                                  displayName: data.name
                                          .replaceAll('عائلة ', '')
                                          .trim()
                                          .isNotEmpty
                                      ? data.name.replaceAll('عائلة ', '').trim()
                                      : 'المدير',
                                  isManager: true,
                                  packageName: resolvedArgs.packageName,
                                  durationDays: resolvedArgs.durationDays,
                                  restaurantTier: resolvedArgs.restaurantTier,
                                  includeFriday: resolvedArgs.includeFriday,
                                  startDate: resolvedArgs.startDate,
                                  endDate: resolvedArgs.endDate,
                                  gender: 1,
                                ),
                                for (int i = 0; i < apiMembers.length; i++)
                                  PaymentSuccessMemberArgs(
                                    memberId: apiMembers[i].memberId,
                                    displayName: apiMembers[i].displayName,
                                    isManager: apiMembers[i].role == 'Manager',
                                    gender: 2,
                                  ),
                              ];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: Spacing.xs),
                                child: SubscriptionSuccessFamilyMembersRow(
                                  members: list,
                                  selectedIndex: _selectedMemberIndex.clamp(
                                    0,
                                    list.length - 1,
                                  ),
                                  onMemberSelected: (index) {
                                    setState(() => _selectedMemberIndex = index);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                      SubscriptionSuccessSummaryCard(args: cardArgs),
                      const SizedBox(height: Spacing.xs),
                      const SubscriptionPaymentConfirmedBanner(),
                      const SizedBox(height: Spacing.xs),
                      const SubscriptionNextStepBanner(),
                      if (resolvedArgs.confirmation?.referralShareCode != null &&
                          resolvedArgs.confirmation!.referralShareCode!.isNotEmpty) ...[
                        const SizedBox(height: Spacing.xs),
                        SubscriptionReferralShareBanner(
                          code: resolvedArgs.confirmation!.referralShareCode!,
                          message: resolvedArgs.confirmation?.referralShareMessage,
                          shareUrl: resolvedArgs.confirmation?.referralShareUrl,
                        ),
                      ],
                      const SizedBox(height: Spacing.sm),
                    ],
                  ).animate().fadeIn(duration: 250.ms),
                ),
              ),
              SubscriptionSuccessActionButtons(
                onStartMeals: () {
                  unawaited(
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                      arguments: AppShellScreen.mealsTabIndex,
                    ),
                  );
                },
                onViewSubscription: () {
                  unawaited(
                    Navigator.of(context).pushNamed(AppRoutes.profileBilling),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
