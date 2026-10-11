import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_programs/data/data_source/subscription_programs_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_programs/data/mapper/subscription_bundle_mapper.dart';
import 'package:meal_meat_user/features/subscription_programs/data/mapper/subscription_program_mapper.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/repo/subscription_programs_repository.dart';

@Injectable(as: SubscriptionProgramsRepository)
class SubscriptionProgramsRepositoryImpl
    implements SubscriptionProgramsRepository {
  SubscriptionProgramsRepositoryImpl(this._remoteDataSource);

  final SubscriptionProgramsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<SubscriptionProgramEntity>>> getSubscriptionPrograms() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getSubscriptionPrograms();
      return response.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<PagedEntity<SubscriptionProgramEntity>>>
  getSubscriptionProgramsPage({required int page, required int pageSize}) {
    return safeApiCall(() async {
      try {
        final catalogResponse = await _remoteDataSource
            .getSubscriptionCatalogProgramsPage(page: page, pageSize: pageSize);
        return catalogResponse.toEntity();
      } on DioException catch (e) {
        if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
          final response = await _remoteDataSource.getSubscriptionProgramsPage(
            page: page,
            pageSize: pageSize,
          );
          return response.toEntity();
        }
        rethrow;
      }
    });
  }

  @override
  Future<ApiResult<SubscriptionProgramBundlesEntity>>
  getSubscriptionProgramBundles(String programId, {int? page, int? pageSize}) {
    return safeApiCall(() async {
      try {
        final catalogResponse = await _remoteDataSource
            .getSubscriptionCatalogProgramBundles(
              programId,
              page: page,
              pageSize: pageSize,
            );
        return catalogResponse.toProgramBundlesEntity();
      } on DioException catch (e) {
        if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
          final response = await _remoteDataSource
              .getSubscriptionProgramBundles(
                programId,
                page: page,
                pageSize: pageSize,
              );
          return response.toProgramBundlesEntity();
        }
        rethrow;
      }
    });
  }
}
