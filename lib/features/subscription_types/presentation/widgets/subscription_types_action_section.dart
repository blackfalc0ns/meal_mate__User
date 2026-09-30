import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_type_notice.dart';

class SubscriptionTypesActionSection extends StatelessWidget {
  const SubscriptionTypesActionSection({
    super.key,
    required this.selectedType,
    required this.isLoading,
    required this.onPressed,
  });

  final SubscriptionTypeEntity? selectedType;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Column(
      children: [
        SubscriptionTypeNotice(message: locale.subscription_type_notice_label),
        const SizedBox(height: Spacing.md),
        AppSubscriptionButton.next(
          text: locale.family_next_program,
          isLoading: isLoading,
          onPressed:
              selectedType == null || !selectedType!.isAvailable || isLoading
              ? null
              : onPressed,
        ),
      ],
    );
  }
}
