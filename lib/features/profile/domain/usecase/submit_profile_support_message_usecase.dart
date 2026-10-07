import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_content_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_message_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_support_repository.dart';

class SubmitProfileSupportMessageUseCase {
  const SubmitProfileSupportMessageUseCase(this._repository);

  final ProfileSupportRepository _repository;

  Future<ApiResult<ProfileSupportSubmitResultEntity>> call(
    ProfileSupportMessageEntity request,
  ) {
    return _repository.submit(request);
  }
}
