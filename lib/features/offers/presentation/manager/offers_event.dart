sealed class OffersEvent {
  const OffersEvent();
}

class GetOffersEvent extends OffersEvent {
  const GetOffersEvent();
}

class RefreshOffersEvent extends OffersEvent {
  const RefreshOffersEvent();
}

class SelectOfferCategoryEvent extends OffersEvent {
  const SelectOfferCategoryEvent(this.index);
  final int index;
}
