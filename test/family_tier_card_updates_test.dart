import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_plan_section.dart';

void main() {
  test('price changes preserve tier card presentation', () {
    const previous = RestaurantPackageTierUiModel(
      id: 'basic',
      title: 'Basic',
      price: '10',
    );
    const current = RestaurantPackageTierUiModel(
      id: 'basic',
      title: 'Basic',
      price: '12',
    );

    expect(sameFamilyTierCardsExceptPrice([previous], [current]), isTrue);
    expect(
      sameFamilyTierCardsExceptPrice(
        [previous],
        [
          const RestaurantPackageTierUiModel(
            id: 'basic',
            title: 'Basic',
            price: '12',
            isAvailable: false,
          ),
        ],
      ),
      isFalse,
    );
  });
}
