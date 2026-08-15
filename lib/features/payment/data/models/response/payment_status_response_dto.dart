import 'package:json_annotation/json_annotation.dart';

part 'payment_status_response_dto.g.dart';

@JsonSerializable()
class PaymentStatusResponseDto {
  const PaymentStatusResponseDto({
    this.paymentStatus,
    this.isPaid,
    this.isFailed,
    this.amount,
    this.currencyCode,
  });

  final String? paymentStatus;
  final bool? isPaid;
  final bool? isFailed;
  final double? amount;
  final String? currencyCode;

  factory PaymentStatusResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentStatusResponseDtoToJson(this);
}
