import 'package:meal_meat_user/features/family_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/family_programs/data/models/response/subscription_program_response_dto.dart';

abstract class FamilyProgramsRemoteDataSource {
  Future<List<FamilyProgramResponseDto>> getFamilyPrograms({
    int? page,
    int? pageSize,
  });
  Future<List<FamilyBundleResponseDto>> getFamilyProgramBundles(
    String programId,
  );
}
