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

    test(
      'ignores raw HTML redirect response and falls back to translation key',
      () {
        final response = Response<dynamic>(
          requestOptions: RequestOptions(
            path: '/api/v1/auth/customers/register',
          ),
          statusCode: 307,
          data:
              '<head><title>Document Moved</title></head><body><h1>Object Moved</h1>This document may be found <a HREF="https://maelmate.runasp.net/api/v1/auth/customers/register">here</a></body>',
        );

        final exception = ApiExceptionMapper.fromResponse(response);

        expect(exception.message, isNot(contains('<head>')));
        expect(exception.message, 'error_server_error');
        expect(exception.isTranslationKey, isTrue);
      },
    );

    test(
      'extracts first error message from ASP.NET Core validation problem details',
      () {
        final response = Response<dynamic>(
          requestOptions: RequestOptions(
            path: '/api/v1/auth/customers/register',
          ),
          statusCode: 400,
          data: const {
            'type': 'https://tools.ietf.org/html/rfc9110#section-15.5.1',
            'title': 'One or more validation errors occurred.',
            'status': 400,
            'errors': {
              'Phone': ['The Phone field is required.'],
              'FullName': ['The FullName field is required.'],
            },
          },
        );

        final exception = ApiExceptionMapper.fromResponse(response);

        expect(exception.message, 'The Phone field is required.');
        expect(exception.isTranslationKey, isFalse);
      },
    );
  });
}
