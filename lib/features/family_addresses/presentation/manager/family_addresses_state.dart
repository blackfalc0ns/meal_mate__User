import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class FamilyAddressesState {
  const FamilyAddressesState({
    this.familyName,
    this.isLoading = false,
    this.members = const [],
    this.currentIndex = 0,
    this.completedMemberIds = const {},
    this.errorMessage,
    this.failure,
    this.completed = false,
    this.addressSaveRevision = 0,
  });

  final String? familyName;
  final bool isLoading;
  final List<FamilyMemberEntity> members;
  final int currentIndex;
  final Set<String> completedMemberIds;
  final String? errorMessage;
  final Failure? failure;
  final bool completed;
  final int addressSaveRevision;

  FamilyMemberEntity? get currentMember =>
      members.isEmpty || currentIndex < 0 || currentIndex >= members.length
      ? null
      : members[currentIndex];

  FamilyAddressesState copyWith({
    String? familyName,
    bool? isLoading,
    List<FamilyMemberEntity>? members,
    int? currentIndex,
    Set<String>? completedMemberIds,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
    bool clearFailure = false,
    bool? completed,
    int? addressSaveRevision,
  }) => FamilyAddressesState(
    familyName: familyName ?? this.familyName,
    isLoading: isLoading ?? this.isLoading,
    members: members ?? this.members,
    currentIndex: currentIndex ?? this.currentIndex,
    completedMemberIds: completedMemberIds ?? this.completedMemberIds,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    failure: clearFailure ? null : (failure ?? this.failure),
    completed: completed ?? this.completed,
    addressSaveRevision: addressSaveRevision ?? this.addressSaveRevision,
  );
}
