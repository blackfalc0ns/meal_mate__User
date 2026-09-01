import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_exception_mapper.dart';

void main() {
  group('ApiExceptionMapper', () {
    test('uses friday availability backend message for unavailable Friday', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/tiers'),
        statusCode: 409,
        data: const {
          'error': 'subscription_flow.friday_unavailable',
          'fridayAvailability': {
            'isAvailable': false,
            'restaurantCount': 0,
            'code': 'FRIDAY_UNAVAILABLE',
            'messageAr':
                'يوم الجمعة غير متاح لعدم وجود مطاعم تعمل الجمعة ضمن هذه الباقة',
            'displayType': 'DISABLED',
            'message':
                'يوم الجمعة غير متاح لعدم وجود مطاعم تعمل الجمعة ضمن هذه الباقة',
          },
        },
      );

      final exception = ApiExceptionMapper.fromResponse(response);

      expect(
        exception.message,
        'يوم الجمعة غير متاح لعدم وجود مطاعم تعمل الجمعة ضمن هذه الباقة',
      );
      expect(
        exception.backendErrorCode,
        'subscription_flow.friday_unavailable',
      );
      expect(exception.isTranslationKey, isFalse);
    });
  });
}
