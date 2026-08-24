class ConversionOptionsModel {
  const ConversionOptionsModel({
    required this.subscriptionId,
    required this.status,
    required this.options,
  });

  final String subscriptionId;
  final String status;
  final List<ConversionOptionModel> options;

  ConversionOptionModel? get convertToFamilyManagerOption {
    for (final option in options) {
      if (option.isConvertToFamilyManager) return option;
    }
    return null;
  }
}

class ConversionOptionModel {
  const ConversionOptionModel({
    required this.code,
    required this.available,
    required this.titleAr,
    required this.titleEn,
    this.action,
    this.disabledReason,
  });

  final String code;
  final bool available;
  final String titleAr;
  final String titleEn;
  final String? action;
  final String? disabledReason;

  bool get isConvertToFamilyManager => code == 'CONVERT_TO_FAMILY_MANAGER';

  bool get isChangeIndividualPlan => code == 'CHANGE_INDIVIDUAL_PLAN';

  String title(String localeName) => localeName == 'ar' ? titleAr : titleEn;
}
