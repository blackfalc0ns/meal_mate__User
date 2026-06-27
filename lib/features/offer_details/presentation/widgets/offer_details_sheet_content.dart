import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/core/widget/custom_button.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/section_header_bottom_sheet.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OfferDetailsSheetContent extends StatelessWidget {
  const OfferDetailsSheetContent({
    super.key,
    required this.offer,
    this.onClose,
    this.onPrimaryPressed,
    this.padding = const EdgeInsets.fromLTRB(20, 6, 20, 20),
    this.showCloseButton = true,
    this.showActionButton = true,
  });

  final OfferDealEntity offer;
  final VoidCallback? onClose;
  final VoidCallback? onPrimaryPressed;
  final EdgeInsetsGeometry padding;
  final bool showCloseButton;
  final bool showActionButton;

  @override
  Widget build(BuildContext context) {
    final expiryText = offer.expiryText ?? '02 يوم : 14 ساعة';
    final couponCode = offer.couponCode ?? 'SAVE20';
    final discountLabel =
        offer.discountLabel.isNotEmpty ? offer.discountLabel : '20%';
    final summaryText =
        offer.conditionsText ?? 'خصم $discountLabel على جميع الباقات الشهرية';
    final termsText =
        offer.noteText ??
        'يسري العرض على الباقات الشهرية فقط. لا يمكن دمجه مع عروض أخرى.';

    return Material(
      color: AppColors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeaderBottomSheet(
                offer: offer,
                onClose: showCloseButton ? onClose : null,
              ),
              const SizedBox(height: 16),
              OfferDetailsInfoCard(
                summaryText: summaryText,
                durationText: expiryText,
                couponCode: couponCode,
                termsText: termsText,
                accentColor: offer.accentColor,
                onCopyCode: () async {
                  await Clipboard.setData(ClipboardData(text: couponCode));
                },
              ),
              if (showActionButton) ...[
                const SizedBox(height: 18),
                CustomButton(
                  text: 'استفد الآن',
                  onPressed: onPrimaryPressed,
                  height: 48,
                  borderRadius: 12,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
