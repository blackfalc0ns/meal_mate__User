import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_stage.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_addresses_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyAddressesScreen extends StatelessWidget {
  const FamilyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider(
      create: (_) => getIt<FamilyAddressesViewModel>()..load(),
      child: BlocConsumer<FamilyAddressesViewModel, FamilyAddressesState>(
        listenWhen: (previous, current) =>
            current.completed &&
            previous.addressSaveRevision != current.addressSaveRevision,
        listener: (context, state) =>
            context.pushNamed(AppRoutes.familyAllergies),
        builder: (context, state) {
          if (isInFamilyFlow) {
            FamilyFlowScope.updateFamilyName(context, state.familyName);
          }
          final member = state.currentMember;
          if (state.isLoading || member == null) {
            const loading = FamilyAddressesLoadingSkeleton();
            if (isInFamilyFlow) return loading;

            return Scaffold(
              backgroundColor: color.surfaceContainerHighest,
              appBar: _buildAppBar(context),
              body: loading,
            );
          }

          final members = state.members.asMap().entries.map((entry) {
            return FamilyProgramMemberUiModel(
              name: entry.value.displayName,
              imageAsset: '',
              status: state.completedMemberIds.contains(entry.value.memberId)
                  ? locale.family_member_completed
                  : locale.family_member_in_progress,
              isSelected: entry.key == state.currentIndex,
              isInProgress: !state.completedMemberIds.contains(
                entry.value.memberId,
              ),
            );
          }).toList();

          final content = Column(
            children: [
              ColoredBox(
                color: color.surface,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: Spacing.familySetupHorizontalPadding,
                    end: Spacing.xs,
                    bottom: Spacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isInFamilyFlow) ...[
                        FamilySetupHeaderBadge(title: state.familyName),
                        const SizedBox(height: Spacing.md),
                        const FamilyProgramStepper(
                          currentStep: 2,
                          includeFamilyCreationStep: true,
                        ),
                      ],
                      const SizedBox(height: Spacing.xs),
                      FamilyProgramMemberStrip(
                        members: members,
                        onSelectMember: context
                            .read<FamilyAddressesViewModel>()
                            .selectMember,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FamilyAddressLocationStage(
                  memberId: member.memberId,
                  initialAddress: member.deliveryAddress,
                  onSaved: context
                      .read<FamilyAddressesViewModel>()
                      .addressSaved,
                ),
              ),
            ],
          );
          if (isInFamilyFlow) {
            return ColoredBox(
              color: color.surfaceContainerHighest,
              child: content,
            );
          }

          return Scaffold(
            backgroundColor: color.surfaceContainerHighest,
            appBar: _buildAppBar(context),
            body: content,
          );
        },
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return CustomAppBar(
      showBackButton: true,
      titleWidget: Column(
        children: [
          Text(
            locale.family_setup_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
          ),
          Text(
            locale.family_setup_subtitle,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size9,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
