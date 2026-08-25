import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_options_grid.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_options_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyPackageDaysPackageSection extends StatelessWidget {
  const FamilyPackageDaysPackageSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final displayedPackages = state.bundles
        .map(
          (bundle) => FamilyPackageOptionUiModel(
            title: bundle.name(locale.localeName),
            description: bundle.description(locale.localeName),
            imageUrl: bundle.imageUrl,
          ),
        )
        .toList();

    final selectedPackageOptions = List<FamilyPackageOptionUiModel>.generate(
      displayedPackages.length,
      (index) => FamilyPackageOptionUiModel(
        title: displayedPackages[index].title,
        description: displayedPackages[index].description,
        imageUrl: displayedPackages[index].imageUrl,
        imageAsset: displayedPackages[index].imageAsset,
        isSelected:
            state.selectedBundleIndex != null &&
            index == state.selectedBundleIndex,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.family_package_choose_title,
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          locale.family_package_choose_subtitle,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.familyPackageOptionsTopGap),
        if (state.isBundlesLoading && state.bundles.isEmpty)
          const FamilyPackageOptionsLoadingSkeleton()
        else if (selectedPackageOptions.isNotEmpty)
          AbsorbPointer(
            absorbing: state.isSelectedManagerPlanLocked,
            child: FamilyPackageOptionsGrid(
              options: selectedPackageOptions,
              onOptionSelected: (index) {
                context.read<FamilyPackageDaysViewModel>().doIntent(
                  SelectFamilyBundleEvent(index),
                );
              },
            ),
          ),
      ],
    );
  }
}
