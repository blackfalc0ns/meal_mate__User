import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';

@injectable
class GetFamilyMemberDetailUseCase {
  const GetFamilyMemberDetailUseCase(this._repository);

  final FamilyMemberRepository _repository;

  Future<ApiResult<FamilyMemberDetailEntity>> call(
    String memberId, {
    String locale = 'ar',
  }) {
    return _repository.getFamilyMemberDetail(memberId, locale: locale);
  }
}
