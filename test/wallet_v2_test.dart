import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/wallet/data/mapper/customer_wallet_mapper.dart';
import 'package:meal_meat_user/features/wallet/data/models/customer_referral_summary_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/customer_wallet_response_dto.dart';
import 'package:meal_meat_user/features/wallet/data/models/wallet_transactions_response_dto.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/customer_wallet_entity.dart';
import 'package:meal_meat_user/features/wallet/domain/repo/customer_wallet_repository.dart';
import 'package:meal_meat_user/features/wallet/domain/usecase/get_customer_referral_summary_usecase.dart';
import 'package:meal_meat_user/features/wallet/domain/usecase/get_customer_wallet_transactions_usecase.dart';
import 'package:meal_meat_user/features/wallet/domain/usecase/get_customer_wallet_usecase.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_event.dart';
import 'package:meal_meat_user/features/wallet/presentation/manager/customer_wallet_view_model.dart';

class MockCustomerWalletRepository implements CustomerWalletRepository {
  ApiResult<CustomerWalletEntity>? walletResult;
  ApiResult<CustomerWalletTransactionsEntity>? transactionsResult;
  ApiResult<CustomerReferralEntity>? referralResult;

  String? lastWalletType;
  int? lastPage;
  int? lastPageSize;

  @override
  Future<ApiResult<CustomerWalletEntity>> getWallet() async {
    return walletResult ??
        const ApiSuccessResult(
          data: CustomerWalletEntity(
            totalBalance: 25.000,
            cashBalance: 15.000,
            promotionalBalance: 10.000,
            currency: 'KWD',
          ),
        );
  }

  @override
  Future<ApiResult<CustomerWalletTransactionsEntity>> getTransactions({
    String? walletType,
    int? page,
    int? pageSize,
  }) async {
    lastWalletType = walletType;
    lastPage = page;
    lastPageSize = pageSize;

    return transactionsResult ??
        ApiSuccessResult(
          data: CustomerWalletTransactionsEntity(
            page: page ?? 1,
            pageSize: pageSize ?? 20,
            totalCount: 2,
            items: const [
              CustomerWalletTransactionItemEntity(
                id: 'tx_1',
                type: 'credit',
                amount: 5.0,
                currency: 'KWD',
                walletType: 'cash',
                description: 'Referral reward',
              ),
              CustomerWalletTransactionItemEntity(
                id: 'tx_2',
                type: 'debit',
                amount: 2.0,
                currency: 'KWD',
                walletType: 'promotional',
                description: 'Order discount applied',
              ),
            ],
          ),
        );
  }

  @override
  Future<ApiResult<CustomerReferralEntity>> getReferralsSummary() async {
    return referralResult ??
        const ApiSuccessResult(
          data: CustomerReferralEntity(
            code: 'AHMED50',
            rewardPercentage: 10.0,
            totalReferrals: 5,
            completedReferrals: 3,
            earnedCredits: 15.0,
            currency: 'KWD',
            shareMessage: 'Use my code AHMED50',
            shareUrl: 'https://mealmate.app/r/AHMED50',
          ),
        );
  }
}

