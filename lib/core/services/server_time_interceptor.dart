import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'server_time_service.dart';

@injectable
class ServerTimeInterceptor extends Interceptor {
  ServerTimeInterceptor(this._serverTimeService);

  final ServerTimeService _serverTimeService;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final dateHeader = response.headers.value('date');
    if (dateHeader != null) {
      _serverTimeService.updateWithServerDateHeader(dateHeader);
    }
    super.onResponse(response, handler);
  }
}
