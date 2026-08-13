import 'package:meal_meat_user/features/wallet/domain/entities/wallet_entities.dart';

class WalletFakeDataSource {
  const WalletFakeDataSource();

  WalletEntity loadWallet() {
    return const WalletEntity(
      totalBalance: '152.3',
      refundableBalance: '32.500',
      currency: 'د.ك',
      lastUpdated: 'اليوم 09:15 ص',
      cards: [
        WalletCardEntity(
          brand: 'Mastercard',
          lastDigits: '4582',
          expiresAt: '06 / 27',
          selected: true,
        ),
        WalletCardEntity(
          brand: 'Visa',
          lastDigits: '7314',
          expiresAt: '06 / 27',
          selected: false,
        ),
      ],
      transactions: [
        WalletTransactionEntity(
          title: 'استرداد من إلغاء اشتراك',
          date: '8 مايو 2026، 09:15 ص',
          amount: '18.750',
          currency: 'د.ك',
          kind: WalletTransactionKind.refund,
          status: WalletTransactionStatus.completed,
        ),
        WalletTransactionEntity(
          title: 'تسوية يدوية',
          date: '3 مايو 2026، 09:15 ص',
          amount: '6.250',
          currency: 'د.ك',
          kind: WalletTransactionKind.settlement,
          status: WalletTransactionStatus.completed,
        ),
        WalletTransactionEntity(
          title: 'استرداد إلى البطاقة قيد المعالجة',
          date: '1 مايو 2026، 09:15 ص',
          amount: '6.500',
          currency: 'د.ك',
          kind: WalletTransactionKind.cardRefund,
          status: WalletTransactionStatus.processing,
        ),
        WalletTransactionEntity(
          title: 'استرداد إلى البطاقة',
          date: '09:05 ص',
          amount: '6.250',
          currency: 'د.ك',
          kind: WalletTransactionKind.cardRefund,
          status: WalletTransactionStatus.processing,
        ),
        WalletTransactionEntity(
          title: 'تسوية خدمة العملاء',
          date: '08:40 ص',
          amount: '6.500',
          currency: 'د.ك',
          kind: WalletTransactionKind.support,
          status: WalletTransactionStatus.completed,
        ),
      ],
    );
  }

  List<WalletTransactionEntity> loadWeeklyTransactions() {
    return const [
      WalletTransactionEntity(
        title: 'استرداد إلى البطاقة',
        date: '3 مايو 2026، 02:40 م',
        amount: '12.000',
        currency: 'د.ك',
        kind: WalletTransactionKind.cardRefund,
        status: WalletTransactionStatus.completed,
      ),
    ];
  }

  List<WalletTransactionEntity> loadAprilTransactions() {
    return const [
      WalletTransactionEntity(
        title: 'استرداد من إلغاء اشتراك',
        date: '7 أبريل 2026، 11:30 ص',
        amount: '12.000',
        currency: 'د.ك',
        kind: WalletTransactionKind.refund,
        status: WalletTransactionStatus.completed,
      ),
    ];
  }
}
