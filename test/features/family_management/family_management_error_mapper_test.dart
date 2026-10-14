import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_error_mapper.dart';

void main() {
  group('FamilyManagementErrorMapper', () {
    test('maps family.not_manager correctly', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/family/home'),
        response: Response(
          requestOptions: RequestOptions(path: '/family/home'),
          statusCode: 403,
          data: {
            'status': 403,
            'code': SubscriptionErrorCodes.familyNotManager,
            'detail': 'Only manager can access family management',
          },
        ),
      );

      final failure = mapFamilyManagementError(dioError);
      expect(failure.code, SubscriptionErrorCodes.familyNotManager);
      expect(failure.requiresManager, isTrue);
      expect(failure.statusCode, 403);
    });

    test('maps family.permissions_changed with version conflict', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/family/members/1/permissions'),
        response: Response(
          requestOptions: RequestOptions(path: '/family/members/1/permissions'),
          statusCode: 409,
          data: {
            'status': 409,
            'code': SubscriptionErrorCodes.familyPermissionsChanged,
            'currentVersion': 3,
            'detail': 'Permissions version changed',
          },
        ),
      );

      final failure = mapFamilyManagementError(dioError);
      expect(failure.code, SubscriptionErrorCodes.familyPermissionsChanged);
      expect(failure.isPermissionConflict, isTrue);
      expect(failure.currentVersion, 3);
      expect(failure.statusCode, 409);
    });

    test('maps family.quote_changed', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/family-subscription-flow/checkout'),
        response: Response(
          requestOptions: RequestOptions(path: '/family-subscription-flow/checkout'),
          statusCode: 409,
          data: {
            'status': 409,
            'code': SubscriptionErrorCodes.familyQuoteChanged,
            'detail': 'Quote has changed',
          },
        ),
      );

      final failure = mapFamilyManagementError(dioError);
      expect(failure.code, SubscriptionErrorCodes.familyQuoteChanged);
      expect(failure.isQuoteChanged, isTrue);
    });

    test('distinguishes member access paused from manager restriction', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/family/members/1/access'),
        response: Response(
          requestOptions: RequestOptions(path: '/family/members/1/access'),
          statusCode: 400,
          data: {
            'code': SubscriptionErrorCodes.familyAccessPaused,
            'detail': 'Member access is paused',
          },
        ),
      );

      final failure = mapFamilyManagementError(dioError);
      expect(failure.isPausedMember, isTrue);
      expect(failure.requiresManager, isFalse);
    });

    test('maps calendar.fulfillment_not_ready', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/subscriptions/sub-1/calendar'),
        response: Response(
          requestOptions: RequestOptions(path: '/subscriptions/sub-1/calendar'),
          statusCode: 409,
          data: {
            'code': SubscriptionErrorCodes.calendarFulfillmentNotReady,
            'detail': 'Fulfillment is not ready',
          },
        ),
      );

      final failure = mapFamilyManagementError(dioError);
      expect(failure.isFulfillmentNotReady, isTrue);
    });

    test('maps network connection errors to isNetworkError', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/family/home'),
        type: DioExceptionType.connectionTimeout,
        message: 'Connection timed out',
      );

      final failure = mapFamilyManagementError(dioError);
      expect(failure.isNetworkError, isTrue);
    });

    test('unknown error defaults to unknown failure with retryable state', () {
      final unknownError = Exception('Something unexpected');
      final failure = mapFamilyManagementError(unknownError);

      expect(failure.isUnknown, isTrue);
      expect(failure.code, 'unknown');
    });
  });
}
