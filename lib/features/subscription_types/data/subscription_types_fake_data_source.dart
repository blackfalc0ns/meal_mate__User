import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';

class SubscriptionTypesFakeDataSource {
  const SubscriptionTypesFakeDataSource();

  List<SubscriptionTypeEntity> getSubscriptionTypes() => const [
    SubscriptionTypeEntity(
      code: 'INDIVIDUAL',
      nameAr: '',
      nameEn: '',
      descriptionAr: '',
      descriptionEn: '',
      maxMembers: 1,
      isAvailable: true,
      membersConfiguredAfterPayment: false,
      requiresConversion: false,
      imageAsset: Assets.subscriptionTypeIndividualProduct,
    ),
    SubscriptionTypeEntity(
      code: 'FAMILY',
      nameAr: '',
      nameEn: '',
      descriptionAr: '',
      descriptionEn: '',
      maxMembers: 4,
      isAvailable: true,
      membersConfiguredAfterPayment: true,
      requiresConversion: false,
      imageAsset: Assets.subscriptionTypeFamilyProduct,
    ),
  ];
}
