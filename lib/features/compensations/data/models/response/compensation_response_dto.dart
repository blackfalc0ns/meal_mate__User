import 'package:json_annotation/json_annotation.dart';

part 'compensation_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CompensationResponseDto {
  const CompensationResponseDto({
    this.compensationId,
    this.subscriptionId,
    this.beneficiaryFamilyMemberId,
    this.failedServiceDate,
    this.totalAmount,
    this.currency,
    this.refundBreakdown,
    this.choiceDeadlineUtc,
    this.serverTimeUtc,
    this.status,
    this.eligibleForAlternativeDay,
    this.eligibleForFreeDay,
    this.selectedAlternativeDate,
  });
  final String? compensationId, subscriptionId, beneficiaryFamilyMemberId;
  final String? failedServiceDate,
      currency,
      choiceDeadlineUtc,
      serverTimeUtc,
      status;
  final String? selectedAlternativeDate;
  final double? totalAmount;
  final RefundBreakdownResponseDto? refundBreakdown;
  final bool? eligibleForAlternativeDay, eligibleForFreeDay;
  factory CompensationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CompensationResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class RefundBreakdownResponseDto {
  const RefundBreakdownResponseDto({
    this.cardRefundAmount,
    this.walletRefundAmount,
    this.apologyCreditAmount,
  });
  final double? cardRefundAmount, walletRefundAmount, apologyCreditAmount;
  factory RefundBreakdownResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RefundBreakdownResponseDtoFromJson(json);
}
