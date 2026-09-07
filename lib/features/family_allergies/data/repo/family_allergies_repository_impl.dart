import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_allergies/data/data_source/family_allergies_remote_data_source.dart';
import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';
import 'package:meal_meat_user/features/family_allergies/domain/entities/family_member_allergy_selection.dart';
import 'package:meal_meat_user/features/family_allergies/domain/repo/family_allergies_repository.dart';

@Injectable(as: FamilyAllergiesRepository)
class FamilyAllergiesRepositoryImpl implements FamilyAllergiesRepository {
  const FamilyAllergiesRepositoryImpl(this._remoteDataSource);
  final FamilyAllergiesRemoteDataSource _remoteDataSource;
  @override
  Future<ApiResult<bool>> saveMemberAllergies({
    required String memberId,
    required List<FamilyMemberAllergySelection> allergies,
  }) => safeApiCall(
    () => _remoteDataSource.saveMemberAllergies(
      memberId,
      FamilyMemberAllergiesRequestDto(
        allergies: allergies
            .map(
              (item) => FamilyMemberAllergyRequestDto(
                code: item.code,
                severity: item.severity,
              ),
            )
            .toList(),
      ),
    ),
  );
}
