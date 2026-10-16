import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';

class FamilyAllergiesActions extends StatelessWidget {
  const FamilyAllergiesActions({
    super.key,
    required this.nextText,
    required this.isLoading,
    required this.onNext,
    this.progress,
    this.progressLabel,
  });

  final String nextText;
  final bool isLoading;
  final VoidCallback? onNext;
  final double? progress;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    return FamilyProgramActions(
      nextText: nextText,
      nextIcon: Icons.arrow_forward_ios_rounded,
      onNextPressed: onNext,
      isLoading: isLoading,
      progress: progress,
      progressLabel: progressLabel,
      showSecondary: false,
    );
  }
}
