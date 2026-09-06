# Address Coverage Preview & Confirmation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the two-step Address Coverage Preview before saving and Confirmation workflow across the mobile app, verifying restaurant delivery coverage for active customer subscriptions.

**Architecture:** Feature-Based Clean Architecture. UI triggers Preview -> ViewModel calls Preview UseCases -> Repository -> Remote DataSource -> Retrofit ApiServices. Coverage preview results open a modal bottom sheet displaying covered restaurants or conflict warnings; user confirmation invokes persistence endpoints (Add, Update, or Set Default) and activates the delivery address.

**Tech Stack:** Flutter, Dart, Dio, Retrofit, flutter_bloc (Cubit), get_it, injectable, json_serializable.

**Spec:** `docs/superpowers/specs/2026-09-06-address-coverage-preview-design.md`

## Global Constraints
- Strictly follow `rules/rules_backend.md` and `rules/ui_rules.md`.
- No hardcoded colors; use `context.colorScheme`.
- No hardcoded strings; use `context.localization` and update `.arb` files.
- Use `Spacing.*` constants for all dimensions and padding.
- Use `styles_manager.dart` for all typography styles.
- Preserve existing project architecture and reuse existing classes.

---

### Task 1: Endpoints, Request & Response DTOs, and ApiServices

**Files:**
- Modify: `lib/core/network/network_constants.dart`
- Create: `lib/features/addresses/data/models/request/address_coverage_preview_request_dto.dart`
- Create: `lib/features/addresses/data/models/response/address_coverage_preview_response_dto.dart`
- Modify: `lib/core/network/api_services.dart`

**Interfaces:**
- Produces:
  - `EndPoints.customerAddressPreviewCoverage`: `/api/v1/customers/me/addresses/preview-coverage`
  - `EndPoints.customerExistingAddressPreviewCoverage`: `/api/v1/customers/me/addresses/{addressId}/preview-coverage`
  - `EndPoints.customerAddressSetDefault`: `/api/v1/customers/me/addresses/{addressId}/set-default`
  - `AddressCoveragePreviewRequestDto`: DTO with `toJson()`
  - `AddressCoveragePreviewResponseDto`: DTO with `fromJson()`
  - `ApiServices.previewNewAddressCoverage`
  - `ApiServices.previewExistingAddressCoverage`
  - `ApiServices.confirmSetDefaultAddress`

- [ ] **Step 1: Add endpoints to `network_constants.dart`**
  Add the 3 endpoints under `abstract class EndPoints`:
  ```dart
  static const String customerAddressPreviewCoverage =
      '/api/v1/customers/me/addresses/preview-coverage';
  static const String customerExistingAddressPreviewCoverage =
      '/api/v1/customers/me/addresses/{addressId}/preview-coverage';
  static const String customerAddressSetDefault =
      '/api/v1/customers/me/addresses/{addressId}/set-default';
  ```

- [ ] **Step 2: Create `address_coverage_preview_request_dto.dart`**
  ```dart
  import 'package:json_annotation/json_annotation.dart';

  part 'address_coverage_preview_request_dto.g.dart';

  @JsonSerializable(createFactory: false)
  class AddressCoveragePreviewRequestDto {
    const AddressCoveragePreviewRequestDto({
      this.regionId,
      this.blockRegionId,
      this.latitude,
      this.longitude,
      this.governorate,
      this.area,
      this.block,
      this.isDefault = true,
    });

    final String? regionId;
    final String? blockRegionId;
    final double? latitude;
    final double? longitude;
    final String? governorate;
    final String? area;
    final String? block;
    final bool isDefault;

    Map<String, dynamic> toJson() =>
        _$AddressCoveragePreviewRequestDtoToJson(this);
  }
  ```

