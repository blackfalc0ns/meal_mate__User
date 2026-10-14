import 'package:json_annotation/json_annotation.dart';

part 'family_checkout_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class FamilyCheckoutRequestDto {
  const FamilyCheckoutRequestDto({
    required this.callbackUrl,
    required this.errorUrl,
    this.correlationId,
    required this.paymentMethodId,
    this.idempotencyKey,
    this.batchId,
    this.batchVersion,
    this.clientContractVersion = 1,
  });

  final String callbackUrl;
  final String errorUrl;
  final String? correlationId;
  final int paymentMethodId;
  final String? idempotencyKey;
  final String? batchId;
  final int? batchVersion;
  final int? clientContractVersion;

  Map<String, dynamic> toJson() => _$FamilyCheckoutRequestDtoToJson(this);
}

