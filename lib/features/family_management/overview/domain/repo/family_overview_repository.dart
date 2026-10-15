import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_home_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

abstract interface class FamilyOverviewRepository {
  Future<ApiResult<FamilyHomeEntity>> getFamilyHome({String locale = 'ar'});
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getFamilyMembers({
    String locale = 'ar',
  });
  Future<ApiResult<List<FamilyMemberSummaryEntity>>> getFamilySwitcher({
    String locale = 'ar',
  });
}
