import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/repo/subscription_programs_repository.dart';

@injectable
class GetSubscriptionProgramsPageUseCase {
  const GetSubscriptionProgramsPageUseCase(this._repository);

  final SubscriptionProgramsRepository _repository;

  Future<ApiResult<PagedEntity<SubscriptionProgramEntity>>> call({
    required int page,
    required int pageSize,
  }) {
    return _repository.getSubscriptionProgramsPage(
      page: page,
      pageSize: pageSize,
    );
  }
}
