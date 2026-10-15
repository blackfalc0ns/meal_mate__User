import 'package:json_annotation/json_annotation.dart';

part 'family_renewal_checkout_request_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class FamilyRenewalCheckoutRequestDto {
  const FamilyRenewalCheckoutRequestDto({
    required this.startDate,
    required this.addressId,
    required this.callbackUrl,
    required this.errorUrl,
    this.correlationId,
    this.paymentMethodId = 3,
    this.idempotencyKey,
    this.clientContractVersion = 1,
  });

  final String startDate;
  final String addressId;
  final String callbackUrl;
  final String errorUrl;
  final String? correlationId;
  final int paymentMethodId;
  final String? idempotencyKey;
  final int? clientContractVersion;

  factory FamilyRenewalCheckoutRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyRenewalCheckoutRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FamilyRenewalCheckoutRequestDtoToJson(this);
}
