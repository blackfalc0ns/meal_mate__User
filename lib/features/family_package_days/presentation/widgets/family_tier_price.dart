import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_price.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';

class FamilyTierPrice extends StatelessWidget {
  const FamilyTierPrice({
    super.key,
    required this.index,
    required this.priceColor,
    required this.subtitleColor,
    required this.dividerColor,
  });

  final int index;
  final Color priceColor;
  final Color subtitleColor;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BlocSelector<
      FamilyPackageDaysViewModel,
      FamilyPackageDaysState,
      (String, String, String?, bool)
    >(
      selector: (state) {
        if (index >= state.tiers.length) return ('', '', null, true);
        final model = state.tiers[index].toTierUiModel(locale.localeName);
        return (
          model.price,
          model.currency,
          model.priceSubtitle,
          state.isTiersLoading,
        );
      },
      builder: (context, price) => RestaurantPackageTierPrice(
        price: price.$1,
        currency: price.$2,
        priceSubtitle: price.$3,
        priceColor: priceColor,
        subtitleColor: subtitleColor,
        dividerColor: dividerColor,
        isLoading: price.$4,
      ),
    );
  }
}
