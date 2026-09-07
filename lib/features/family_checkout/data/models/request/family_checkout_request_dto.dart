import 'package:json_annotation/json_annotation.dart';

part 'family_checkout_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class FamilyCheckoutRequestDto {
  const FamilyCheckoutRequestDto({
    required this.callbackUrl,
    required this.errorUrl,
    required this.correlationId,
    required this.paymentMethodId,
  });

  final String callbackUrl;
  final String errorUrl;
  final String correlationId;
  final int paymentMethodId;

  Map<String, dynamic> toJson() => _$FamilyCheckoutRequestDtoToJson(this);
}
