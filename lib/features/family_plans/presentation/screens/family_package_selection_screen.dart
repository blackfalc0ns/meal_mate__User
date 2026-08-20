import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_view_model.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_package_selection_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_size_package_list.dart';

class FamilyPackageSelectionScreen extends StatelessWidget {
  const FamilyPackageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilyPlanViewModel>(
      create: (_) =>
          getIt<FamilyPlanViewModel>()
            ..doIntent(const GetFamilySizePackagesEvent()),
      child: Scaffold(
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
                  fontSize: FontSize.size8,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<FamilyPlanViewModel, FamilyPlanState>(
            builder: (context, state) {
              if (state.isPackagesLoading && state.packages.isEmpty) {
                return const FamilyPackageSelectionLoadingSkeleton();
              }

              if (state.failure != null && state.packages.isEmpty) {
                return ApiErrorWidget(
                  exception: state.failure!.exception,
                  onRetry: () => context.read<FamilyPlanViewModel>().doIntent(
                    const GetFamilySizePackagesEvent(),
                  ),
                );
              }

              if (state.packages.isEmpty) {
                return EmptyStateWidget(
                  title: locale.family_packages_empty,
                  description: locale.family_packages_selection_subtitle,
                  icon: Icons.groups_2_rounded,
                );
              }

              return _buildContent(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FamilyPlanState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    final selectedPackage = state.selectedPackage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Spacing.md),
          Text(
            locale.family_packages_selection_title,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size18,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.family_packages_selection_subtitle,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FamilySizePackageList(
                packages: state.packages,
                selectedPackageId: selectedPackage?.id,
                onSelectPackage: (pkg) {
                  context.read<FamilyPlanViewModel>().doIntent(
                    SelectFamilySizePackageEvent(pkg),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          AppButton.filled(
            text: locale.family_package_continue_button,
            onPressed: selectedPackage == null
                ? null
                : () {
                    context.pushNamed(
                      AppRoutes.familySubscriptionSetup,
                      arguments: selectedPackage,
                    );
                  },
            borderRadius: Spacing.radiusPill,
            textColor: color.onPrimary,
            fontSize: FontSize.size12,
            iconWidget: Icon(
              Icons.chevron_right_rounded,
              color: color.onPrimary,
              size: Spacing.iconMd,
            ),
          ),
          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }
}
