import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_text_field.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart';

class FamilyMemberRelationshipSection extends StatelessWidget {
  const FamilyMemberRelationshipSection({
    super.key,
    required this.controller,
    required this.errorText,
    required this.onTap,
    required this.onRelationshipsChanged,
  });

  final TextEditingController controller;
  final String? errorText;
  final VoidCallback onTap;
  final ValueChanged<List<FamilyRelationshipEntity>> onRelationshipsChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.family_relation,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        BlocListener<FamilySubscriptionSetupViewModel, FamilyPlanState>(
          listenWhen: (previous, current) =>
              previous.relationships != current.relationships,
          listener: (context, state) =>
              onRelationshipsChanged(state.relationships),
          child: AppTextField(
            controller: controller,
            hint: locale.family_relation_hint,
            errorText: errorText,
            readOnly: true,
            onTap: onTap,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: color.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
