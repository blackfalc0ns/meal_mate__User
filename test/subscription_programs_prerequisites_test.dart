import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_page_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_view_model.dart';

void main() {
  test('bundle loading keeps profile completion flags in state', () async {
    const result = SubscriptionProgramBundlesEntity(
      hasDeliveryAddress: true,
      hasAllergies: true,
      hasDietaryPreferences: false,
      isProfileComplete: false,
      bundles: [],
    );
    final viewModel = SubscriptionProgramsViewModel(
      _UnusedProgramsUseCase(),
      _BundlesUseCase(ApiSuccessResult(data: result)),
      _UnusedProgramsPageUseCase(),
    );
    addTearDown(viewModel.close);

    viewModel.doIntent(const GetSubscriptionProgramBundlesEvent('program-1'));

    await expectLater(
      viewModel.stream,
      emitsThrough(
        isA<dynamic>()
            .having((state) => state.hasDeliveryAddress, 'address', true)
            .having((state) => state.hasAllergies, 'allergies', true)
            .having(
              (state) => state.hasDietaryPreferences,
              'dietary preferences',
              false,
            )
            .having((state) => state.isProfileComplete, 'complete', false),
      ),
    );
  });
}

class _UnusedProgramsUseCase extends Fake
    implements GetSubscriptionProgramsUseCase {}

class _UnusedProgramsPageUseCase extends Fake
    implements GetSubscriptionProgramsPageUseCase {}

class _BundlesUseCase extends Fake
    implements GetSubscriptionProgramBundlesUseCase {
  _BundlesUseCase(this.result);

  final ApiResult<SubscriptionProgramBundlesEntity> result;

  @override
  Future<ApiResult<SubscriptionProgramBundlesEntity>> call(
    String programId, {
    int? page,
    int? pageSize,
  }) async => result;
}
