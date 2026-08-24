import 'package:meal_meat_user/features/family_packages/data/models/response/family_size_package_response_dto.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';

extension FamilySizePackageResponseDtoMapper on FamilySizePackageResponseDto {
  FamilySizePackageEntity toEntity() {
    return FamilySizePackageEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      minMembers: minMembers,
      maxMembers: maxMembers,
      discountPercent: discountPercent,
      sortOrder: sortOrder,
      imageStorageKey: imageStorageKey,
      imageUrl: imageUrl,
    );
  }
}
