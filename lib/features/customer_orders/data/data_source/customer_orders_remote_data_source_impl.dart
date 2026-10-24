import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/customer_orders/data/data_source/customer_orders_remote_data_source.dart';
import 'package:meal_meat_user/features/customer_orders/data/models/response/delivered_boxes_response_dto.dart';

@Injectable(as: CustomerOrdersRemoteDataSource)
class CustomerOrdersRemoteDataSourceImpl
    implements CustomerOrdersRemoteDataSource {
  CustomerOrdersRemoteDataSourceImpl(this._api);
  final ApiServices _api;

  @override
  Future<DeliveredBoxesResponseDto> getDeliveredBoxes({
    required int pageNumber,
    required int pageSize,
    String? fromDate,
    String? toDate,
    String? subscriptionId,
  }) => _api.getSupportDeliveredBoxes(
    pageNumber,
    pageSize,
    fromDate,
    toDate,
    subscriptionId,
  );
}
