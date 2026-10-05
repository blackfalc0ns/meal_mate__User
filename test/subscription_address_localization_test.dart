import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_summary_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_readiness_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

void main() {
  group('Subscription Address Bilingual Localization Tests', () {
    test('resolves Arabic and English names cleanly with localizedNamesLine', () {
      const address = SubscriptionSummaryAddressEntity(
        id: 'addr-1',
        label: 'Home / المنزل',
        addressLine: 'Street 10, Building 4',
        governorate: 'Hawally Legacy',
        area: 'Salmiya Legacy',
        block: 'Block 4 Legacy',
        governorateNameAr: 'حولي',
        governorateNameEn: 'Hawally',
        areaNameAr: 'السالمية',
        areaNameEn: 'Salmiya',
        blockNameAr: 'قطعة 4',
        blockNameEn: 'Block 4',
      );

      // In Arabic: uses Arabic fields
      expect(address.localizedNamesLine('ar'), equals('حولي - السالمية - قطعة 4'));

      // In English: uses English fields
      expect(address.localizedNamesLine('en'), equals('Hawally - Salmiya - Block 4'));

      // Verbatim label and addressLine are preserved
      expect(address.label, equals('Home / المنزل'));
      expect(address.addressLine, equals('Street 10, Building 4'));
    });

    test('falls back to legacy fields for missing or empty bilingual parts', () {
      const address = SubscriptionSummaryAddressEntity(
        id: 'addr-2',
        label: 'Work',
        addressLine: 'Tower A',
        governorate: 'Capital Legacy',
        area: 'Sharq Legacy',
        block: 'Block 1 Legacy',
        governorateNameAr: 'العاصمة',
        governorateNameEn: null, // Missing English
        areaNameAr: 'شرق',
        areaNameEn: '', // Empty English
        blockNameAr: null,
        blockNameEn: 'Block 1',
      );

      // In Arabic: governorate and area from Arabic, block falls back to legacy
      expect(address.localizedNamesLine('ar'), equals('العاصمة - شرق - Block 1 Legacy'));

      // In English: governorate and area fallback to legacy, block from English
      expect(address.localizedNamesLine('en'), equals('Capital Legacy - Sharq Legacy - Block 1'));
    });

    test('handles completely null region catalog and missing fields without errors', () {
      const address = SubscriptionSummaryAddressEntity(
        id: 'addr-3',
        label: 'Only Address Line',
        addressLine: 'Just a Street',
      );

      expect(address.localizedNamesLine('ar'), isEmpty);
      expect(address.localizedNamesLine('en'), isEmpty);
      expect(address.formattedAddress, equals('Just a Street'));
    });

    test('SubscriptionSummaryAddressResponseDto maps all 6 bilingual fields and legacy fields', () {
      final json = <String, dynamic>{
        'id': 'addr-100',
        'label': 'Office',
        'addressLine': 'Floor 3',
        'governorate': 'Ahmadi',
        'area': 'Fahaheel',
        'block': 'Block 2',
        'regionId': 'reg-1',
        'governorateNameAr': 'الأحمدي',
        'governorateNameEn': 'Ahmadi',
        'areaNameAr': 'الفحيحيل',
        'areaNameEn': 'Fahaheel',
        'blockNameAr': 'قطعة 2',
        'blockNameEn': 'Block 2',
      };

      final dto = SubscriptionSummaryAddressResponseDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, equals('addr-100'));
      expect(entity.label, equals('Office'));
      expect(entity.addressLine, equals('Floor 3'));
      expect(entity.governorate, equals('Ahmadi'));
      expect(entity.area, equals('Fahaheel'));
      expect(entity.block, equals('Block 2'));
      expect(entity.regionId, equals('reg-1'));
      expect(entity.governorateNameAr, equals('الأحمدي'));
      expect(entity.governorateNameEn, equals('Ahmadi'));
      expect(entity.areaNameAr, equals('الفحيحيل'));
      expect(entity.areaNameEn, equals('Fahaheel'));
      expect(entity.blockNameAr, equals('قطعة 2'));
      expect(entity.blockNameEn, equals('Block 2'));
    });

    test('SubscriptionReadinessAddressResponseDto maps all 6 bilingual fields and legacy fields', () {
      final json = <String, dynamic>{
        'id': 'addr-200',
        'label': 'Beach House',
        'addressLine': 'Chalet 12',
        'governorate': 'Ahmadi',
        'area': 'Khiran',
        'block': 'Block 1',
        'regionId': null,
        'governorateNameAr': 'الأحمدي',
        'governorateNameEn': 'Ahmadi',
        'areaNameAr': 'الخيران',
        'areaNameEn': 'Khiran',
        'blockNameAr': 'قطعة 1',
        'blockNameEn': 'Block 1',
      };

      final dto = SubscriptionReadinessAddressResponseDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, equals('addr-200'));
      expect(entity.label, equals('Beach House'));
      expect(entity.addressLine, equals('Chalet 12'));
      expect(entity.governorateNameAr, equals('الأحمدي'));
      expect(entity.governorateNameEn, equals('Ahmadi'));
      expect(entity.areaNameAr, equals('الخيران'));
      expect(entity.areaNameEn, equals('Khiran'));
      expect(entity.blockNameAr, equals('قطعة 1'));
      expect(entity.blockNameEn, equals('Block 1'));
    });
  });
}
