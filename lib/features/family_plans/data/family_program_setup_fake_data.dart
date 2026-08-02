import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_plan_entity.dart';

class FamilyProgramSetupFakeDataSource {
  const FamilyProgramSetupFakeDataSource();

  List<FamilyProgramSetupMemberFakeData> getMembers(AppLocalizations locale) {
    return [
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_ahmed,
        imageAsset: AssetsFake.familyMemberAhmed,
        status: locale.family_member_completed,
        isSelected: true,
        isInProgress: true,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_sarah,
        imageAsset: AssetsFake.familyMemberSarah,
        status: locale.family_member_completed,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_yousef,
        imageAsset: AssetsFake.familyMemberYousef,
        status: locale.family_member_completed,
      ),
      FamilyProgramSetupMemberFakeData(
        name: locale.family_member_mariam,
        imageAsset: AssetsFake.familyMemberMariam,
        status: locale.family_member_completed,
      ),
    ];
  }

  FamilyProgramSetupMemberDetailsFakeData getSelectedMemberDetails(
    AppLocalizations locale,
  ) {
    return FamilyProgramSetupMemberDetailsFakeData(
      name: locale.family_member_ahmed,
      imageAsset: AssetsFake.familyMemberAhmed,
      age: locale.family_selected_member_age,
      gender: locale.family_selected_member_gender,
      goal: locale.family_subscription_program_value,
      activityLevel: locale.family_activity_medium,
    );
  }

  List<FamilyProgramSetupProgramFakeData> getPrograms(AppLocalizations locale) {
    return [
      FamilyProgramSetupProgramFakeData(
        title: locale.family_program_balanced_title,
        description: locale.family_program_balanced_description,
        imageAsset: AssetsFake.familySetupProgramBalanced,
        isSelected: true,
      ),
      FamilyProgramSetupProgramFakeData(
        title: locale.family_program_weight_loss_title,
        description: locale.family_program_weight_loss_description,
        imageAsset: AssetsFake.familySetupProgramWeightLoss,
      ),
      FamilyProgramSetupProgramFakeData(
        title: locale.family_program_muscle_title,
        description: locale.family_program_muscle_description,
        imageAsset: AssetsFake.familySetupProgramMuscle,
      ),
      FamilyProgramSetupProgramFakeData(
        title: locale.family_program_keto_title,
        description: locale.family_program_keto_description,
        imageAsset: AssetsFake.familySetupProgramKeto,
      ),
    ];
  }

  List<FamilyPackageOptionFakeData> getPackageOptions(AppLocalizations locale) {
    return [
      FamilyPackageOptionFakeData(
        title: locale.family_subscription_package_value,
        description: locale.subscription_summary_daily_meals,
        icon: FamilyPackageOptionIcon.appleCutlery,
        isSelected: true,
      ),
      FamilyPackageOptionFakeData(
        title: locale.family_package_three_meals_title,
        description: locale.family_package_three_meals_description,
        icon: FamilyPackageOptionIcon.cutlery,
      ),
      FamilyPackageOptionFakeData(
        title: locale.family_package_two_meals_title,
        description: locale.family_package_two_meals_description,
        icon: FamilyPackageOptionIcon.cutlery,
      ),
    ];
  }

  List<FamilyDayOptionFakeData> getDayOptions(AppLocalizations locale) {
    return [
      FamilyDayOptionFakeData(label: locale.family_days_7, isSelected: true),
      FamilyDayOptionFakeData(label: locale.family_days_14),
      FamilyDayOptionFakeData(label: locale.family_days_30),
    ];
  }

  FamilySelectionSummaryFakeData getPackageDaysSelectionSummary(
    AppLocalizations locale,
  ) {
    return FamilySelectionSummaryFakeData(
      title: locale.family_member_selection_summary,
      rows: [
        FamilySelectionSummaryRowFakeData(
          label: locale.family_subscription_program_label,
          value: locale.family_subscription_program_value,
          icon: FamilySelectionSummaryIcon.balance,
        ),
        FamilySelectionSummaryRowFakeData(
          label: locale.family_subscription_package_label,
          value: locale.family_subscription_package_value,
          icon: FamilySelectionSummaryIcon.cutlery,
        ),
        FamilySelectionSummaryRowFakeData(
          label: locale.family_subscription_days_label,
          value: locale.family_days_7,
          icon: FamilySelectionSummaryIcon.calendar,
        ),
        FamilySelectionSummaryRowFakeData(
          label: locale.family_friday_delivery_title,
          value: locale.family_friday_delivery_added,
          icon: FamilySelectionSummaryIcon.check,
        ),
        FamilySelectionSummaryRowFakeData(
          label: locale.family_weekly_price,
          value: locale.family_weekly_price_value,
          icon: FamilySelectionSummaryIcon.receipt,
          isPrice: true,
        ),
        FamilySelectionSummaryRowFakeData(
          label: locale.family_monthly_price,
          value: locale.family_monthly_price_value,
          icon: FamilySelectionSummaryIcon.calendar,
          isPrice: true,
        ),
      ],
    );
  }

  FamilySelectionSummaryFakeData getSelectionSummary(AppLocalizations locale) {
    return FamilySelectionSummaryFakeData(
      title: locale.family_subscription_summary,
      rows: [
        FamilySelectionSummaryRowFakeData(
          label: locale.family_subscription_program_label,
          value: locale.family_subscription_program_value,
          icon: FamilySelectionSummaryIcon.balance,
        ),
        FamilySelectionSummaryRowFakeData(
          label: locale.family_subscription_package_label,
          value: locale.family_subscription_package_value,
          icon: FamilySelectionSummaryIcon.cutlery,
        ),
        FamilySelectionSummaryRowFakeData(
          label: locale.family_subscription_days_label,
          value: locale.family_subscription_days_value,
          icon: FamilySelectionSummaryIcon.calendar,
        ),
      ],
    );
  }

  FamilyPaymentPriceDetailsFakeData getPaymentPriceDetails(
    AppLocalizations locale,
  ) {
    return FamilyPaymentPriceDetailsFakeData(
      rows: [
        FamilyPaymentPriceRowFakeData(
          label: locale.family_price_duration_total,
          value: '420.00',
        ),
        FamilyPaymentPriceRowFakeData(
          label: locale.family_price_discount,
          value: '-42.00',
          isDiscount: true,
        ),
        FamilyPaymentPriceRowFakeData(
          label: locale.family_price_tax_total,
          value: '378.00',
          isStrong: true,
        ),
      ],
      totalLabel: locale.family_monthly_total_label,
      totalValue: '378.00',
    );
  }

  List<FamilyPaymentMethodFakeData> getPaymentMethods(AppLocalizations locale) {
    return [
      FamilyPaymentMethodFakeData(
        label: locale.family_payment_card_label,
        imageAsset: AssetsFake.familyPaymentCard,
        selected: true,
      ),
      FamilyPaymentMethodFakeData(
        label: locale.family_payment_apple_pay_label,
        imageAsset: AssetsFake.familyPaymentApplePay,
      ),
      FamilyPaymentMethodFakeData(
        label: locale.family_payment_mada_label,
        imageAsset: AssetsFake.familyPaymentMada,
      ),
    ];
  }

  List<FamilyMemberEntity> getOverviewMembers(AppLocalizations locale) {
    return [
      FamilyMemberEntity(
        name: locale.family_member_ahmed,
        imageAsset: AssetsFake.familyMemberAhmed,
        detailLines: const [],
        actionLabel: '',
        mealsCount: locale.family_meals_4,
        mealChecks: const [true, true, true, true],
        isOwner: true,
      ),
      FamilyMemberEntity(
        name: locale.family_member_sarah,
        imageAsset: AssetsFake.familyMemberSarah,
        detailLines: const [],
        actionLabel: '',
        mealsCount: locale.family_meals_4,
        mealChecks: const [true, false, true, true],
      ),
      FamilyMemberEntity(
        name: locale.family_member_yousef,
        imageAsset: AssetsFake.familyMemberYousef,
        detailLines: const [],
        actionLabel: '',
        mealsCount: locale.family_meals_4,
        mealChecks: const [true, true, true, true],
      ),
      FamilyMemberEntity(
        name: locale.family_member_mariam,
        imageAsset: AssetsFake.familyMemberMariam,
        detailLines: const [],
        actionLabel: '',
        mealsCount: locale.family_meals_4,
        mealChecks: const [false, true, true, false],
      ),
    ];
  }
}

