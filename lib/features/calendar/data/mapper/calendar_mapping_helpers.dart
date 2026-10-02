part of 'calendar_mapper.dart';

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

DateTime? _parseDateTime(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

String _localized(
  String localeName, {
  String? ar,
  String? en,
  String? fallback,
}) {
  final value = localeName.startsWith('ar')
      ? ar ?? fallback ?? en
      : en ?? fallback ?? ar;
  return value ?? '';
}

List<String> _localizedList(
  String localeName, {
  List<String>? ar,
  List<String>? en,
  List<String>? fallback,
}) {
  final values = localeName.startsWith('ar')
      ? ar ?? fallback ?? en
      : en ?? fallback ?? ar;
  return (values ?? const [])
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList();
}

String _firstNotEmpty(List<String?> values) {
  return _firstNullableNotEmpty(values) ?? '';
}

String? _firstNullableNotEmpty(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}

int? _wholeNumber(num? value) {
  if (value == null) return null;
  return value.round();
}

String _deliveryWindowText({
  String? deliveryTimeText,
  String? deliveryWindowStart,
  String? deliveryWindowEnd,
}) {
  final providedText = _firstNullableNotEmpty([deliveryTimeText]);
  if (providedText != null) return providedText;

  final start = _firstNullableNotEmpty([deliveryWindowStart]);
  final end = _firstNullableNotEmpty([deliveryWindowEnd]);
  if (start == null && end == null) return '';
  if (start == null) return end!;
  if (end == null) return start;
  return '$start - $end';
}

String _formatWeekday(DateTime date, String localeName) {
  try {
    return DateFormat.E(localeName).format(date);
  } catch (_) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
