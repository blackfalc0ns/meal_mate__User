import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/influencer/analytics/data/mapper/influencer_analytics_mapper.dart';
import 'package:meal_meat_user/features/influencer/analytics/data/models/influencer_analytics_dto.dart';
import 'package:meal_meat_user/features/influencer/dashboard/data/mapper/influencer_dashboard_mapper.dart';
import 'package:meal_meat_user/features/influencer/dashboard/data/models/influencer_dashboard_dto.dart';
import 'package:meal_meat_user/features/influencer/wallet/data/mapper/influencer_wallet_mapper.dart';
import 'package:meal_meat_user/features/influencer/wallet/data/models/influencer_wallet_dto.dart';
import 'package:meal_meat_user/features/influencer/wallet/domain/entities/influencer_wallet_entity.dart';

void main() {
  test('home maps server money, policy, KPI and activity values', () {
    final dto = InfluencerHomeResponseDto.fromJson({
      'totalCommissions': {'amount': 480, 'currency': 'KWD'},
      'kpis': {
        'registeredCustomers': 48,
        'linkClicks': 1250,
        'conversionRate': 3.84,
      },
      'influencerCode': 'FAHAD10',
      'wallet': {
        'availableBalance': {'amount': 145.5, 'currency': 'KWD'},
        'hasActiveWithdrawalRequest': false,
        'withdrawalPolicy': {
          'minimumAmount': 10,
          'maximumAmount': 145.5,
          'canWithdraw': true,
        },
      },
      'recentActivities': [
        {
          'activityId': 'a1',
          'activityCode': 'subscription_purchased',
          'commissionAmount': {'amount': 12.5, 'currency': 'KWD'},
          'occurredAtUtc': '2026-09-14T14:20:00Z',
        },
      ],
    });

    final entity = dto.toEntity();
    expect(entity.influencerCode, 'FAHAD10');
    expect(entity.totalCommissions.amount, 480);
    expect(entity.kpis.linkClicks, 1250);
    expect(entity.wallet.withdrawalPolicy.minimumAmount, 10);
    expect(entity.recentActivities.single.occurredAtUtc?.isUtc, isTrue);
  });

  test('unknown withdrawal status maps safely', () {
    final dto = InfluencerWithdrawalResponseDto.fromJson({
      'withdrawalId': 'w1',
      'status': 'FutureStatus',
      'amount': {'amount': 100, 'currency': 'KWD'},
    });
    expect(dto.toEntity().status, InfluencerWithdrawalStatus.unknown);
  });

  test(
    'withdrawal request contains correlation id and omits absent bank data',
    () {
      final dto = InfluencerWithdrawalRequestDto(
        amount: 100,
        withdrawalMethod: 'BankTransfer',
        saveAsDefaultBank: false,
        correlationId: 'correlation-1',
      );
      expect(dto.toJson(), {
        'amount': 100.0,
        'withdrawalMethod': 'BankTransfer',
        'saveAsDefaultBank': false,
        'correlationId': 'correlation-1',
      });
    },
  );

  test('analytics maps comparison, chart and localized packages', () {
    final entity = InfluencerAnalyticsResponseDto.fromJson({
      'period': '30d',
      'currencyCode': 'KWD',
      'comparison': {'clicksChangePercentage': 8.2},
      'earningsChart': [
        {
          'dateUtc': '2026-08-17T00:00:00Z',
          'amount': 12,
          'clicks': 45,
          'orders': 2,
        },
      ],
      'topPackages': [
        {
          'programId': 'p1',
          'bundleId': 'b1',
          'nameAr': 'باقة',
          'nameEn': 'Bundle',
          'orderCount': 38,
          'totalCommission': 228,
        },
      ],
    }).toEntity();
    expect(entity.comparison.clicksChangePercentage, 8.2);
    expect(entity.earningsChart.single.clicks, 45);
    expect(entity.topPackages.single.programId, 'p1');
  });
}
