import 'package:json_annotation/json_annotation.dart';

part 'customer_referral_summary_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class CustomerReferralSummaryResponseDto {
  const CustomerReferralSummaryResponseDto({
    this.code,
    this.referralCode,
    this.rewardPercentage,
    this.totalReferrals,
    this.completedReferrals,
    this.referralCount,
    this.earnedCredits,
    this.earnedCreditsKwd,
    this.shareMessage,
    this.shareUrl,
    this.currency,
  });

  final String? code;
  final String? referralCode;
  final double? rewardPercentage;
  final int? totalReferrals;
  final int? completedReferrals;
  final int? referralCount;
  final double? earnedCredits;
  final double? earnedCreditsKwd;
  final String? shareMessage;
  final String? shareUrl;
  final String? currency;

  String get resolvedCode => code ?? referralCode ?? '';
  int get resolvedTotalReferrals => totalReferrals ?? referralCount ?? 0;
  int get resolvedCompletedReferrals => completedReferrals ?? 0;
  double get resolvedEarnedCredits => earnedCreditsKwd ?? earnedCredits ?? 0.0;
  String get resolvedCurrency => currency ?? 'KWD';

  factory CustomerReferralSummaryResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CustomerReferralSummaryResponseDtoFromJson(json);
}
