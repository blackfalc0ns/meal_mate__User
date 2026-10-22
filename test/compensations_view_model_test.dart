import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/compensations/domain/entities/compensation_entity.dart';
import 'package:meal_meat_user/features/compensations/domain/entities/alternative_date_entity.dart';
import 'package:meal_meat_user/features/compensations/domain/entities/compensation_choice_entity.dart';
import 'package:meal_meat_user/features/compensations/domain/entities/choose_compensation_request_entity.dart';
import 'package:meal_meat_user/features/compensations/domain/repo/compensations_repository.dart';
import 'package:meal_meat_user/features/compensations/domain/usecase/get_compensations_usecase.dart';
import 'package:meal_meat_user/features/compensations/domain/usecase/get_compensation_alternative_dates_usecase.dart';
import 'package:meal_meat_user/features/compensations/domain/usecase/choose_compensation_usecase.dart';
import 'package:meal_meat_user/features/compensations/presentation/manager/compensations_view_model.dart';
import 'package:meal_meat_user/features/compensations/presentation/manager/compensations_event.dart';

CompensationEntity item({bool eligible = true}) => CompensationEntity(
  id: 'c1',
  subscriptionId: 's1',
  status: 'PendingChoice',
  failedServiceDate: '2026-10-20',
  totalAmount: 4.5,
  currency: 'KWD',
  cardRefundAmount: 3,
  walletRefundAmount: 1.5,
  apologyCreditAmount: 0,
  eligibleForAlternativeDay: eligible,
  serverTimeUtc: DateTime.utc(2026, 10, 21),
  choiceDeadlineUtc: DateTime.utc(2026, 10, 23),
);

class FakeRepository implements CompensationsRepository {
  int submissions = 0, dateLoads = 0;
  List<CompensationEntity> items = [item()];
  Failure? datesFailure;
  final pendingChoice = Completer<ApiResult<CompensationChoiceEntity>>();
  @override
  Future<ApiResult<List<CompensationEntity>>> getCompensations() async =>
      ApiSuccessResult(data: items);
  @override
  Future<ApiResult<List<AlternativeDateEntity>>> getAlternativeDates(
    String id,
  ) async {
    dateLoads++;
    if (datesFailure case final failure?) {
      return ApiErrorResult(failure: failure);
    }
    return const ApiSuccessResult(
      data: [AlternativeDateEntity(date: '2026-10-24', isAvailable: true)],
    );
  }

  @override
  Future<ApiResult<CompensationChoiceEntity>> choose(
    ChooseCompensationRequestEntity request,
  ) {
    submissions++;
    return pendingChoice.future;
  }
}

Future<void> flush() => Future<void>.delayed(Duration.zero);

