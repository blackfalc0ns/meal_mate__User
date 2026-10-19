import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/wallet/domain/entities/customer_wallet_entity.dart';

class CustomerWalletState {
  const CustomerWalletState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isTransactionsLoading = false,
    this.isLoadingMore = false,
    this.wallet,
    this.transactions = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.hasMore = false,
    this.selectedWalletType,
    this.referral,
    this.failure,
    this.transactionsFailure,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isTransactionsLoading;
  final bool isLoadingMore;
  final CustomerWalletEntity? wallet;
  final List<CustomerWalletTransactionItemEntity> transactions;
  final int totalCount;
  final int currentPage;
  final bool hasMore;
  final String? selectedWalletType;
  final CustomerReferralEntity? referral;
  final Failure? failure;
  final Failure? transactionsFailure;

  bool get isEmpty =>
      !isLoading &&
      failure == null &&
      (wallet == null || (wallet!.totalBalance <= 0 && transactions.isEmpty));

  CustomerWalletState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isTransactionsLoading,
    bool? isLoadingMore,
    CustomerWalletEntity? wallet,
    List<CustomerWalletTransactionItemEntity>? transactions,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
    String? selectedWalletType,
    CustomerReferralEntity? referral,
    Failure? failure,
    Failure? transactionsFailure,
    bool clearFailure = false,
    bool clearTransactionsFailure = false,
    bool clearSelectedWalletType = false,
  }) {
    return CustomerWalletState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isTransactionsLoading:
          isTransactionsLoading ?? this.isTransactionsLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      selectedWalletType: clearSelectedWalletType
          ? null
          : (selectedWalletType ?? this.selectedWalletType),
      referral: referral ?? this.referral,
      failure: clearFailure ? null : (failure ?? this.failure),
      transactionsFailure: clearTransactionsFailure
          ? null
          : (transactionsFailure ?? this.transactionsFailure),
    );
  }
}
