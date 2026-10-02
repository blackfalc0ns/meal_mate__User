import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/payment/domain/entities/activation_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/activation/activation_order_summary_card.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/activation/activation_promo_code_card.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/activation/activation_success_hero_header.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/activation/activation_terms_section.dart';

class ActivationSuccessScreen extends StatelessWidget {
  const ActivationSuccessScreen({super.key, required this.args});

  final ActivationSuccessArgs args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;
    final checkout = args.checkoutArgs;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: AppBar(
          backgroundColor: color.surface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            locale.offer_activation_success_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.close, color: color.onSurface),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Spacing.md),
                const ActivationSuccessHeroHeader(),
                const SizedBox(height: Spacing.xl),
                ActivationOrderSummaryCard(checkout: checkout),
                if (checkout.offer.promoCode != null &&
                    checkout.offer.promoCode!.isNotEmpty) ...[
                  const SizedBox(height: Spacing.md),
                  ActivationPromoCodeCard(promoCode: checkout.offer.promoCode!),
                ],
                if (checkout.offer.terms(lang) != null &&
                    checkout.offer.terms(lang)!.isNotEmpty)
                  ActivationTermsSection(terms: checkout.offer.terms(lang)!),
                const SizedBox(height: Spacing.xxl),
                AppButton(
                  text: locale.offer_activation_choose_plan_button,
                  onPressed: () {
                    unawaited(
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.calendar,
                        (route) => route.isFirst,
                        arguments: args.subscriptionId,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
