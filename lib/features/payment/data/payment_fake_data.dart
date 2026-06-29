import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

/// ─────────────────────────────────────────────────────────────
/// Fake data source for the Payment feature (no real API yet).
/// ─────────────────────────────────────────────────────────────
class PaymentFakeData {
  PaymentFakeData._();

  static const OrderSummaryEntity orderSummary = OrderSummaryEntity(
    planName: 'باقة شهر',
    planDuration: '26 يوم',
    planMeals: '4 وجبات يومياً',
    basePrice: 52.000,
    discountAmount: 10.400,
    totalAfterDiscount: 41.600,
    couponCode: 'MEAL20',
  );

  static const List<PaymentMethodEntity> paymentMethods = [
    PaymentMethodEntity(
      type: PaymentMethodType.mada,
      title: 'بطاقة مدى',
      subtitle: 'ادفع باستخدام بطاقات مدى',
    ),
    PaymentMethodEntity(
      type: PaymentMethodType.visa,
      title: 'بطاقة ائتمانية / خصم مباشر',
      subtitle: 'Visa, Mastercard',
    ),
    PaymentMethodEntity(
      type: PaymentMethodType.applePay,
      title: 'Apple Pay',
      subtitle: 'ادفع باستخدام Apple pay',
    ),
    PaymentMethodEntity(
      type: PaymentMethodType.wallet,
      title: 'محفظة MealMate',
      subtitle: 'الرصيد المتاح :',
      walletBalance: 120.500,
    ),
  ];
}
