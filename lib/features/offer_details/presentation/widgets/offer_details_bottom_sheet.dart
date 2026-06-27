import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_sheet_content.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OfferDetailsBottomSheet extends StatelessWidget {
  const OfferDetailsBottomSheet({super.key, required this.offer});

  final OfferDealEntity offer;

  static Future<T?> show<T>(BuildContext context, OfferDealEntity offer) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.18),
      builder: (_) => OfferDetailsBottomSheet(offer: offer),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.82;

    return SizedBox(
      height: height,
      child: OfferDetailsSheetContent(
        offer: offer,
        onClose: () => Navigator.of(context).pop(),
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, AppRoutes.offerDetails);
        },
      ),
    );
  }
}
