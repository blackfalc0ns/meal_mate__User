import 'dart:async';
import 'package:injectable/injectable.dart';

abstract interface class CustomerDeliveryRealtimeService {
  Stream<String> get onDeliveryChanged;
  void notifyDeliveryChanged(String subscriptionDayId);
}

@LazySingleton(as: CustomerDeliveryRealtimeService)
class CustomerDeliveryRealtimeServiceImpl
    implements CustomerDeliveryRealtimeService {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  @override
  Stream<String> get onDeliveryChanged => _controller.stream;

  @override
  void notifyDeliveryChanged(String subscriptionDayId) {
    if (!_controller.isClosed) {
      _controller.add(subscriptionDayId);
    }
  }

  void dispose() {
    unawaited(_controller.close());
  }
}
