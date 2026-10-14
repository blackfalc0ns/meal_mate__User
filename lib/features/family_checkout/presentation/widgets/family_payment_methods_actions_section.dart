import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_view_model.dart';
import 'package:meal_meat_user/features/family_checkout/domain/entities/family_checkout_blocker_destination.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_actions.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_methods_section.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyPaymentMethodsActionsSection extends StatelessWidget {
  const FamilyPaymentMethodsActionsSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;
    final paymentMethods = state.paymentMethods
        .map(
          (method) => FamilyPaymentMethodUiModel(
            label: method.title,
            imageAsset: '',
            selected: state.selectedPaymentMethod?.id == method.id,
          ),
        )
        .toList();

    return Column(
      children: [
        if (paymentMethods.isNotEmpty) ...[
          const SizedBox(height: Spacing.md),
          FamilyPaymentMethodsSection(
            methods: paymentMethods,
            onSelectMethod: (index) {
              if (index < 0 || index >= state.paymentMethods.length) return;
              context.read<FamilyCheckoutViewModel>().doIntent(
                SelectFamilyPaymentMethodEvent(state.paymentMethods[index]),
              );
            },
          ),
        ],
        const SizedBox(height: Spacing.lg),
        FamilyPaymentActions(
          canCheckout: state.summary?.canCheckout ?? false,
          isLoading: state.isCheckoutLoading,
          checkoutBlockReason: state.summary?.checkoutBlockReason,
          onResolveBlocker: () {
            final route = familyCheckoutBlockerRoute(
              state.summary?.checkoutBlockReason,
            );
            if (route != null) {
              unawaited(context.pushReplacementNamed(route));
            }
          },
          onConfirmPayment: state.selectedPaymentMethod?.id == null
              ? null
              : () {
                  final methodId = state.selectedPaymentMethod?.id;
                  if (methodId == null) return;
                  context.read<FamilyCheckoutViewModel>().doIntent(
                    CheckoutFamilySubscriptionEvent(
                      callbackUrl: 'mealmate://checkout/success',
                      errorUrl: 'mealmate://checkout/error',
                      correlationId: context
                          .read<FamilyCheckoutViewModel>()
                          .correlationId,
                      paymentMethodId: methodId,
                    ),
                  );
                },
        ),
      ],
    );
  }
}
