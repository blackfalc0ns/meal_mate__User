import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
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

    test('CustomerDeliveryRealtimeService broadcasts onDeliveryChanged', () async {
      final service = CustomerDeliveryRealtimeServiceImpl(_FakeTokenService());
      final received = <String>[];
      final subscription = service.onDeliveryChanged.listen(received.add);

      service.notifyDeliveryChanged('sub-day-123');
      await Future<void>.delayed(Duration.zero);

      expect(received, equals(['sub-day-123']));
      await subscription.cancel();
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
  });
}
