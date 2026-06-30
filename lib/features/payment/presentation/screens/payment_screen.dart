import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_order_summary_card.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/payment/data/payment_fake_data.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/card_details_form.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_footer.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/payment_method_selector.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethodType _selectedMethod = PaymentMethodType.mada;
  bool _isProcessing = false;

  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _holderNameCtrl = TextEditingController();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _holderNameCtrl.dispose();
    super.dispose();
  }

  bool get _showCardForm =>
      _selectedMethod == PaymentMethodType.mada ||
      _selectedMethod == PaymentMethodType.visa;

  Future<void> _handlePayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    Navigator.of(context).pushNamed(AppRoutes.paymentSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.payment_title,
       
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 8, bottom: 18),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
                  child: AppOrderSummaryCard(
                    planTitle: l10n.payment_plan_month,
                    planDuration: l10n.payment_plan_duration,
                    mealsPerDay: l10n.payment_plan_meals,
                    originalPrice: '52.000',
                    discountAmount: '10.400',
                    totalPrice: '41.600',
                    imageAsset: 'assets/images/offers/meal_boxes.png',
                    couponHint: l10n.payment_coupon_hint,
                  ),
                ),
                const SizedBox(height: 16),
                PaymentMethodSelector(
                  methods: PaymentFakeData.paymentMethods,
                  selectedType: _selectedMethod,
                  onMethodSelected: (type) =>
                      setState(() => _selectedMethod = type),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _showCardForm
                      ? Padding(
                          padding: const EdgeInsets.only(top: Spacing.base),
                          child: CardDetailsForm(
                            cardNumberController: _cardNumberCtrl,
                            expiryController: _expiryCtrl,
                            cvvController: _cvvCtrl,
                            holderNameController: _holderNameCtrl,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: Spacing.base),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PaymentFooter(
        totalAmount: PaymentFakeData.orderSummary.totalAfterDiscount,
        isLoading: _isProcessing,
        onPayNow: _handlePayment,
      ),
    );
  }
}
