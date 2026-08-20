class FamilySizePackageResponseDto {
  final String id;
  final String nameAr;
  final String nameEn;
  final int minMembers;
  final int maxMembers;
  final double discountPercent;
  final int sortOrder;
  final String? imageStorageKey;
  final String? imageUrl;

  FamilySizePackageResponseDto({
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

  factory FamilySizePackageResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilySizePackageResponseDto(
      id: json['id'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      minMembers: json['minMembers'] as int? ?? 1,
      maxMembers: json['maxMembers'] as int? ?? 1,
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
      sortOrder: json['sortOrder'] as int? ?? 0,
      imageStorageKey: json['imageStorageKey'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'minMembers': minMembers,
        'maxMembers': maxMembers,
        'discountPercent': discountPercent,
        'sortOrder': sortOrder,
        'imageStorageKey': imageStorageKey,
        'imageUrl': imageUrl,
      };
}
