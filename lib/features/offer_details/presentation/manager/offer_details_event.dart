sealed class OfferDetailsEvent {
  const OfferDetailsEvent();
}

class LoadOfferDetailsEvent extends OfferDetailsEvent {
  const LoadOfferDetailsEvent(this.offerId);
  final String offerId;
}

class ToggleSaveOfferDetailEvent extends OfferDetailsEvent {
  const ToggleSaveOfferDetailEvent();
}

class AddReminderToCalendarEvent extends OfferDetailsEvent {
  const AddReminderToCalendarEvent(this.date);
  final String date;
}
