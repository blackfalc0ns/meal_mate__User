import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_location_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';

class FamilyAddressesLoadingSkeleton extends StatelessWidget {
  const FamilyAddressesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return Semantics(
          label: locale.addresses_choose_location_title,
          child: Column(
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
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          height: Spacing.xxl,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: color.surface,
                            border: Border.all(color: color.outlineVariant),
                            borderRadius: BorderRadius.circular(Spacing.xss),
                          ),
                          child: const Center(
                            child: ShimmerPlaceholder.rect(
                              width: Spacing.xxxl * 2,
                              height: Spacing.sm,
                              borderRadius: Spacing.radiusSm,
                            ),
                          ),
                        ),
                      ),
                      if (!isInFamilyFlow) ...[
                        const SizedBox(height: Spacing.md),
                        const FamilyProgramStepper(
                          currentStep: 2,
                          includeFamilyCreationStep: true,
                        ),
                        const SizedBox(height: Spacing.lg),
                      ],
                      SizedBox(
                        height: Spacing.familyProgramMemberCardHeight,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          separatorBuilder: (_, _) => const SizedBox(
                            width: Spacing.familyProgramMemberGap,
                          ),
                          itemBuilder: (_, _) => Container(
                            width: Spacing.familyProgramMemberCardWidth,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: color.surface,
                              border: Border.all(color: color.outlineVariant),
                              borderRadius: BorderRadius.circular(
                                Spacing.familyProgramMemberCardRadius,
                              ),
                            ),
                            child: const Row(
                              children: [
                                ShimmerPlaceholder.circle(
                                  size: Spacing.familyProgramMemberAvatarSize,
                                ),
                                SizedBox(width: Spacing.xs),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ShimmerPlaceholder.rect(
                                        height: Spacing.sm,
                                        borderRadius: Spacing.radiusSm,
                                      ),
                                      SizedBox(height: Spacing.xs),
                                      ShimmerPlaceholder.rect(
                                        height: Spacing.xss,
                                        borderRadius: Spacing.radiusSm,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: FamilyAddressLocationLoadingSkeleton()),
            ],
          ),
        );
  }
}
