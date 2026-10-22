import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/compensations/data/data_source/compensations_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/compensations/data/repo/compensations_repository_impl.dart';
import 'package:meal_meat_user/features/compensations/domain/entities/choose_compensation_request_entity.dart';

void main() {
  late Dio dio;
  late CompensationsRepositoryImpl repository;
  late List<RequestOptions> captured;
  Object response = <Object>[];
  setUp(() {
    captured = [];
    dio = Dio(BaseOptions(baseUrl: 'https://compensations.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured.add(options);
          handler.resolve(
            Response(requestOptions: options, statusCode: 200, data: response),
          );
        },
      ),
    );
    repository = CompensationsRepositoryImpl(
      CompensationsRemoteDataSourceImpl(ApiServices(dio)),
    );
  });
  tearDown(() => dio.close(force: true));

  test(
    'list maps server deadline through the actual generated transport',
    () async {
      response = [
        {
          'compensationId': 'c1',
          'serverTimeUtc': '2026-10-21T12:00:00Z',
          'choiceDeadlineUtc': '2026-10-22T12:00:00Z',
          'status': 'PendingChoice',
        },
      ];
      final result = await repository.getCompensations();
      expect(captured.single.method, 'GET');
      expect(captured.single.path, '/api/v1/customer/compensations');
      expect((result as ApiSuccessResult).data.single.canChoose, isTrue);
    },
  );

  test(
    'replacement dates send count and preserve unavailable options',
    () async {
      response = [
        {'date': '2026-10-24', 'isAvailable': false},
      ];
      final result = await repository.getAlternativeDates('c1');
      expect(
        captured.single.path,
        '/api/v1/customer/compensations/c1/alternative-dates',
      );
      expect(captured.single.queryParameters, {'count': 14});
      expect((result as ApiSuccessResult).data.single.isAvailable, isFalse);
    },
  );

  test(
    'choice uses exact enum values and excludes a stale date from cash refund',
    () async {
      response = {'compensationId': 'c1', 'status': 'AutoRefundInitiated'};
      await repository.choose(
        const ChooseCompensationRequestEntity(
          compensationId: 'c1',
          choice: CompensationChoice.cashRefund,
          targetDate: '2026-10-24',
        ),
      );
      expect(captured.single.method, 'POST');
      expect(captured.single.path, '/api/v1/customer/compensations/c1/choose');
      expect(captured.single.data, {
        'choice': 'CashRefund',
        'targetDate': null,
      });
      captured.clear();
      await repository.choose(
        const ChooseCompensationRequestEntity(
          compensationId: 'c1',
          choice: CompensationChoice.alternativeDay,
          targetDate: '2026-10-24',
        ),
      );
      expect(captured.single.data, {
        'choice': 'AlternativeDay',
        'targetDate': '2026-10-24',
      });
    },
  );
}
