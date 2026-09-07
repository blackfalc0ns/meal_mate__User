import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_allergies/data/data_source/family_allergies_remote_data_source.dart';
import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';

@Injectable(as: FamilyAllergiesRemoteDataSource)
class FamilyAllergiesRemoteDataSourceImpl
    implements FamilyAllergiesRemoteDataSource {
  const FamilyAllergiesRemoteDataSourceImpl(this._apiServices);
  final ApiServices _apiServices;
  @override
  Future<bool> saveMemberAllergies(
    String memberId,
    FamilyMemberAllergiesRequestDto request,
  ) => _apiServices.saveFamilyMemberAllergies(memberId, request);
}
