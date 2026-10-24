/// Manages the active promo code selected across the user session
/// so it can be automatically applied at the subscription summary step.
class PromoCodeSession {
  PromoCodeSession._();

  static String? _activePromoCode;

  /// Returns the current active promo code, if any.
  static String? get activePromoCode => _activePromoCode;

  /// Sets the active promo code for the session.
  static void setActivePromoCode(String? code) {
    if (code != null && code.trim().isNotEmpty) {
      _activePromoCode = code.trim().toUpperCase();
    } else {
      _activePromoCode = null;
    }
  }

  /// Clears the active promo code from the session.
  static void clear() {
    _activePromoCode = null;
  }
}
