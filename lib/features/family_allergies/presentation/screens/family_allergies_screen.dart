import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
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
            (!previous.completed && current.completed) ||
            (previous.isSaving &&
                !current.isSaving &&
                current.saveFailure != null),
        listener: (context, state) {
          if (state.saveFailure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.saveFailure!,
              ),
            );
          } else if (state.optionalSaveErrorMessage != null) {
            CustomSnackbar.showError(
              context: context,
              message: state.optionalSaveErrorMessage!,
            );
          }
          if (state.completed) {
            context.pushNamed(AppRoutes.familyPackageDaysSetup);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.members.isEmpty) {
            return const FamilyAllergiesLoadingSkeleton();
          }
          if (state.failure != null && state.members.isEmpty) {
            final errorWidget = ApiErrorWidget(
              exception: state.failure!.exception,
              onRetry: () => context.read<FamilyAllergiesViewModel>().load(
                memberId: FamilyFlowScope.targetMemberIdOf(context),
              ),
            );
            if (isInFamilyFlow) return errorWidget;
            return Scaffold(
              backgroundColor: color.surface,
              appBar: CustomAppBar(
                title: locale.family_setup_title,
                showBackButton: true,
              ),
              body: SafeArea(top: false, child: errorWidget),
            );
          }
          final content = FamilyAllergiesContent(
            state: state,
          ).animate().fadeIn(duration: 250.ms);
          if (isInFamilyFlow) {
            return content;
          }
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.family_setup_title,
              showBackButton: true,
            ),
            body: SafeArea(top: false, child: content),
          );
        },
      ),
    );
  }
}
