import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class SubscriptionPlanDetailsArgs {
  const SubscriptionPlanDetailsArgs({
    required this.program,
    required this.bundle,
  });

  final SubscriptionProgramEntity program;
  final SubscriptionBundleEntity bundle;
}
