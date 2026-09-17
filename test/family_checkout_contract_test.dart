import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/mapper/family_checkout_mapper.dart';

void main() {
  test('checkout request includes stable correlation id', () {
    expect(
      const FamilyCheckoutRequestDto(
        callbackUrl: 'mealmate://callback',
        errorUrl: 'mealmate://error',
        correlationId: 'family-attempt-1',
        paymentMethodId: 2,
      ).toJson()['correlationId'],
      'family-attempt-1',
    );
  });

  test('family summary maps identity and checkout metadata', () {
    final entity = FamilySummaryResponseDto.fromJson({
      'familyGroupId': 'family-1',
      'familyName': 'Family',
      'checkoutEndpoint': 'POST /checkout',
      'finalPrice': 81,
      'selectedMember': {'tierNameEn': 'Basic'},
    }).toEntity();

    expect(entity.familyGroupId, 'family-1');
    expect(entity.familyName, 'Family');
    expect(entity.checkoutEndpoint, 'POST /checkout');
    expect(entity.selectedMember?.tierNameEn, 'Basic');
    expect(entity.finalPrice, 81);
  });

  test('summary accepts named setup statuses and selected member id', () {
    final summary = FamilySummaryResponseDto.fromJson({
      'selectedMemberId': 'member-2',
      'members': [
        {'memberId': 'member-1', 'setupStatus': 'NotStarted'},
        {'memberId': 'member-2', 'setupStatus': 'Ready'},
      ],
      'selectedMember': {
        'memberId': 'member-2',
        'setupStatus': 'Ready',
        'durationLabelEn': '26 Days',
        'tierNameEn': 'Premium Tier',
      },
    }).toEntity();

    expect(summary.selectedMemberId, 'member-2');
    expect(summary.members.map((member) => member.setupStatus), [0, 2]);
    expect(summary.selectedMember?.isReady, isTrue);
    expect(summary.selectedMember?.durationText('en'), '26 Days');
    expect(summary.selectedMember?.tierText('en'), 'Premium Tier');
  });
}