void main() {
  late FakeRepository repo;
  late CompensationsViewModel vm;
  setUp(() {
    repo = FakeRepository();
    vm = CompensationsViewModel(
      GetCompensationsUseCase(repo),
      GetCompensationAlternativeDatesUseCase(repo),
      ChooseCompensationUseCase(repo),
    );
  });
  tearDown(() => vm.close());

  test(
    'uses server time despite device date and prevents duplicate submissions',
    () async {
      vm.doIntent(const LoadCompensationsEvent());
      await flush();
      expect(vm.remainingSeconds('c1'), greaterThan(170000));
      vm.doIntent(
        const SubmitCompensationChoiceEvent(
          'c1',
          CompensationChoice.cashRefund,
        ),
      );
      vm.doIntent(
        const SubmitCompensationChoiceEvent(
          'c1',
          CompensationChoice.cashRefund,
        ),
      );
      expect(repo.submissions, 1);
      repo.pendingChoice.complete(
        ApiErrorResult(failure: Failure(errorMessage: 'network')),
      );
      await flush();
      expect(vm.state.submitting, isEmpty);
    },
  );

  test(
    'alternative choice requires eligibility and a currently available selected date',
    () async {
      repo.items = [item(eligible: false)];
      vm.doIntent(const LoadCompensationsEvent());
      await flush();
      vm.doIntent(
        const SubmitCompensationChoiceEvent(
          'c1',
          CompensationChoice.alternativeDay,
        ),
      );
      vm.doIntent(const LoadCompensationDatesEvent('c1'));
      await flush();
      expect(repo.submissions, 0);
      expect(repo.dateLoads, 0);
    },
  );

  test(
    'capacity conflict refreshes dates and clears the stale selection',
    () async {
      vm.doIntent(const LoadCompensationsEvent());
      await flush();
      vm.doIntent(const LoadCompensationDatesEvent('c1'));
      await flush();
      vm.doIntent(const SelectCompensationDateEvent('c1', '2026-10-24'));
      vm.doIntent(
        const SubmitCompensationChoiceEvent(
          'c1',
          CompensationChoice.alternativeDay,
        ),
      );
      repo.pendingChoice.complete(
        ApiErrorResult(
          failure: Failure(
            errorMessage: 'capacity',
            code: 'CAPACITY_DEPLETED_FOR_DATE',
          ),
        ),
      );
      await flush();
      expect(repo.dateLoads, 2);
      expect(vm.state.selectedDates, isEmpty);
      expect(vm.state.actionFailures['c1']?.code, 'CAPACITY_DEPLETED_FOR_DATE');
    },
  );

  test(
    'expiry blocks further choices without inventing a settled refund',
    () async {
      vm.doIntent(const LoadCompensationsEvent());
      await flush();
      vm.doIntent(
        const SubmitCompensationChoiceEvent(
          'c1',
          CompensationChoice.cashRefund,
        ),
      );
      repo.pendingChoice.complete(
        ApiErrorResult(
          failure: Failure(
            errorMessage: 'expired',
            code: 'COMPENSATION_CHOICE_WINDOW_EXPIRED',
          ),
        ),
      );
      await flush();
      expect(vm.remainingSeconds('c1'), 0);
      expect(vm.state.items.single.status, 'PendingChoice');
      vm.doIntent(
        const SubmitCompensationChoiceEvent(
          'c1',
          CompensationChoice.cashRefund,
        ),
      );
      expect(repo.submissions, 1);
    },
  );

  test('dates eligibility error hides the alternative action', () async {
    vm.doIntent(const LoadCompensationsEvent());
    await flush();
    repo.datesFailure = Failure(
      errorMessage: 'ineligible',
      code: 'ALTERNATIVE_DAY_NOT_ELIGIBLE',
    );
    vm.doIntent(const LoadCompensationDatesEvent('c1'));
    await flush();
    expect(vm.state.alternativeIneligible, contains('c1'));
    expect(vm.state.submitting, isEmpty);
    vm.doIntent(
      const SubmitCompensationChoiceEvent('c1', CompensationChoice.cashRefund),
    );
    expect(repo.submissions, 1);
    repo.pendingChoice.complete(
      ApiErrorResult(failure: Failure(errorMessage: 'network')),
    );
    await flush();
  });

  test('expired dates request blocks choices and clears stale dates', () async {
    vm.doIntent(const LoadCompensationsEvent());
    await flush();
    vm.doIntent(const LoadCompensationDatesEvent('c1'));
    await flush();
    expect(vm.state.dates['c1'], isNotEmpty);
    repo.datesFailure = Failure(
      errorMessage: 'expired',
      code: 'COMPENSATION_CHOICE_WINDOW_EXPIRED',
    );
    vm.doIntent(const LoadCompensationDatesEvent('c1'));
    await flush();
    expect(vm.state.dates['c1'], isNull);
    expect(vm.state.blockedChoices, contains('c1'));
    vm.doIntent(
      const SubmitCompensationChoiceEvent('c1', CompensationChoice.cashRefund),
    );
    expect(repo.submissions, 0);
  });
}
