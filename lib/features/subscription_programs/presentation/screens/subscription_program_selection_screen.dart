import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_selection_view.dart';

class SubscriptionProgramSelectionScreen extends StatelessWidget {
  const SubscriptionProgramSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: Scaffold(
        backgroundColor: color.surface,
        body: Stack(
          children: [
            SubscriptionProgramSelectionView(
              showBottomSpace: false,
              onProgramSelected: (index) {
                context.pushNamed(
                  AppRoutes.subscriptionPackageSelection,
                  arguments: index.clamp(0, 2),
                );
              },
            ),
            CustomBackButton(
              top: MediaQuery.paddingOf(context).top + Spacing.base,
              onPressed: () => Navigator.maybePop(context),
            ),
          ],
        ),
      ),
    );
  }
}
