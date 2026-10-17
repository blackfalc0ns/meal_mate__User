import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_apply_manager_banner.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_stage.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_addresses_header.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_addresses_member_strip.dart';

class FamilyAddressesBody extends StatelessWidget {
  const FamilyAddressesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      key: const ValueKey('family-addresses-content'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: color.surface,
          child: const Padding(
            padding: EdgeInsetsDirectional.only(
              start: Spacing.familySetupHorizontalPadding,
              end: Spacing.xs,
              bottom: Spacing.xs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FamilyAddressesHeader(),
                SizedBox(height: Spacing.xs),
                FamilyAddressesMemberStrip(),
                SizedBox(height: Spacing.xs),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: Spacing.familySetupHorizontalPadding - Spacing.xs,
                  ),
                  child: FamilyAddressApplyManagerBanner(),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child:
              BlocSelector<
                FamilyAddressesViewModel,
                FamilyAddressesState,
                ({
                  String memberId,
                  CustomerAddressEntity? initialAddress,
                  bool canProceedToAllergies,
                })?
              >(
                selector: (state) {
                  final member = state.currentMember;
                  if (member == null) return null;
                  final allCompleted =
                      state.completed ||
                      (state.members.isNotEmpty &&
                          state.completedMemberIds.length ==
                              state.members.length);
                  final hasSavedAddress =
                      member.deliveryAddress != null ||
                      (member.deliveryAddressId?.isNotEmpty ?? false);
                  return (
                    memberId: member.memberId,
                    initialAddress: member.deliveryAddress,
                    canProceedToAllergies: allCompleted && hasSavedAddress,
                  );
                },
                builder: (context, memberData) {
                  if (memberData == null) {
                    return const SizedBox.shrink();
                  }

                  return FamilyAddressLocationStage(
                    key: ValueKey(
                      '${memberData.memberId}-${memberData.initialAddress?.addressId ?? "empty"}',
                    ),
                    memberId: memberData.memberId,
                    initialAddress: memberData.initialAddress,
                    customActionText: memberData.canProceedToAllergies
                        ? locale.family_step_allergies
                        : null,
                    customActionIcon: memberData.canProceedToAllergies
                        ? const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: Spacing.iconXs,
                          )
                        : null,
                    onCustomAction: memberData.canProceedToAllergies
                        ? context
                            .read<FamilyAddressesViewModel>()
                            .proceedToNextStep
                        : null,
                    onAddressSaved: context
                        .read<FamilyAddressesViewModel>()
                        .addressSaved,
                  );
                },
              ),
        ),
      ],
    ).animate().fadeIn(duration: 250.ms);
  }
}
