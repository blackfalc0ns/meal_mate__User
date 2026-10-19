import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_contract_constants.dart';

part 'family_checkout_request_dto.g.dart';

@JsonSerializable(createFactory: false, includeIfNull: false)
class FamilyCheckoutRequestDto {
  const FamilyCheckoutRequestDto({
    required this.callbackUrl,
    required this.errorUrl,
    this.correlationId,
    this.paymentMethodId,
    this.idempotencyKey,
    this.batchId,
    this.batchVersion,
    this.clientContractVersion =
        FamilyCheckoutContractConstants.clientContractVersion,
    this.promoCode,
  });

  final String callbackUrl;
  final String errorUrl;
  final String? correlationId;
  final int? paymentMethodId;
  final String? idempotencyKey;
  final String? batchId;
  final int? batchVersion;
  final int? clientContractVersion;
  final String? promoCode;

  Map<String, dynamic> toJson() => _$FamilyCheckoutRequestDtoToJson(this);
}
