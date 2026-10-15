import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';
import 'package:meal_meat_user/features/auth/domain/usecase/get_calling_codes_usecase.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/calling_codes_view_model.dart';

class _FakeGetCallingCodesUseCase extends Fake
    implements GetCallingCodesUseCase {
  int callCount = 0;
  Completer<ApiResult<List<CallingCodeEntity>>>? completer;
  ApiResult<List<CallingCodeEntity>>? cannedResult;

  @override
  Future<ApiResult<List<CallingCodeEntity>>> call() async {
    callCount++;
    if (completer != null) {
      return completer!.future;
    }
    return cannedResult!;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeGetCallingCodesUseCase fakeUseCase;
  late CallingCodesViewModel viewModel;

  const kw = CallingCodeEntity(
    countryCode: 'KW',
    nameAr: 'الكويت',
    nameEn: 'Kuwait',
    dialCode: '+965',
    flagEmoji: '🇰🇼',
  );
  const sa = CallingCodeEntity(
    countryCode: 'SA',
    nameAr: 'السعودية',
    nameEn: 'Saudi Arabia',
    dialCode: '+966',
    flagEmoji: '🇸🇦',
  );

  setUp(() {
    fakeUseCase = _FakeGetCallingCodesUseCase();
    viewModel = CallingCodesViewModel(fakeUseCase);
  });

  tearDown(() async {
    await viewModel.close();
  });

  group('CallingCodesViewModel', () {
    test(
      'LoadCallingCodesEvent fetches codes, sets loading then success',
      () async {
        fakeUseCase.cannedResult = const ApiSuccessResult(data: [kw, sa]);

        expect(viewModel.state.isLoading, isFalse);
        expect(viewModel.state.items, isEmpty);

        viewModel.doIntent(const LoadCallingCodesEvent());
        await Future<void>.delayed(Duration.zero);

        expect(fakeUseCase.callCount, 1);
        expect(viewModel.state.isLoading, isFalse);
        expect(viewModel.state.items.length, 2);
        expect(viewModel.state.selected?.countryCode, 'KW');
      },
    );

    test(
      'concurrent LoadCallingCodesEvent produces only ONE in-flight request',
      () async {
        fakeUseCase.completer = Completer<ApiResult<List<CallingCodeEntity>>>();

        viewModel.doIntent(const LoadCallingCodesEvent());
        viewModel.doIntent(const LoadCallingCodesEvent());

        expect(fakeUseCase.callCount, 1);

        fakeUseCase.completer!.complete(const ApiSuccessResult(data: [kw]));
        await Future<void>.delayed(Duration.zero);

        expect(fakeUseCase.callCount, 1);
      },
    );

    test('selecting the same calling code does NOT emit new state', () async {
      fakeUseCase.cannedResult = const ApiSuccessResult(data: [kw, sa]);
      viewModel.doIntent(const LoadCallingCodesEvent());
      await Future<void>.delayed(Duration.zero);

      final states = <CallingCodesState>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(const SelectCallingCodeEvent(kw));
      await Future<void>.delayed(Duration.zero);

      expect(states, isEmpty);
      await subscription.cancel();
    });

    test('selecting different calling code updates selected', () async {
      fakeUseCase.cannedResult = const ApiSuccessResult(data: [kw, sa]);
      viewModel.doIntent(const LoadCallingCodesEvent());
      await Future<void>.delayed(Duration.zero);

      viewModel.doIntent(const SelectCallingCodeEvent(sa));
      expect(viewModel.state.selected?.countryCode, 'SA');
    });

    test(
      'reload preserves selected code if still present in refreshed list',
      () async {
        fakeUseCase.cannedResult = const ApiSuccessResult(data: [kw, sa]);
        viewModel.doIntent(const LoadCallingCodesEvent());
        await Future<void>.delayed(Duration.zero);

        viewModel.doIntent(const SelectCallingCodeEvent(sa));
        expect(viewModel.state.selected?.countryCode, 'SA');

        // Reload
        viewModel.doIntent(const LoadCallingCodesEvent());
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.selected?.countryCode, 'SA');
      },
    );

    test('empty country list leaves items empty and selected null', () async {
      fakeUseCase.cannedResult = const ApiSuccessResult(data: []);
      viewModel.doIntent(const LoadCallingCodesEvent());
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.items, isEmpty);
      expect(viewModel.state.selected, isNull);
      expect(viewModel.state.failure, isNull);
    });

    test('failure emits failure and clears loading', () async {
      final failure = Failure(errorMessage: 'Network error');
      fakeUseCase.cannedResult = ApiErrorResult(failure: failure);

      viewModel.doIntent(const LoadCallingCodesEvent());
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.failure, failure);
    });
  });
}
