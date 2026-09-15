import '../../domain/entities/influencer_social_links_entity.dart';

sealed class InfluencerSocialLinksEvent {
  const InfluencerSocialLinksEvent();
}

final class LoadInfluencerSocialLinksEvent extends InfluencerSocialLinksEvent {
  const LoadInfluencerSocialLinksEvent({this.forceRefresh = false});
  final bool forceRefresh;
}

final class SaveInfluencerSocialLinksEvent extends InfluencerSocialLinksEvent {
  const SaveInfluencerSocialLinksEvent(this.links);
  final InfluencerSocialLinksEntity links;
}
