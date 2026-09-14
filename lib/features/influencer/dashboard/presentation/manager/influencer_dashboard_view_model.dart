import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/network/api_results.dart';
import '../../domain/entities/influencer_api_entities.dart';
import '../../domain/usecase/influencer_read_usecases.dart';
import 'influencer_dashboard_state.dart';

@injectable
class InfluencerDashboardViewModel extends Cubit<InfluencerDashboardState> {
  InfluencerDashboardViewModel(this._getHome, this._getProfile)
    : super(const InfluencerDashboardState());
  final GetInfluencerHomeUseCase _getHome;
  final GetInfluencerProfileUseCase _getProfile;

  Future<void> load({bool forceRefresh = false}) async {
    if (state.isLoading || (!forceRefresh && state.home != null)) return;
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final homeResult = await _getHome();
    final profileResult = await _getProfile();
    if (homeResult is ApiSuccessResult<InfluencerHomeApiEntity>) {
      emit(
        state.copyWith(
          isLoading: false,
          home: homeResult.data,
          profile: profileResult is ApiSuccessResult<InfluencerProfileApiEntity>
              ? profileResult.data
              : null,
          clearFailure: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          failure:
              (homeResult as ApiErrorResult<InfluencerHomeApiEntity>).failure,
        ),
      );
    }
  }
}
