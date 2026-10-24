import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';
import 'package:meal_meat_user/features/customer_orders/domain/repo/customer_orders_repository.dart';

@injectable
class GetDeliveredBoxesUseCase {
  GetDeliveredBoxesUseCase(this._repository);
  final CustomerOrdersRepository _repository;
  Future<ApiResult<DeliveredBoxesPageEntity>> call({
    required int pageNumber,
    required int pageSize,
    String? fromDate,
    String? toDate,
    String? subscriptionId,
  }) => _repository.getDeliveredBoxes(
    pageNumber: pageNumber,
    pageSize: pageSize,
    fromDate: fromDate,
    toDate: toDate,
    subscriptionId: subscriptionId,
  );
}
