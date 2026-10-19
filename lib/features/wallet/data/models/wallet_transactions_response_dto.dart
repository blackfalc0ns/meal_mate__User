import 'package:json_annotation/json_annotation.dart';

part 'wallet_transactions_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class WalletTransactionsResponseDto {
  const WalletTransactionsResponseDto({
    this.items,
    this.page,
    this.pageSize,
    this.totalCount,
  });

  final List<WalletTransactionItemDto>? items;
  final int? page;
  final int? pageSize;
  final int? totalCount;

  factory WalletTransactionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionsResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class WalletTransactionItemDto {
  const WalletTransactionItemDto({
    this.id,
    this.type,
    this.amount,
    this.walletType,
    this.description,
    this.reason,
    this.currency,
    this.referenceId,
    this.createdAtUtc,
  });

  final dynamic id;
  final String? type;
  final double? amount;
  final String? walletType;
  final String? description;
  final String? reason;
  final String? currency;
  final String? referenceId;
  final String? createdAtUtc;

  factory WalletTransactionItemDto.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionItemDtoFromJson(json);
}
