import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';
import 'package:meal_meat_user/core/services/language_service.dart';

@lazySingleton
class AddressLocationCache {
  AddressLocationCache({required LanguageService this._languageService});

  AddressLocationCache.test({this._languageService});

  final LanguageService? _languageService;

  final Map<String, LocationsCatalogEntity> _cache = {};
  final Map<String, Future<LocationsCatalogEntity>> _inFlight = {};
  int _revision = 0;

  String _buildKey(String countryCode, String? areaId) {
    final lang = _languageService?.getLanguageCode() ?? '';
    final area = areaId ?? '';
    return '${countryCode.toUpperCase()}_${area}_$lang';
  }

  LocationsCatalogEntity? get(String countryCode, String? areaId) {
    return _cache[_buildKey(countryCode, areaId)];
  }

  Future<LocationsCatalogEntity> getOrFetch(
    String countryCode,
    String? areaId,
    Future<LocationsCatalogEntity> Function() fetch,
  ) async {
    final key = _buildKey(countryCode, areaId);
    final cached = _cache[key];
    if (cached != null) {
      if (areaId == null && cached.governorates.isEmpty) {
        // Do not return an empty catalog if valid ones require governorates.
      } else {
        return cached;
      }
    }

    final pending = _inFlight[key];
    if (pending != null) {
      return pending;
    }

    final requestRevision = _revision;
    final future = () async {
      final result = await fetch();
      if (requestRevision == _revision) {
        if (areaId == null) {
          if (result.governorates.isNotEmpty) {
            _cache[key] = result;
          }
        } else {
          _cache[key] = result;
        }
      }
      return result;
    }();

    _inFlight[key] = future;
    try {
      return await future;
    } finally {
      _inFlight.remove(key);
    }
  }

  void clear() {
    _revision++;
    _cache.clear();
    _inFlight.clear();
  }
}
