import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/notifications/data/data_source/notifications_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/notifications/data/repo/notifications_repository_impl.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notifications_page_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import 'package:meal_meat_user/features/notifications/domain/usecase/mark_notification_read_usecase.dart';

void main() {
  group('Notifications API Contract', () {
    test(
      'GET customer notifications sends correct path and query parameters',
      () async {
        RequestOptions? recordedOptions;
        final dio = Dio(BaseOptions(baseUrl: 'https://maelmate.runasp.net'))
          ..httpClientAdapter = _MockHttpAdapter((options) {
            recordedOptions = options;
            return ResponseBody.fromString(
              jsonEncode({
                'items': [
                  {
                    'id': 'n1',
                    'eventKey': 'order.confirmed_by_restaurant',
                    'subjectId': 'day-1',
                    'subscriptionId': 'sub-1',
                    'titleAr': 'تم التأكيد',
                    'titleEn': 'Confirmed',
                    'bodyAr': 'وجبتك جاهزة',
                    'bodyEn': 'Your meal is ready',
                    'deepLink': 'mealmate://orders',
                    'createdAtUtc': '2026-10-05T09:00:00Z',
                    'readAtUtc': null,
                  },
                ],
                'totalCount': 41,
                'page': 1,
                'pageSize': 20,
                'totalPages': 3,
                'hasNextPage': true,
                'hasPreviousPage': false,
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          });

        final dataSource = NotificationsRemoteDataSourceImpl(ApiServices(dio));
        final repo = NotificationsRepositoryImpl(dataSource);
        final useCase = GetNotificationsUseCase(repo);

        final result = await useCase(page: 1, pageSize: 20);

        expect(recordedOptions?.method, 'GET');
        expect(recordedOptions?.uri.path, '/api/v1/customers/me/notifications');
        expect(recordedOptions?.uri.queryParameters['page'], '1');
        expect(recordedOptions?.uri.queryParameters['pageSize'], '20');

        expect(result, isA<ApiSuccessResult<NotificationsPageEntity>>());
        final page = (result as ApiSuccessResult<NotificationsPageEntity>).data;
        expect(page.page, 1);
        expect(page.pageSize, 20);
        expect(page.totalCount, 41);
        expect(page.totalPages, 3);
        expect(page.hasNextPage, isTrue);
        expect(page.items.length, 1);
        expect(page.items.first.id, 'n1');
        expect(page.items.first.isRead, isFalse);
      },
    );

    test(
      'PUT mark notification read sends exact path with 204 no body',
      () async {
        RequestOptions? recordedOptions;
        final dio = Dio(BaseOptions(baseUrl: 'https://maelmate.runasp.net'))
          ..httpClientAdapter = _MockHttpAdapter((options) {
            recordedOptions = options;
            return ResponseBody.fromString('', 204);
          });

        final dataSource = NotificationsRemoteDataSourceImpl(ApiServices(dio));
        final repo = NotificationsRepositoryImpl(dataSource);
        final useCase = MarkNotificationReadUseCase(repo);

        final result = await useCase('n123');

        expect(recordedOptions?.method, 'PUT');
        expect(
          recordedOptions?.uri.path,
          '/api/v1/customers/me/notifications/n123/read',
        );
        expect(recordedOptions?.data, isNull);
        expect(result, isA<ApiSuccessResult<void>>());
      },
    );

    test(
      'PUT mark all notifications read sends exact path with 204 no body',
      () async {
        RequestOptions? recordedOptions;
        final dio = Dio(BaseOptions(baseUrl: 'https://maelmate.runasp.net'))
          ..httpClientAdapter = _MockHttpAdapter((options) {
            recordedOptions = options;
            return ResponseBody.fromString('', 204);
          });

        final dataSource = NotificationsRemoteDataSourceImpl(ApiServices(dio));
        final repo = NotificationsRepositoryImpl(dataSource);
        final useCase = MarkAllNotificationsReadUseCase(repo);

        final result = await useCase();

        expect(recordedOptions?.method, 'PUT');
        expect(
          recordedOptions?.uri.path,
          '/api/v1/customers/me/notifications/read-all',
        );
        expect(recordedOptions?.data, isNull);
        expect(result, isA<ApiSuccessResult<void>>());
      },
    );

    test(
      'HTTP 401/403/404 ProblemDetails maps to Failure with expected code',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://maelmate.runasp.net'))
          ..httpClientAdapter = _MockHttpAdapter((options) {
            return ResponseBody.fromString(
              jsonEncode({
                'type': 'https://tools.ietf.org/html/rfc7231#section-6.5.4',
                'title': 'Not Found',
                'status': 404,
                'code': 'notification.not_found',
              }),
              404,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          });

        final dataSource = NotificationsRemoteDataSourceImpl(ApiServices(dio));
        final repo = NotificationsRepositoryImpl(dataSource);
        final useCase = MarkNotificationReadUseCase(repo);

        final result = await useCase('not-found-id');

        expect(result, isA<ApiErrorResult<void>>());
        final failure = (result as ApiErrorResult<void>).failure;
        expect(failure.code, 'notification.not_found');
      },
    );
  });
}

class _MockHttpAdapter implements HttpClientAdapter {
  final ResponseBody Function(RequestOptions options) handler;
  _MockHttpAdapter(this.handler);

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }
}