class FamilyProgramSetupMemberFakeData {
  const FamilyProgramSetupMemberFakeData({
    required this.name,
    required this.imageAsset,
    required this.status,
    this.isSelected = false,
    this.isInProgress = false,
  });

  final String name;
  final String imageAsset;
  final String status;
  final bool isSelected;
  final bool isInProgress;
}

class FamilyProgramSetupProgramFakeData {
  const FamilyProgramSetupProgramFakeData({
    required this.title,
    required this.description,
    required this.imageAsset,
    this.isSelected = false,
  });

  final String title;
  final String description;
  final String imageAsset;
  final bool isSelected;
}

class FamilyProgramSetupMemberDetailsFakeData {
  const FamilyProgramSetupMemberDetailsFakeData({
    required this.name,
    required this.imageAsset,
    required this.age,
    required this.gender,
    required this.goal,
    required this.activityLevel,
  });

  final String name;
  final String imageAsset;
  final String age;
  final String gender;
  final String goal;
  final String activityLevel;
}

enum FamilyPackageOptionIcon { cutlery, appleCutlery }

class FamilyPackageOptionFakeData {
  const FamilyPackageOptionFakeData({
    required this.title,
    required this.description,
    required this.icon,
    this.isSelected = false,
  });

  final String title;
  final String description;
  final FamilyPackageOptionIcon icon;
  final bool isSelected;
}

class FamilyDayOptionFakeData {
  const FamilyDayOptionFakeData({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;
}

enum FamilySelectionSummaryIcon { balance, cutlery, calendar, check, receipt }

class FamilySelectionSummaryFakeData {
  const FamilySelectionSummaryFakeData({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<FamilySelectionSummaryRowFakeData> rows;
}

class FamilySelectionSummaryRowFakeData {
  const FamilySelectionSummaryRowFakeData({
    required this.label,
    required this.value,
    required this.icon,
    this.isPrice = false,
  });

  final String label;
  final String value;
  final FamilySelectionSummaryIcon icon;
  final bool isPrice;
}

class FamilyPaymentPriceDetailsFakeData {
  const FamilyPaymentPriceDetailsFakeData({
    required this.rows,
    required this.totalLabel,
    required this.totalValue,
  });

  final List<FamilyPaymentPriceRowFakeData> rows;
  final String totalLabel;
  final String totalValue;
}

class FamilyPaymentPriceRowFakeData {
  const FamilyPaymentPriceRowFakeData({
    required this.label,
    required this.value,
    this.isDiscount = false,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isDiscount;
  final bool isStrong;
}

class FamilyPaymentMethodFakeData {
  const FamilyPaymentMethodFakeData({
    required this.label,
    required this.imageAsset,
    this.selected = false,
  });

  final String label;
  final String imageAsset;
  final bool selected;
}
