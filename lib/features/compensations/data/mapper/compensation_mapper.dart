import '../../domain/entities/compensation_entity.dart';
import '../../domain/entities/alternative_date_entity.dart';
import '../../domain/entities/compensation_choice_entity.dart';
import '../../domain/entities/choose_compensation_request_entity.dart';
import '../models/response/compensation_response_dto.dart';
import '../models/response/alternative_date_response_dto.dart';
import '../models/response/compensation_choice_response_dto.dart';
import '../models/request/choose_compensation_request_dto.dart';

extension CompensationMapper on CompensationResponseDto {
  CompensationEntity toEntity() => CompensationEntity(
    id: compensationId ?? '',
    subscriptionId: subscriptionId ?? '',
    beneficiaryFamilyMemberId: beneficiaryFamilyMemberId,
    failedServiceDate: failedServiceDate ?? '',
    status: status ?? '',
    totalAmount: totalAmount,
    currency: currency ?? '',
    cardRefundAmount: refundBreakdown?.cardRefundAmount,
    walletRefundAmount: refundBreakdown?.walletRefundAmount,
    apologyCreditAmount: refundBreakdown?.apologyCreditAmount,
    eligibleForAlternativeDay:
        eligibleForAlternativeDay ?? eligibleForFreeDay ?? false,
    choiceDeadlineUtc: DateTime.tryParse(choiceDeadlineUtc ?? '')?.toUtc(),
    serverTimeUtc: DateTime.tryParse(serverTimeUtc ?? '')?.toUtc(),
    selectedAlternativeDate: selectedAlternativeDate,
  );
}

extension AlternativeDateMapper on AlternativeDateResponseDto {
  AlternativeDateEntity toEntity() => AlternativeDateEntity(
    date: date ?? '',
    isAvailable: isAvailable == true && DateTime.tryParse(date ?? '') != null,
  );
}

extension CompensationChoiceMapper on CompensationChoiceResponseDto {
  CompensationChoiceEntity toEntity() => CompensationChoiceEntity(
    id: compensationId ?? '',
    status: status ?? '',
    selectedAlternativeDate: selectedAlternativeDate,
  );
}

extension ChooseCompensationMapper on ChooseCompensationRequestEntity {
  ChooseCompensationRequestDto toDto() => ChooseCompensationRequestDto(
    choice: choice == CompensationChoice.cashRefund
        ? 'CashRefund'
        : 'AlternativeDay',
    targetDate: choice == CompensationChoice.alternativeDay ? targetDate : null,
  );
}
