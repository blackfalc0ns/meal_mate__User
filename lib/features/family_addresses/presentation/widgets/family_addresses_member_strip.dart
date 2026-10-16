import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

@immutable
class _MemberStripData {
  const _MemberStripData({
    required this.members,
    required this.currentIndex,
    required this.completedMemberIds,
  });

  final List<FamilyMemberEntity> members;
  final int currentIndex;
  final Set<String> completedMemberIds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MemberStripData &&
          currentIndex == other.currentIndex &&
          _listEquals(members, other.members) &&
          _setEquals(completedMemberIds, other.completedMemberIds);

  @override
  int get hashCode => Object.hash(
    currentIndex,
    Object.hashAll(members),
    Object.hashAll(completedMemberIds),
  );

  static bool _listEquals(
    List<FamilyMemberEntity> a,
    List<FamilyMemberEntity> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].memberId != b[i].memberId ||
          a[i].displayName != b[i].displayName ||
          a[i].gender != b[i].gender) {
        return false;
      }
    }
    return true;
  }

  static bool _setEquals(Set<String> a, Set<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}

class FamilyAddressesMemberStrip extends StatelessWidget {
  const FamilyAddressesMemberStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      FamilyAddressesViewModel,
      FamilyAddressesState,
      _MemberStripData
    >(
      selector: (state) => _MemberStripData(
        members: state.members,
        currentIndex: state.currentIndex,
        completedMemberIds: state.completedMemberIds,
      ),
      builder: (context, data) {
        if (data.members.isEmpty) {
          return const SizedBox.shrink();
        }

        final uiModels = data.members
            .asMap()
            .entries
            .map((entry) {
              final isCompleted = data.completedMemberIds.contains(
                entry.value.memberId,
              );
              return FamilyProgramMemberUiModel(
                name: entry.value.displayName,
                imageAsset: resolveFamilyMemberAvatar(
                  entry.value.gender,
                  entry.key,
                ),
                status: isCompleted
                    ? locale.family_member_completed
                    : locale.family_member_in_progress,
                isSelected: entry.key == data.currentIndex,
                isInProgress: !isCompleted,
              );
            })
            .toList(growable: false);

        return FamilyProgramMemberStrip(
          members: uiModels,
          onSelectMember: context.read<FamilyAddressesViewModel>().selectMember,
        );
      },
    );
  }
}
