import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/home/data/home_fake_data_source.dart';
import 'package:meal_meat_user/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._dataSource) : super(const HomeState());

  final HomeFakeDataSource _dataSource;

  void loadHome() =>
      emit(state.copyWith(dashboard: _dataSource.getDashboard()));

  void selectTab(int index) => emit(state.copyWith(selectedTabIndex: index));
}
