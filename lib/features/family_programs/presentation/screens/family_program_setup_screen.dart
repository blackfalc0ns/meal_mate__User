import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_event.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_state.dart';
import 'package:meal_meat_user/features/family_programs/presentation/manager/family_programs_view_model.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_content.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyProgramSetupScreen extends StatelessWidget {
  const FamilyProgramSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider<FamilyProgramsViewModel>(
      create: (_) => getIt<FamilyProgramsViewModel>()
        ..doIntent(const GetFamilySubscriptionCurrentEvent())
        ..doIntent(const GetFamilyProgramsEvent()),
      child: isInFamilyFlow
          ? BlocBuilder<FamilyProgramsViewModel, FamilyPlanState>(
              builder: _buildContent,
            )
          : Scaffold(
              backgroundColor: color.surface,
              appBar: CustomAppBar(
                showBackButton: true,
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
                child: BlocBuilder<FamilyProgramsViewModel, FamilyPlanState>(
                  builder: _buildContent,
                ),
              ),
            ),
    );
  }

  Widget _buildContent(BuildContext context, FamilyPlanState state) {
    if (state.isLoading && state.programs.isEmpty && state.members.isEmpty) {
      return const FamilyProgramSetupLoadingSkeleton();
    }

    if (state.failure != null && state.programs.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () {
          context.read<FamilyProgramsViewModel>().doIntent(
            const GetFamilyProgramsEvent(),
          );
          context.read<FamilyProgramsViewModel>().doIntent(
            const GetFamilySubscriptionCurrentEvent(),
          );
        },
      );
    }

    return FamilyProgramContent(state: state);
  }
}
