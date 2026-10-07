import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/subscription_billing_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_content.dart';

class SubscriptionBillingScreen extends StatelessWidget {
  const SubscriptionBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionBillingViewModel>(
      create: (_) =>
          getIt<SubscriptionBillingViewModel>()
            ..doIntent(const GetSubscriptionBillingEvent()),
      child: const SubscriptionBillingContent(),
    );
  }
}
