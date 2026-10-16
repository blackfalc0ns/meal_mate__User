import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_event.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_state.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilyAllergiesMemberStrip extends StatelessWidget {
  const FamilyAllergiesMemberStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BlocSelector<
      FamilyAllergiesViewModel,
      FamilyAllergiesState,
      ({List<FamilyMemberEntity> members, int index})
    >(
      selector: (state) => (members: state.members, index: state.currentIndex),
      builder: (context, data) {
        final models = data.members
            .asMap()
            .entries
            .map((entry) {
              final member = entry.value;
              final isCompleted =
                  member.allergiesCompleted ||
                  member.hasNoAllergies ||
                  member.allergies.isNotEmpty;
              return FamilyProgramMemberUiModel(
                name: member.displayName,
                imageAsset: resolveFamilyMemberAvatar(member.gender, entry.key),
                status: isCompleted
                    ? locale.family_member_completed
                    : locale.family_member_in_progress,
                isSelected: entry.key == data.index,
                isInProgress: !isCompleted,
              );
            })
            .toList(growable: false);
        return FamilyProgramMemberStrip(
          members: models,
          onSelectMember: (index) => context
              .read<FamilyAllergiesViewModel>()
              .doIntent(SelectFamilyAllergyMemberEvent(index)),
        );
      },
    );
  }
}
