import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_invoice_history_card.dart';

class SubscriptionBillingInvoicesSection extends StatelessWidget {
  const SubscriptionBillingInvoicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      SubscriptionBillingViewModel,
      SubscriptionBillingState,
      List<SubscriptionBillingInvoiceEntity>
    >(
      selector: (state) => state.billing.data?.invoices ?? const [],
      builder: (context, invoices) {
        return SubscriptionBillingEntrance(
          sectionKey: 'invoice_history',
          delay: const Duration(milliseconds: 160),
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.md),
            child: SubscriptionBillingInvoiceHistoryCard(invoices: invoices),
          ),
        );
      },
    );
  }
}
