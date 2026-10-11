import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_selected_program_card.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionPackageProgramHeaderSection extends StatelessWidget {
  const SubscriptionPackageProgramHeaderSection({
    super.key,
    required this.program,
  });

  final SubscriptionProgramEntity program;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsetsDirectional.only(
        top: Spacing.xl,
        start: Spacing.lg,
        end: Spacing.lg,
      ),
      sliver: SliverToBoxAdapter(
        child: SubscriptionSelectedProgramCard(program: program)
            .animate()
            .fadeIn(duration: 350.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.1,
              end: 0,
              duration: 350.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}
