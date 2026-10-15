import 'package:meal_meat_user/features/family_checkout/domain/entities/family_checkout_selection_entity.dart';

class FamilyCheckoutSelectionResponseDto {
  const FamilyCheckoutSelectionResponseDto({
    this.batchId,
    this.batchVersion,
    this.memberId,
    this.checkoutSelected,
    this.selectedNewSubscriberCount,
  });

  final String? batchId;
  final int? batchVersion;
  final String? memberId;
  final bool? checkoutSelected;
  final int? selectedNewSubscriberCount;

  factory FamilyCheckoutSelectionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return FamilyCheckoutSelectionResponseDto(
      batchId: json['batchId'] as String?,
      batchVersion: json['batchVersion'] is num
          ? (json['batchVersion'] as num).toInt()
          : (json['batchVersion'] != null
                ? int.tryParse(json['batchVersion'].toString())
                : null),
      memberId: (json['memberId'] ?? json['id']) as String?,
      checkoutSelected:
          json['checkoutSelected'] as bool? ?? json['subscribeNow'] as bool?,
      selectedNewSubscriberCount: json['selectedNewSubscriberCount'] is num
          ? (json['selectedNewSubscriberCount'] as num).toInt()
          : (json['selectedNewSubscriberCount'] != null
                ? int.tryParse(json['selectedNewSubscriberCount'].toString())
                : null),
    );
  }

  FamilyCheckoutSelectionEntity toEntity() {
    return FamilyCheckoutSelectionEntity(
      batchId: batchId ?? '',
      batchVersion: batchVersion ?? 0,
      memberId: memberId ?? '',
      checkoutSelected: checkoutSelected ?? false,
      selectedNewSubscriberCount: selectedNewSubscriberCount ?? 0,
    );
  }
}
