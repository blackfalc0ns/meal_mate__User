import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/entities/influencer_social_links_entity.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/repo/influencer_social_links_repository.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/usecase/get_influencer_social_profile_usecase.dart';
import 'package:meal_meat_user/features/influencer/social_links/domain/usecase/update_influencer_social_links_usecase.dart';
import 'package:meal_meat_user/features/influencer/social_links/presentation/manager/influencer_social_links_event.dart';
import 'package:meal_meat_user/features/influencer/social_links/presentation/manager/influencer_social_links_view_model.dart';

void main() {
  test(
    'loading the social profile does not report a successful save',
    () async {
      final repository = _SocialLinksRepository();
      final viewModel = InfluencerSocialLinksViewModel(
        GetInfluencerSocialProfileUseCase(repository),
        UpdateInfluencerSocialLinksUseCase(repository),
      );
      addTearDown(viewModel.close);

      await viewModel.doIntent(const LoadInfluencerSocialLinksEvent());

      expect(viewModel.state.profile, isNotNull);
      expect(viewModel.state.isSuccess, isFalse);
    },
  );
}

class _SocialLinksRepository implements InfluencerSocialLinksRepository {
  @override
  Future<ApiResult<InfluencerSocialProfileEntity>> getProfile() async {
    return ApiSuccessResult(data: _profile);
  }

  @override
  Future<ApiResult<InfluencerSocialLinksEntity>> updateSocialLinks(
    InfluencerSocialLinksEntity links,
  ) async {
    return ApiSuccessResult(data: links);
  }
}

const _profile = InfluencerSocialProfileEntity(
  id: 'profile-id',
  displayName: 'Yahya',
  code: 'YA6B96',
  commissionRate: 10,
  status: 'active',
  isActive: true,
  hasCompletedSocialOnboarding: false,
  links: InfluencerSocialLinksEntity(),
);
