import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_event.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/manager/food_preferences_view_model.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/add_allergy_option_tile.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/widgets/dietary_preferences_option.dart';

class AddAllergyGridSection extends StatelessWidget {
  const AddAllergyGridSection({
    super.key,
    required this.options,
    required this.selectedCodes,
  });

  final List<DietaryPreferencesOption> options;
  final Set<String> selectedCodes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: Spacing.addAllergyGridTileHeight,
        mainAxisSpacing: Spacing.addAllergyGridGap,
        crossAxisSpacing: Spacing.addAllergyGridGap,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        return AddAllergyOptionTile(
          label: option.label,
          isSelected: selectedCodes.contains(option.code),
          onTap: () => context.read<FoodPreferencesViewModel>().doIntent(
            ToggleAllergyPreferenceEvent(option.code),
          ),
        );
      },
    );
  }
}
