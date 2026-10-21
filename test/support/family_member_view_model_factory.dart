import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_view_model.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_context/domain/usecase/get_my_family_contexts_usecase.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/get_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_permissions_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/update_family_member_basic_info_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/renew_family_member_subscription_usecase.dart';
import 'package:meal_meat_user/features/family_management/member/domain/usecase/detach_family_member_usecase.dart';

FamilyMemberViewModel createFamilyMemberViewModel([
  GetFamilyMemberDetailUseCase? getDetail,
  GetFamilyMemberAccessUseCase? getAccess,
  UpdateFamilyMemberAccessUseCase? updateAccess,
  GetFamilyMemberPermissionsUseCase? getPermissions,
  UpdateFamilyMemberPermissionsUseCase? updatePermissions,
  UpdateFamilyMemberBasicInfoUseCase? updateBasicInfo,
  RenewFamilyMemberSubscriptionUseCase? renewSubscription,
  DetachFamilyMemberUseCase? detachMemberUseCase,
]) {
  final repo = _UnusedMemberRepository();
  return FamilyMemberViewModel(
    getDetail ??
        (getIt.isRegistered<GetFamilyMemberDetailUseCase>()
            ? getIt<GetFamilyMemberDetailUseCase>()
            : GetFamilyMemberDetailUseCase(repo)),
    getAccess ??
        (getIt.isRegistered<GetFamilyMemberAccessUseCase>()
            ? getIt<GetFamilyMemberAccessUseCase>()
            : GetFamilyMemberAccessUseCase(repo)),
    updateAccess ??
        (getIt.isRegistered<UpdateFamilyMemberAccessUseCase>()
            ? getIt<UpdateFamilyMemberAccessUseCase>()
            : UpdateFamilyMemberAccessUseCase(repo)),
    getPermissions ??
        (getIt.isRegistered<GetFamilyMemberPermissionsUseCase>()
            ? getIt<GetFamilyMemberPermissionsUseCase>()
            : GetFamilyMemberPermissionsUseCase(repo)),
    updatePermissions ??
        (getIt.isRegistered<UpdateFamilyMemberPermissionsUseCase>()
            ? getIt<UpdateFamilyMemberPermissionsUseCase>()
            : UpdateFamilyMemberPermissionsUseCase(repo)),
    updateBasicInfo ??
        (getIt.isRegistered<UpdateFamilyMemberBasicInfoUseCase>()
            ? getIt<UpdateFamilyMemberBasicInfoUseCase>()
            : UpdateFamilyMemberBasicInfoUseCase(repo)),
    renewSubscription ??
        (getIt.isRegistered<RenewFamilyMemberSubscriptionUseCase>()
            ? getIt<RenewFamilyMemberSubscriptionUseCase>()
            : RenewFamilyMemberSubscriptionUseCase(repo)),
    detachMemberUseCase ??
        (getIt.isRegistered<DetachFamilyMemberUseCase>()
            ? getIt<DetachFamilyMemberUseCase>()
            : DetachFamilyMemberUseCase(repo)),
    getIt.isRegistered<FamilyContextViewModel>()
        ? getIt<FamilyContextViewModel>()
        : FamilyContextViewModel(_EmptyContextsUseCase()),
  );
}

class _UnusedMemberRepository implements FamilyMemberRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<ApiResult<Never>>.value(
    ApiErrorResult<Never>(
      failure: Failure(errorMessage: 'No test result supplied'),
    ),
  );
}

class _EmptyContextsUseCase implements GetMyFamilyContextsUseCase {
  @override
  Future<ApiResult<List<FamilyContextEntity>>> call() async =>
      const ApiSuccessResult(data: []);
}
