import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_api_entity.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/repo/influencer_dashboard_repository.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/usecase/get_influencer_home_usecase.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/usecase/get_influencer_links_usecase.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/manager/influencer_dashboard_event.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/manager/influencer_dashboard_view_model.dart';

void main() {
  test('dashboard loads once unless force refreshed', () async {
    final repo = _DashboardRepo();
    final vm = InfluencerDashboardViewModel(
      GetInfluencerHomeUseCase(repo),
      GetInfluencerLinksUseCase(repo),
    );
    await vm.doIntent(const LoadInfluencerDashboardEvent());
    await vm.doIntent(const LoadInfluencerDashboardEvent());
    expect(repo.homeCalls, 1);
    expect(vm.state.home?.influencerCode, 'CODE');
    await vm.doIntent(const LoadInfluencerDashboardEvent(forceRefresh: true));
    expect(repo.homeCalls, 2);
  });
}

class _DashboardRepo implements InfluencerDashboardRepository {
  int homeCalls = 0;
  @override
  Future<ApiResult<InfluencerHomeApiEntity>> getHome() async {
    homeCalls++;
    return ApiSuccessResult(data: _home);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _money = InfluencerDashboardMoneyEntity(amount: 0, currency: 'KWD');
const _bank = InfluencerDashboardBankEntity(
  bankName: '',
  accountHolderName: '',
  maskedIban: '',
  isConfigured: false,
);
const _policy = InfluencerDashboardPolicyEntity(
  minimumAmount: 10,
  maximumAmount: 0,
  currencyCode: 'KWD',
  canWithdraw: false,
);
const _kpis = InfluencerDashboardKpisEntity(
  registeredCustomers: 0,
  completedSubscriptions: 0,
  linkClicks: 0,
  conversionRate: 0,
  registeredCustomersDiff: 0,
  completedSubscriptionsDiff: 0,
  linkClicksDiff: 0,
  conversionRateDiff: 0,
);
const _wallet = InfluencerDashboardWalletEntity(
  availableBalance: _money,
  pendingBalance: _money,
  lifetimeEarnings: _money,
  thisMonthEarned: _money,
  thisMonthWithdrawn: _money,
  currencyCode: 'KWD',
  hasActiveWithdrawalRequest: false,
  withdrawalPolicy: _policy,
  bankInfo: _bank,
);
const _home = InfluencerHomeApiEntity(
  totalCommissions: _money,
  thisWeekCommissionsDiff: _money,
  kpis: _kpis,
  influencerCode: 'CODE',
  referralLink: 'link',
  qrCodeData: 'link',
  wallet: _wallet,
  bankInfo: _bank,
  recentActivities: [],
);
