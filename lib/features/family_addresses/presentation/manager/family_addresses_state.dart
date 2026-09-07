import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilyAddressesState {
  const FamilyAddressesState({
    this.isLoading = false,
    this.isSaving = false,
    this.members = const [],
    this.addresses = const [],
    this.currentIndex = 0,
    this.errorMessage,
    this.completed = false,
  });
  final bool isLoading;
  final bool isSaving;
  final List<FamilyMemberEntity> members;
  final List<CustomerAddressEntity> addresses;
  final int currentIndex;
  final String? errorMessage;
  final bool completed;
  FamilyMemberEntity? get currentMember =>
      members.isEmpty ? null : members[currentIndex];

  FamilyAddressesState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<FamilyMemberEntity>? members,
    List<CustomerAddressEntity>? addresses,
    int? currentIndex,
    String? errorMessage,
    bool clearError = false,
    bool? completed,
  }) => FamilyAddressesState(
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    members: members ?? this.members,
    addresses: addresses ?? this.addresses,
    currentIndex: currentIndex ?? this.currentIndex,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    completed: completed ?? this.completed,
  );
}
