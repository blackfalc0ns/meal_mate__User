import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_programs/data/data_source/subscription_programs_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_programs_page_response_dto.dart';

@Injectable(as: SubscriptionProgramsRemoteDataSource)
class SubscriptionProgramsRemoteDataSourceImpl
    implements SubscriptionProgramsRemoteDataSource {
  SubscriptionProgramsRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<SubscriptionProgramResponseDto>> getSubscriptionPrograms() {
    return _apiServices.getSubscriptionPrograms();
  }

  @override
  Future<SubscriptionProgramsPageResponseDto> getSubscriptionProgramsPage({
    required int page,
    required int pageSize,
  }) async {
    final items = await _apiServices.getSubscriptionPrograms(
      page: page,
      pageSize: pageSize,
    );
    final hasNext = items.length >= pageSize;
    return SubscriptionProgramsPageResponseDto(
      items: items,
      totalCount: items.length,
      page: page,
      pageSize: pageSize,
      totalPages: hasNext ? page + 1 : page,
      hasNextPage: hasNext,
      hasPreviousPage: page > 1,
    );
  }

  @override
  Future<SubscriptionProgramBundlesResponseDto> getSubscriptionProgramBundles(
    String programId, {
    int? page,
    int? pageSize,
  }) {
    return _apiServices.getSubscriptionProgramBundles(
      programId,
      page: page,
      pageSize: pageSize,
    );
  }
}
