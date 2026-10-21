import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_context/domain/usecase/get_my_family_contexts_usecase.dart';
import 'family_context_event.dart';
import 'family_context_state.dart';

@lazySingleton
class FamilyContextViewModel extends Cubit<FamilyContextState> {
  FamilyContextViewModel(this._getMyFamilyContextsUseCase)
    : super(const FamilyContextState());

  final GetMyFamilyContextsUseCase _getMyFamilyContextsUseCase;

  int _requestToken = 0;

  void loadFamilyContext() => doIntent(const LoadFamilyContextsEvent());

  void doIntent(FamilyContextEvent event) {
    switch (event) {
      case LoadFamilyContextsEvent():
        _loadContexts();
      case ClearFamilyContextsEvent():
        _requestToken++;
        emit(const FamilyContextState());
    }
  }

  Future<void> _loadContexts() async {
    final token = ++_requestToken;
    emit(state.copyWith(isLoading: true, failure: () => null));

    final result = await _getMyFamilyContextsUseCase();

    if (isClosed || token != _requestToken) return;

    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(isLoading: false, contexts: data));
      case ApiErrorResult(:final failure):
        emit(state.copyWith(isLoading: false, failure: () => failure));
    }
  }
}
