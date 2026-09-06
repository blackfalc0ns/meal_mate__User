# Design Spec: Address Coverage Preview & Confirmation Flow

**Date:** 2026-09-06  
**Status:** Approved by User  
**Scope:** Feature-Based Clean Architecture update for addresses in `meal_mate__User` (Mobile Flutter App).

---

## 1. Executive Summary & Goals
To prevent users from saving unsupported delivery addresses and to give customers full visibility of available subscription restaurants prior to committing changes, the address flow is structured as a **Two-Step Workflow**:
1. **Preview Coverage (معاينة التغطية قبل الحفظ):** Read-only verification against the customer's active subscription restaurant pool. Does not alter database state.
2. **Confirmation (التأكيد والحفظ):** Triggered only after user views the preview results and explicitly confirms. Immediately activates delivery address for eligible subscription days.

This workflow applies to:
- **Adding a new delivery address** (`POST /customers/me/addresses/preview-coverage` -> `POST /customers/me/addresses`).
- **Editing an existing delivery address** (`POST /customers/me/addresses/preview-coverage` -> `PUT /customers/me/addresses/{id}`).
- **Setting an existing address as default** (`GET /customers/me/addresses/{id}/preview-coverage` -> `POST /customers/me/addresses/{id}/set-default`).

---

## 2. Business Rules & Behavior
1. **Active Subscription Scope (`hasActiveSubscription: true`):**
   - `servingRestaurants` is restricted exclusively to restaurants in the customer's active subscription package (`SubscriptionRestaurantSnapshots`) that service the specified region/coordinates.
   - If any subscribed meal preparation restaurant does not deliver to the address:
     - `canSetAsDefault: false`.
     - `isCurrentSubscriptionRestaurantCovered: false`.
     - `uncoveredRestaurantNameAr` and `uncoveredRestaurantNameEn` are populated.
     - `conflictMessage` provides human-readable Arabic explanation.
     - The confirmation button in the UI is **Disabled**.
2. **No Active Subscription (`hasActiveSubscription: false`):**
   - `canSetAsDefault: true` always.
   - `servingRestaurants` returns all active and approved restaurants servicing the region system-wide for exploratory purposes.
   - Confirmation button is **Enabled**.
3. **No Database Persistence on Preview:**
   - Calling preview endpoints does not persist or modify any record in the backend database.
4. **Immediate Delivery Activation:**
   - Calling `POST /customers/me/addresses/{id}/set-default` or creating a default address sets `isDeliveryActive: true` and updates un-invoiced future subscription days.

---

## 3. Endpoints & API Contracts

### Base URL: `https://maelmate.runasp.net/api/v1`

### Endpoints
1. `POST /customers/me/addresses/preview-coverage`
   - Request Body:
     ```json
     {
       "regionId": "d4a9acc2-afb8-49d8-b440-f93b8622239c",
       "blockRegionId": "817ce4d2-7941-4c58-a0a9-8aa72bb93610",
       "latitude": 29.3412132,
       "longitude": 48.082421,
       "governorate": "حولي",
       "area": "السالمية",
       "block": "قطعة 5",
       "isDefault": true
     }
     ```
   - Response Body (200 OK): `AddressCoveragePreviewResponseDto`
2. `GET /customers/me/addresses/{addressId}/preview-coverage`
   - Path parameter: `addressId`. No request body.
   - Response Body (200 OK): `AddressCoveragePreviewResponseDto`
3. `POST /customers/me/addresses/{addressId}/set-default`
   - Path parameter: `addressId`. Request body: `{}`.
   - Response Body (200 OK): `CustomerAddressResponseDto`.
   - Conflict (409): Returns conflict failure if address restaurant does not service region.
4. Existing Endpoints:
   - `POST /customers/me/addresses`: Create new address.
   - `PUT /customers/me/addresses/{addressId}`: Update existing address.
   - `DELETE /customers/me/addresses/{addressId}`: Delete address.
   - `GET /customers/me/addresses`: List customer addresses.

---

## 4. Architecture & Component Design

### 4.1 Data Layer (`lib/features/addresses/data`)
- **DTOs (`models/request` & `models/response`):**
  - `AddressCoveragePreviewRequestDto`: JSON serialization for preview payload.
  - `AddressCoveragePreviewResponseDto`: Parsed response from preview endpoints.
  - `ServingRestaurantDto` & `LocalizedNoticeDto`: Embedded inside response.
