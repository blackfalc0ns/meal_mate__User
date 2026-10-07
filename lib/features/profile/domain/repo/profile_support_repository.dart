import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_content_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_message_entity.dart';

abstract interface class ProfileSupportRepository {
  Future<ApiResult<ProfileSupportSubmitResultEntity>> submit(
    ProfileSupportMessageEntity request,
  );
}
