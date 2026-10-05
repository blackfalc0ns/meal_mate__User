import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

@injectable
class PreviewNewAddressCoverageUseCase {
  const PreviewNewAddressCoverageUseCase(this._repository);

  final AddressesRepository _repository;

  Future<ApiResult<AddressCoveragePreviewEntity>> call(
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  }) {
    return _repository.previewNewAddressCoverage(
      request,
      page: page,
      pageSize: pageSize,
    );
  }
}
