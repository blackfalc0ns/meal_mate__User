import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/screens/family_addresses_screen.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/screens/family_allergies_screen.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/screens/family_payment_setup_screen.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/screens/family_package_days_setup_screen.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_programs/presentation/screens/family_program_setup_screen.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_navigator.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/screens/family_subscription_setup_screen.dart';

class FamilySubscriptionFlowScreen extends StatelessWidget {
  const FamilySubscriptionFlowScreen({
    super.key,
    required this.initialRoute,
    this.initialArguments,
  });

  final String initialRoute;
  final Object? initialArguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FamilySubscriptionFlowViewModel>(
      create: (_) => FamilySubscriptionFlowViewModel(
        getIt<GetFamilyFlowCurrentUseCase>(),
        getIt<FamilyFlowSnapshotStore>(),
      )..load(),
      child: FamilyFlowScope(
        child: FamilyFlowNavigator(
          initialRoute: initialRoute,
          routeFactory: _buildStageRoute,
        ),
      ),
    );
  }

  Route<dynamic>? _buildStageRoute(RouteSettings settings) {
    final arguments =
        settings.arguments ??
        (settings.name == initialRoute ? initialArguments : null);
    final page = switch (settings.name) {
      AppRoutes.familySubscriptionSetup => FamilySubscriptionSetupScreen(
        selectedPackage: arguments is FamilySizePackageEntity
            ? arguments
            : null,
      ),
      AppRoutes.familyProgramSetup => const FamilyProgramSetupScreen(),
      AppRoutes.familyAddresses => const FamilyAddressesScreen(),
      AppRoutes.familyAllergies => const FamilyAllergiesScreen(),
      AppRoutes.familyPackageDaysSetup => FamilyPackageDaysSetupScreen(
        programId: arguments is String ? arguments : null,
      ),
      AppRoutes.familyPaymentSetup => const FamilyPaymentSetupScreen(),
      _ => null,
    };
    if (page == null) return null;

    return MaterialPageRoute<dynamic>(settings: settings, builder: (_) => page);
  }
}
