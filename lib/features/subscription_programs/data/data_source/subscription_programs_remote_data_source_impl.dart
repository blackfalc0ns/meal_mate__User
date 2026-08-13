import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/subscription_programs/data/data_source/subscription_programs_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';

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
  Future<List<SubscriptionBundleResponseDto>> getSubscriptionProgramBundles(
    String programId,
  ) {
    return _apiServices.getSubscriptionProgramBundles(programId);
  }
}
