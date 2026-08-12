import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

class AddAllergyFakeDataSource {
  const AddAllergyFakeDataSource();

  List<(String, String?)> getGridOptions(AppLocalizations locale) => [
    (locale.add_allergy_sesame, AssetsFake.addAllergySelected),
    (locale.add_allergy_eggs, AssetsFake.addAllergyEgg),
    (locale.add_allergy_gluten, AssetsFake.addAllergyGluten),
    (locale.add_allergy_peanuts, AssetsFake.addAllergyPeanut),
    (locale.add_allergy_seafood, AssetsFake.addAllergyShrimp),
    (locale.add_allergy_soy, null),
    (locale.add_allergy_wheat, null),
    (locale.add_allergy_fish, AssetsFake.addAllergyFishDetail),
    (locale.add_allergy_shellfish, AssetsFake.addAllergyCrab),
  ];

  List<String> getCommonOptions(AppLocalizations locale) => [
    locale.dietary_preferences_allergy_lactose,
    locale.dietary_preferences_allergy_nuts,
    locale.add_allergy_celery,
    locale.add_allergy_mustard,
    locale.add_allergy_lupin,
  ];

  Set<String> getInitialSelectedAllergies(AppLocalizations locale) => {
    locale.dietary_preferences_allergy_nuts,
    locale.dietary_preferences_allergy_lactose,
  };
}
