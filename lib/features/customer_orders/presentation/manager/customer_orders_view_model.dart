import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_orders/domain/usecase/get_delivered_boxes_usecase.dart';
import 'package:meal_meat_user/features/customer_orders/presentation/manager/customer_orders_state.dart';

@injectable
class CustomerOrdersViewModel extends Cubit<CustomerOrdersState> {
  CustomerOrdersViewModel(this._boxes) : super(const CustomerOrdersState());
  final GetDeliveredBoxesUseCase _boxes;

  Future<void> loadBoxes({bool next = false}) async {
    if (state.loading) return;
    if (next && state.boxes.length >= state.total) return;
    final page = next ? state.page + 1 : 1;
    emit(state.copyWith(loading: true, clearError: true));
    final result = await _boxes(pageNumber: page, pageSize: 20);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            boxes: next ? [...state.boxes, ...data.items] : data.items,
            page: page,
            total: data.totalCount,
            loading: false,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(loading: false, errorMessage: failure.errorMessage),
        );
    }
  }
}
