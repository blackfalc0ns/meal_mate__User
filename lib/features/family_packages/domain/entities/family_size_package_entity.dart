class FamilySizePackageEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final int minMembers;
  final int maxMembers;
  final double discountPercent;
  final int sortOrder;
  final String? imageStorageKey;
  final String? imageUrl;

  const FamilySizePackageEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.minMembers,
    required this.maxMembers,
    required this.discountPercent,
    required this.sortOrder,
    this.imageStorageKey,
    this.imageUrl,
  });

  String name(String languageCode) {
    if (languageCode.toLowerCase().startsWith('en') && nameEn.isNotEmpty) {
      return nameEn;
    }
    return nameAr.isNotEmpty ? nameAr : nameEn;
  }

  String get discountLabel {
    final percent = discountPercent * 100;
    final formatted = percent % 1 == 0
        ? percent.toInt().toString()
        : percent.toStringAsFixed(1);
    return '$formatted%';
  }
}
