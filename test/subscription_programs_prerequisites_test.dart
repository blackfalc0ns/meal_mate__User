import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/subscription_tiers/domain/usecase/check_subscription_prerequisites_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_view_model.dart';

void main() {
  test('package flow stays blocked when a prerequisite is missing', () async {
    final failure = Failure(
      errorMessage: 'Address required',
      code: 'checkout.address_required',
    );
    final viewModel = SubscriptionProgramsViewModel(
      _UnusedProgramsUseCase(),
      _UnusedBundlesUseCase(),
      _PrerequisitesUseCase(ApiErrorResult(failure: failure)),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(const CheckSubscriptionPrerequisitesEvent());
    await expectLater(
      viewModel.stream,
      emitsThrough(
        isA<dynamic>()
            .having((state) => state.prerequisitesCompleted, 'completed', false)
            .having(
              (state) => state.prerequisitesFailure?.code,
              'failure code',
              'checkout.address_required',
            ),
      ),
    );
  });

  test('package flow can navigate only after prerequisites succeed', () async {
    final viewModel = SubscriptionProgramsViewModel(
      _UnusedProgramsUseCase(),
      _UnusedBundlesUseCase(),
      _PrerequisitesUseCase(ApiSuccessResult<void>(data: null)),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(const CheckSubscriptionPrerequisitesEvent());
    await expectLater(
      viewModel.stream,
      emitsThrough(
        isA<dynamic>().having(
          (state) => state.prerequisitesCompleted,
          'completed',
          true,
        ),
      ),
    );
  });
}

class _UnusedProgramsUseCase extends Fake
    implements GetSubscriptionProgramsUseCase {}

class _UnusedBundlesUseCase extends Fake
    implements GetSubscriptionProgramBundlesUseCase {}

class _PrerequisitesUseCase extends Fake
    implements CheckSubscriptionPrerequisitesUseCase {
  _PrerequisitesUseCase(this.result);

  final ApiResult<void> result;

  @override
  Future<ApiResult<void>> call() async => result;
}
