import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class MarkNotificationReadUseCase {
  MarkNotificationReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<void>> call(String id) {
    return _repository.markNotificationRead(id);
  }
}
