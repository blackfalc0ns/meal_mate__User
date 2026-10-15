import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_content_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_message_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_support_repository.dart';

class ProfileSupportFakeRepository implements ProfileSupportRepository {
  const ProfileSupportFakeRepository({
    this.delayDuration = const Duration(milliseconds: 600),
  });

  final Duration delayDuration;

  @override
  Future<ApiResult<ProfileSupportSubmitResultEntity>> submit(
    ProfileSupportMessageEntity request,
  ) async {
    if (request.subject.trim().isEmpty || request.message.trim().isEmpty) {
      return ApiErrorResult(
        failure: Failure(errorMessage: 'Invalid message content'),
      );
    }

    if (delayDuration > Duration.zero) {
      await Future<void>.delayed(delayDuration);
    }

    return ApiSuccessResult(
      data: ProfileSupportSubmitResultEntity(
        isSuccess: true,
        messageKind: request.kind,
        isDemoOnly: true,
      ),
    );
  }
}
