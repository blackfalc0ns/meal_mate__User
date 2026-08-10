import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/repo/auth_repository.dart';

@injectable
class RefreshTokenUseCase {
  RefreshTokenUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<RefreshTokenEntity>> call(
    RefreshTokenRequestEntity request,
  ) {
    return _repository.refreshToken(request);
  }
}
