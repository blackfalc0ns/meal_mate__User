import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/family_addresses/domain/repo/family_addresses_repository.dart';

@injectable
class GetFamilyMemberAddressesUseCase {
  const GetFamilyMemberAddressesUseCase(this._repo);
  final FamilyAddressesRepository _repo;
  Future<ApiResult<List<CustomerAddressEntity>>> call(String memberId) =>
      _repo.getAddresses(memberId);
}

@injectable
class AddFamilyMemberAddressUseCase {
  const AddFamilyMemberAddressUseCase(this._repo);
  final FamilyAddressesRepository _repo;
  Future<ApiResult<CustomerAddressEntity>> call(
    String memberId,
    CustomerAddressRequestEntity request,
  ) => _repo.addAddress(memberId, request);
}

@injectable
class PreviewFamilyMemberAddressUseCase {
  const PreviewFamilyMemberAddressUseCase(this._repo);
  final FamilyAddressesRepository _repo;
  Future<ApiResult<AddressCoveragePreviewEntity>> call(
    String memberId,
    CustomerAddressRequestEntity request,
  ) => _repo.previewAddress(memberId, request);
}

@injectable
class PreviewExistingFamilyMemberAddressUseCase {
  const PreviewExistingFamilyMemberAddressUseCase(this._repo);
  final FamilyAddressesRepository _repo;
  Future<ApiResult<AddressCoveragePreviewEntity>> call(
    String memberId,
    String addressId,
  ) => _repo.previewExistingAddress(memberId, addressId);
}

@injectable
class SetDefaultFamilyMemberAddressUseCase {
  const SetDefaultFamilyMemberAddressUseCase(this._repo);
  final FamilyAddressesRepository _repo;
  Future<ApiResult<CustomerAddressEntity>> call(
    String memberId,
    String addressId,
  ) => _repo.setDefaultAddress(memberId, addressId);
}
