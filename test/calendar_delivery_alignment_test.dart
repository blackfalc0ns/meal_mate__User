import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/calendar/data/mapper/customer_delivery_mapper.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/customer_delivery_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/services/customer_delivery_realtime_service.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/overview/calendar_overview_state.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_actions.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_info_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_status_hero.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_support_card.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_delivery_details_timeline.dart';

class _FakeTokenService implements TokenService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<String?> getToken() async => 'fake-token';
}

void main() {
  group('CustomerDeliveryStatus & Contract Alignment', () {
    test('fromString parses all backend statuses correctly', () {
      expect(
        CustomerDeliveryStatus.fromString('NotStarted'),
        equals(CustomerDeliveryStatus.notStarted),
      );
      expect(
        CustomerDeliveryStatus.fromString('Preparing'),
        equals(CustomerDeliveryStatus.preparing),
      );
      expect(
        CustomerDeliveryStatus.fromString('ReadyForPickup'),
        equals(CustomerDeliveryStatus.ready),
      );
      expect(
        CustomerDeliveryStatus.fromString('ready_for_pickup'),
        equals(CustomerDeliveryStatus.ready),
      );
      expect(
        CustomerDeliveryStatus.fromString('OutForDelivery'),
        equals(CustomerDeliveryStatus.outForDelivery),
      );
      expect(
        CustomerDeliveryStatus.fromString('Delivered'),
        equals(CustomerDeliveryStatus.delivered),
      );
      expect(
        CustomerDeliveryStatus.fromString('Failed'),
        equals(CustomerDeliveryStatus.failed),
      );
      expect(
        CustomerDeliveryStatus.fromString('ReturnedToKitchen'),
        equals(CustomerDeliveryStatus.returnedToKitchen),
      );
      expect(
        CustomerDeliveryStatus.fromString('Frozen'),
        equals(CustomerDeliveryStatus.frozen),
      );
      expect(
        CustomerDeliveryStatus.fromString('Cancelled'),
        equals(CustomerDeliveryStatus.cancelled),
      );
      expect(
        CustomerDeliveryStatus.fromString('tracking_unavailable'),
        equals(CustomerDeliveryStatus.trackingUnavailable),
      );
      expect(
        CustomerDeliveryStatus.fromString('unknown_status'),
        equals(CustomerDeliveryStatus.unknown),
      );
    });

    test('isTerminalStatus correctly flags final states', () {
      const deliveredItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.delivered,
        isTerminal: false,
        isTrackable: false,
      );
      expect(deliveredItem.isTerminalStatus, isTrue);

      const returnedItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.returnedToKitchen,
        isTerminal: false,
        isTrackable: false,
      );
      expect(returnedItem.isTerminalStatus, isTrue);

      const preparingItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.preparing,
        isTerminal: false,
        isTrackable: false,
      );
      expect(preparingItem.isTerminalStatus, isFalse);
    });

    test('CalendarOverviewState exposes all delivery items', () {
      const item1 = CustomerDeliveryItemEntity(
        subscriptionDayId: 'day-1',
        deliveryStatus: CustomerDeliveryStatus.outForDelivery,
        isTerminal: false,
        isTrackable: true,
      );
      const item2 = CustomerDeliveryItemEntity(
        subscriptionDayId: 'day-2',
        deliveryStatus: CustomerDeliveryStatus.preparing,
        isTerminal: false,
        isTrackable: false,
      );

      const state = CalendarOverviewState(
        deliveryWidget: CustomerDeliveryWidgetEntity(
          items: [item1, item2],
        ),
      );

      expect(state.deliveryItems.length, equals(2));
      expect(state.deliveryItems[0].subscriptionDayId, equals('day-1'));
      expect(state.deliveryItems[1].subscriptionDayId, equals('day-2'));
      expect(state.currentDeliveryItem?.subscriptionDayId, equals('day-1'));
    });

    test('CustomerDeliveryRealtimeService broadcasts onDeliveryChanged and disconnects cleanly', () async {
      final service = CustomerDeliveryRealtimeServiceImpl(_FakeTokenService());
      final received = <String>[];
      final subscription = service.onDeliveryChanged.listen(received.add);

      service.notifyDeliveryChanged('sub-day-123');
      await Future<void>.delayed(Duration.zero);

      expect(received, equals(['sub-day-123']));
      await subscription.cancel();
      await service.disconnect();
      service.dispose();
    });

    testWidgets('CalendarDeliveryDetails widgets render correctly with delivered status',
        (tester) async {
      final now = DateTime.utc(2026, 9, 20, 10, 12);
      final item = CustomerDeliveryItemEntity(
        subscriptionDayId: 'day-1',
        orderCode: 'MM-25090025',
        deliveryStatus: CustomerDeliveryStatus.delivered,
        isTerminal: true,
        isTrackable: false,
        readyAtUtc: now.subtract(const Duration(minutes: 52)),
        pickedUpAtUtc: now.subtract(const Duration(minutes: 27)),
        deliveredAtUtc: now,
        destinationAddress: 'شارع التخصصي ، حي الربيع، الرياض',
        driver: const CustomerDeliveryDriverEntity(
          name: 'أحمد',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CalendarDeliveryDetailsStatusHero(deliveryItem: item),
                  CalendarDeliveryDetailsInfoCard(deliveryItem: item),
                  CalendarDeliveryDetailsTimeline(deliveryItem: item),
                  const CalendarDeliveryDetailsSupportCard(),
                  CalendarDeliveryDetailsActions(
                    onBackToHome: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CalendarDeliveryDetailsStatusHero), findsOneWidget);
      expect(find.byType(CalendarDeliveryDetailsInfoCard), findsOneWidget);
      expect(find.byType(CalendarDeliveryDetailsTimeline), findsOneWidget);
      expect(find.byType(CalendarDeliveryDetailsSupportCard), findsOneWidget);
      expect(find.byType(CalendarDeliveryDetailsActions), findsOneWidget);
      expect(find.text('MM-25090025'), findsOneWidget);
      expect(find.text('أحمد'), findsOneWidget);
      expect(find.text('تحتاج مساعدة؟'), findsOneWidget);
      expect(find.text('العودة للرئيسية'), findsOneWidget);
      expect(find.text('تقييم التجربة'), findsOneWidget);
      expect(find.text('الإبلاغ عن مشكلة'), findsOneWidget);
    });

    test('shouldShowDeliveryCard returns false for scheduled and true from preparing onwards', () {
      const scheduledItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.scheduled,
        isTerminal: false,
        isTrackable: false,
      );
      expect(scheduledItem.shouldShowDeliveryCard, isFalse);

      const notStartedItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.notStarted,
        isTerminal: false,
        isTrackable: false,
      );
      expect(notStartedItem.shouldShowDeliveryCard, isFalse);

      const preparingItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.preparing,
        isTerminal: false,
        isTrackable: true,
      );
      expect(preparingItem.shouldShowDeliveryCard, isTrue);

      const readyItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.ready,
        isTerminal: false,
        isTrackable: true,
      );
      expect(readyItem.shouldShowDeliveryCard, isTrue);

      const outItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.outForDelivery,
        isTerminal: false,
        isTrackable: true,
      );
      expect(outItem.shouldShowDeliveryCard, isTrue);

      const deliveredItem = CustomerDeliveryItemEntity(
        deliveryStatus: CustomerDeliveryStatus.delivered,
        isTerminal: true,
        isTrackable: false,
      );
      expect(deliveredItem.shouldShowDeliveryCard, isTrue);
    });

    test('CustomerDeliveryWidgetResponseDto successfully parses backend payload with Object destinationAddress and int plateNumber', () {
      final json = {
        'serviceDate': '2026-10-17',
        'serverTimeUtc': '2026-10-17T09:22:44.1869433Z',
        'refreshAfterSeconds': 30,
        'items': [
          {
            'subscriptionId': '042d669d-782d-4df6-a9ee-83d640bbb549',
            'subscriptionDayId': 'aba37004-58ac-4099-aca4-439058985f65',
            'orderId': '0ff6aded-efd5-4f42-b217-33ab3592d0ef',
            'tripStopId': '3a6c6a75-3627-4a79-8a8d-38cc59f62d7f',
            'orderCode': '#BX-4917',
            'deliveryStatus': 'OutForDelivery',
            'deliveryStatusTextAr': 'خرج للتوصيل',
            'deliveryStatusTextEn': 'Out for delivery',
            'isTerminal': false,
            'isTrackable': true,
            'unavailableReasonCode': null,
            'readyAtUtc': '2026-10-17T08:54:09.310765Z',
            'pickedUpAtUtc': '2026-10-17T09:21:23.117085Z',
            'arrivedAtUtc': null,
            'deliveredAtUtc': null,
            'driver': {
              'id': '52a408f2-94d4-4c7d-bfaf-3e9017eb0d49',
              'nameAr': 'يحيي سواق',
              'nameEn': 'yahya driver',
              'maskedPhone': '123***54',
              'avatarUrl':
                  '/api/v1/uploads/content?key=uploads%2Fdrivers%2Fdriver-registration%2Ff53d8f92a4bb43c28c3aedeb8f4c10fa_Screenshot_2026-09-09-18-40-55-34_ffecf901ff8b6ced2230e4c65e7fd945.jpg',
              'rating': null,
            },
            'vehicle': {
              'typeCode': 'Car',
              'typeLabelAr': 'سيارة',
              'typeLabelEn': 'Car',
              'plateNumber': 1275765,
            },
            'location': null,
            'etaMinutes': null,
            'etaSource': null,
            'destinationAddress': {
              'addressLine': 'حولي, السالمية, قطعة 3, شارع 2, جادة 2, 2',
              'latitude': 29.340749,
              'longitude': 48.083898,
            },
            'detailsUrl':
                '/api/v1/customer/orders/3a6c6a75-3627-4a79-8a8d-38cc59f62d7f/live-tracking',
            'deliveryDetailsUrl':
                '/api/v1/customer/subscription-days/aba37004-58ac-4099-aca4-439058985f65/delivery-details',
          },
        ],
      };

      final dto = CustomerDeliveryWidgetResponseDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.items.length, 1);
      final item = entity.items.first;
      expect(item.deliveryStatus, CustomerDeliveryStatus.outForDelivery);
      expect(item.orderCode, '#BX-4917');
      expect(
        item.destinationAddress,
        'حولي, السالمية, قطعة 3, شارع 2, جادة 2, 2',
      );
      expect(item.destinationLatitude, 29.340749);
      expect(item.destinationLongitude, 48.083898);
      expect(item.vehicle?.plateNumber, '1275765');
      expect(item.driver?.avatarUrl, startsWith('https://api.trymealmate.com'));
      expect(item.shouldShowDeliveryCard, isTrue);
    });
  });
}
