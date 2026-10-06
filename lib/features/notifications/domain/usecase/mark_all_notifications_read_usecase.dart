import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class MarkAllNotificationsReadUseCase {
  MarkAllNotificationsReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.markAllNotificationsRead();
  }
}