- **Remote Data Source (`AddressesRemoteDataSource` & `AddressesRemoteDataSourceImpl`):**
  - `Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(AddressCoveragePreviewRequestDto request);`
  - `Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(String addressId);`
  - `Future<CustomerAddressResponseDto> confirmSetDefault(String addressId);`
- **Mapper (`AddressMapper`):**
  - Maps `AddressCoveragePreviewResponseDto` -> `AddressCoveragePreviewEntity`.
  - Maps `AddressCoveragePreviewRequestEntity` -> `AddressCoveragePreviewRequestDto`.
- **Repository Implementation (`AddressesRepositoryImpl`):**
  - Wraps remote calls with `safeApiCall` returning `ApiResult<AddressCoveragePreviewEntity>` and `ApiResult<CustomerAddressEntity>`.

### 4.2 Domain Layer (`lib/features/addresses/domain`)
- **Entities:**
  - `AddressCoveragePreviewEntity`:
    ```dart
    class AddressCoveragePreviewEntity {
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
    }
    ```
- **Use Cases:**
  - `PreviewNewAddressCoverageUseCase`: executes preview for new/edited address data.
  - `PreviewExistingAddressCoverageUseCase`: executes preview for existing address ID.
  - `ConfirmSetDefaultAddressUseCase`: executes `set-default` call.

### 4.3 Presentation Layer (`lib/features/addresses/presentation`)
- **Cubit / ViewModel (`AddressesViewModel`):**
  - State holds `AddressCoveragePreviewState`:
    ```dart
    class AddressCoveragePreviewState {
      final bool isLoading;
      final bool isSuccess;
      final AddressCoveragePreviewEntity? preview;
      final AddressPendingActionType? pendingAction; // add | update | setDefault
      final String? targetAddressId;
      final CustomerAddressRequestEntity? pendingRequest;
      final Failure? failure;
    }
    ```
  - Events:
    - `PreviewNewAddressCoverageEvent(request)`
    - `PreviewUpdateAddressCoverageEvent(addressId, request)`
    - `PreviewExistingAddressCoverageEvent(addressId)`
    - `ConfirmSetDefaultAddressEvent(addressId)`
    - `ConfirmSaveNewAddressEvent(request)`
    - `ConfirmUpdateAddressEvent(addressId, request)`
    - `ClearCoveragePreviewEvent()`
- **Widgets & Screens:**
  - `AddressCoveragePreviewBottomSheet`:
    - Reusable modal bottom sheet opened on preview success.
    - If `canSetAsDefault == true`:
      - Shows success indicator & `restaurantCoverageNotice`.
      - Shows horizontal list of `servingRestaurants` (logo, name, rating).
      - Enabled primary button: "تأكيد وحفظ العنوان" / "تأكيد تعيين كافتراضي". Tapping triggers confirmation event.
    - If `canSetAsDefault == false`:
      - Shows warning badge with `conflictMessage` and uncovered restaurant name.
      - Disabled primary button with explanatory text.
      - Secondary button: "اختيار عنوان آخر" to dismiss sheet and adjust location.
  - `AddressesScreen`:
    - Tapping "تعيين كافتراضي" triggers `PreviewExistingAddressCoverageEvent(address.addressId)`.
    - Opens `AddressCoveragePreviewBottomSheet`.
    - Confirming triggers `ConfirmSetDefaultAddressEvent`.
  - `AddressChooseLocationScreen` / `AddressesFigmaFrame`:
    - Primary action button is labeled: "التحقق من التغطية والمتابعة".
    - Tapping triggers preview event with coordinates and address details.
    - Opens `AddressCoveragePreviewBottomSheet`.
    - Confirming triggers add or update, pops screens, and updates addresses list.

---

## 5. UI Guidelines & Design Rules Adherence
- All colors derived from `context.colorScheme`.
- All text strings derived from `context.localization` (keys added in `app_ar.arb` and `app_en.arb`).
- Spacings strictly from `Spacing.*`.
- Typography styles from `styles_manager.dart`.
- Responsive RTL and LTR support through Flutter's built-in directionality.

---

## 6. Error Handling
- Invalid coordinates outside Kuwait bounds blocked before network request via `isWithinKuwaitBounds`.
- 409 Conflict handled cleanly via `FailureMapper` displaying human-readable localized messages.
- Network and timeout errors mapped to standard error snackbars.
