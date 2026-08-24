import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/core/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/core/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/family_programs/data/data_source/family_programs_remote_data_source.dart';

@Injectable(as: FamilyProgramsRemoteDataSource)
class FamilyProgramsRemoteDataSourceImpl
    implements FamilyProgramsRemoteDataSource {
  FamilyProgramsRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<SubscriptionProgramResponseDto>> getFamilyPrograms() {
    return _apiServices.getFamilyPrograms();
  }

  @override
  Future<List<SubscriptionBundleResponseDto>> getFamilyProgramBundles(
    String programId,
  ) {
    return _apiServices.getFamilyProgramBundles(programId);
  }
}
