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
  Future<List<SubscriptionProgramResponseDto>> getSubscriptionPrograms() async {
    final response = await _apiServices.getSubscriptionPrograms();
    return response.items ?? const [];
  }

  @override
  Future<SubscriptionProgramsPageResponseDto> getSubscriptionProgramsPage({
    required int page,
    required int pageSize,
  }) async {
    return _apiServices.getSubscriptionPrograms(page: page, pageSize: pageSize);
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
