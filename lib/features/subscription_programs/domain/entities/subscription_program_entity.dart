import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';

class SubscriptionProgramEntity {
  const SubscriptionProgramEntity({
    required this.programId,
    required this.code,
    required this.shortCode,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.keywordsAr,
    required this.keywordsEn,
    required this.imageUrl,
    required this.bundleCount,
    required this.supportedSlots,
    required this.fallbackImageAsset,
    this.isAvailable = true,
    this.disabledReason,
    this.availability,
  });

  final String programId;
  final String code;
  final String shortCode;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final List<String> keywordsAr;
  final List<String> keywordsEn;
  final String? imageUrl;
  final int bundleCount;
  final List<String> supportedSlots;
  final String fallbackImageAsset;
  final bool isAvailable;
  final String? disabledReason;
  final SubscriptionAvailabilityEntity? availability;

  bool get canSelect {
    if (!isAvailable) return false;
    if (availability != null) {
      if (!availability!.effectiveCanSelect) return false;
      if (!availability!.isAddressRequired &&
          availability!.coveredRestaurantCount == 0 &&
          availability!.canSelect != true) {
        return false;
      }
    }
    return true;
  }

  String name(String localeName) => localeName == 'ar' ? nameAr : nameEn;

  String description(String localeName) =>
      localeName == 'ar' ? descriptionAr : descriptionEn;

  List<String> keywords(String localeName) =>
      localeName == 'ar' ? keywordsAr : keywordsEn;
}
