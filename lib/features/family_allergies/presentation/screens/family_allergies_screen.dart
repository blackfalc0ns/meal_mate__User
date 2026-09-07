import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_state.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_view_model.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_content.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_loading_skeleton.dart';

class FamilyAllergiesScreen extends StatelessWidget {
  const FamilyAllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider(
      create: (_) => getIt<FamilyAllergiesViewModel>()..load(),
      child: BlocConsumer<FamilyAllergiesViewModel, FamilyAllergiesState>(
        listenWhen: (previous, current) =>
            !previous.completed && current.completed,
        listener: (context, state) =>
            context.pushReplacementNamed(AppRoutes.familyPackageDaysSetup),
        builder: (context, state) {
          if (state.isLoading && state.members.isEmpty) {
            return const FamilyAllergiesLoadingSkeleton();
          }
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.family_setup_title,
              showBackButton: true,
            ),
            body: SafeArea(
              top: false,
              child: FamilyAllergiesContent(state: state),
            ),
          );
        },
      ),
    );
  }
}
