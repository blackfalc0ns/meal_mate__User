import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notifications_page_entity.dart';
import 'package:meal_meat_user/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class GetNotificationsUseCase {
  GetNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<NotificationsPageEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getNotifications(page: page, pageSize: pageSize);
  }
}
