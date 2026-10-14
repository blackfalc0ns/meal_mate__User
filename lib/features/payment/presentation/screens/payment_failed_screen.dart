import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_failed_args.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/failed/payment_failed_action_buttons.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/failed/payment_failed_card.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/failed/payment_failed_hero_header.dart';

/// Screen displayed when checkout payment fails.
/// Conforms to Figma M-06.23 - Checkout / Payment Failed (node 3312:7475).
class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key, this.args});

  final PaymentFailedArgs? args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.payment_failed_screen_title,
        centerTitle: true,
        onBackPressed: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    PaymentFailedHeroHeader(),
                    SizedBox(height: Spacing.xs),
                    PaymentFailedCard(),
                    SizedBox(height: Spacing.base),
                  ],
                ),
              ),
            ),
            PaymentFailedActionButtons(
              onRetry: () {
                if (args?.onRetry != null) {
                  args!.onRetry!();
                } else {
                  unawaited(Navigator.of(context).maybePop());
                }
              },
              onChangePaymentMethod: () {
                if (args?.onChangePaymentMethod != null) {
                  args!.onChangePaymentMethod!();
                } else {
                  unawaited(Navigator.of(context).maybePop());
                }
              },
              onContactSupport: () {
                if (args?.onContactSupport != null) {
                  args!.onContactSupport!();
                } else {
                  unawaited(
                    Navigator.of(context).pushNamed(AppRoutes.profileContactUs),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
