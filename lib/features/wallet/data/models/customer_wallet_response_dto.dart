import 'package:json_annotation/json_annotation.dart';

part 'customer_wallet_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CustomerWalletResponseDto {
  const CustomerWalletResponseDto({
    this.cashBalanceKwd,
    this.cashBalance,
    this.promotionalBalanceKwd,
    this.promotionalBalance,
    this.totalAvailableBalanceKwd,
    this.totalBalance,
    this.currencyCode,
    this.currency,
    this.updatedAtUtc,
  });

  final double? cashBalanceKwd;
  final double? cashBalance;
  final double? promotionalBalanceKwd;
  final double? promotionalBalance;
  final double? totalAvailableBalanceKwd;
  final double? totalBalance;
  final String? currencyCode;
  final String? currency;
  final String? updatedAtUtc;

  double get resolvedCashBalance => cashBalanceKwd ?? cashBalance ?? 0.0;
  double get resolvedPromotionalBalance =>
      promotionalBalanceKwd ?? promotionalBalance ?? 0.0;
  double get resolvedTotalBalance =>
      totalAvailableBalanceKwd ??
      totalBalance ??
      (resolvedCashBalance + resolvedPromotionalBalance);
  String get resolvedCurrency => currencyCode ?? currency ?? 'KWD';

  factory CustomerWalletResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerWalletResponseDtoFromJson(json);
}
