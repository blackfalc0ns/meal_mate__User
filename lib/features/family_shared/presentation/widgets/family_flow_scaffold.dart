import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_program_stepper.dart';

class FamilyFlowScaffold extends StatelessWidget {
  const FamilyFlowScaffold({
    super.key,
    required this.currentStepListenable,
    required this.body,
    this.onBackPressed,
  });

  final ValueListenable<int> currentStepListenable;
  final Widget body;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        showBackButton: true,
        onBackPressed: onBackPressed,
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
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: Spacing.familySetupHorizontalPadding,
                end: Spacing.familySetupHorizontalPadding,
                top: Spacing.md,
                bottom: Spacing.md,
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: currentStepListenable,
                builder: (context, currentStep, child) => FamilyProgramStepper(
                  currentStep: currentStep,
                  completedSteps: currentStep == 0 ? 1 : 0,
                  includeFamilyCreationStep: true,
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
