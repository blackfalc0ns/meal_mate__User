import 'package:meal_meat_user/features/addresses/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilyAddressesState {
  const FamilyAddressesState({
    this.familyName,
    this.isLoading = false,
    this.isSaving = false,
    this.members = const [],
    this.addresses = const [],
    this.currentIndex = 0,
    this.completedMemberIds = const {},
    this.errorMessage,
    this.completed = false,
    this.addressSaveRevision = 0,
  });
  final String? familyName;
  final bool isLoading;
  final bool isSaving;
  final List<FamilyMemberEntity> members;
  final List<CustomerAddressEntity> addresses;
  final int currentIndex;
  final Set<String> completedMemberIds;
  final String? errorMessage;
  final bool completed;
  final int addressSaveRevision;
  FamilyMemberEntity? get currentMember =>
      members.isEmpty ? null : members[currentIndex];

  FamilyAddressesState copyWith({
    String? familyName,
    bool? isLoading,
    bool? isSaving,
    List<FamilyMemberEntity>? members,
    List<CustomerAddressEntity>? addresses,
    int? currentIndex,
    Set<String>? completedMemberIds,
    String? errorMessage,
    bool clearError = false,
    bool? completed,
    int? addressSaveRevision,
  }) => FamilyAddressesState(
    familyName: familyName ?? this.familyName,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
    members: members ?? this.members,
    addresses: addresses ?? this.addresses,
    currentIndex: currentIndex ?? this.currentIndex,
    completedMemberIds: completedMemberIds ?? this.completedMemberIds,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    completed: completed ?? this.completed,
    addressSaveRevision: addressSaveRevision ?? this.addressSaveRevision,
  );
}
