import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_stage.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_addresses_actions.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_addresses_header.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_addresses_member_strip.dart';

class FamilyAddressesBody extends StatelessWidget {
  const FamilyAddressesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

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
              bottom: Spacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FamilyAddressesHeader(),
                SizedBox(height: Spacing.xs),
                FamilyAddressesMemberStrip(),
              ],
            ),
          ),
        ),
        Expanded(
          child:
              BlocSelector<
                FamilyAddressesViewModel,
                FamilyAddressesState,
                ({String memberId, CustomerAddressEntity? initialAddress})?
              >(
                selector: (state) {
                  final member = state.currentMember;
                  return member != null
                      ? (
                          memberId: member.memberId,
                          initialAddress: member.deliveryAddress,
                        )
                      : null;
                },
                builder: (context, memberData) {
                  if (memberData == null) {
                    return const SizedBox.shrink();
                  }

                  return FamilyAddressLocationStage(
                    key: ValueKey(memberData.memberId),
                    memberId: memberData.memberId,
                    initialAddress: memberData.initialAddress,
                    onAddressSaved: context
                        .read<FamilyAddressesViewModel>()
                        .addressSaved,
                  );
                },
              ),
        ),
        const FamilyAddressesActions(),
      ],
    ).animate().fadeIn(duration: 250.ms);
  }
}
