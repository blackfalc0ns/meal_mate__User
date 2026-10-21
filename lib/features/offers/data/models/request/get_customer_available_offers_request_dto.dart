import 'package:json_annotation/json_annotation.dart';

part 'get_customer_available_offers_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class GetCustomerAvailableOffersRequestDto {
  const GetCustomerAvailableOffersRequestDto({
    this.customerId,
    this.cartAmount,
    this.durationDays,
    this.includeCampaigns,
    this.deliveryGovernorate,
    this.programId,
    this.bundleId,
    this.restaurantId,
  });

  final String? customerId;
  final double? cartAmount;
  final int? durationDays;
  final bool? includeCampaigns;
  final String? deliveryGovernorate;
  final String? programId;
  final String? bundleId;
  final String? restaurantId;

  Map<String, dynamic> toJson() =>
      _$GetCustomerAvailableOffersRequestDtoToJson(this);
}
