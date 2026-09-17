sealed class OfferDetailsEvent {
  const OfferDetailsEvent();
}

class LoadOfferDetailsEvent extends OfferDetailsEvent {
  const LoadOfferDetailsEvent(this.offerId);
  final String offerId;
}