- [ ] **Step 3: Create `address_coverage_preview_response_dto.dart`**
  ```dart
  import 'package:json_annotation/json_annotation.dart';
  import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';

  part 'address_coverage_preview_response_dto.g.dart';

  @JsonSerializable(createToJson: false)
  class AddressCoveragePreviewResponseDto {
    const AddressCoveragePreviewResponseDto({
      this.canSetAsDefault = true,
      this.isCurrentSubscriptionRestaurantCovered = true,
      this.uncoveredRestaurantNameAr,
      this.uncoveredRestaurantNameEn,
      this.conflictMessage,
      this.resolvedRegionId,
      this.resolvedRegionNameAr,
      this.resolvedRegionNameEn,
      this.governorate,
      this.area,
      this.block,
      this.latitude,
      this.longitude,
      this.hasActiveSubscription = false,
      this.restaurantCoverageNotice,
      this.servingRestaurants = const [],
    });

    final bool canSetAsDefault;
    final bool isCurrentSubscriptionRestaurantCovered;
    final String? uncoveredRestaurantNameAr;
    final String? uncoveredRestaurantNameEn;
    final String? conflictMessage;
    final String? resolvedRegionId;
    final String? resolvedRegionNameAr;
    final String? resolvedRegionNameEn;
    final String? governorate;
    final String? area;
    final String? block;
    final double? latitude;
    final double? longitude;
    final bool hasActiveSubscription;
    @JsonKey(fromJson: _parseCoverageNotice)
    final CustomerAddressCoverageNoticeDto? restaurantCoverageNotice;
    @JsonKey(fromJson: _parseServingRestaurants)
    final List<ServingRestaurantDto> servingRestaurants;

    static CustomerAddressCoverageNoticeDto? _parseCoverageNotice(dynamic value) {
      if (value == null) return null;
      if (value is Map) {
        return CustomerAddressCoverageNoticeDto.fromJson(
          Map<String, dynamic>.from(value),
        );
      }
      final str = value.toString().trim();
      return str.isEmpty ? null : CustomerAddressCoverageNoticeDto(ar: str, en: str);
    }

    static List<ServingRestaurantDto> _parseServingRestaurants(dynamic value) {
      if (value is List) {
        return value
            .whereType<Map>()
            .map((e) => ServingRestaurantDto.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return const [];
    }

    factory AddressCoveragePreviewResponseDto.fromJson(
      Map<String, dynamic> json,
    ) => _$AddressCoveragePreviewResponseDtoFromJson(json);
  }
  ```

- [ ] **Step 4: Update `api_services.dart` with preview and set-default methods**
  Add in `ApiServices`:
  ```dart
  @POST(EndPoints.customerAddressPreviewCoverage)
  Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(
    @Body() AddressCoveragePreviewRequestDto request,
  );

  @GET(EndPoints.customerExistingAddressPreviewCoverage)
  Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
    @Path('addressId') String addressId,
  );

  @POST(EndPoints.customerAddressSetDefault)
  Future<CustomerAddressResponseDto> confirmSetDefaultAddress(
    @Path('addressId') String addressId,
    @Body() Map<String, dynamic> body,
  );
  ```

---

### Task 2: Domain Layer Entities, Repository Contract & Use Cases

**Files:**
- Create: `lib/features/addresses/domain/entities/address_coverage_preview_entity.dart`
- Modify: `lib/features/addresses/domain/repo/addresses_repository.dart`
- Create: `lib/features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart`
- Create: `lib/features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart`
- Create: `lib/features/addresses/domain/usecase/confirm_set_default_address_usecase.dart`

**Interfaces:**
- Consumes: `CustomerAddressRequestEntity`, `CustomerAddressEntity`, `ApiResult`
- Produces: `AddressCoveragePreviewEntity`, `PreviewNewAddressCoverageUseCase`, `PreviewExistingAddressCoverageUseCase`, `ConfirmSetDefaultAddressUseCase`

