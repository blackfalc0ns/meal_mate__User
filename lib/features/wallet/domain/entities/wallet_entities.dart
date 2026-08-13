import 'package:flutter/material.dart';

enum WalletTransactionKind { refund, cardRefund, settlement, support }

enum WalletTransactionStatus { completed, processing }

class WalletEntity {
  const WalletEntity({
    required this.totalBalance,
    required this.refundableBalance,
    required this.currency,
    required this.lastUpdated,
    required this.transactions,
    required this.cards,
  });

  final String totalBalance;
  final String refundableBalance;
  final String currency;
  final String lastUpdated;
  final List<WalletTransactionEntity> transactions;
  final List<WalletCardEntity> cards;
}

class WalletTransactionEntity {
  const WalletTransactionEntity({
    required this.title,
    required this.date,
    required this.amount,
    required this.currency,
    required this.kind,
    required this.status,
  });

  final String title;
  final String date;
  final String amount;
  final String currency;
  final WalletTransactionKind kind;
  final WalletTransactionStatus status;

  IconData get icon {
    return switch (kind) {
      WalletTransactionKind.refund => Icons.refresh_rounded,
      WalletTransactionKind.cardRefund => Icons.credit_card_rounded,
      WalletTransactionKind.settlement => Icons.tune_rounded,
      WalletTransactionKind.support => Icons.support_agent_rounded,
    };
  }
}

class WalletCardEntity {
  const WalletCardEntity({
    required this.brand,
    required this.lastDigits,
    required this.expiresAt,
    required this.selected,
  });

  final String brand;
  final String lastDigits;
  final String expiresAt;
  final bool selected;
}
