import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

String mapFailureMessage(BuildContext context, String message) {
  final locale = context.localization;

  switch (message) {
    case 'error_connection_timeout':
      return locale.error_connection_timeout;
    case 'error_send_timeout':
      return locale.error_send_timeout;
    case 'error_receive_timeout':
      return locale.error_receive_timeout;
    case 'error_bad_certificate':
      return locale.error_bad_certificate;
    case 'error_request_cancelled':
      return locale.error_request_cancelled;
    case 'error_no_internet':
    case 'error_no_internet_connection':
      return locale.error_no_internet;
    case 'error_unknown':
      return locale.error_unknown;
    case 'error_no_response':
      return locale.error_no_response;
    case 'error_bad_request':
      return locale.error_bad_request;
    case 'error_unauthorized':
      return locale.error_unauthorized;
    case 'error_forbidden':
      return locale.error_forbidden;
    case 'error_not_found':
      return locale.error_not_found;
    case 'error_conflict':
      return locale.error_conflict;
    case 'error_validation':
      return locale.error_validation;
    case 'error_method_not_allowed':
      return locale.error_method_not_allowed;
    case 'error_not_acceptable':
      return locale.error_not_acceptable;
    case 'error_request_timeout':
      return locale.error_request_timeout;
    case 'error_gone':
      return locale.error_gone;
    case 'error_length_required':
      return locale.error_length_required;
    case 'error_precondition_failed':
      return locale.error_precondition_failed;
    case 'error_payload_too_large':
      return locale.error_payload_too_large;
    case 'error_uri_too_long':
      return locale.error_uri_too_long;
    case 'error_unsupported_media_type':
      return locale.error_unsupported_media_type;
    case 'error_range_not_satisfiable':
      return locale.error_range_not_satisfiable;
    case 'error_expectation_failed':
      return locale.error_expectation_failed;
    case 'error_too_many_requests':
      return locale.error_too_many_requests;
    case 'error_internal_server_error':
      return locale.error_internal_server_error;
    case 'error_bad_gateway':
      return locale.error_bad_gateway;
    case 'error_service_unavailable':
      return locale.error_service_unavailable;
    case 'error_gateway_timeout':
      return locale.error_gateway_timeout;
    case 'error_server_error':
      return locale.error_server_error;
    case 'error_cancelled':
      return locale.error_cancelled;
    case 'error_other':
      return locale.error_other;
    case 'location_service_disabled':
      return locale.location_service_disabled;
    case 'location_permission_denied':
      return locale.location_permission_denied;
    case 'location_permission_denied_forever':
      return locale.location_permission_denied_forever;
    case 'error_server':
      return locale.error_server;
    default:
      return message;
  }
}
