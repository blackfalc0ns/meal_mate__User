import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/data_source/eligible_start_dates_remote_data_source_impl.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/repo/eligible_start_dates_repository_impl.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/eligible_start_dates_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/eligible_start_dates_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/eligible_start_dates_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/eligible_start_dates_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_eligible_start_dates_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/widgets/eligible_start_date_calendar.dart';

class DatesRepository implements EligibleStartDatesRepository {
  List<String> dates = ['2026-10-22', '2026-10-24'];
  @override
  Future<ApiResult<EligibleStartDatesEntity>> getDates({
    required bool includeFriday,
  }) async => ApiSuccessResult(
    data: EligibleStartDatesEntity(dates: dates, includeFriday: includeFriday),
  );
}

class SummaryRepository implements SubscriptionSummaryRepository {
  final List<SubscriptionSummaryRequestEntity> requests = [];
  @override
  Future<ApiResult<SubscriptionSummaryEntity>> getSummary(
    SubscriptionSummaryRequestEntity request,
  ) async {
    requests.add(request);
    return ApiErrorResult(
      failure: Failure(errorMessage: 'test summary response'),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const request = SubscriptionSummaryRequestEntity(
  programId: 'p',
  bundleId: 'b',
  tier: 'Basic',
  durationDays: 26,
  startDate: '',
  includeFriday: false,
);

void main() {
  test(
    'maps only server dates, rejects malformed dates and excluded Fridays',
    () {
      final entity = EligibleStartDatesResponseDto.fromJson({
        'includeFriday': false,
        'earliestEligibleDeliveryDate': '2026-10-21',
        'eligibleFirstDeliveryDates': [
          '2026-10-24',
          'bad',
          '2026-10-23',
          '2026-10-22',
          '2026-10-24',
        ],
        'operationalLeadHours': 96,
      }).toEntity(requestedIncludeFriday: false);
      expect(entity.dates, ['2026-10-22', '2026-10-24']);
      expect(entity.operationalLeadHours, 96);
      expect(
        EligibleStartDatesResponseDto.fromJson({
          'earliestEligibleDeliveryDate': '2026-10-22',
        }).toEntity(requestedIncludeFriday: false).dates,
        isEmpty,
      );
    },
  );

  test('generated transport sends Friday flag and requested horizon', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://start-dates.test'));
    addTearDown(() => dio.close(force: true));
    RequestOptions? captured;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.resolve(
            Response(
              requestOptions: options,
              data: {
                'includeFriday': true,
                'eligibleFirstDeliveryDates': ['2026-10-23'],
              },
              statusCode: 200,
            ),
          );
        },
      ),
    );
    final repo = EligibleStartDatesRepositoryImpl(
      EligibleStartDatesRemoteDataSourceImpl(ApiServices(dio)),
    );
    final result = await repo.getDates(includeFriday: true);
    expect(
      captured?.path,
      '/api/v1/customer/subscription-flow/eligible-start-dates',
    );
    expect(captured?.queryParameters, {
      'includeFriday': true,
      'lookaheadDays': 14,
    });
    expect((result as ApiSuccessResult<EligibleStartDatesEntity>).data.dates, [
      '2026-10-23',
    ]);
  });

  test(
    'summary resolves an empty date from server and rejects an unlisted date intent',
    () async {
      final dates = DatesRepository();
      final summary = SummaryRepository();
      final vm = SubscriptionSummaryViewModel(
        GetSubscriptionSummaryUseCase(summary),
        getEligibleStartDatesUseCase: GetEligibleStartDatesUseCase(dates),
      );
      addTearDown(vm.close);
      vm.doIntent(const GetSubscriptionSummaryEvent(request));
      await Future<void>.delayed(Duration.zero);
      expect(summary.requests.single.startDate, '2026-10-22');
      expect(vm.state.selectedStartDate, '2026-10-22');
      vm.doIntent(
        const ChangeSubscriptionStartDateEvent(
          startDate: '2026-10-23',
          baseRequest: request,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(summary.requests.length, 1);
      vm.doIntent(
        const ChangeSubscriptionStartDateEvent(
          startDate: '2026-10-24',
          baseRequest: request,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(summary.requests.last.startDate, '2026-10-24');
      dates.dates = ['2026-10-25'];
      vm.doIntent(
        const ChangeSubscriptionStartDateEvent(
          startDate: '2026-10-25',
          baseRequest: request,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(summary.requests.last.startDate, '2026-10-25');
    },
  );

  test(
    'empty eligibility blocks summary request instead of inventing tomorrow',
    () async {
      final dates = DatesRepository()..dates = [];
      final summary = SummaryRepository();
      final vm = SubscriptionSummaryViewModel(
        GetSubscriptionSummaryUseCase(summary),
        getEligibleStartDatesUseCase: GetEligibleStartDatesUseCase(dates),
      );
      addTearDown(vm.close);
      vm.doIntent(const GetSubscriptionSummaryEvent(request));
      await Future<void>.delayed(Duration.zero);
      expect(summary.requests, isEmpty);
      expect(vm.state.canCheckout, isFalse);
      expect(vm.state.failure?.code, 'subscription.start_dates_unavailable');
    },
  );

  for (final language in ['en', 'ar']) {
    testWidgets(
      'eligible calendar hides Fridays and fits narrow $language dialog',
      (tester) async {
        tester.view.physicalSize = const Size(360, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        String? selected;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: AlertDialog(
                content: EligibleStartDateCalendar(
                  dates: const ['2026-10-22', '2026-10-24'],
                  includeFriday: false,
                  onSelected: (date) => selected = date,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(EligibleStartDateCalendar));
        final material = MaterialLocalizations.of(context);
        expect(find.text(material.formatDecimal(23)), findsNothing);
        await tester.tap(find.text(material.formatDecimal(24)));
        expect(selected, '2026-10-24');
        expect(tester.takeException(), isNull);
      },
    );
  }
}
