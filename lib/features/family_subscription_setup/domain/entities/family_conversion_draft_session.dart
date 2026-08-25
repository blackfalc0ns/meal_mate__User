class FamilyConversionDraftSession {
  const FamilyConversionDraftSession._();

  static bool _isConvertedFamilyDraft = false;

  static bool get isConvertedFamilyDraft => _isConvertedFamilyDraft;

  static void markConvertedFamilyDraft() {
    _isConvertedFamilyDraft = true;
  }

  static void clearConvertedFamilyDraft() {
    _isConvertedFamilyDraft = false;
  }
}
