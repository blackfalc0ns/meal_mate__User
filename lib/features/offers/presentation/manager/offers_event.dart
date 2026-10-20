sealed class OffersEvent {
  const OffersEvent();
}

class GetOffersEvent extends OffersEvent {
  const GetOffersEvent({this.includeCampaigns = false});
  final bool? includeCampaigns;
}

class RefreshOffersEvent extends OffersEvent {
  const RefreshOffersEvent({this.includeCampaigns = false});
  final bool? includeCampaigns;
}

class SelectOfferCategoryEvent extends OffersEvent {
  const SelectOfferCategoryEvent(this.index);
  final int index;
}

class ToggleSaveOfferEvent extends OffersEvent {
  const ToggleSaveOfferEvent(this.offerId);
  final String offerId;
}

class LoadOffersHubEvent extends OffersEvent {
  const LoadOffersHubEvent();
}

class LoadSavedOffersEvent extends OffersEvent {
  const LoadSavedOffersEvent();
}

class LoadOfferCalendarEvent extends OffersEvent {
  const LoadOfferCalendarEvent();
}
