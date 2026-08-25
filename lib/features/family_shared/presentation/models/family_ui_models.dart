import 'package:flutter/material.dart';

enum FamilyPackageOptionIcon { cutlery, appleCutlery, spark }

enum FamilySelectionSummaryIcon { balance, cutlery, calendar, check, receipt }

class FamilySelectionSummaryData {
  const FamilySelectionSummaryData({required this.title, required this.rows});

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
    this.roleLabel = '',
  });

  final String name;
  final String imageAsset;
  final String age;
  final String gender;
  final String roleLabel;
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
    this.icon = FamilyPackageOptionIcon.appleCutlery,
    this.imageUrl,
    this.imageAsset = '',
    this.isSelected = false,
  });

  final String title;
  final String description;
  final FamilyPackageOptionIcon icon;
  final String? imageUrl;
  final String imageAsset;
  final bool isSelected;
}

class FamilyDayOptionUiModel {
  const FamilyDayOptionUiModel({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;
}

class FamilyPaymentPriceRowUiModel {
  const FamilyPaymentPriceRowUiModel({
    required this.label,
    required this.value,
    this.isDiscount = false,
    this.isStrong = false,
    this.showCurrency = true,
  });

  final String label;
  final String value;
  final bool isDiscount;
  final bool isStrong;
  final bool showCurrency;
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

class FamilySummaryStatUiModel {
  const FamilySummaryStatUiModel({
    required this.iconName,
    required this.value,
    required this.label,
  });

  final String iconName;
  final String value;
  final String label;
}

class FamilyPlanDetailsPriceRowUiModel {
  const FamilyPlanDetailsPriceRowUiModel({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class FamilyPlanMemberUiModel {
  const FamilyPlanMemberUiModel({
    required this.name,
    required this.imageAsset,
    this.isOwner = false,
    this.detailLines = const [],
    this.actionLabel = '',
    this.mealChecks = const [],
    this.mealsCount = '',
    this.badgeColor,
    this.badgeTextColor,
  });

  final String name;
  final String imageAsset;
  final bool isOwner;
  final List<String> detailLines;
  final String actionLabel;
  final List<bool> mealChecks;
  final String mealsCount;
  final Color? badgeColor;
  final Color? badgeTextColor;
}

class FamilyPlanDetailsUiModel {
  const FamilyPlanDetailsUiModel({
    required this.members,
    required this.summaryStats,
    required this.priceRows,
    required this.totalLabel,
    required this.totalPrice,
  });

  final List<FamilyPlanMemberUiModel> members;
  final List<FamilySummaryStatUiModel> summaryStats;
  final List<FamilyPlanDetailsPriceRowUiModel> priceRows;
  final String totalLabel;
  final String totalPrice;
}
