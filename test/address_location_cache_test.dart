import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/address/data/data_source/address_location_cache.dart';
import 'package:meal_meat_user/core/address/domain/entities/locations_catalog_entity.dart';

void main() {
  group('AddressLocationCache', () {
    late AddressLocationCache cache;

    setUp(() {
      cache = AddressLocationCache.test();
    });

    test('same country and area returns cached result on second call', () async {
      var fetchCount = 0;
      Future<LocationsCatalogEntity> fetch() async {
        fetchCount++;
        return const LocationsCatalogEntity(
          countryId: 'kw',
          countryCode: 'KW',
          governorates: [
            LocationGovernorateEntity(
              id: 'gov1',
              code: 'G1',
              nameAr: 'العاصمة',
              nameEn: 'Capital',
            ),
          ],
        );
      }

      final result1 = await cache.getOrFetch('KW', null, fetch);
      final result2 = await cache.getOrFetch('KW', null, fetch);

      expect(fetchCount, 1);
      expect(result1, equals(result2));
    });

    test('different countries or areas do not share cache', () async {
      var fetchKw = 0;
      var fetchSa = 0;
      var fetchArea = 0;

      await cache.getOrFetch('KW', null, () async {
        fetchKw++;
        return const LocationsCatalogEntity(countryId: 'kw', countryCode: 'KW', governorates: [LocationGovernorateEntity(id: 'g1', code: 'c1', nameAr: 'ع1', nameEn: 'G1')]);
      });

      await cache.getOrFetch('SA', null, () async {
        fetchSa++;
        return const LocationsCatalogEntity(countryId: 'sa', countryCode: 'SA', governorates: [LocationGovernorateEntity(id: 'g2', code: 'c2', nameAr: 'ع2', nameEn: 'G2')]);
      });

      await cache.getOrFetch('KW', 'area123', () async {
        fetchArea++;
        return const LocationsCatalogEntity(countryId: 'kw', countryCode: 'KW');
      });

      expect(fetchKw, 1);
      expect(fetchSa, 1);
      expect(fetchArea, 1);
    });

    test('concurrent pending requests share the same in-flight Future', () async {
      final completer = Completer<LocationsCatalogEntity>();
      var fetchCount = 0;

      Future<LocationsCatalogEntity> fetch() {
        fetchCount++;
        return completer.future;
      }

      final future1 = cache.getOrFetch('KW', null, fetch);
      final future2 = cache.getOrFetch('KW', null, fetch);

      expect(fetchCount, 1);

      completer.complete(
        const LocationsCatalogEntity(
          countryId: 'kw',
          countryCode: 'KW',
          governorates: [LocationGovernorateEntity(id: 'g1', code: 'c1', nameAr: 'ع', nameEn: 'Gov')],
        ),
      );

      final r1 = await future1;
      final r2 = await future2;

      expect(identical(r1, r2), isTrue);
    });

    test('failed request allows a new attempt and does not cache failure', () async {
      var fetchCount = 0;

      await expectLater(
        cache.getOrFetch('KW', null, () async {
          fetchCount++;
          throw Exception('Network error');
        }),
        throwsA(isA<Exception>()),
      );

      expect(fetchCount, 1);

      // Next attempt should call fetch again
      final successResult = await cache.getOrFetch('KW', null, () async {
        fetchCount++;
        return const LocationsCatalogEntity(
          countryId: 'kw',
          countryCode: 'KW',
          governorates: [LocationGovernorateEntity(id: 'g1', code: 'c1', nameAr: 'ع', nameEn: 'Gov')],
        );
      });

      expect(fetchCount, 2);
      expect(successResult.countryCode, 'KW');
    });

    test('clear prevents in-flight request started before clear from populating cache', () async {
      final completer = Completer<LocationsCatalogEntity>();
      var fetchCount = 0;

      final oldFuture = cache.getOrFetch('KW', null, () {
        fetchCount++;
        return completer.future;
      });

      expect(fetchCount, 1);

      // Clear cache while request is in-flight
      cache.clear();

      // Complete the old request
      completer.complete(
        const LocationsCatalogEntity(
          countryId: 'kw',
          countryCode: 'KW',
          governorates: [LocationGovernorateEntity(id: 'g1', code: 'c1', nameAr: 'ع قديم', nameEn: 'Gov Old')],
        ),
      );
      await oldFuture;

      // New request should NOT get the old cached result!
      var newFetchCount = 0;
      final newResult = await cache.getOrFetch('KW', null, () async {
        newFetchCount++;
        return const LocationsCatalogEntity(
          countryId: 'kw',
          countryCode: 'KW',
          governorates: [LocationGovernorateEntity(id: 'g1', code: 'c1', nameAr: 'ع جديد', nameEn: 'Gov New')],
        );
      });

      expect(newFetchCount, 1);
      expect(newResult.governorates.first.nameEn, 'Gov New');
    });
  });
}
