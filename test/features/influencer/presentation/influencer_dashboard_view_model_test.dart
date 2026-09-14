import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_api_entities.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/repo/influencer_repository.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/usecase/influencer_read_usecases.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/manager/influencer_dashboard_view_model.dart';

void main() {
  test('dashboard loads once unless force refreshed', () async {
    final repo = _Repo();
    final vm = InfluencerDashboardViewModel(
      GetInfluencerHomeUseCase(repo),
      GetInfluencerProfileUseCase(repo),
    );
    await vm.load();
    await vm.load();
    expect(repo.homeCalls, 1);
    expect(vm.state.home?.influencerCode, 'CODE');
    await vm.load(forceRefresh: true);
    expect(repo.homeCalls, 2);
  });
}

class _Repo implements InfluencerRepository {
  int homeCalls = 0;
  @override
  Future<ApiResult<InfluencerHomeApiEntity>> getHome() async {
    homeCalls++;
    return ApiSuccessResult(data: _home);
  }

  @override
  Future<ApiResult<InfluencerProfileApiEntity>> getProfile() async =>
      ApiSuccessResult(data: _profile);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _money = InfluencerMoneyEntity(amount: 0, currency: 'KWD');
const _bank = InfluencerBankInfoEntity(
  bankName: '',
  accountHolderName: '',
  maskedIban: '',
  isConfigured: false,
);
const _policy = InfluencerWithdrawalPolicyEntity(
  minimumAmount: 10,
  maximumAmount: 0,
  currencyCode: 'KWD',
  canWithdraw: false,
);
const _kpis = InfluencerKpisEntity(
  registeredCustomers: 0,
  completedSubscriptions: 0,
  linkClicks: 0,
  conversionRate: 0,
  registeredCustomersDiff: 0,
  completedSubscriptionsDiff: 0,
  linkClicksDiff: 0,
  conversionRateDiff: 0,
);
const _wallet = InfluencerWalletApiEntity(
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
const _profile = InfluencerProfileApiEntity(
  id: 'id',
  displayName: 'Name',
  code: 'CODE',
  commissionRate: 10,
  status: 'Active',
  isActive: true,
  hasCompletedSocialOnboarding: true,
  socialLinks: InfluencerSocialLinksEntity(),
  bankInfo: _bank,
);
