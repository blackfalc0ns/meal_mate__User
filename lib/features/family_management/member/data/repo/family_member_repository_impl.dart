import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/member/data/data_source/family_member_remote_data_source.dart';
import 'package:meal_meat_user/features/family_management/member/data/mapper/family_member_mapper.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/data/models/request/update_family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_access_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_permissions_entity.dart';
import 'package:meal_meat_user/features/family_management/member/domain/repo/family_member_repository.dart';
import 'package:meal_meat_user/features/family_management/shared/family_management_error_mapper.dart';

@Injectable(as: FamilyMemberRepository)
class FamilyMemberRepositoryImpl implements FamilyMemberRepository {
  const FamilyMemberRepositoryImpl(this._remoteDataSource);

  final FamilyMemberRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<FamilyMemberDetailEntity>> getFamilyMemberDetail(
    String memberId, {
    String locale = 'ar',
  }) async {
    try {
      final dto = await _remoteDataSource.getFamilyMemberDetail(memberId);
      final entity = FamilyMemberMapper.toDetailEntity(dto, locale: locale);
      return ApiSuccessResult(data: entity);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }

  @override
  Future<ApiResult<FamilyMemberAccessEntity>> getMemberAccess(
    String memberId,
  ) async {
    try {
      final dto = await _remoteDataSource.getMemberAccess(memberId);
      final entity = FamilyMemberMapper.toAccessEntity(dto);
      return ApiSuccessResult(data: entity);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }

  @override
  Future<ApiResult<FamilyMemberAccessEntity>> updateMemberAccess(
    String memberId,
    UpdateFamilyMemberAccessRequestDto request,
  ) async {
    try {
      final dto = await _remoteDataSource.updateMemberAccess(memberId, request);
      final entity = FamilyMemberMapper.toAccessEntity(dto);
      return ApiSuccessResult(data: entity);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> getMemberPermissions(
    String memberId, {
    String locale = 'ar',
  }) async {
    try {
      final dto = await _remoteDataSource.getMemberPermissions(memberId);
      final entity =
          FamilyMemberMapper.toPermissionsEntity(dto, locale: locale);
      return ApiSuccessResult(data: entity);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }

  @override
  Future<ApiResult<FamilyMemberPermissionsEntity>> updateMemberPermissions(
    String memberId,
    UpdateFamilyMemberPermissionsRequestDto request, {
    String locale = 'ar',
  }) async {
    try {
      final dto = await _remoteDataSource.updateMemberPermissions(
        memberId,
        request,
      );
      final entity =
          FamilyMemberMapper.toPermissionsEntity(dto, locale: locale);
      return ApiSuccessResult(data: entity);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }

  @override
  Future<ApiResult<void>> updateMemberBasicInfo(
    String memberId,
    FamilyMemberWriteRequestDto request,
  ) async {
    try {
      await _remoteDataSource.updateMemberBasicInfo(memberId, request);
      return const ApiSuccessResult(data: null);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }

  @override
  Future<ApiResult<void>> renewMemberSubscription(String renewalPath) async {
    try {
      await _remoteDataSource.renewMemberSubscription(renewalPath);
      return const ApiSuccessResult(data: null);
    } catch (e) {
      return ApiErrorResult(failure: mapFamilyManagementError(e));
    }
  }
}
