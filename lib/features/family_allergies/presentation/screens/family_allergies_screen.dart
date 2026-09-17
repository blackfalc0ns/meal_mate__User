import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_state.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/manager/family_allergies_view_model.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_content.dart';
import 'package:meal_meat_user/features/family_allergies/presentation/widgets/family_allergies_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyAllergiesScreen extends StatelessWidget {
  const FamilyAllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider(
      create: (_) =>
          getIt<FamilyAllergiesViewModel>()
            ..load(memberId: FamilyFlowScope.targetMemberIdOf(context)),
      child: BlocConsumer<FamilyAllergiesViewModel, FamilyAllergiesState>(
        listenWhen: (previous, current) =>
            !previous.completed && current.completed,
        listener: (context, state) {
          if (state.optionalSaveErrorMessage != null) {
            CustomSnackbar.showError(
              context: context,
              message: state.optionalSaveErrorMessage!,
            );
          }
          context.pushNamed(AppRoutes.familyPackageDaysSetup);
        },
        builder: (context, state) {
          if (state.isLoading && state.members.isEmpty) {
            return const FamilyAllergiesLoadingSkeleton();
          }
          if (isInFamilyFlow) {
            return FamilyAllergiesContent(state: state);
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
