import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_home_usecase.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/usecase/get_family_members_usecase.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/manager/family_overview_event.dart';
import 'package:meal_meat_user/features/family_management/overview/presentation/manager/family_overview_state.dart';

@injectable
class FamilyOverviewViewModel extends Cubit<FamilyOverviewState> {
  FamilyOverviewViewModel(this._getHome, this._getMembers)
    : super(const FamilyOverviewState());

  final GetFamilyHomeUseCase _getHome;
  final GetFamilyMembersUseCase _getMembers;

  void doIntent(FamilyOverviewEvent event) {
    switch (event) {
      case LoadFamilyHomeEvent():
        _loadHome(event.locale);
      case LoadFamilyMembersEvent():
        _loadMembers(event.locale);
      case SearchFamilyMembersEvent():
        _search(event.query);
    }
  }

  Future<void> _loadHome(String locale) async {
    emit(state.copyWith(isLoadingHome: true, clearFailure: true));
    final result = await _getHome(locale: locale);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(home: data, isLoadingHome: false));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(failure: failure, isLoadingHome: false));
    }
  }

  Future<void> _loadMembers(String locale) async {
    emit(state.copyWith(isLoadingMembers: true, clearFailure: true));
    final result = await _getMembers(locale: locale);
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            members: data,
            filteredMembers: _applyFilter(data, state.searchQuery),
            isLoadingMembers: false,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(state.copyWith(failure: failure, isLoadingMembers: false));
    }
  }

  void _search(String query) {
    final trimmed = query.trim();
    emit(
      state.copyWith(
        searchQuery: trimmed,
        filteredMembers: _applyFilter(state.members, trimmed),
      ),
    );
  }

  List<T> _applyFilter<T>(List<T> list, String query) {
    if (query.isEmpty) return list;
    return list.where((item) {
      final name =
          (item as dynamic).displayName?.toString().toLowerCase() ?? '';
      return name.contains(query.toLowerCase());
    }).toList();
  }
}