- [ ] **Step 1: Create `address_coverage_preview_entity.dart`**
  ```dart
  import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';

  class AddressCoveragePreviewEntity {
    const AddressCoveragePreviewEntity({
      required this.canSetAsDefault,
      required this.isCurrentSubscriptionRestaurantCovered,
      this.uncoveredRestaurantNameAr,
      this.uncoveredRestaurantNameEn,
      this.conflictMessage,
      this.resolvedRegionId,
      this.resolvedRegionNameAr,
      this.resolvedRegionNameEn,
      this.governorate,
      this.area,
      this.block,
      this.latitude,
      this.longitude,
      required this.hasActiveSubscription,
      this.restaurantCoverageNotice,
      this.servingRestaurants = const [],
    });

    final bool canSetAsDefault;
    final bool isCurrentSubscriptionRestaurantCovered;
    final String? uncoveredRestaurantNameAr;
    final String? uncoveredRestaurantNameEn;
    final String? conflictMessage;
    final String? resolvedRegionId;
    final String? resolvedRegionNameAr;
    final String? resolvedRegionNameEn;
    final String? governorate;
    final String? area;
    final String? block;
    final double? latitude;
    final double? longitude;
    final bool hasActiveSubscription;
    final CustomerAddressCoverageNoticeEntity? restaurantCoverageNotice;
    final List<ServingRestaurantEntity> servingRestaurants;

    String? uncoveredRestaurantName(String localeName) {
      if (localeName.startsWith('ar')) {
        return (uncoveredRestaurantNameAr != null && uncoveredRestaurantNameAr!.isNotEmpty)
            ? uncoveredRestaurantNameAr
            : uncoveredRestaurantNameEn;
      }
      return (uncoveredRestaurantNameEn != null && uncoveredRestaurantNameEn!.isNotEmpty)
          ? uncoveredRestaurantNameEn
          : uncoveredRestaurantNameAr;
    }
  }
  ```

- [ ] **Step 2: Add methods to `AddressesRepository`**
  In `lib/features/addresses/domain/repo/addresses_repository.dart`:
  ```dart
  Future<ApiResult<AddressCoveragePreviewEntity>> previewNewAddressCoverage(
    CustomerAddressRequestEntity request,
  );

  Future<ApiResult<AddressCoveragePreviewEntity>> previewExistingAddressCoverage(
    String addressId,
  );

  Future<ApiResult<CustomerAddressEntity>> confirmSetDefaultAddress(
    String addressId,
  );
  ```

- [ ] **Step 3: Create Use Cases**
  - Create `preview_new_address_coverage_usecase.dart`:
    ```dart
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
        CustomerAddressRequestEntity request,
      ) => _repository.previewNewAddressCoverage(request);
    }
    ```
  - Create `preview_existing_address_coverage_usecase.dart`:
    ```dart
    import 'package:injectable/injectable.dart';
    import 'package:meal_meat_user/core/network/api_results.dart';
    import 'package:meal_meat_user/features/addresses/domain/entities/address_coverage_preview_entity.dart';
    import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

    @injectable
    class PreviewExistingAddressCoverageUseCase {
      const PreviewExistingAddressCoverageUseCase(this._repository);
      final AddressesRepository _repository;

      Future<ApiResult<AddressCoveragePreviewEntity>> call(String addressId) =>
          _repository.previewExistingAddressCoverage(addressId);
    }
    ```
  - Create `confirm_set_default_address_usecase.dart`:
    ```dart
    import 'package:injectable/injectable.dart';
    import 'package:meal_meat_user/core/network/api_results.dart';
    import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
    import 'package:meal_meat_user/features/addresses/domain/repo/addresses_repository.dart';

    @injectable
    class ConfirmSetDefaultAddressUseCase {
      const ConfirmSetDefaultAddressUseCase(this._repository);
      final AddressesRepository _repository;

      Future<ApiResult<CustomerAddressEntity>> call(String addressId) =>
          _repository.confirmSetDefaultAddress(addressId);
    }
    ```

---

### Task 3: Remote DataSource, Mapper & Repository Implementation

**Files:**
- Modify: `lib/features/addresses/data/data_source/addresses_remote_data_source.dart`
- Modify: `lib/features/addresses/data/data_source/addresses_remote_data_source_impl.dart`
- Modify: `lib/features/addresses/data/mapper/customer_address_mapper.dart`
- Modify: `lib/features/addresses/data/repo/addresses_repository_impl.dart`

**Interfaces:**
- Consumes: `ApiServices`, `AddressCoveragePreviewResponseDto`, `CustomerAddressRequestEntity`
- Produces: Implemented methods in `AddressesRepositoryImpl` and `AddressesRemoteDataSourceImpl`

