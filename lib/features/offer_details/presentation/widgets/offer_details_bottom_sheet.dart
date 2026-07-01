import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_sheet_content.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OfferDetailsBottomSheet extends StatelessWidget {
  const OfferDetailsBottomSheet({super.key, required this.offer});

  final OfferDealEntity offer;

  static Future<T?> show<T>(BuildContext context, OfferDealEntity offer) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.4),
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) {
          return OfferDetailsBottomSheet(offer: offer);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.60;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE3DB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Expanded(
              child: OfferDetailsSheetContent(
                offer: offer,
                onClose: () => Navigator.of(context).pop(),
                onPrimaryPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, AppRoutes.offerDetails);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
