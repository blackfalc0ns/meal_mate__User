import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  const HomeState({
    required this.status,
    required this.dashboard,
    required this.selectedCategoryIndex,
    required this.selectedTabIndex,
    this.errorMessage,
  });

  const HomeState.initial()
    : status = HomeStatus.initial,
      dashboard = null,
      selectedCategoryIndex = 3,
      selectedTabIndex = 0,
      errorMessage = null;

  final HomeStatus status;
  final HomeDashboardEntity? dashboard;
  final int selectedCategoryIndex;
  final int selectedTabIndex;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    HomeDashboardEntity? dashboard,
    int? selectedCategoryIndex,
    int? selectedTabIndex,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
