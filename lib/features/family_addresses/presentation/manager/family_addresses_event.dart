import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';

sealed class FamilyAddressesEvent {
  const FamilyAddressesEvent();
}

final class LoadFamilyAddressesEvent extends FamilyAddressesEvent {
  const LoadFamilyAddressesEvent({this.memberId});

  final String? memberId;
}

final class SelectFamilyAddressMemberEvent extends FamilyAddressesEvent {
  const SelectFamilyAddressMemberEvent(this.index);

  final int index;
}

final class SaveFamilyMemberAddressEvent extends FamilyAddressesEvent {
  const SaveFamilyMemberAddressEvent({
    this.memberId,
    this.savedAddress,
  });

  final String? memberId;
  final CustomerAddressEntity? savedAddress;
}

final class ProceedToNextAddressStepEvent extends FamilyAddressesEvent {
  const ProceedToNextAddressStepEvent();
}

final class ToggleApplyManagerAddressEvent extends FamilyAddressesEvent {
  const ToggleApplyManagerAddressEvent();
}
