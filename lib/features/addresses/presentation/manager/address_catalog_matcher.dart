import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/map_address_autofill_entity.dart';

class InitialLocationSelection {
  const InitialLocationSelection({this.governorate, this.area});

  final LocationGovernorateEntity? governorate;
  final LocationAreaEntity? area;
}

/// Helper service for resolving and matching geocoded addresses with the backend locations catalog.
class AddressCatalogMatcher {
  const AddressCatalogMatcher._();

  static InitialLocationSelection findInitialSelection(
    LocationsCatalogEntity locations,
    CustomerAddressEntity? address, {
    MapAddressAutofillEntity? autofill,
  }) {
    if (address == null && autofill == null) {
      return const InitialLocationSelection();
    }

    for (final governorate in locations.governorates) {
      for (final area in governorate.areas) {
        if (matchesArea(area, address, autofill: autofill)) {
          return InitialLocationSelection(
            governorate: governorate,
            area: area,
          );
        }
      }
    }

    return const InitialLocationSelection();
  }

  static bool matchesArea(
    LocationAreaEntity area,
    CustomerAddressEntity? address, {
    MapAddressAutofillEntity? autofill,
  }) {
    if (autofill != null) {
      if (matchesValue(area.id, autofill.suggestedRegionId)) return true;
      if (matchesValue(area.nameAr, autofill.suggestedRegionNameAr)) {
        return true;
      }
      if (matchesValue(area.nameEn, autofill.suggestedRegionName)) return true;
      if (matchesValue(area.nameAr, autofill.area)) return true;
      if (matchesValue(area.nameEn, autofill.area)) return true;
    }
    if (address == null) return false;
    return matchesValue(area.id, address.regionId) ||
        matchesValue(area.code, address.area) ||
        matchesValue(area.nameAr, address.area) ||
        matchesValue(area.nameEn, address.area);
  }

  static LocationBlockEntity? findInitialBlock(
    LocationAreaEntity area,
    CustomerAddressEntity? address, {
    MapAddressAutofillEntity? autofill,
  }) {
    if (address == null && autofill == null) return null;

    for (final block in area.blocks) {
      if (autofill != null) {
        if (matchesValue(block.id, autofill.suggestedBlockId)) return block;
        if (matchesValue(block.nameAr, autofill.suggestedBlockNameAr)) {
          return block;
        }
        if (matchesValue(block.nameEn, autofill.suggestedBlockName)) {
          return block;
        }
        if (matchesValue(block.nameAr, autofill.block)) return block;
        if (matchesValue(block.nameEn, autofill.block)) return block;
      }
      if (address != null &&
          (matchesValue(block.id, address.blockRegionId) ||
              matchesValue(block.code, address.block) ||
              matchesValue(block.nameAr, address.block) ||
              matchesValue(block.nameEn, address.block))) {
        return block;
      }
    }
    return null;
  }

  static LocationAreaEntity? findAreaById(
    LocationsCatalogEntity locations,
    String areaId,
  ) {
    for (final governorate in locations.governorates) {
      for (final area in governorate.areas) {
        if (area.id == areaId) return area;
      }
    }
    return null;
  }

  static bool matchesValue(String? first, String? second) {
    final normalizedFirst = normalize(first);
    final normalizedSecond = normalize(second);
    return normalizedFirst.isNotEmpty && normalizedFirst == normalizedSecond;
  }

  static String normalize(String? value) {
    return value?.trim().toLowerCase() ?? '';
  }
}
