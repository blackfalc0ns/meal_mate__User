import 'dart:io';
import 'package:injectable/injectable.dart';

@lazySingleton
class ServerTimeService {
  Duration _serverOffset = Duration.zero;
  bool _hasSynced = false;

  Duration get serverOffset => _serverOffset;
  bool get hasSynced => _hasSynced;

  DateTime get nowUtc => DateTime.now().toUtc().add(_serverOffset);

  void updateWithServerDateHeader(String? dateHeader) {
    if (dateHeader == null || dateHeader.isEmpty) return;
    try {
      final serverDate = HttpDate.parse(dateHeader);
      final localNow = DateTime.now().toUtc();
      _serverOffset = serverDate.toUtc().difference(localNow);
      _hasSynced = true;
    } catch (_) {}
  }

  void updateWithServerDateTime(DateTime serverUtc) {
    final localNow = DateTime.now().toUtc();
    _serverOffset = serverUtc.toUtc().difference(localNow);
    _hasSynced = true;
  }
}
