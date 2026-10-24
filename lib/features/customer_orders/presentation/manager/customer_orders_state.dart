import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';

class CustomerOrdersState {
  const CustomerOrdersState({
    this.boxes = const [],
    this.page = 0,
    this.total = 0,
    this.loading = false,
    this.errorMessage,
  });

  final List<DeliveredBoxEntity> boxes;
  final int page;
  final int total;
  final bool loading;
  final String? errorMessage;

  CustomerOrdersState copyWith({
    List<DeliveredBoxEntity>? boxes,
    int? page,
    int? total,
    bool? loading,
    String? errorMessage,
    bool clearError = false,
  }) => CustomerOrdersState(
    boxes: boxes ?? this.boxes,
    page: page ?? this.page,
    total: total ?? this.total,
    loading: loading ?? this.loading,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}
