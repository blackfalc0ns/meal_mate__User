sealed class CustomerWalletEvent {
  const CustomerWalletEvent();
}

class LoadCustomerWalletEvent extends CustomerWalletEvent {
  const LoadCustomerWalletEvent();
}

class RefreshCustomerWalletEvent extends CustomerWalletEvent {
  const RefreshCustomerWalletEvent();
}

class FilterWalletTransactionsEvent extends CustomerWalletEvent {
  const FilterWalletTransactionsEvent(this.walletType);

  final String? walletType;
}

class LoadMoreWalletTransactionsEvent extends CustomerWalletEvent {
  const LoadMoreWalletTransactionsEvent();
}

class LoadCustomerReferralEvent extends CustomerWalletEvent {
  const LoadCustomerReferralEvent();
}
