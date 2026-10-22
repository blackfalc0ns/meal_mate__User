import 'package:json_annotation/json_annotation.dart';

part 'payment_checkout_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class PaymentCheckoutRequestDto {
  const PaymentCheckoutRequestDto({
    required this.programId,
    required this.bundleId,
    required this.tier,
    required this.durationDays,
    required this.startDate,
    required this.callbackUrl,
    required this.errorUrl,
    required this.includeFriday,
    required this.paymentMethodId,
    required this.correlationId,
    this.promoCode,
    this.offerId,
    this.idempotencyKey,
    this.quoteId,
  });

  final String programId;
  final String bundleId;
  final String tier;
  final int durationDays;
  final String startDate;
  final String callbackUrl;
  final String errorUrl;
  final bool includeFriday;
  final int paymentMethodId;
  final String correlationId;
  @JsonKey(includeIfNull: false)
  final String? promoCode;
  @JsonKey(includeIfNull: false)
  final String? offerId;
  @JsonKey(includeIfNull: false)
  final String? idempotencyKey;
  @JsonKey(includeIfNull: false)
  final String? quoteId;

  Map<String, dynamic> toJson() => _$PaymentCheckoutRequestDtoToJson(this);
}
