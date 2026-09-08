import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_stage.dart';
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
            !previous.completed && current.completed,
        listener: (context, state) =>
            context.pushNamed(AppRoutes.familyAllergies),
        builder: (context, state) {
          final member = state.currentMember;
          if (state.isLoading || member == null) {
            return const LoadingWidget.fullScreen();
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
                    end: Spacing.familySetupHorizontalPadding,
                    top: Spacing.sm,
                    bottom: Spacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FamilySetupHeaderBadge(title: state.familyName),
                      if (!isInFamilyFlow) ...[
                        const SizedBox(height: Spacing.md),
                        const FamilyProgramStepper(
                          currentStep: 2,
                          includeFamilyCreationStep: true,
                        ),
                        const SizedBox(height: Spacing.lg),
                      ],
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
            appBar: CustomAppBar(
              title: locale.family_setup_title,
              showBackButton: true,
            ),
            body: content,
          );
        },
      ),
    );
  }
}
