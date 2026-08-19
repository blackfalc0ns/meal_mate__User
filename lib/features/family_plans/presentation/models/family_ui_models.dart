enum FamilyPackageOptionIcon {
  cutlery,
  appleCutlery,
  spark,
}

enum FamilySelectionSummaryIcon {
  balance,
  cutlery,
  calendar,
  check,
  receipt,
}

class FamilySelectionSummaryData {
  const FamilySelectionSummaryData({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<FamilySelectionSummaryRowData> rows;
}

class FamilySelectionSummaryRowData {
  const FamilySelectionSummaryRowData({
    required this.icon,
    required this.label,
    required this.value,
    this.isPrice = false,
  });

  final FamilySelectionSummaryIcon icon;
  final String label;
  final String value;
  final bool isPrice;
}

class FamilyProgramMemberUiModel {
  const FamilyProgramMemberUiModel({
    required this.name,
    required this.imageAsset,
    this.status = '',
    this.isSelected = false,
    this.isInProgress = false,
  });

  final String name;
  final String imageAsset;
  final String status;
  final bool isSelected;
  final bool isInProgress;
}

class FamilyProgramMemberDetailsUiModel {
  const FamilyProgramMemberDetailsUiModel({
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

class FamilyProgramUiModel {
  const FamilyProgramUiModel({
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

class FamilyPackageOptionUiModel {
  const FamilyPackageOptionUiModel({
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

class FamilyDayOptionUiModel {
  const FamilyDayOptionUiModel({
    required this.label,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;
}

class FamilyPaymentPriceRowUiModel {
  const FamilyPaymentPriceRowUiModel({
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

class FamilyPaymentPriceDetailsUiModel {
  const FamilyPaymentPriceDetailsUiModel({
    required this.badge,
    required this.note,
    required this.totalLabel,
    required this.totalValue,
    required this.rows,
  });

  final String badge;
  final String note;
  final String totalLabel;
  final String totalValue;
  final List<FamilyPaymentPriceRowUiModel> rows;
}

class FamilyPaymentMethodUiModel {
  const FamilyPaymentMethodUiModel({
    required this.label,
    required this.imageAsset,
    this.selected = false,
  });

  final String label;
  final String imageAsset;
  final bool selected;

  bool get isSelected => selected;
  String get name => label;
  String get logoAsset => imageAsset;
}
