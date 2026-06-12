// import 'dart:async';

// import 'package:dio/dio.dart';
// import 'package:meal_meat_user/core/di/di.dart';
// import 'package:meal_meat_user/core/network/network_constants.dart';
// import 'package:meal_meat_user/core/services/language_service.dart';
// import 'package:meal_meat_user/core/services/token_service.dart';

// class AuthRefreshService {
//   AuthRefreshService({
//     Dio? dio,
//     TokenService? tokenService,
//     LanguageService? languageService,
   
//   }) : _dio = dio ?? Dio(),
//        _tokenService = tokenService ?? getIt<TokenService>(),
//        _languageService = languageService ?? getIt<LanguageService>()
     

//   final Dio _dio;
//   final TokenService _tokenService;
//   final LanguageService _languageService;


//   /// Mutex: ensures only one refresh call is in-flight at a time.
//   /// Concurrent callers await the same future instead of issuing
//   /// duplicate refresh requests (which would trigger reuse detection).
//   Future<String?>? _inFlightRefresh;

//   static const List<String> _refreshEndpoints = <String>[
//     '/customers/auth/refresh-token',
//     '/customers/auth/refresh',
//   ];

//   Future<String?> refreshAccessToken() async {
//     // If a refresh is already in progress, await it instead of starting
//     // a new one. This prevents refresh token reuse detection on the backend.
//     if (_inFlightRefresh != null) {
//       return _inFlightRefresh!;
//     }

//     _inFlightRefresh = _doRefresh();
//     try {
//       return await _inFlightRefresh!;
//     } finally {
//       _inFlightRefresh = null;
//     }
//   }

//   Future<String?> _doRefresh() async {
//     final refreshToken = await _tokenService.getRefreshToken();
//     if (refreshToken == null || refreshToken.isEmpty) {
//       return null;
//     }

 
//     final headers = <String, dynamic>{
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Accept-Language': _languageService.getLanguageCode(),
     
//     };

//     DioException? lastError;
//     for (final endpoint in _refreshEndpoints) {
//       try {
//         final response = await _dio.post<Map<String, dynamic>>(
//           '${NetworkConstants.baseUrl}$endpoint',
//           data: {'refreshToken': refreshToken},
//           options: Options(headers: headers),
//         );

//         final tokens = _parseTokens(
//           response.data,
//           fallbackRefreshToken: refreshToken,
//         );
//         final accessToken = tokens.$1;
//         final nextRefreshToken = tokens.$2;

//         if (accessToken == null || accessToken.isEmpty) {
//           continue;
//         }

//         await _tokenService.saveAccessToken(accessToken);
//         if (nextRefreshToken != null && nextRefreshToken.isNotEmpty) {
//           await _tokenService.saveRefreshToken(nextRefreshToken);
//         }
//         return accessToken;
//       } on DioException catch (error) {
//         lastError = error;
//         final statusCode = error.response?.statusCode;
//         if (statusCode != 404 && statusCode != 405) {
//           break;
//         }
//       }
//     }

//     if (lastError != null) {
//       throw lastError;
//     }

//     return null;
//   }

//   (String?, String?) _parseTokens(
//     Map<String, dynamic>? data, {
//     required String fallbackRefreshToken,
//   }) {
//     if (data == null) {
//       return (null, fallbackRefreshToken);
//     }

//     final dynamic nestedTokens = data['tokens'];
//     if (nestedTokens is Map<String, dynamic>) {
//       return (
//         nestedTokens['accessToken'] as String?,
//         nestedTokens['refreshToken'] as String? ?? fallbackRefreshToken,
//       );
//     }

//     return (
//       data['accessToken'] as String?,
//       data['refreshToken'] as String? ?? fallbackRefreshToken,
//     );
//   }
// }
