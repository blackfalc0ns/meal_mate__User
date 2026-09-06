import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/addresses/data/mapper/customer_address_mapper.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';

void main() {
  group('Address Coverage Preview Feature Tests', () {
    test('AddressCoveragePreviewResponseDto parses covered JSON correctly', () {
      final json = {
        'canSetAsDefault': true,
        'isCurrentSubscriptionRestaurantCovered': true,
        'uncoveredRestaurantNameAr': null,
        'uncoveredRestaurantNameEn': null,
        'conflictMessage': null,
        'resolvedRegionId': 'd4a9acc2-afb8-49d8-b440-f93b8622239c',
        'resolvedRegionNameAr': 'السالمية',
        'resolvedRegionNameEn': 'Salmiya',
        'governorate': 'حولي',
        'area': 'السالمية',
        'block': 'قطعة 5',
        'latitude': 29.3412132,
        'longitude': 48.082421,
        'hasActiveSubscription': true,
        'restaurantCoverageNotice': {
          'ar': 'تنبيه: ستقتصر المطاعم على منطقتك.',
          'en': 'Notice: Only restaurants serving this region will be available.'
        },
        'servingRestaurants': [
          {
            'id': '97db2bbb-b652-4aaa-8584-3414e6966792',
            'nameAr': 'دايت ستيشن',
            'nameEn': 'Diet Station',
            'logoUrl': '/api/v1/uploads/logo.png',
            'rating': 4.9
          }
        ]
      };

      final dto = AddressCoveragePreviewResponseDto.fromJson(json);
      expect(dto.canSetAsDefault, isTrue);
      expect(dto.isCurrentSubscriptionRestaurantCovered, isTrue);
      expect(dto.uncoveredRestaurantNameAr, isNull);
      expect(dto.servingRestaurants.length, 1);
      expect(dto.servingRestaurants.first.nameAr, 'دايت ستيشن');

      final entity = dto.toEntity();
      expect(entity.canSetAsDefault, isTrue);
      expect(entity.servingRestaurants.length, 1);
      expect(entity.servingRestaurants.first.name('ar'), 'دايت ستيشن');
      expect(entity.servingRestaurants.first.name('en'), 'Diet Station');
    });

    test('AddressCoveragePreviewResponseDto parses uncovered JSON correctly', () {
      final json = {
        'canSetAsDefault': false,
        'isCurrentSubscriptionRestaurantCovered': false,
        'uncoveredRestaurantNameAr': 'دايت ستور العاصمة',
        'uncoveredRestaurantNameEn': 'Diet Store Capital',
        'conflictMessage': 'مطعم اشتراكك الحالي لا يدعم التوصيل إلى هذه المنطقة.',
        'hasActiveSubscription': true,
        'servingRestaurants': []
      };

      final dto = AddressCoveragePreviewResponseDto.fromJson(json);
      expect(dto.canSetAsDefault, isFalse);
      expect(dto.isCurrentSubscriptionRestaurantCovered, isFalse);
      expect(dto.uncoveredRestaurantNameAr, 'دايت ستور العاصمة');

      final entity = dto.toEntity();
      expect(entity.canSetAsDefault, isFalse);
      expect(entity.uncoveredRestaurantName('ar'), 'دايت ستور العاصمة');
      expect(entity.uncoveredRestaurantName('en'), 'Diet Store Capital');
    });

    test('CustomerAddressRequestEntity toPreviewDto creates proper preview DTO', () {
      const entity = CustomerAddressRequestEntity(
        label: 'المنزل',
        addressLine: 'السالمية قطعة 5 شارع 2',
        regionId: 'reg-123',
        blockRegionId: 'block-456',
        latitude: 29.34,
        longitude: 48.08,
        governorate: 'حولي',
        area: 'السالمية',
        block: '5',
        isDefault: true,
        notifyOnDelivery: true,
      );

      final previewDto = entity.toPreviewDto();
      expect(previewDto.regionId, 'reg-123');
      expect(previewDto.blockRegionId, 'block-456');
      expect(previewDto.latitude, 29.34);
      expect(previewDto.longitude, 48.08);
      expect(previewDto.isDefault, isTrue);

      final json = previewDto.toJson();
      expect(json['regionId'], 'reg-123');
      expect(json['blockRegionId'], 'block-456');
      expect(json['latitude'], 29.34);
      expect(json['isDefault'], isTrue);
    });

    test('AddressCoveragePreviewState copyWith works properly', () {
      const state = AddressCoveragePreviewState();
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isFalse);

      final loadingState = state.copyWith(isLoading: true);
      expect(loadingState.isLoading, isTrue);

      final pendingState = state.copyWith(
        pendingAction: AddressPendingActionType.setDefault,
        targetAddressId: 'addr-789',
      );
      expect(pendingState.pendingAction, AddressPendingActionType.setDefault);
      expect(pendingState.targetAddressId, 'addr-789');
    });
  });
}
