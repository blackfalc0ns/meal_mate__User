import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/customer_support/data/models/request/create_customer_issue_request_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/response/customer_support_options_response_dto.dart';
import 'package:meal_meat_user/features/customer_orders/data/models/response/delivered_boxes_response_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/models/response/customer_issue_response_dto.dart';
import 'package:meal_meat_user/features/customer_support/data/mapper/customer_support_mapper.dart';

void main() {
  test('general issue omits both resource fields', () {
    const request = CreateCustomerIssueRequestDto(
      typeCode: 'late_delivery',
      subject: 'Late delivery',
      description: 'The order did not arrive on time',
      idempotencyKey: 'operation-1',
    );
    expect(request.toJson().containsKey('relatedResourceType'), isFalse);
    expect(request.toJson().containsKey('relatedResourceId'), isFalse);
  });

  test('issue options preserve server codes and localized labels', () {
    final options = CustomerSupportOptionsResponseDto.fromJson({
      'issues': [
        {
          'value': 'box_problem',
          'label': 'Box problem',
          'labelAr': 'مشكلة صندوق',
        },
      ],
    });
    expect(options.issues.single.value, 'box_problem');
    expect(options.issues.single.labelAr, 'مشكلة صندوق');
  });

  test('delivered box keeps exact resource pair from server', () {
    final page = DeliveredBoxesResponseDto.fromJson({
      'items': [
        {
          'subscriptionId': 'subscription-1',
          'subscriptionDayId': 'day-1',
          'restaurantDailyOrderId': 'order-1',
          'serviceDate': '2026-10-24',
          'relatedResourceType': 'RestaurantDailyOrder',
          'relatedResourceId': 'order-1',
        },
        {
          'subscriptionId': 'subscription-1',
          'subscriptionDayId': 'day-2',
          'restaurantDailyOrderId': null,
          'serviceDate': '2026-10-23',
          'relatedResourceType': 'SubscriptionDay',
          'relatedResourceId': 'day-2',
        },
      ],
      'totalCount': 2,
      'pageNumber': 1,
      'pageSize': 20,
    });
    expect(page.items.first.relatedResourceId, 'order-1');
    expect(page.items.last.relatedResourceId, 'day-2');
    expect(page.items.last.restaurantDailyOrderId, isNull);
  });

  test('only server-provided timing deadlines are mapped', () {
    final issue = CustomerIssueResponseDto.fromJson({
      'id': 'case-1',
      'status': 'InProgress',
      'version': 3,
      'activeTimingCycle': {
        'firstResponseDeadlineUtc': '2026-10-24T10:00:00Z',
        'resolutionDeadlineUtc': null,
      },
    }).toEntity();
    expect(issue.activeTimingCycle?.firstResponseDeadlineUtc?.isUtc, isTrue);
    expect(issue.activeTimingCycle?.resolutionDeadlineUtc, isNull);
    expect(issue.activeTimingCycle?.escalationDeadlineUtc, isNull);
  });
}
