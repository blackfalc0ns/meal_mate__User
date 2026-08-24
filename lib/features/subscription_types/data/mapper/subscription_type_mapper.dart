import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscription_types/data/models/response/subscription_type_response_dto.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';

extension SubscriptionTypeResponseDtoMapper on SubscriptionTypeResponseDto {
  SubscriptionTypeEntity toEntity() {
    final normalizedCode = code ?? '';

    return SubscriptionTypeEntity(
      code: normalizedCode,
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      descriptionAr: descriptionAr ?? '',
      descriptionEn: descriptionEn ?? '',
      maxMembers: maxMembers ?? 0,
      isAvailable: isAvailable ?? false,
      membersConfiguredAfterPayment: membersConfiguredAfterPayment ?? false,
      disabledReason: disabledReason,
      requiresConversion: requiresConversion ?? false,
      conversionEndpoint: conversionEndpoint,
      imageAsset: _imageAssetForCode(normalizedCode),
    );
  }

  String _imageAssetForCode(String code) {
    return code == 'FAMILY'
        ? Assets.subscriptionTypeFamilyProduct
        : Assets.subscriptionTypeIndividualProduct;
  }
}