- [ ] **Step 1: Add DataSource methods to interface & implementation**
  Add to `AddressesRemoteDataSource`:
  ```dart
  Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(
    AddressCoveragePreviewRequestDto request,
  );
  Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
    String addressId,
  );
  Future<CustomerAddressResponseDto> confirmSetDefaultAddress(
    String addressId,
  );
  ```
  Implement in `AddressesRemoteDataSourceImpl`:
  ```dart
  @override
  Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(
    AddressCoveragePreviewRequestDto request,
  ) {
    return _apiServices.previewNewAddressCoverage(request);
  }

  @override
  Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
    String addressId,
  ) {
    return _apiServices.previewExistingAddressCoverage(addressId);
  }

  @override
  Future<CustomerAddressResponseDto> confirmSetDefaultAddress(
    String addressId,
  ) {
    return _apiServices.confirmSetDefaultAddress(addressId, const {});
  }
  ```

- [ ] **Step 2: Add Mapping methods in `customer_address_mapper.dart`**
  Map `AddressCoveragePreviewResponseDto` -> `AddressCoveragePreviewEntity` and `CustomerAddressRequestEntity` -> `AddressCoveragePreviewRequestDto`.

- [ ] **Step 3: Implement Repository methods in `addresses_repository_impl.dart`**
  Implement `previewNewAddressCoverage`, `previewExistingAddressCoverage`, and `confirmSetDefaultAddress` using `safeApiCall`.

---

### Task 4: Localization Keys

**Files:**
- Modify: `lib/core/l10n/app_ar.arb`
- Modify: `lib/core/l10n/app_en.arb`

- [ ] **Step 1: Add address coverage keys to `app_ar.arb`**
  ```json
  "address_preview_check_button": "متابعة وتحقق من التغطية",
  "address_coverage_covered_title": "منطقتك مغطاة بمطاعم اشتراكك",
  "address_coverage_uncovered_title": "المنطقة غير مغطاة باشتراكك",
  "address_coverage_confirm_save": "تأكيد وحفظ العنوان",
  "address_coverage_confirm_set_default": "تأكيد تعيين كافتراضي",
  "address_coverage_choose_another": "اختيار عنوان آخر",
  "address_coverage_uncovered_warning_prefix": "مطعم اشتراكك الحالي ({restaurant}) لا يدعم التوصيل إلى هذه المنطقة."
  ```

- [ ] **Step 2: Add address coverage keys to `app_en.arb`**
  ```json
  "address_preview_check_button": "Continue & Check Coverage",
  "address_coverage_covered_title": "Your area is covered by your subscription",
  "address_coverage_uncovered_title": "Area not covered by your subscription",
  "address_coverage_confirm_save": "Confirm and Save Address",
  "address_coverage_confirm_set_default": "Confirm Set as Default",
  "address_coverage_choose_another": "Choose Another Location",
  "address_coverage_uncovered_warning_prefix": "Your subscribed restaurant ({restaurant}) does not deliver to this area."
  ```

---

### Task 5: Presentation State, Events & AddressesViewModel

**Files:**
- Modify: `lib/features/addresses/presentation/manager/addresses_state.dart`
- Modify: `lib/features/addresses/presentation/manager/addresses_event.dart`
- Modify: `lib/features/addresses/presentation/manager/addresses_view_model.dart`

**Interfaces:**
- Produces:
  - `AddressPendingActionType` (`add`, `update`, `setDefault`)
  - `AddressCoveragePreviewState`
  - `PreviewNewAddressCoverageEvent`
  - `PreviewUpdateAddressCoverageEvent`
  - `PreviewExistingAddressCoverageEvent`
  - `ConfirmSetDefaultAddressEvent`
  - `ConfirmSaveAddressEvent`
  - `ClearCoveragePreviewEvent`

- [ ] **Step 1: Update `addresses_state.dart`**
  Define `enum AddressPendingActionType { add, update, setDefault }`
  Add `AddressCoveragePreviewState` with `isLoading`, `isSuccess`, `preview`, `pendingAction`, `targetAddressId`, `pendingRequest`, `failure`.
  Add `coveragePreview` property to `AddressesState` and `copyWith`.

