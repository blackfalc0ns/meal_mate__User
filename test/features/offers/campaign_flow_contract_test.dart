import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_flow_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/mapper/campaign_flow_mapper.dart';
import 'package:meal_meat_user/features/offers/data/models/request/campaign_quote_request_dto.dart';

void main() {
  test('nullable campaign prices stay absent and cursor remains opaque', () {
    final page = CampaignPageResponseDto.fromJson({
      'items': [
        {'campaignId': 'campaign-1', 'minPrice': null},
      ],
      'nextCursor': 'opaque+/==',
    }).toEntity();
    expect(page.items.single.minPrice, isNull);
    expect(page.nextCursor, 'opaque+/==');
  });
  test(
    'campaign purchase option keeps campaign and catalog identifiers distinct',
    () {
      final details = CampaignDetailsResponseDto.fromJson({
        'campaignId': 'campaign-1',
        'canCheckout': true,
        'options': [
          {
            'campaignBundleId': 'campaign-bundle',
            'catalogBundleId': 'catalog-bundle',
            'durationDays': 6,
            'finalPrice': 48.125,
            'customerDiscountPercent': 20,
            'canShowReferencePrice': false,
          },
        ],
      }).toEntity();
      final option = details.options.single;
      expect(option.campaignBundleId, 'campaign-bundle');
      expect(option.catalogBundleId, 'catalog-bundle');
      expect(option.finalPrice, 48.125);
      expect(option.customerDiscountPercent, 20);
      expect(option.canShowReferencePrice, false);
    },
  );
  test('blocked zero quote and missing readiness never authorize payment', () {
    final quote = CampaignQuoteResponseDto.fromJson({
      'quoteId': '00000000-0000-0000-0000-000000000000',
      'canCheckout': false,
      'blockingReasons': [
        {
          'code': 'address_required',
          'messageAr': '?????',
          'action': 'addresses',
        },
      ],
    }).toEntity();
    expect(quote.isUsable, false);
    expect(quote.blockingReasons.single.action, 'addresses');
    expect(
      CampaignQuoteResponseDto.fromJson({'quoteId': 'q'}).toEntity().isUsable,
      false,
    );
  });
  test('quote request uses campaignBundleId and preserves coupon text', () {
    final body = const CampaignQuoteRequestDto(
      customerId: 'owner',
      campaignId: 'c',
      programId: 'p',
      campaignBundleId: 'cb',
      durationDays: 6,
      startDate: '2026-11-01',
      addressId: 'a',
      promoCode: 'Save20',
    ).toJson();
    expect(body['campaignBundleId'], 'cb');
    expect(body.containsKey('bundleId'), false);
    expect(body['promoCode'], 'Save20');
  });
}
