/// Counts down against server time using elapsed time, independent of device clock changes.
class PaymentHoldClock {
  PaymentHoldClock({
    required DateTime expiresAtUtc,
    required DateTime serverTimeUtc,
    this.elapsed,
  }) : _initial = expiresAtUtc.toUtc().difference(serverTimeUtc.toUtc()) {
    _stopwatch.start();
  }
  PaymentHoldClock.expired() : _initial = Duration.zero, elapsed = null;

  final Duration _initial;
  final Duration Function()? elapsed;
  final Stopwatch _stopwatch = Stopwatch();
  Duration get remaining {
    final value = _initial - (elapsed?.call() ?? _stopwatch.elapsed);
    return value.isNegative ? Duration.zero : value;
  }

  bool get isExpired => remaining == Duration.zero;
}
