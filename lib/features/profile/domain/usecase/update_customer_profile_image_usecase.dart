import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_repository.dart';

@injectable
class UpdateCustomerProfileImageUseCase {
  UpdateCustomerProfileImageUseCase(this._repository);

  final ProfileRepository _repository;

  Future<ApiResult<void>> call(ProfileImageRequestEntity request) {
    return _repository.updateCustomerProfileImage(request);
  }
}
