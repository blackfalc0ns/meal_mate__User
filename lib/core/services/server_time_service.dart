import 'dart:async';
import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class ServerTimeService {
  static const String serverOffsetKey = 'server_time_offset_ms';

  Duration _serverOffset = Duration.zero;
  bool _hasSynced = false;

  Duration get serverOffset => _serverOffset;
  bool get hasSynced => _hasSynced;

  DateTime get nowUtc => DateTime.now().toUtc().add(_serverOffset);

  Future<void> _persistOffset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(serverOffsetKey, _serverOffset.inMilliseconds);
    } catch (_) {}
  }

  Future<void> loadPersistedOffset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ms = prefs.getInt(serverOffsetKey);
      if (ms != null) {
        _serverOffset = Duration(milliseconds: ms);
        _hasSynced = true;
      }
    } catch (_) {}
  }

  void updateWithServerDateHeader(String? dateHeader) {
    if (dateHeader == null || dateHeader.isEmpty) return;
    try {
      final serverDate = HttpDate.parse(dateHeader);
      final localNow = DateTime.now().toUtc();
      _serverOffset = serverDate.toUtc().difference(localNow);
      _hasSynced = true;
      unawaited(_persistOffset());
    } catch (_) {}
  }

  void updateWithServerDateTime(DateTime serverUtc) {
    final localNow = DateTime.now().toUtc();
    _serverOffset = serverUtc.toUtc().difference(localNow);
    _hasSynced = true;
    unawaited(_persistOffset());
  }
}
