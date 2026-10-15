import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_home_entity.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

class FamilyOverviewState {
  const FamilyOverviewState({
    this.home,
    this.members = const [],
    this.filteredMembers = const [],
    this.searchQuery = '',
    this.isLoadingHome = false,
    this.isLoadingMembers = false,
    this.failure,
  });

  final FamilyHomeEntity? home;
  final List<FamilyMemberSummaryEntity> members;
  final List<FamilyMemberSummaryEntity> filteredMembers;
  final String searchQuery;
  final bool isLoadingHome;
  final bool isLoadingMembers;
  final Failure? failure;

  FamilyOverviewState copyWith({
    FamilyHomeEntity? home,
    List<FamilyMemberSummaryEntity>? members,
    List<FamilyMemberSummaryEntity>? filteredMembers,
    String? searchQuery,
    bool? isLoadingHome,
    bool? isLoadingMembers,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FamilyOverviewState(
      home: home ?? this.home,
      members: members ?? this.members,
      filteredMembers: filteredMembers ?? this.filteredMembers,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingHome: isLoadingHome ?? this.isLoadingHome,
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
