import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_browse_card.dart';

void main() {
  testWidgets(
    'unavailable offer stays visible with localized reason and disabled action',
    (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: OfferBrowseCard(
              offer: const OfferEntity(
                id: 'blocked',
                nameAr: '???',
                nameEn: 'Blocked offer',
                descriptionAr: '',
                descriptionEn: 'Description',
                purchaseMode: OfferPurchaseMode.directPurchase,
                isAvailable: false,
                availabilityReasonCode: 'offers.customer.unavailable',
              ),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      final context = tester.element(find.byType(OfferBrowseCard));
      final locale = AppLocalizations.of(context)!;
      expect(find.text('Blocked offer'), findsOneWidget);
      expect(
        find.text(locale.offers_error_customer_unavailable),
        findsOneWidget,
      );
      expect(find.text(locale.offer_browse_action_button), findsOneWidget);
      await tester.tap(find.text(locale.offer_browse_action_button));
      expect(tapped, false);
    },
  );
}
