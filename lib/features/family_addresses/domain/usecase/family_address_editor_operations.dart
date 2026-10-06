import 'package:meal_meat_user/core/address/domain/contracts/address_editor_operations.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';

typedef PreviewFamilyMemberAddressFn = Future<ApiResult<AddressCoveragePreviewEntity>> Function(
  String memberId,
  CustomerAddressRequestEntity request, {
  int? page,
  int? pageSize,
});
typedef AddFamilyMemberAddressFn = Future<ApiResult<CustomerAddressEntity>> Function(
  String memberId,
  CustomerAddressRequestEntity request,
);

class FamilyAddressEditorOperations implements AddressEditorOperations {
  FamilyAddressEditorOperations({
    required this.memberId,
    PreviewFamilyMemberAddressFn? previewFamilyMemberAddress,
    AddFamilyMemberAddressFn? addFamilyMemberAddress,
    PreviewFamilyMemberAddressUseCase? previewFamilyMemberAddressUseCase,
    AddFamilyMemberAddressUseCase? addFamilyMemberAddressUseCase,
  })  : _preview = previewFamilyMemberAddress ??
            (previewFamilyMemberAddressUseCase != null
                ? previewFamilyMemberAddressUseCase.call
                : null),
        _add = addFamilyMemberAddress ??
            (addFamilyMemberAddressUseCase != null
                ? addFamilyMemberAddressUseCase.call
                : null);

  final String memberId;
  final PreviewFamilyMemberAddressFn? _preview;
  final AddFamilyMemberAddressFn? _add;

  @override
  Set<AddressEditorAction> get supportedActions => const {
        AddressEditorAction.add,
      };

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewNew(
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  }) {
    if (_preview != null) {
      return _preview(memberId, request, page: page, pageSize: pageSize);
    }
    return Future.value(ApiErrorResult(
      failure: Failure(errorMessage: 'Preview operation not configured'),
    ));
  }

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewExisting(
    String addressId, {
    int? page,
    int? pageSize,
  }) async {
    return ApiErrorResult(
      failure: Failure(
        errorMessage: 'Preview existing address is not supported for family members',
      ),
    );
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> add(
    CustomerAddressRequestEntity request,
  ) {
    if (_add != null) {
      return _add(memberId, request);
    }
    return Future.value(ApiErrorResult(
      failure: Failure(errorMessage: 'Add operation not configured'),
    ));
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> update(
    String addressId,
    CustomerAddressRequestEntity request,
  ) async {
    return ApiErrorResult(
      failure: Failure(
        errorMessage: 'Update address is not supported for family members',
      ),
    );
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> setDefault(String addressId) async {
    return ApiErrorResult(
      failure: Failure(
        errorMessage: 'Set default address is not supported for family members',
      ),
    );
  }
}
