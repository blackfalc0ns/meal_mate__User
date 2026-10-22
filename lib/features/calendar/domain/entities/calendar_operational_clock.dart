class CalendarOperationalClock {
  CalendarOperationalClock(DateTime serverTimeUtc)
    : _serverTimeUtc = serverTimeUtc.toUtc(),
      _elapsed = Stopwatch()..start();

  final DateTime _serverTimeUtc;
  final Stopwatch _elapsed;
  DateTime get now => _serverTimeUtc.add(_elapsed.elapsed);
}
