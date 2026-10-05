import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_dates_row.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_delivery_address_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_participating_restaurants_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_plan_summary_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_restaurant_repetition_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_summary_details_card.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/subscription_total_price_card.dart';

void main() {
  const dummyPlan = MonthlyPlanDetailsEntity(
    titlePrefix: 'باقة',
    titleHighlight: '4 وجبات',
    duration: '26 يوم',
    mealsPerDay: '4 وجبات',
    discountLabel: 'بلاتينيوم',
    subscribeLabel: 'اشترك الآن',
    price: '930',
    currency: 'د.ك',
    heroImageAsset: '',
    description: '',
    features: [],
    packageTiers: [],
    filters: [],
    restaurants: [],
    meals: [],
  );

  const dummySummary = SubscriptionSummaryEntity(
    programId: 'prog_1',
    programNameAr: 'خسارة الوزن',
    programNameEn: 'Weight Loss',
    bundleId: 'bundle_1',
    bundleNameAr: 'باقة 4 وجبات',
    bundleNameEn: '4 Meals Plan',
    restaurantCount: 100,
    tier: 'platinum',
    tierNameAr: 'بلاتينيوم',
    tierNameEn: 'Platinum',
    durationDays: 26,
    chosenStartDate: '2026-09-20',
    startDate: '2026-09-23',
    endDate: '2026-10-15',
    serviceDates: [],
    restaurantRepetition: SubscriptionSummaryRestaurantRepetitionEntity(
      limit: 8,
      restaurantCount: 100,
      durationDays: 26,
    ),
    slotRequirements: [],
    basePrice: 930.0,
    campaignDiscount: 0,
    promoDiscount: 0,
    walletCredit: 0,
    gatewayFee: 0,
    finalPrice: 930.0,
    currencyCode: 'د.ك',
    canCheckout: true,
    address: SubscriptionSummaryAddressEntity(
      id: 'addr_1',
      label: 'المنزل',
      addressLine: 'Hawalli, Salmiya, Block 4',
      governorate: 'حولي',
      area: 'السالمية',
      block: 'قطعة 4',
    ),
    restaurants: [
      SubscriptionSummaryRestaurantEntity(
        restaurantId: 'r1',
        nameAr: 'برجر كينج',
        nameEn: 'Burger King',
        tier: 'platinum',
      ),
      SubscriptionSummaryRestaurantEntity(
        restaurantId: 'r2',
        nameAr: 'ستاربكس',
        nameEn: 'Starbucks',
        tier: 'platinum',
      ),
    ],
    termsAcceptanceRequired: false,
    checkoutEndpoint: '/checkout',
    includeFriday: true,
    fridayDays: 4,
    totalServiceDays: 26,
    includes: SubscriptionSummaryIncludesEntity(
      titleAr: 'يشمل اشتراكك',
      titleEn: 'Your subscription includes',
      items: [],
    ),
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      home: Scaffold(
        body: SingleChildScrollView(
          child: SubscriptionSummaryDetailsCard(
            summary: dummySummary,
            selectedStartDate: '2026-09-23',
            onEditStartDate: () {},
          ),
        ),
      ),
    );
  }

  group('SubscriptionSummaryDetailsCard Figma Layout Tests', () {
    testWidgets('renders all Figma cards correctly in Arabic', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionPlanSummaryCard), findsOneWidget);
      expect(find.byType(SubscriptionParticipatingRestaurantsCard), findsOneWidget);
      expect(find.byType(SubscriptionRestaurantRepetitionCard), findsOneWidget);
      expect(find.byType(SubscriptionDeliveryAddressCard), findsOneWidget);
      expect(find.byType(SubscriptionTotalPriceCard), findsOneWidget);
      expect(find.byType(SubscriptionDatesRow), findsOneWidget);

      expect(find.text('ملخص الاشتراك'), findsOneWidget);
      expect(find.text('المطاعم المشاركة'), findsOneWidget);
      expect(find.text('تكرار المطعم'), findsOneWidget);
      expect(find.text('المنزل'), findsOneWidget);
      expect(find.text('السعر الإجمالي'), findsOneWidget);
      expect(find.text('930'), findsOneWidget);

      expect(find.text('تاريخ الدفع'), findsOneWidget);
      expect(find.text('تاريخ بدء الاشتراك'), findsOneWidget);
      expect(find.text('تاريخ انتهاء الاشتراك'), findsOneWidget);
    });
  });
}
