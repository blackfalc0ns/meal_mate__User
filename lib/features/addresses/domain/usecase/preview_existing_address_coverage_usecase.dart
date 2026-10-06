import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@injectable
class PreviewExistingAddressCoverageUseCase {
  const PreviewExistingAddressCoverageUseCase(this._repository);

  final AddressesRepository _repository;

  Future<ApiResult<AddressCoveragePreviewEntity>> call(
    String addressId, {
    int? page,
    int? pageSize,
  }) {
    return _repository.previewExistingAddressCoverage(
      addressId,
      page: page,
      pageSize: pageSize,
    );
  }
}
