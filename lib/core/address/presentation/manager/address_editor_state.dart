import 'package:meal_meat_user/core/address/domain/entities/address_coverage_preview_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/address/domain/entities/map_address_autofill_entity.dart';
import 'package:meal_meat_user/core/network/failures.dart';

enum AddressPendingActionType { add, update, setDefault }

class AddressEditorState {
  const AddressEditorState({
    this.locations = const LocationsCatalogState(),
    this.action = const AddressesActionState(),
    this.mapAutofill = const MapAutofillState(),
    this.coveragePreview = const AddressCoveragePreviewState(),
  });

  final LocationsCatalogState locations;
  final AddressesActionState action;
  final MapAutofillState mapAutofill;
  final AddressCoveragePreviewState coveragePreview;

  AddressEditorState copyWith({
    LocationsCatalogState? locations,
    AddressesActionState? action,
    MapAutofillState? mapAutofill,
    AddressCoveragePreviewState? coveragePreview,
  }) {
    return AddressEditorState(
      locations: locations ?? this.locations,
      action: action ?? this.action,
      mapAutofill: mapAutofill ?? this.mapAutofill,
      coveragePreview: coveragePreview ?? this.coveragePreview,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressEditorState &&
          runtimeType == other.runtimeType &&
          locations == other.locations &&
          action == other.action &&
          mapAutofill == other.mapAutofill &&
          coveragePreview == other.coveragePreview;

  @override
  int get hashCode =>
      Object.hash(locations, action, mapAutofill, coveragePreview);
}

class LocationsCatalogState {
  const LocationsCatalogState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.selectedGovernorate,
    this.selectedArea,
    this.selectedBlock,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final LocationsCatalogEntity? data;
  final LocationGovernorateEntity? selectedGovernorate;
  final LocationAreaEntity? selectedArea;
  final LocationBlockEntity? selectedBlock;
  final Failure? failure;

  List<LocationGovernorateEntity> get governorates {
    return data?.governorates ?? const [];
  }

  List<LocationAreaEntity> get areas {
    return selectedGovernorate?.areas ?? const [];
  }

  List<LocationBlockEntity> get blocks {
    return selectedArea?.blocks ?? const [];
  }

  LocationsCatalogState copyWith({
    bool? isLoading,
    bool? isSuccess,
    LocationsCatalogEntity? data,
    LocationGovernorateEntity? selectedGovernorate,
    LocationAreaEntity? selectedArea,
    LocationBlockEntity? selectedBlock,
    Failure? failure,
    bool clearFailure = false,
    bool clearSelectedGovernorate = false,
    bool clearSelectedArea = false,
    bool clearSelectedBlock = false,
  }) {
    return LocationsCatalogState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      selectedGovernorate: clearSelectedGovernorate
          ? null
          : selectedGovernorate ?? this.selectedGovernorate,
      selectedArea: clearSelectedArea
          ? null
          : selectedArea ?? this.selectedArea,
      selectedBlock: clearSelectedBlock
          ? null
          : selectedBlock ?? this.selectedBlock,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationsCatalogState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isSuccess == other.isSuccess &&
          data == other.data &&
          selectedGovernorate == other.selectedGovernorate &&
          selectedArea == other.selectedArea &&
          selectedBlock == other.selectedBlock &&
          failure == other.failure;

  @override
  int get hashCode => Object.hash(
    isLoading,
    isSuccess,
    data,
    selectedGovernorate,
    selectedArea,
    selectedBlock,
    failure,
  );
}

class AddressesActionState {
  const AddressesActionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.failure,
    this.address,
    this.deliveryChangeNotice,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Failure? failure;
  final CustomerAddressEntity? address;
  final String? deliveryChangeNotice;

  String? get displayErrorMessage {
    final code = failure?.code.trim();
    if (code != null && code.isNotEmpty && code != 'unknown') {
      return code;
    }
    return errorMessage;
  }

  AddressesActionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Failure? failure,
    CustomerAddressEntity? address,
    String? deliveryChangeNotice,
    bool clearError = false,
    bool clearAddress = false,
  }) {
    return AddressesActionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
      address: clearAddress ? null : address ?? this.address,
      deliveryChangeNotice: clearError
          ? null
          : deliveryChangeNotice ?? this.deliveryChangeNotice,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressesActionState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isSuccess == other.isSuccess &&
          errorMessage == other.errorMessage &&
          failure == other.failure &&
          address == other.address &&
          deliveryChangeNotice == other.deliveryChangeNotice;

  @override
  int get hashCode => Object.hash(
    isLoading,
    isSuccess,
    errorMessage,
    failure,
    address,
    deliveryChangeNotice,
  );
}

class MapAutofillState {
  const MapAutofillState({
    this.isLoading = false,
    this.isSuccess = false,
    this.autofill,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final MapAddressAutofillEntity? autofill;
  final Failure? failure;

  String? get displayErrorMessage {
    final code = failure?.code.trim();
    if (code != null && code.isNotEmpty && code != 'unknown') {
      return code;
    }
    return failure?.errorMessage;
  }

  MapAutofillState copyWith({
    bool? isLoading,
    bool? isSuccess,
    MapAddressAutofillEntity? autofill,
    Failure? failure,
    bool clearFailure = false,
    bool clearAutofill = false,
  }) {
    return MapAutofillState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      autofill: clearAutofill ? null : autofill ?? this.autofill,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapAutofillState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isSuccess == other.isSuccess &&
          autofill == other.autofill &&
          failure == other.failure;

  @override
  int get hashCode => Object.hash(isLoading, isSuccess, autofill, failure);
}

class AddressCoveragePreviewState {
  const AddressCoveragePreviewState({
    this.sessionId = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.isLoadingMore = false,
    this.reachedEnd = false,
    this.preview,
    this.pendingAction,
    this.targetAddressId,
    this.pendingRequest,
    this.failure,
    this.loadMoreFailure,
  });

  final int sessionId;
  final bool isLoading;
  final bool isSuccess;
  final bool isLoadingMore;
  final bool reachedEnd;
  final AddressCoveragePreviewEntity? preview;
  final AddressPendingActionType? pendingAction;
  final String? targetAddressId;
  final CustomerAddressRequestEntity? pendingRequest;
  final Failure? failure;
  final Failure? loadMoreFailure;

  bool get canLoadMore {
    final meta = preview?.pagination;
    return isSuccess &&
        !isLoading &&
        !isLoadingMore &&
        !reachedEnd &&
        meta != null &&
        meta.hasNextPage == true &&
        (meta.page ?? 0) >= 1 &&
        (meta.pageSize ?? 0) >= 1;
  }

  String? get displayErrorMessage {
    final code = failure?.code.trim();
    if (code != null && code.isNotEmpty && code != 'unknown') {
      return code;
    }
    return failure?.errorMessage;
  }

  String? get displayLoadMoreErrorMessage {
    final code = loadMoreFailure?.code.trim();
    if (code != null && code.isNotEmpty && code != 'unknown') {
      return code;
    }
    return loadMoreFailure?.errorMessage;
  }

  AddressCoveragePreviewState copyWith({
    int? sessionId,
    bool? isLoading,
    bool? isSuccess,
    bool? isLoadingMore,
    bool? reachedEnd,
    AddressCoveragePreviewEntity? preview,
    AddressPendingActionType? pendingAction,
    String? targetAddressId,
    CustomerAddressRequestEntity? pendingRequest,
    Failure? failure,
    Failure? loadMoreFailure,
    bool clearPreview = false,
    bool clearFailure = false,
    bool clearPending = false,
    bool clearLoadMoreFailure = false,
  }) {
    return AddressCoveragePreviewState(
      sessionId: sessionId ?? this.sessionId,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      preview: clearPreview ? null : preview ?? this.preview,
      pendingAction: clearPending ? null : pendingAction ?? this.pendingAction,
      targetAddressId: clearPending
          ? null
          : targetAddressId ?? this.targetAddressId,
      pendingRequest: clearPending
          ? null
          : pendingRequest ?? this.pendingRequest,
      failure: clearFailure ? null : failure ?? this.failure,
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : loadMoreFailure ?? this.loadMoreFailure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressCoveragePreviewState &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId &&
          isLoading == other.isLoading &&
          isSuccess == other.isSuccess &&
          isLoadingMore == other.isLoadingMore &&
          reachedEnd == other.reachedEnd &&
          preview == other.preview &&
          pendingAction == other.pendingAction &&
          targetAddressId == other.targetAddressId &&
          pendingRequest == other.pendingRequest &&
          failure == other.failure &&
          loadMoreFailure == other.loadMoreFailure;

  @override
  int get hashCode => Object.hash(
    sessionId,
    isLoading,
    isSuccess,
    isLoadingMore,
    reachedEnd,
    preview,
    pendingAction,
    targetAddressId,
    pendingRequest,
    failure,
    loadMoreFailure,
  );
}
