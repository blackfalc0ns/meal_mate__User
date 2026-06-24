import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/home/data/home_fake_data_source.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._fakeDataSource) : super(const HomeState.initial());

  final HomeFakeDataSource _fakeDataSource;

  void loadHome() {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final dashboard = _fakeDataSource.getDashboard();
    emit(
      state.copyWith(
        status: HomeStatus.success,
        dashboard: dashboard,
      ),
    );
  }

  void selectCategory(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void selectTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }
}