- [ ] **Step 2: Update `addresses_event.dart`**
  Add preview and confirmation event classes.

- [ ] **Step 3: Update `addresses_view_model.dart`**
  Inject:
  - `_previewNewAddressCoverageUseCase`
  - `_previewExistingAddressCoverageUseCase`
  - `_confirmSetDefaultAddressUseCase`
  Handle preview events with Kuwait bounds check (`isWithinKuwaitBounds`).
  Handle confirmation events. On success of confirmation, reload addresses via `_getCustomerAddresses()`.

---

### Task 6: Address Coverage Preview Bottom Sheet Widget

**Files:**
- Create/Update: `lib/features/addresses/presentation/widgets/address_coverage_preview_bottom_sheet.dart`

**Interfaces:**
- Consumes: `AddressCoveragePreviewEntity`, `isSubmitting`, `onConfirm`, `onChooseAnother`

- [ ] **Step 1: Build the Bottom Sheet UI**
  - Draggable handle at top.
  - Success container (green theme) or warning container (error theme) depending on `canSetAsDefault`.
  - Notice text and conflict message.
  - Horizontal ListView of `servingRestaurants` (with restaurant logo, name, rating).
  - Main button: `AppButton.filled` with text based on action (`address_coverage_confirm_save` or `address_coverage_confirm_set_default`).
    - If `canSetAsDefault == false`: Button is disabled (`onPressed: null`).
    - If `canSetAsDefault == true`: Calls `onConfirm()`.
  - Secondary button: `AppButton.outlined` with text `address_coverage_choose_another` calling `onChooseAnother()`.

---

### Task 7: UI Integration in Choose Location Screen & Frame

**Files:**
- Modify: `lib/features/addresses/presentation/widgets/address_choose_location_sheet.dart`
- Modify: `lib/features/addresses/presentation/widgets/addresses_figma_frame.dart`
- Modify: `lib/features/addresses/presentation/screens/address_choose_location_screen.dart`

- [ ] **Step 1: Update button text in `address_choose_location_sheet.dart`**
  Update button text to `locale.address_preview_check_button`.

- [ ] **Step 2: Update `_submitAddress` in `addresses_figma_frame.dart`**
  Instead of immediately calling `AddCustomerAddressEvent` or `UpdateCustomerAddressEvent`, dispatch:
  - `PreviewNewAddressCoverageEvent(request)` (when adding)
  - `PreviewUpdateAddressCoverageEvent(addressId, request)` (when updating)

- [ ] **Step 3: Listen to `coveragePreview` in `address_choose_location_screen.dart`**
  In `BlocConsumer`:
  When `coveragePreview.isSuccess && coveragePreview.preview != null`:
  Show modal bottom sheet `AddressCoveragePreviewBottomSheet`.
  - On confirm: Dispatch `ConfirmSaveAddressEvent` (for add) or `ConfirmUpdateAddressEvent` (for edit).
  - On action success: Close sheet, then `Navigator.of(context).pop(true)`.

---

### Task 8: UI Integration in Saved Addresses Screen

**Files:**
- Modify: `lib/features/addresses/presentation/screens/addresses_screen.dart`

- [ ] **Step 1: Update "Set Default" in `addresses_screen.dart`**
  In `_buildAddressTiles`:
  When tapping `onSetDefault`:
  Dispatch `PreviewExistingAddressCoverageEvent(address.addressId)`.

- [ ] **Step 2: Handle `coveragePreview` listener in `addresses_screen.dart`**
  Show `AddressCoveragePreviewBottomSheet`:
  - If confirmed: Dispatch `ConfirmSetDefaultAddressEvent(addressId)`.
  - On success: Closes sheet, shows success/notice feedback, addresses list refreshes.

---

### Task 9: Code Generation & Verification

- [ ] **Step 1: Run build_runner**
  Run `dart run build_runner build --delete-conflicting-outputs` to generate JSON serializable and Retrofit files.

- [ ] **Step 2: Run Flutter analysis**
  Run `flutter analyze` to ensure 0 errors.

- [ ] **Step 3: Verify all paths**
  Verify adding address, editing address, and setting default address flows.
