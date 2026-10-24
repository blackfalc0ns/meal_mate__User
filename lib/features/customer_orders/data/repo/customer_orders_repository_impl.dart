import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_orders/data/data_source/customer_orders_remote_data_source.dart';
import 'package:meal_meat_user/features/customer_orders/data/mapper/customer_orders_mapper.dart';
import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';
import 'package:meal_meat_user/features/customer_orders/domain/repo/customer_orders_repository.dart';

@Injectable(as: CustomerOrdersRepository)
class CustomerOrdersRepositoryImpl implements CustomerOrdersRepository {
  CustomerOrdersRepositoryImpl(this._remote);
  final CustomerOrdersRemoteDataSource _remote;

  @override
  Future<ApiResult<DeliveredBoxesPageEntity>> getDeliveredBoxes({
    required int pageNumber,
    required int pageSize,
    String? fromDate,
    String? toDate,
    String? subscriptionId,
  }) => safeApiCall(
    () async => (await _remote.getDeliveredBoxes(
      pageNumber: pageNumber,
      pageSize: pageSize,
      fromDate: fromDate,
      toDate: toDate,
      subscriptionId: subscriptionId,
    )).toEntity(),
  );
}
