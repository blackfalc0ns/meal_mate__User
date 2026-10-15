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
import 'package:meal_meat_user/features/family_packages/presentation/manager/family_packages_event.dart';
import 'package:meal_meat_user/features/family_packages/presentation/manager/family_packages_state.dart';
import 'package:meal_meat_user/features/family_packages/presentation/manager/family_packages_view_model.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_package_hero_card.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_package_section_header.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_package_selection_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_packages/presentation/widgets/family_size_package_list.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class FamilyPackageSelectionScreen extends StatelessWidget {
  const FamilyPackageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilyPackagesViewModel>(
      create: (_) =>
          getIt<FamilyPackagesViewModel>()
            ..doIntent(const GetFamilySizePackagesEvent()),
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: const CustomAppBar(
          showBackButton: true,
          showShadow: false,
          centerTitle: true,
          titleWidget: AppLogo(
            size: Spacing.subscriptionTypeLogoHeight,
            alignment: CrossAxisAlignment.center,
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<FamilyPackagesViewModel, FamilyPlanState>(
            builder: (context, state) {
              if (state.isPackagesLoading && state.packages.isEmpty) {
                return const FamilyPackageSelectionLoadingSkeleton();
              }

              if (state.failure != null && state.packages.isEmpty) {
                return ApiErrorWidget(
                  exception: state.failure!.exception,
                  onRetry: () => context
                      .read<FamilyPackagesViewModel>()
                      .doIntent(const GetFamilySizePackagesEvent()),
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Spacing.sm),
          Text(
            locale.family_packages_header_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size22,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.hairline * 2),
          Text(
            locale.family_packages_header_subtitle,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size16,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.md),
          const FamilyPackageHeroCard(),
          const SizedBox(height: Spacing.md),
          const FamilyPackageSectionHeader(),
          const SizedBox(height: Spacing.sm),
          FamilySizePackageList(
            packages: state.packages,
            selectedPackageId: selectedPackage?.id,
            onSelectPackage: (pkg) {
              context.read<FamilyPackagesViewModel>().doIntent(
                SelectFamilySizePackageEvent(pkg),
              );
            },
          ),
          const SizedBox(height: Spacing.md),
          AppButton.filled(
            text: locale.family_packages_continue_button,
            onPressed: selectedPackage == null
                ? null
                : () async {
                    await context.pushNamed(
                      AppRoutes.familySubscriptionSetup,
                      arguments: selectedPackage,
                    );
                  },
            borderRadius: Spacing.radiusPill,
            textColor: color.onPrimary,
            fontSize: FontSize.size14,
            iconWidget: Icon(
              isRtl
                  ? Icons.arrow_circle_left_outlined
                  : Icons.arrow_circle_right_outlined,
              color: color.onPrimary,
              size: Spacing.iconLg,
            ),
          ),
          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }
}
