import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_payment_card.dart';

class SubscriptionBillingPaymentSection extends StatelessWidget {
  const SubscriptionBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      SubscriptionBillingViewModel,
      SubscriptionBillingState,
      SubscriptionBillingPaymentMethodEntity?
    >(
      selector: (state) => state.billing.data?.paymentMethod,
      builder: (context, paymentMethod) {
        if (paymentMethod == null || !paymentMethod.hasSavedMethod) {
          return const SizedBox.shrink();
        }

        return SubscriptionBillingEntrance(
          sectionKey: 'payment_method',
          delay: const Duration(milliseconds: 120),
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.md),
            child: SubscriptionBillingPaymentCard(paymentMethod: paymentMethod),
          ),
        );
      },
    );
  }
}