void main() {
  group('Customer Wallet & Referrals v2 tests', () {
    test('CustomerWalletResponseDto maps separate balances and keeps total balance as returned', () {
      final dto = CustomerWalletResponseDto.fromJson(const {
        'totalBalance': 12.500,
        'cashBalance': 10.000,
        'promotionalBalance': 2.500,
        'currency': 'KWD',
        'isPromotionalExpiringSoon': true,
        'nextExpiringPromotionalAmount': 1.250,
        'nextExpiringAtUtc': '2026-05-01T00:00:00Z',
      });

      final entity = dto.toEntity();
      expect(entity.totalBalance, 12.500);
      expect(entity.cashBalance, 10.000);
      expect(entity.promotionalBalance, 2.500);
      expect(entity.currency, 'KWD');
    });

    test('WalletTransactionsResponseDto maps paged ledger and item details', () {
      final dto = WalletTransactionsResponseDto.fromJson(const {
        'page': 1,
        'pageSize': 20,
        'totalCount': 25,
        'items': [
          {
            'id': 'tx_1',
            'type': 'credit',
            'amount': 5.000,
            'currency': 'KWD',
            'walletType': 'cash',
            'reason': 'Referral reward',
            'referenceId': 'ref_123',
            'createdAtUtc': '2026-04-10T12:00:00Z',
          },
        ],
      });

      final entity = dto.toEntity();
      expect(entity.page, 1);
      expect(entity.pageSize, 20);
      expect(entity.totalCount, 25);
      expect(entity.hasMore, isTrue);
      expect(entity.items.length, 1);
      expect(entity.items.first.id, 'tx_1');
      expect(entity.items.first.description, 'Referral reward');
      expect(entity.items.first.walletType, 'cash');
    });

    test('CustomerReferralSummaryResponseDto maps referral code, rates, and share data', () {
      final dto = CustomerReferralSummaryResponseDto.fromJson(const {
        'code': 'AHMED50',
        'rewardPercentage': 10.0,
        'totalReferrals': 5,
        'completedReferrals': 3,
        'earnedCredits': 15.000,
        'currency': 'KWD',
        'shareMessage': 'Use my code AHMED50',
        'shareUrl': 'https://mealmate.app/r/AHMED50',
      });

      final entity = dto.toEntity();
      expect(entity.code, 'AHMED50');
      expect(entity.rewardPercentage, 10.0);
      expect(entity.totalReferrals, 5);
      expect(entity.completedReferrals, 3);
      expect(entity.earnedCredits, 15.000);
      expect(entity.shareUrl, 'https://mealmate.app/r/AHMED50');
    });

    test('CustomerWalletViewModel loads balances and transactions', () async {
      final repo = MockCustomerWalletRepository();
      final vm = CustomerWalletViewModel(
        GetCustomerWalletUseCase(repo),
        GetCustomerWalletTransactionsUseCase(repo),
        GetCustomerReferralSummaryUseCase(repo),
      );

      vm.doIntent(const LoadCustomerWalletEvent());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(vm.state.isLoading, isFalse);
      expect(vm.state.wallet?.totalBalance, 25.0);
      expect(vm.state.wallet?.cashBalance, 15.0);
      expect(vm.state.wallet?.promotionalBalance, 10.0);
      expect(vm.state.transactions.length, 2);
    });

    test('CustomerWalletViewModel filters by walletType and resets page', () async {
      final repo = MockCustomerWalletRepository();
      final vm = CustomerWalletViewModel(
        GetCustomerWalletUseCase(repo),
        GetCustomerWalletTransactionsUseCase(repo),
        GetCustomerReferralSummaryUseCase(repo),
      );

      vm.doIntent(const FilterWalletTransactionsEvent('promotional'));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(repo.lastWalletType, 'promotional');
      expect(repo.lastPage, 1);
      expect(vm.state.selectedWalletType, 'promotional');
    });

    test('CustomerWalletViewModel appends on loadMore', () async {
      final repo = MockCustomerWalletRepository();
      repo.transactionsResult = const ApiSuccessResult(
        data: CustomerWalletTransactionsEntity(
          page: 1,
          pageSize: 2,
          totalCount: 4,
          items: [
            CustomerWalletTransactionItemEntity(
              id: 'tx_1',
              type: 'credit',
              amount: 5.0,
              currency: 'KWD',
              walletType: 'cash',
              description: 'First',
            ),
          ],
        ),
      );

      final vm = CustomerWalletViewModel(
        GetCustomerWalletUseCase(repo),
        GetCustomerWalletTransactionsUseCase(repo),
        GetCustomerReferralSummaryUseCase(repo),
      );

      vm.doIntent(const LoadCustomerWalletEvent());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(vm.state.transactions.length, 1);
      expect(vm.state.hasMore, isTrue);

      // Now prepare page 2
      repo.transactionsResult = const ApiSuccessResult(
        data: CustomerWalletTransactionsEntity(
          page: 2,
          pageSize: 2,
          totalCount: 4,
          items: [
            CustomerWalletTransactionItemEntity(
              id: 'tx_2',
              type: 'credit',
              amount: 10.0,
              currency: 'KWD',
              walletType: 'cash',
              description: 'Second',
            ),
          ],
        ),
      );

      vm.doIntent(const LoadMoreWalletTransactionsEvent());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(vm.state.transactions.length, 2);
      expect(vm.state.transactions[0].id, 'tx_1');
      expect(vm.state.transactions[1].id, 'tx_2');
    });

    test('CustomerWalletViewModel preserves stale data on refresh failure', () async {
      final repo = MockCustomerWalletRepository();
      final vm = CustomerWalletViewModel(
        GetCustomerWalletUseCase(repo),
        GetCustomerWalletTransactionsUseCase(repo),
        GetCustomerReferralSummaryUseCase(repo),
      );

      vm.doIntent(const LoadCustomerWalletEvent());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(vm.state.wallet, isNotNull);

      // Trigger refresh with failure
      repo.walletResult = ApiErrorResult(
        failure: ServerFailure(
          code: 'network_error',
          errorMessage: 'Server down',
          exception: const ApiException(
            message: 'Server down',
            statusCode: 500,
            errorType: ApiErrorType.serverError,
          ),
        ),
      );

      vm.doIntent(const RefreshCustomerWalletEvent());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(vm.state.failure, isNotNull);
      expect(vm.state.wallet?.totalBalance, 25.0); // Preserved!
    });
  });
}
