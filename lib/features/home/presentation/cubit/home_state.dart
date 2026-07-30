import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';

class HomeState {
  const HomeState({this.dashboard, this.selectedTabIndex = 0});

  final HomeDashboardEntity? dashboard;
  final int selectedTabIndex;

  HomeState copyWith({HomeDashboardEntity? dashboard, int? selectedTabIndex}) {
    return HomeState(
      dashboard: dashboard ?? this.dashboard,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}
