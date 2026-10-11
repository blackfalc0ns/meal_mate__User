import 'package:meal_meat_user/core/address/domain/contracts/address_editor_operations.dart';
import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/confirm_set_default_address_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/update_customer_address_usecase.dart';

typedef PreviewNewAddressCoverageFn =
    Future<ApiResult<AddressCoveragePreviewEntity>> Function(
      CustomerAddressRequestEntity request, {
      int? page,
      int? pageSize,
    });
typedef PreviewExistingAddressCoverageFn =
    Future<ApiResult<AddressCoveragePreviewEntity>> Function(
      String addressId, {
      int? page,
      int? pageSize,
    });
typedef AddCustomerAddressFn =
    Future<ApiResult<CustomerAddressEntity>> Function(
      CustomerAddressRequestEntity request,
    );
typedef UpdateCustomerAddressFn =
    Future<ApiResult<CustomerAddressEntity>> Function(
      String addressId,
      CustomerAddressRequestEntity request,
    );
typedef ConfirmSetDefaultAddressFn =
    Future<ApiResult<CustomerAddressEntity>> Function(String addressId);

class CustomerAddressEditorOperations implements AddressEditorOperations {
  CustomerAddressEditorOperations({
    PreviewNewAddressCoverageUseCase? previewNewAddressCoverageUseCase,
    PreviewExistingAddressCoverageUseCase?
    previewExistingAddressCoverageUseCase,
    AddCustomerAddressUseCase? addCustomerAddressUseCase,
    UpdateCustomerAddressUseCase? updateCustomerAddressUseCase,
    ConfirmSetDefaultAddressUseCase? confirmSetDefaultAddressUseCase,
    PreviewNewAddressCoverageFn? previewNewAddressCoverage,
    PreviewExistingAddressCoverageFn? previewExistingAddressCoverage,
    AddCustomerAddressFn? addCustomerAddress,
    UpdateCustomerAddressFn? updateCustomerAddress,
    ConfirmSetDefaultAddressFn? confirmSetDefaultAddress,
  }) : _previewNew =
           previewNewAddressCoverage ??
           (previewNewAddressCoverageUseCase != null
               ? previewNewAddressCoverageUseCase.call
               : null),
       _previewExisting =
           previewExistingAddressCoverage ??
           (previewExistingAddressCoverageUseCase != null
               ? previewExistingAddressCoverageUseCase.call
               : null),
       _add =
           addCustomerAddress ??
           (addCustomerAddressUseCase != null
               ? addCustomerAddressUseCase.call
               : null),
       _update =
           updateCustomerAddress ??
           (updateCustomerAddressUseCase != null
               ? updateCustomerAddressUseCase.call
               : null),
       _setDefault =
           confirmSetDefaultAddress ??
           (confirmSetDefaultAddressUseCase != null
               ? confirmSetDefaultAddressUseCase.call
               : null);

  final PreviewNewAddressCoverageFn? _previewNew;
  final PreviewExistingAddressCoverageFn? _previewExisting;
  final AddCustomerAddressFn? _add;
  final UpdateCustomerAddressFn? _update;
  final ConfirmSetDefaultAddressFn? _setDefault;

  @override
  Set<AddressEditorAction> get supportedActions => const {
    AddressEditorAction.add,
    AddressEditorAction.update,
    AddressEditorAction.setDefault,
  };

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewNew(
    CustomerAddressRequestEntity request, {
    int? page,
    int? pageSize,
  }) {
    if (_previewNew != null) {
      return _previewNew(request, page: page, pageSize: pageSize);
    }
    return Future.value(
      ApiErrorResult(
        failure: Failure(errorMessage: 'Preview new operation not configured'),
      ),
    );
  }

  @override
  Future<ApiResult<AddressCoveragePreviewEntity>> previewExisting(
    String addressId, {
    int? page,
    int? pageSize,
  }) {
    if (_previewExisting != null) {
      return _previewExisting(addressId, page: page, pageSize: pageSize);
    }
    return Future.value(
      ApiErrorResult(
        failure: Failure(
          errorMessage: 'Preview existing operation not configured',
        ),
      ),
    );
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> add(
    CustomerAddressRequestEntity request,
  ) {
    if (_add != null) {
      return _add(request);
    }
    return Future.value(
      ApiErrorResult(
        failure: Failure(errorMessage: 'Add operation not configured'),
      ),
    );
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> update(
    String addressId,
    CustomerAddressRequestEntity request,
  ) {
    if (_update != null) {
      return _update(addressId, request);
    }
    return Future.value(
      ApiErrorResult(
        failure: Failure(errorMessage: 'Update operation not configured'),
      ),
    );
  }

  @override
  Future<ApiResult<CustomerAddressEntity>> setDefault(String addressId) {
    if (_setDefault != null) {
      return _setDefault(addressId);
    }
    return Future.value(
      ApiErrorResult(
        failure: Failure(errorMessage: 'Set default operation not configured'),
      ),
    );
  }
}
