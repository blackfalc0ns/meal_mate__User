class CallingCodeEntity {
  const CallingCodeEntity({
    required this.countryCode,
    required this.nameAr,
    required this.nameEn,
    required this.dialCode,
    required this.flagEmoji,
  });

  final String countryCode;
  final String nameAr;
  final String nameEn;
  final String dialCode;
  final String flagEmoji;

  static const kuwaitFallback = CallingCodeEntity(
    countryCode: 'KW',
    nameAr: 'الكويت',
    nameEn: 'Kuwait',
    dialCode: '+965',
    flagEmoji: '🇰🇼',
  );

  String localPhoneDigits(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    final dialDigits = dialCode.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('00$dialDigits')) {
      digits = digits.substring(dialDigits.length + 2);
    } else if (digits.startsWith(dialDigits)) {
      digits = digits.substring(dialDigits.length);
    }
    return digits;
  }

  bool hasCompleteLocalPhone(String input) =>
      localPhoneDigits(input).length >= 8;

  String formatInternationalPhone(String input) {
    final trimmed = input.trim();
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (trimmed.startsWith('+')) return '+$digits';
    if (digits.startsWith('00')) return '+${digits.substring(2)}';

    final dialDigits = dialCode.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith(dialDigits)) return '+$digits';

    final localDigits = digits.startsWith('0') ? digits.substring(1) : digits;
    return '+$dialDigits$localDigits';
  }
}
