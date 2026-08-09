import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translations/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @app_brand_name.
  ///
  /// In en, this message translates to:
  /// **'MealMate'**
  String get app_brand_name;

  /// No description provided for @app_brand_tagline.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Meal Mate'**
  String get app_brand_tagline;

  /// No description provided for @error_no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_no_internet_connection;

  /// No description provided for @error_no_internet_connection_desc.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get error_no_internet_connection_desc;

  /// No description provided for @error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get error_connection_timeout;

  /// No description provided for @error_connection_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The connection took too long to establish. Please try again'**
  String get error_connection_timeout_desc;

  /// No description provided for @error_receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout'**
  String get error_receive_timeout;

  /// No description provided for @error_receive_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again'**
  String get error_receive_timeout_desc;

  /// No description provided for @error_send_timeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout'**
  String get error_send_timeout;

  /// No description provided for @error_send_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'Failed to send data to the server. Please try again'**
  String get error_send_timeout_desc;

  /// No description provided for @error_server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get error_server_error;

  /// No description provided for @error_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on the server. Please try again later'**
  String get error_server_error_desc;

  /// No description provided for @error_internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get error_internal_server_error;

  /// No description provided for @error_internal_server_error_desc.
  ///
  /// In en, this message translates to:
  /// **'The server encountered an internal error. Please try again later'**
  String get error_internal_server_error_desc;

  /// No description provided for @error_bad_gateway.
  ///
  /// In en, this message translates to:
  /// **'Temporary error'**
  String get error_bad_gateway;

  /// No description provided for @error_bad_gateway_desc.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while connecting to the server. Please try again'**
  String get error_bad_gateway_desc;

  /// No description provided for @error_service_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get error_service_unavailable;

  /// No description provided for @error_service_unavailable_desc.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again later'**
  String get error_service_unavailable_desc;

  /// No description provided for @error_gateway_timeout.
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout'**
  String get error_gateway_timeout;

  /// No description provided for @error_gateway_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The gateway timed out. Please try again later'**
  String get error_gateway_timeout_desc;

  /// No description provided for @error_bad_request.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get error_bad_request;

  /// No description provided for @properties_empty_message_favourite.
  ///
  /// In en, this message translates to:
  /// **'You have not added any properties to your favorites.'**
  String get properties_empty_message_favourite;

  /// No description provided for @reviewsFor.
  ///
  /// In en, this message translates to:
  /// **'Reviews for'**
  String get reviewsFor;

  /// No description provided for @error_bad_request_desc.
  ///
  /// In en, this message translates to:
  /// **'The request contains invalid data. Please check your input'**
  String get error_bad_request_desc;

  /// No description provided for @error_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get error_unauthorized;

  /// No description provided for @error_unauthorized_desc.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access this resource. Please login again'**
  String get error_unauthorized_desc;

  /// No description provided for @error_forbidden.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get error_forbidden;

  /// No description provided for @error_forbidden_desc.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this resource'**
  String get error_forbidden_desc;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get error_not_found;

  /// No description provided for @error_not_found_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found'**
  String get error_not_found_desc;

  /// No description provided for @error_method_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'Method not allowed'**
  String get error_method_not_allowed;

  /// No description provided for @error_method_not_allowed_desc.
  ///
  /// In en, this message translates to:
  /// **'This method is not allowed for this resource'**
  String get error_method_not_allowed_desc;

  /// No description provided for @error_not_acceptable.
  ///
  /// In en, this message translates to:
  /// **'Not acceptable'**
  String get error_not_acceptable;

  /// No description provided for @error_not_acceptable_desc.
  ///
  /// In en, this message translates to:
  /// **'The request is not acceptable'**
  String get error_not_acceptable_desc;

  /// No description provided for @error_request_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get error_request_timeout;

  /// No description provided for @error_request_timeout_desc.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Please try again'**
  String get error_request_timeout_desc;

  /// No description provided for @error_conflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get error_conflict;

  /// No description provided for @error_conflict_desc.
  ///
  /// In en, this message translates to:
  /// **'There is a conflict with the current state of the resource'**
  String get error_conflict_desc;

  /// No description provided for @error_gone.
  ///
  /// In en, this message translates to:
  /// **'Resource gone'**
  String get error_gone;

  /// No description provided for @error_gone_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested resource is no longer available'**
  String get error_gone_desc;

  /// No description provided for @error_length_required.
  ///
  /// In en, this message translates to:
  /// **'Length required'**
  String get error_length_required;

  /// No description provided for @error_length_required_desc.
  ///
  /// In en, this message translates to:
  /// **'The request must specify the content length'**
  String get error_length_required_desc;

  /// No description provided for @error_precondition_failed.
  ///
  /// In en, this message translates to:
  /// **'Precondition failed'**
  String get error_precondition_failed;

  /// No description provided for @error_precondition_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'One or more preconditions failed'**
  String get error_precondition_failed_desc;

  /// No description provided for @error_payload_too_large.
  ///
  /// In en, this message translates to:
  /// **'Payload too large'**
  String get error_payload_too_large;

  /// No description provided for @error_payload_too_large_desc.
  ///
  /// In en, this message translates to:
  /// **'The request payload is too large'**
  String get error_payload_too_large_desc;

  /// No description provided for @error_uri_too_long.
  ///
  /// In en, this message translates to:
  /// **'URI too long'**
  String get error_uri_too_long;

  /// No description provided for @error_uri_too_long_desc.
  ///
  /// In en, this message translates to:
  /// **'The request URI is too long'**
  String get error_uri_too_long_desc;

  /// No description provided for @lead_send_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending the contact request'**
  String get lead_send_error;

  /// No description provided for @lead_info_collected.
  ///
  /// In en, this message translates to:
  /// **'Lead information collected successfully'**
  String get lead_info_collected;

  /// No description provided for @lead_offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Contact information saved offline'**
  String get lead_offline_mode;

  /// No description provided for @error_unsupported_media_type.
  ///
  /// In en, this message translates to:
  /// **'Unsupported media type'**
  String get error_unsupported_media_type;

  /// No description provided for @error_unsupported_media_type_desc.
  ///
  /// In en, this message translates to:
  /// **'The media type is not supported'**
  String get error_unsupported_media_type_desc;

  /// No description provided for @error_range_not_satisfiable.
  ///
  /// In en, this message translates to:
  /// **'Range not satisfiable'**
  String get error_range_not_satisfiable;

  /// No description provided for @error_range_not_satisfiable_desc.
  ///
  /// In en, this message translates to:
  /// **'The requested range cannot be satisfied'**
  String get error_range_not_satisfiable_desc;

  /// No description provided for @error_expectation_failed.
  ///
  /// In en, this message translates to:
  /// **'Expectation failed'**
  String get error_expectation_failed;

  /// No description provided for @error_expectation_failed_desc.
  ///
  /// In en, this message translates to:
  /// **'The expectation given in the request header field could not be met'**
  String get error_expectation_failed_desc;

  /// No description provided for @error_too_many_requests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests'**
  String get error_too_many_requests;

  /// No description provided for @error_too_many_requests_desc.
  ///
  /// In en, this message translates to:
  /// **'You have sent too many requests. Please try again later'**
  String get error_too_many_requests_desc;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get error_unknown;

  /// No description provided for @error_unknown_desc.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again'**
  String get error_unknown_desc;

  /// No description provided for @error_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get error_cancelled;

  /// No description provided for @error_cancelled_desc.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled'**
  String get error_cancelled_desc;

  /// No description provided for @error_other.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get error_other;

  /// No description provided for @error_other_desc.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get error_other_desc;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contact_support;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get go_back;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @check_connection.
  ///
  /// In en, this message translates to:
  /// **'Check Connection'**
  String get check_connection;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @continue_as_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continue_as_guest;

  /// No description provided for @name_is_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required!'**
  String get name_is_required;

  /// No description provided for @name_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This name is not valid'**
  String get name_is_not_valid;

  /// No description provided for @email_is_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required!'**
  String get email_is_required;

  /// No description provided for @email_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This email is not valid'**
  String get email_is_not_valid;

  /// No description provided for @password_is_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required!'**
  String get password_is_required;

  /// No description provided for @password_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This password is not valid'**
  String get password_is_not_valid;

  /// No description provided for @password_must_be_at_least_6_characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_must_be_at_least_6_characters;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @confirm_password_is_required.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required!'**
  String get confirm_password_is_required;

  /// No description provided for @confirm_password_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This confirm password is not valid'**
  String get confirm_password_is_not_valid;

  /// No description provided for @password_and_confirm_password_must_be_same.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password must be same!'**
  String get password_and_confirm_password_must_be_same;

  /// No description provided for @phone_number_is_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required!'**
  String get phone_number_is_required;

  /// No description provided for @phone_number_is_not_valid.
  ///
  /// In en, this message translates to:
  /// **'This phone number is not valid'**
  String get phone_number_is_not_valid;

  /// No description provided for @this_field_is_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get this_field_is_required;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @error_bad_certificate.
  ///
  /// In en, this message translates to:
  /// **'Security certificate error'**
  String get error_bad_certificate;

  /// No description provided for @error_request_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled'**
  String get error_request_cancelled;

  /// No description provided for @error_no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get error_no_internet;

  /// No description provided for @error_no_response.
  ///
  /// In en, this message translates to:
  /// **'No response from server'**
  String get error_no_response;

  /// No description provided for @error_validation.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get error_validation;

  /// No description provided for @error_server.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get error_server;

  /// No description provided for @location_service_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get location_service_disabled;

  /// No description provided for @location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get location_permission_denied;

  /// No description provided for @location_permission_denied_forever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Please enable it from settings'**
  String get location_permission_denied_forever;

  /// No description provided for @location_service_disabled_message.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services to continue'**
  String get location_service_disabled_message;

  /// No description provided for @location_permission_denied_message.
  ///
  /// In en, this message translates to:
  /// **'Please grant location permission to continue'**
  String get location_permission_denied_message;

  /// No description provided for @location_permission_denied_forever_message.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Please enable it from your device settings'**
  String get location_permission_denied_forever_message;

  /// No description provided for @verification_code_required.
  ///
  /// In en, this message translates to:
  /// **'Verification code is required'**
  String get verification_code_required;

  /// No description provided for @verification_code_invalid.
  ///
  /// In en, this message translates to:
  /// **'Verification code is invalid'**
  String get verification_code_invalid;

  /// No description provided for @start_button.
  ///
  /// In en, this message translates to:
  /// **'start now'**
  String get start_button;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcome_back;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to access your meal plan and track your health goals'**
  String get login_subtitle;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_title;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @phone_hint.
  ///
  /// In en, this message translates to:
  /// **'000 000 00 00'**
  String get phone_hint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get password_hint;

  /// No description provided for @remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get remember_me;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @login_with_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get login_with_google;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @auth_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get auth_welcome_title;

  /// No description provided for @auth_welcome_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to access your meal plan and track your health goals.'**
  String get auth_welcome_subtitle;

  /// No description provided for @auth_sign_in_title.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_sign_in_title;

  /// No description provided for @auth_sign_in_button.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_sign_in_button;

  /// No description provided for @auth_no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get auth_no_account;

  /// No description provided for @auth_create_account_link.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get auth_create_account_link;

  /// No description provided for @auth_have_account_prompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get auth_have_account_prompt;

  /// No description provided for @auth_sign_in_link.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_sign_in_link;

  /// No description provided for @auth_create_account_title.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get auth_create_account_title;

  /// No description provided for @auth_create_account_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join MealMate and start your healthier journey.'**
  String get auth_create_account_subtitle;

  /// No description provided for @auth_name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get auth_name_label;

  /// No description provided for @auth_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get auth_name_hint;

  /// No description provided for @auth_confirm_password_label.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get auth_confirm_password_label;

  /// No description provided for @auth_confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get auth_confirm_password_hint;

  /// No description provided for @auth_terms_label.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and conditions'**
  String get auth_terms_label;

  /// No description provided for @auth_create_account_button.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get auth_create_account_button;

  /// No description provided for @auth_reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get auth_reset_password_title;

  /// No description provided for @auth_reset_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to receive an OTP code.'**
  String get auth_reset_password_subtitle;

  /// No description provided for @auth_reset_password_hint.
  ///
  /// In en, this message translates to:
  /// **'We will send an OTP code to your phone number.'**
  String get auth_reset_password_hint;

  /// No description provided for @auth_send_otp_button.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get auth_send_otp_button;

  /// No description provided for @auth_otp_title.
  ///
  /// In en, this message translates to:
  /// **'Verify your code'**
  String get auth_otp_title;

  /// No description provided for @auth_otp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP code sent to your phone.'**
  String get auth_otp_subtitle;

  /// No description provided for @auth_otp_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP code to continue.'**
  String get auth_otp_hint;

  /// No description provided for @auth_verify_code_button.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get auth_verify_code_button;

  /// No description provided for @auth_no_code_title.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get auth_no_code_title;

  /// No description provided for @auth_resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get auth_resend_code;

  /// No description provided for @auth_resend_code_in.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get auth_resend_code_in;

  /// No description provided for @auth_seconds_label.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get auth_seconds_label;

  /// No description provided for @auth_new_password_title.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get auth_new_password_title;

  /// No description provided for @auth_new_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password for your account.'**
  String get auth_new_password_subtitle;

  /// No description provided for @auth_new_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password.'**
  String get auth_new_password_hint;

  /// No description provided for @auth_new_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_new_password_label;

  /// No description provided for @auth_new_password_hint_field.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get auth_new_password_hint_field;

  /// No description provided for @auth_new_password_button.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get auth_new_password_button;

  /// No description provided for @onboarding_first_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your healthy companion every day.'**
  String get onboarding_first_subtitle;

  /// No description provided for @onboarding_second_title.
  ///
  /// In en, this message translates to:
  /// **'Healthy and tasty meals'**
  String get onboarding_second_title;

  /// No description provided for @onboarding_second_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Delivered right to your door...'**
  String get onboarding_second_subtitle;

  /// No description provided for @onboarding_third_title.
  ///
  /// In en, this message translates to:
  /// **'Healthy food'**
  String get onboarding_third_title;

  /// No description provided for @onboarding_third_subtitle.
  ///
  /// In en, this message translates to:
  /// **'For a better mood!'**
  String get onboarding_third_subtitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get nav_meals;

  /// No description provided for @nav_offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get nav_offers;

  /// No description provided for @nav_subscription.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get nav_subscription;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @profile_user_name.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Mohamed'**
  String get profile_user_name;

  /// No description provided for @profile_user_email.
  ///
  /// In en, this message translates to:
  /// **'ahmed.mohamed@gemil.com'**
  String get profile_user_email;

  /// No description provided for @profile_premium_member.
  ///
  /// In en, this message translates to:
  /// **'Premium member'**
  String get profile_premium_member;

  /// No description provided for @profile_completed_plans.
  ///
  /// In en, this message translates to:
  /// **'Completed plans'**
  String get profile_completed_plans;

  /// No description provided for @profile_streak_days.
  ///
  /// In en, this message translates to:
  /// **'Consecutive days'**
  String get profile_streak_days;

  /// No description provided for @profile_points.
  ///
  /// In en, this message translates to:
  /// **'Your points'**
  String get profile_points;

  /// No description provided for @profile_weight_lost.
  ///
  /// In en, this message translates to:
  /// **'kg lost'**
  String get profile_weight_lost;

  /// No description provided for @profile_personal_info.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get profile_personal_info;

  /// No description provided for @profile_personal_info_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit your personal details'**
  String get profile_personal_info_subtitle;

  /// No description provided for @profile_goals.
  ///
  /// In en, this message translates to:
  /// **'My goals'**
  String get profile_goals;

  /// No description provided for @profile_goals_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your health goals'**
  String get profile_goals_subtitle;

  /// No description provided for @profile_dietary_preferences.
  ///
  /// In en, this message translates to:
  /// **'Dietary preferences'**
  String get profile_dietary_preferences;

  /// No description provided for @profile_dietary_preferences_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your preferences and allergies'**
  String get profile_dietary_preferences_subtitle;

  /// No description provided for @dietary_preferences_diet_title.
  ///
  /// In en, this message translates to:
  /// **'Diet type'**
  String get dietary_preferences_diet_title;

  /// No description provided for @dietary_preferences_diet_balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get dietary_preferences_diet_balanced;

  /// No description provided for @dietary_preferences_diet_vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietary_preferences_diet_vegetarian;

  /// No description provided for @dietary_preferences_diet_vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietary_preferences_diet_vegan;

  /// No description provided for @dietary_preferences_diet_keto.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get dietary_preferences_diet_keto;

  /// No description provided for @dietary_preferences_diet_high_protein.
  ///
  /// In en, this message translates to:
  /// **'High protein'**
  String get dietary_preferences_diet_high_protein;

  /// No description provided for @dietary_preferences_dislikes_title.
  ///
  /// In en, this message translates to:
  /// **'Foods you dislike'**
  String get dietary_preferences_dislikes_title;

  /// No description provided for @dietary_preferences_dislike_onion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get dietary_preferences_dislike_onion;

  /// No description provided for @dietary_preferences_dislike_mushroom.
  ///
  /// In en, this message translates to:
  /// **'Mushroom'**
  String get dietary_preferences_dislike_mushroom;

  /// No description provided for @dietary_preferences_dislike_olives.
  ///
  /// In en, this message translates to:
  /// **'Olives'**
  String get dietary_preferences_dislike_olives;

  /// No description provided for @dietary_preferences_dislike_coriander.
  ///
  /// In en, this message translates to:
  /// **'Coriander'**
  String get dietary_preferences_dislike_coriander;

  /// No description provided for @dietary_preferences_allergies_title.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get dietary_preferences_allergies_title;

  /// No description provided for @dietary_preferences_allergy_nuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get dietary_preferences_allergy_nuts;

  /// No description provided for @dietary_preferences_allergy_lactose.
  ///
  /// In en, this message translates to:
  /// **'Lactose'**
  String get dietary_preferences_allergy_lactose;

  /// No description provided for @dietary_preferences_manage_allergies.
  ///
  /// In en, this message translates to:
  /// **'Manage allergies'**
  String get dietary_preferences_manage_allergies;

  /// No description provided for @dietary_preferences_notes_title.
  ///
  /// In en, this message translates to:
  /// **'Dietary notes'**
  String get dietary_preferences_notes_title;

  /// No description provided for @dietary_preferences_notes_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: I want low-sodium meals...'**
  String get dietary_preferences_notes_hint;

  /// No description provided for @dietary_preferences_allergy_notice_title.
  ///
  /// In en, this message translates to:
  /// **'Important allergy information'**
  String get dietary_preferences_allergy_notice_title;

  /// No description provided for @dietary_preferences_allergy_notice_message.
  ///
  /// In en, this message translates to:
  /// **'Allergy information helps us customize safe meals for you and avoid ingredients that may affect your health.'**
  String get dietary_preferences_allergy_notice_message;

  /// No description provided for @dietary_preferences_save.
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get dietary_preferences_save;

  /// No description provided for @add_allergy_title.
  ///
  /// In en, this message translates to:
  /// **'Add allergy'**
  String get add_allergy_title;

  /// No description provided for @add_allergy_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the allergies you have so we can avoid showing meals that are not suitable for you.'**
  String get add_allergy_subtitle;

  /// No description provided for @add_allergy_selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get add_allergy_selected;

  /// No description provided for @add_allergy_current_allergies.
  ///
  /// In en, this message translates to:
  /// **'Your current allergies'**
  String get add_allergy_current_allergies;

  /// No description provided for @add_allergy_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for an ingredient or allergy'**
  String get add_allergy_search_hint;

  /// No description provided for @add_allergy_sesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get add_allergy_sesame;

  /// No description provided for @add_allergy_eggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get add_allergy_eggs;

  /// No description provided for @add_allergy_gluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get add_allergy_gluten;

  /// No description provided for @add_allergy_peanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get add_allergy_peanuts;

  /// No description provided for @add_allergy_seafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get add_allergy_seafood;

  /// No description provided for @add_allergy_soy.
  ///
  /// In en, this message translates to:
  /// **'Soy'**
  String get add_allergy_soy;

  /// No description provided for @add_allergy_wheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get add_allergy_wheat;

  /// No description provided for @add_allergy_fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get add_allergy_fish;

  /// No description provided for @add_allergy_shellfish.
  ///
  /// In en, this message translates to:
  /// **'Shellfish'**
  String get add_allergy_shellfish;

  /// No description provided for @add_allergy_common_allergies.
  ///
  /// In en, this message translates to:
  /// **'Common allergies'**
  String get add_allergy_common_allergies;

  /// No description provided for @add_allergy_celery.
  ///
  /// In en, this message translates to:
  /// **'Celery'**
  String get add_allergy_celery;

  /// No description provided for @add_allergy_mustard.
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get add_allergy_mustard;

  /// No description provided for @add_allergy_lupin.
  ///
  /// In en, this message translates to:
  /// **'Lupin'**
  String get add_allergy_lupin;

  /// No description provided for @add_allergy_note_title.
  ///
  /// In en, this message translates to:
  /// **'Important note'**
  String get add_allergy_note_title;

  /// No description provided for @add_allergy_note_message.
  ///
  /// In en, this message translates to:
  /// **'We rely on ingredient information from our partners; recipes may change.'**
  String get add_allergy_note_message;

  /// No description provided for @add_allergy_save.
  ///
  /// In en, this message translates to:
  /// **'Save allergies'**
  String get add_allergy_save;

  /// No description provided for @profile_billing.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions and billing'**
  String get profile_billing;

  /// No description provided for @profile_billing_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your subscription and payment details'**
  String get profile_billing_subtitle;

  /// No description provided for @billing_plan_name.
  ///
  /// In en, this message translates to:
  /// **'Fitness plan'**
  String get billing_plan_name;

  /// No description provided for @billing_plan_tier.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get billing_plan_tier;

  /// No description provided for @billing_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get billing_active;

  /// No description provided for @billing_renewal_date.
  ///
  /// In en, this message translates to:
  /// **'Next renewal: June 15, 2025'**
  String get billing_renewal_date;

  /// No description provided for @billing_days_remaining.
  ///
  /// In en, this message translates to:
  /// **'18 days remaining'**
  String get billing_days_remaining;

  /// No description provided for @billing_plan_usage.
  ///
  /// In en, this message translates to:
  /// **'Plan usage this month'**
  String get billing_plan_usage;

  /// No description provided for @billing_plan_usage_value.
  ///
  /// In en, this message translates to:
  /// **'22 of 30 days'**
  String get billing_plan_usage_value;

  /// No description provided for @billing_plan_usage_current.
  ///
  /// In en, this message translates to:
  /// **'22'**
  String get billing_plan_usage_current;

  /// No description provided for @billing_plan_usage_remaining.
  ///
  /// In en, this message translates to:
  /// **'of 30 days'**
  String get billing_plan_usage_remaining;

  /// No description provided for @billing_renew.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get billing_renew;

  /// No description provided for @billing_freeze.
  ///
  /// In en, this message translates to:
  /// **'Freeze'**
  String get billing_freeze;

  /// No description provided for @billing_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get billing_cancel;

  /// No description provided for @billing_default_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Default payment method'**
  String get billing_default_payment_method;

  /// No description provided for @billing_expiration_date.
  ///
  /// In en, this message translates to:
  /// **'Expiration date'**
  String get billing_expiration_date;

  /// No description provided for @billing_invoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get billing_invoices;

  /// No description provided for @billing_paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get billing_paid;

  /// No description provided for @billing_invoice_date.
  ///
  /// In en, this message translates to:
  /// **'May 15, 2025'**
  String get billing_invoice_date;

  /// No description provided for @billing_manage_subscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get billing_manage_subscription;

  /// No description provided for @billing_notice.
  ///
  /// In en, this message translates to:
  /// **'You can freeze your subscription for up to 30 days once every 6 months. Once cancelled, you can still enjoy your meals until the end of the current billing cycle.'**
  String get billing_notice;

  /// No description provided for @profile_addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get profile_addresses;

  /// No description provided for @profile_addresses_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage delivery addresses'**
  String get profile_addresses_subtitle;

  /// No description provided for @addresses_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get addresses_default;

  /// No description provided for @addresses_access_instructions.
  ///
  /// In en, this message translates to:
  /// **'Access instructions'**
  String get addresses_access_instructions;

  /// No description provided for @addresses_current_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get addresses_current_home;

  /// No description provided for @addresses_current_home_details.
  ///
  /// In en, this message translates to:
  /// **'Apartment 525\nAhmed Mohamed Street\nFaiyum, Egypt'**
  String get addresses_current_home_details;

  /// No description provided for @addresses_saved_section.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get addresses_saved_section;

  /// No description provided for @addresses_home_address.
  ///
  /// In en, this message translates to:
  /// **'1174 Roy Alley, Colorado 80205'**
  String get addresses_home_address;

  /// No description provided for @addresses_work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get addresses_work;

  /// No description provided for @addresses_work_address.
  ///
  /// In en, this message translates to:
  /// **'1801 California Street, Denver, Colorado 80202'**
  String get addresses_work_address;

  /// No description provided for @addresses_other.
  ///
  /// In en, this message translates to:
  /// **'Other address'**
  String get addresses_other;

  /// No description provided for @addresses_other_address.
  ///
  /// In en, this message translates to:
  /// **'3200 South Cherry Creek Street, Denver 80209'**
  String get addresses_other_address;

  /// No description provided for @addresses_delivery_preferences.
  ///
  /// In en, this message translates to:
  /// **'Delivery preferences'**
  String get addresses_delivery_preferences;

  /// No description provided for @addresses_contact_on_arrival.
  ///
  /// In en, this message translates to:
  /// **'Contact on arrival'**
  String get addresses_contact_on_arrival;

  /// No description provided for @addresses_contact_on_arrival_description.
  ///
  /// In en, this message translates to:
  /// **'We will notify you when the courier arrives'**
  String get addresses_contact_on_arrival_description;

  /// No description provided for @addresses_leave_at_door.
  ///
  /// In en, this message translates to:
  /// **'Leave the order at the door'**
  String get addresses_leave_at_door;

  /// No description provided for @addresses_leave_at_door_description.
  ///
  /// In en, this message translates to:
  /// **'Leave the order in a safe place at the door'**
  String get addresses_leave_at_door_description;

  /// No description provided for @addresses_add_new.
  ///
  /// In en, this message translates to:
  /// **'Add new address'**
  String get addresses_add_new;

  /// No description provided for @addresses_availability_notice.
  ///
  /// In en, this message translates to:
  /// **'Available meals and restaurants may vary by delivery area'**
  String get addresses_availability_notice;

  /// No description provided for @addresses_save.
  ///
  /// In en, this message translates to:
  /// **'Save address'**
  String get addresses_save;

  /// No description provided for @profile_security.
  ///
  /// In en, this message translates to:
  /// **'Security and privacy'**
  String get profile_security;

  /// No description provided for @profile_security_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Change your password and privacy settings'**
  String get profile_security_subtitle;

  /// No description provided for @profile_privacy_security_section.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profile_privacy_security_section;

  /// No description provided for @profile_privacy_section.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profile_privacy_section;

  /// No description provided for @profile_privacy_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profile_privacy_change_password;

  /// No description provided for @profile_privacy_change_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update the password for your account'**
  String get profile_privacy_change_password_subtitle;

  /// No description provided for @profile_privacy_phone_verification.
  ///
  /// In en, this message translates to:
  /// **'Verify phone number'**
  String get profile_privacy_phone_verification;

  /// No description provided for @profile_privacy_phone_verification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone number to keep your account secure'**
  String get profile_privacy_phone_verification_subtitle;

  /// No description provided for @profile_privacy_email_verification.
  ///
  /// In en, this message translates to:
  /// **'Verify email address'**
  String get profile_privacy_email_verification;

  /// No description provided for @profile_privacy_email_verification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email address to secure your account'**
  String get profile_privacy_email_verification_subtitle;

  /// No description provided for @profile_privacy_location_permission.
  ///
  /// In en, this message translates to:
  /// **'Location permission'**
  String get profile_privacy_location_permission;

  /// No description provided for @profile_privacy_location_permission_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow access to your location for better services'**
  String get profile_privacy_location_permission_subtitle;

  /// No description provided for @profile_privacy_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_privacy_notifications;

  /// No description provided for @profile_privacy_notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize alerts and updates'**
  String get profile_privacy_notifications_subtitle;

  /// No description provided for @profile_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get profile_privacy_policy;

  /// No description provided for @profile_privacy_policy_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn how we collect and use your data'**
  String get profile_privacy_policy_subtitle;

  /// No description provided for @profile_privacy_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get profile_privacy_terms;

  /// No description provided for @profile_privacy_terms_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Review the terms and conditions of the service'**
  String get profile_privacy_terms_subtitle;

  /// No description provided for @profile_privacy_permissions_title.
  ///
  /// In en, this message translates to:
  /// **'Enable permissions for a better experience'**
  String get profile_privacy_permissions_title;

  /// No description provided for @profile_privacy_permissions_message.
  ///
  /// In en, this message translates to:
  /// **'Permissions help us provide more accurate services and recommendations.'**
  String get profile_privacy_permissions_message;

  /// No description provided for @profile_privacy_password_reminder_title.
  ///
  /// In en, this message translates to:
  /// **'We recommend updating your password regularly'**
  String get profile_privacy_password_reminder_title;

  /// No description provided for @profile_privacy_password_reminder_message.
  ///
  /// In en, this message translates to:
  /// **'Regular updates increase account security and protect your personal data.'**
  String get profile_privacy_password_reminder_message;

  /// No description provided for @profile_privacy_manage_security.
  ///
  /// In en, this message translates to:
  /// **'Manage security'**
  String get profile_privacy_manage_security;

  /// No description provided for @coming_soon_subtitle.
  ///
  /// In en, this message translates to:
  /// **'This section is being prepared and will be available soon.'**
  String get coming_soon_subtitle;

  /// No description provided for @drawer_guest_name.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Mohamed'**
  String get drawer_guest_name;

  /// No description provided for @drawer_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome,'**
  String get drawer_welcome;

  /// No description provided for @drawer_weight_loss_program.
  ///
  /// In en, this message translates to:
  /// **'Weight loss program'**
  String get drawer_weight_loss_program;

  /// No description provided for @drawer_month_package.
  ///
  /// In en, this message translates to:
  /// **'Monthly package'**
  String get drawer_month_package;

  /// No description provided for @drawer_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get drawer_account;

  /// No description provided for @drawer_my_account.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get drawer_my_account;

  /// No description provided for @drawer_payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get drawer_payment_methods;

  /// No description provided for @drawer_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get drawer_notifications;

  /// No description provided for @drawer_subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get drawer_subscription;

  /// No description provided for @drawer_current_subscription.
  ///
  /// In en, this message translates to:
  /// **'Current subscription'**
  String get drawer_current_subscription;

  /// No description provided for @drawer_family_members.
  ///
  /// In en, this message translates to:
  /// **'Family members'**
  String get drawer_family_members;

  /// No description provided for @drawer_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get drawer_orders;

  /// No description provided for @drawer_previous_orders.
  ///
  /// In en, this message translates to:
  /// **'Previous orders'**
  String get drawer_previous_orders;

  /// No description provided for @drawer_track_current_order.
  ///
  /// In en, this message translates to:
  /// **'Track current order'**
  String get drawer_track_current_order;

  /// No description provided for @drawer_rewards_offers.
  ///
  /// In en, this message translates to:
  /// **'Rewards and offers'**
  String get drawer_rewards_offers;

  /// No description provided for @drawer_points_rewards.
  ///
  /// In en, this message translates to:
  /// **'Points and rewards'**
  String get drawer_points_rewards;

  /// No description provided for @drawer_invite_friends.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get drawer_invite_friends;

  /// No description provided for @drawer_special_offers.
  ///
  /// In en, this message translates to:
  /// **'Special offers'**
  String get drawer_special_offers;

  /// No description provided for @drawer_support_help.
  ///
  /// In en, this message translates to:
  /// **'Support and help'**
  String get drawer_support_help;

  /// No description provided for @drawer_technical_support.
  ///
  /// In en, this message translates to:
  /// **'Technical support'**
  String get drawer_technical_support;

  /// No description provided for @drawer_faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get drawer_faq;

  /// No description provided for @drawer_contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get drawer_contact_us;

  /// No description provided for @drawer_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawer_settings;

  /// No description provided for @drawer_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawer_language;

  /// No description provided for @drawer_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get drawer_logout;

  /// No description provided for @offers_title.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers_title;

  /// No description provided for @offers_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get offers_hero_badge;

  /// No description provided for @offers_hero_discount.
  ///
  /// In en, this message translates to:
  /// **'30%'**
  String get offers_hero_discount;

  /// No description provided for @offers_hero_title.
  ///
  /// In en, this message translates to:
  /// **'30% off'**
  String get offers_hero_title;

  /// No description provided for @offers_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'on all plans'**
  String get offers_hero_subtitle;

  /// No description provided for @offers_hero_description.
  ///
  /// In en, this message translates to:
  /// **'Start your healthy journey today'**
  String get offers_hero_description;

  /// No description provided for @offers_hero_button.
  ///
  /// In en, this message translates to:
  /// **'Subscribe now'**
  String get offers_hero_button;

  /// No description provided for @offers_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get offers_filter_all;

  /// No description provided for @offers_filter_offers.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get offers_filter_offers;

  /// No description provided for @offers_filter_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get offers_filter_restaurants;

  /// No description provided for @offers_filter_meals.
  ///
  /// In en, this message translates to:
  /// **'Limited time'**
  String get offers_filter_meals;

  /// No description provided for @offers_filter_gifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get offers_filter_gifts;

  /// No description provided for @offers_featured_section_title.
  ///
  /// In en, this message translates to:
  /// **'Featured offers'**
  String get offers_featured_section_title;

  /// No description provided for @offers_view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get offers_view_all;

  /// No description provided for @offers_restaurants_section_title.
  ///
  /// In en, this message translates to:
  /// **'Popular restaurants'**
  String get offers_restaurants_section_title;

  /// No description provided for @offers_invite_title.
  ///
  /// In en, this message translates to:
  /// **'Invite friends and get'**
  String get offers_invite_title;

  /// No description provided for @offers_invite_subtitle.
  ///
  /// In en, this message translates to:
  /// **'30% off'**
  String get offers_invite_subtitle;

  /// No description provided for @offers_invite_button.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get offers_invite_button;

  /// No description provided for @offers_coupon_prefix.
  ///
  /// In en, this message translates to:
  /// **'Use '**
  String get offers_coupon_prefix;

  /// No description provided for @offers_coupon_highlight.
  ///
  /// In en, this message translates to:
  /// **'discount code'**
  String get offers_coupon_highlight;

  /// No description provided for @offers_coupon_suffix.
  ///
  /// In en, this message translates to:
  /// **' to get'**
  String get offers_coupon_suffix;

  /// No description provided for @offers_coupon_second_line.
  ///
  /// In en, this message translates to:
  /// **'a discount on your subscription'**
  String get offers_coupon_second_line;

  /// No description provided for @offers_coupon_button.
  ///
  /// In en, this message translates to:
  /// **'Redeem now'**
  String get offers_coupon_button;

  /// No description provided for @offers_countdown_label.
  ///
  /// In en, this message translates to:
  /// **'Ends in'**
  String get offers_countdown_label;

  /// No description provided for @offers_countdown_value.
  ///
  /// In en, this message translates to:
  /// **'10:18:24'**
  String get offers_countdown_value;

  /// No description provided for @offers_featured_button.
  ///
  /// In en, this message translates to:
  /// **'Subscribe now'**
  String get offers_featured_button;

  /// No description provided for @offers_featured_burger_title.
  ///
  /// In en, this message translates to:
  /// **'Monthly package'**
  String get offers_featured_burger_title;

  /// No description provided for @offers_featured_burger_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Balanced meals all month'**
  String get offers_featured_burger_subtitle;

  /// No description provided for @offers_featured_burger_discount.
  ///
  /// In en, this message translates to:
  /// **'-20%'**
  String get offers_featured_burger_discount;

  /// No description provided for @offers_featured_burger_badge.
  ///
  /// In en, this message translates to:
  /// **'-20%'**
  String get offers_featured_burger_badge;

  /// No description provided for @offers_featured_burger_delivery.
  ///
  /// In en, this message translates to:
  /// **'10:18:24'**
  String get offers_featured_burger_delivery;

  /// No description provided for @offers_featured_burger_reviews.
  ///
  /// In en, this message translates to:
  /// **'4.9'**
  String get offers_featured_burger_reviews;

  /// No description provided for @offers_featured_salad_title.
  ///
  /// In en, this message translates to:
  /// **'Protein package'**
  String get offers_featured_salad_title;

  /// No description provided for @offers_featured_salad_subtitle.
  ///
  /// In en, this message translates to:
  /// **'20 protein-rich meals'**
  String get offers_featured_salad_subtitle;

  /// No description provided for @offers_featured_salad_discount.
  ///
  /// In en, this message translates to:
  /// **'Most useful'**
  String get offers_featured_salad_discount;

  /// No description provided for @offers_featured_salad_badge.
  ///
  /// In en, this message translates to:
  /// **'Healthy pick'**
  String get offers_featured_salad_badge;

  /// No description provided for @offers_featured_salad_delivery.
  ///
  /// In en, this message translates to:
  /// **'10:18:24'**
  String get offers_featured_salad_delivery;

  /// No description provided for @offers_featured_salad_reviews.
  ///
  /// In en, this message translates to:
  /// **'4.8'**
  String get offers_featured_salad_reviews;

  /// No description provided for @offers_featured_gift_title.
  ///
  /// In en, this message translates to:
  /// **'3-month subscription'**
  String get offers_featured_gift_title;

  /// No description provided for @offers_featured_gift_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Bigger savings with a complete 3-month nutrition plan'**
  String get offers_featured_gift_subtitle;

  /// No description provided for @offers_featured_gift_discount.
  ///
  /// In en, this message translates to:
  /// **'-15%'**
  String get offers_featured_gift_discount;

  /// No description provided for @offers_featured_gift_badge.
  ///
  /// In en, this message translates to:
  /// **'-15%'**
  String get offers_featured_gift_badge;

  /// No description provided for @offers_featured_gift_delivery.
  ///
  /// In en, this message translates to:
  /// **'10:18:24'**
  String get offers_featured_gift_delivery;

  /// No description provided for @offers_featured_gift_reviews.
  ///
  /// In en, this message translates to:
  /// **'5.0'**
  String get offers_featured_gift_reviews;

  /// No description provided for @offers_restaurant_burger_title.
  ///
  /// In en, this message translates to:
  /// **'Burger King deal'**
  String get offers_restaurant_burger_title;

  /// No description provided for @offers_restaurant_burger_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Special offer on your favorite classic meals.'**
  String get offers_restaurant_burger_subtitle;

  /// No description provided for @offers_restaurant_burger_discount.
  ///
  /// In en, this message translates to:
  /// **'30% off'**
  String get offers_restaurant_burger_discount;

  /// No description provided for @offers_restaurant_burger_badge.
  ///
  /// In en, this message translates to:
  /// **'Hot deal'**
  String get offers_restaurant_burger_badge;

  /// No description provided for @offers_restaurant_burger_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery in 15 min'**
  String get offers_restaurant_burger_delivery;

  /// No description provided for @offers_restaurant_burger_reviews.
  ///
  /// In en, this message translates to:
  /// **'4.9'**
  String get offers_restaurant_burger_reviews;

  /// No description provided for @offers_restaurant_mcdonalds_title.
  ///
  /// In en, this message translates to:
  /// **'McDonald\'s'**
  String get offers_restaurant_mcdonalds_title;

  /// No description provided for @offers_restaurant_mcdonalds_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Discount on all menu items.'**
  String get offers_restaurant_mcdonalds_subtitle;

  /// No description provided for @offers_restaurant_mcdonalds_discount.
  ///
  /// In en, this message translates to:
  /// **'30% off'**
  String get offers_restaurant_mcdonalds_discount;

  /// No description provided for @offers_restaurant_mcdonalds_badge.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get offers_restaurant_mcdonalds_badge;

  /// No description provided for @offers_restaurant_mcdonalds_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery in 20 min'**
  String get offers_restaurant_mcdonalds_delivery;

  /// No description provided for @offers_restaurant_mcdonalds_reviews.
  ///
  /// In en, this message translates to:
  /// **'4.0'**
  String get offers_restaurant_mcdonalds_reviews;

  /// No description provided for @offers_restaurant_starbucks_title.
  ///
  /// In en, this message translates to:
  /// **'Starbucks'**
  String get offers_restaurant_starbucks_title;

  /// No description provided for @offers_restaurant_starbucks_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Special deal on drinks and snacks.'**
  String get offers_restaurant_starbucks_subtitle;

  /// No description provided for @offers_restaurant_starbucks_discount.
  ///
  /// In en, this message translates to:
  /// **'30% off'**
  String get offers_restaurant_starbucks_discount;

  /// No description provided for @offers_restaurant_starbucks_badge.
  ///
  /// In en, this message translates to:
  /// **'Fresh pick'**
  String get offers_restaurant_starbucks_badge;

  /// No description provided for @offers_restaurant_starbucks_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery in 25 min'**
  String get offers_restaurant_starbucks_delivery;

  /// No description provided for @offers_restaurant_starbucks_reviews.
  ///
  /// In en, this message translates to:
  /// **'4.8'**
  String get offers_restaurant_starbucks_reviews;

  /// No description provided for @offers_restaurant_bowls_title.
  ///
  /// In en, this message translates to:
  /// **'Green bowls'**
  String get offers_restaurant_bowls_title;

  /// No description provided for @offers_restaurant_bowls_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Balanced bowls with fresh ingredients.'**
  String get offers_restaurant_bowls_subtitle;

  /// No description provided for @offers_restaurant_bowls_discount.
  ///
  /// In en, this message translates to:
  /// **'20% off'**
  String get offers_restaurant_bowls_discount;

  /// No description provided for @offers_restaurant_bowls_badge.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get offers_restaurant_bowls_badge;

  /// No description provided for @offers_restaurant_bowls_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery in 18 min'**
  String get offers_restaurant_bowls_delivery;

  /// No description provided for @offers_restaurant_bowls_reviews.
  ///
  /// In en, this message translates to:
  /// **'4.8'**
  String get offers_restaurant_bowls_reviews;

  /// No description provided for @offer_details_title.
  ///
  /// In en, this message translates to:
  /// **'Offer details'**
  String get offer_details_title;

  /// No description provided for @offer_details_hero_heading.
  ///
  /// In en, this message translates to:
  /// **'20% off monthly plans'**
  String get offer_details_hero_heading;

  /// No description provided for @offer_details_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete nutrition plans'**
  String get offer_details_hero_subtitle;

  /// No description provided for @offer_details_hero_description.
  ///
  /// In en, this message translates to:
  /// **'Helps you stay on track with your goals'**
  String get offer_details_hero_description;

  /// No description provided for @offer_details_hero_timer_label.
  ///
  /// In en, this message translates to:
  /// **'Ends in'**
  String get offer_details_hero_timer_label;

  /// No description provided for @offer_details_info_title.
  ///
  /// In en, this message translates to:
  /// **'Offer details'**
  String get offer_details_info_title;

  /// No description provided for @offer_details_info_summary.
  ///
  /// In en, this message translates to:
  /// **'20% off on all monthly plans'**
  String get offer_details_info_summary;

  /// No description provided for @offer_details_info_duration_label.
  ///
  /// In en, this message translates to:
  /// **'Offer duration'**
  String get offer_details_info_duration_label;

  /// No description provided for @offer_details_info_coupon_label.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get offer_details_info_coupon_label;

  /// No description provided for @offer_details_info_terms_label.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get offer_details_info_terms_label;

  /// No description provided for @offer_details_info_terms_description.
  ///
  /// In en, this message translates to:
  /// **'This offer applies to monthly plans only and cannot be combined with other offers.'**
  String get offer_details_info_terms_description;

  /// No description provided for @offer_details_info_copy_code.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get offer_details_info_copy_code;

  /// No description provided for @offer_details_plan_section_title.
  ///
  /// In en, this message translates to:
  /// **'Choose the right plan'**
  String get offer_details_plan_section_title;

  /// No description provided for @offer_details_plan_month_title.
  ///
  /// In en, this message translates to:
  /// **'Monthly plan'**
  String get offer_details_plan_month_title;

  /// No description provided for @offer_details_plan_half_month_title.
  ///
  /// In en, this message translates to:
  /// **'Half-month plan'**
  String get offer_details_plan_half_month_title;

  /// No description provided for @offer_details_plan_week_title.
  ///
  /// In en, this message translates to:
  /// **'Weekly plan'**
  String get offer_details_plan_week_title;

  /// No description provided for @offer_details_plan_duration_month.
  ///
  /// In en, this message translates to:
  /// **'26 days'**
  String get offer_details_plan_duration_month;

  /// No description provided for @offer_details_plan_duration_half_month.
  ///
  /// In en, this message translates to:
  /// **'12 days'**
  String get offer_details_plan_duration_half_month;

  /// No description provided for @offer_details_plan_duration_week.
  ///
  /// In en, this message translates to:
  /// **'6 days'**
  String get offer_details_plan_duration_week;

  /// No description provided for @offer_details_plan_meals.
  ///
  /// In en, this message translates to:
  /// **'4 meals per day'**
  String get offer_details_plan_meals;

  /// No description provided for @offer_details_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Total after discount'**
  String get offer_details_summary_title;

  /// No description provided for @offer_details_summary_button.
  ///
  /// In en, this message translates to:
  /// **'Continue purchase'**
  String get offer_details_summary_button;

  /// No description provided for @offer_details_summary_secure_payment.
  ///
  /// In en, this message translates to:
  /// **'Secure payment'**
  String get offer_details_summary_secure_payment;

  /// No description provided for @offer_details_open_plans_button.
  ///
  /// In en, this message translates to:
  /// **'Choose plan'**
  String get offer_details_open_plans_button;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'KWD'**
  String get currency;

  /// No description provided for @payment_title.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment_title;

  /// No description provided for @payment_order_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get payment_order_summary_title;

  /// No description provided for @payment_plan_month.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get payment_plan_month;

  /// No description provided for @payment_plan_duration.
  ///
  /// In en, this message translates to:
  /// **'26 days'**
  String get payment_plan_duration;

  /// No description provided for @payment_plan_meals.
  ///
  /// In en, this message translates to:
  /// **'4 meals per day'**
  String get payment_plan_meals;

  /// No description provided for @payment_base_price_label.
  ///
  /// In en, this message translates to:
  /// **'Base price'**
  String get payment_base_price_label;

  /// No description provided for @payment_discount_label.
  ///
  /// In en, this message translates to:
  /// **'Discount (20%)'**
  String get payment_discount_label;

  /// No description provided for @payment_total_after_discount.
  ///
  /// In en, this message translates to:
  /// **'Total after discount'**
  String get payment_total_after_discount;

  /// No description provided for @payment_coupon_hint.
  ///
  /// In en, this message translates to:
  /// **'User discount code'**
  String get payment_coupon_hint;

  /// No description provided for @payment_method_section_title.
  ///
  /// In en, this message translates to:
  /// **'Choose payment method'**
  String get payment_method_section_title;

  /// No description provided for @payment_method_mada.
  ///
  /// In en, this message translates to:
  /// **'Mada Card'**
  String get payment_method_mada;

  /// No description provided for @payment_method_mada_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay using Mada cards'**
  String get payment_method_mada_subtitle;

  /// No description provided for @payment_method_visa.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get payment_method_visa;

  /// No description provided for @payment_method_visa_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard'**
  String get payment_method_visa_subtitle;

  /// No description provided for @payment_method_apple.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get payment_method_apple;

  /// No description provided for @payment_method_apple_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay using Apple Pay'**
  String get payment_method_apple_subtitle;

  /// No description provided for @payment_method_wallet.
  ///
  /// In en, this message translates to:
  /// **'MealMate Wallet'**
  String get payment_method_wallet;

  /// No description provided for @payment_method_wallet_balance.
  ///
  /// In en, this message translates to:
  /// **'Available balance:'**
  String get payment_method_wallet_balance;

  /// No description provided for @payment_card_details_title.
  ///
  /// In en, this message translates to:
  /// **'Card Details'**
  String get payment_card_details_title;

  /// No description provided for @payment_card_number_label.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get payment_card_number_label;

  /// No description provided for @payment_card_number_hint.
  ///
  /// In en, this message translates to:
  /// **'•••• •••• •••• ••••'**
  String get payment_card_number_hint;

  /// No description provided for @payment_expiry_hint.
  ///
  /// In en, this message translates to:
  /// **'MM / YY'**
  String get payment_expiry_hint;

  /// No description provided for @payment_cvv_hint.
  ///
  /// In en, this message translates to:
  /// **'•••'**
  String get payment_cvv_hint;

  /// No description provided for @payment_expiry_label.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get payment_expiry_label;

  /// No description provided for @payment_cvv_label.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get payment_cvv_label;

  /// No description provided for @payment_card_holder_hint.
  ///
  /// In en, this message translates to:
  /// **'Name as on card'**
  String get payment_card_holder_hint;

  /// No description provided for @payment_card_holder_label.
  ///
  /// In en, this message translates to:
  /// **'Card holder name'**
  String get payment_card_holder_label;

  /// No description provided for @payment_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total amount due'**
  String get payment_total_label;

  /// No description provided for @payment_total_includes_tax.
  ///
  /// In en, this message translates to:
  /// **'Includes tax'**
  String get payment_total_includes_tax;

  /// No description provided for @payment_pay_now_button.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payment_pay_now_button;

  /// No description provided for @payment_secure_label.
  ///
  /// In en, this message translates to:
  /// **'Secure payment'**
  String get payment_secure_label;

  /// No description provided for @payment_success_title.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get payment_success_title;

  /// No description provided for @payment_success_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your subscription is now active. Enjoy your healthy meals.'**
  String get payment_success_subtitle;

  /// No description provided for @payment_success_button.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get payment_success_button;

  /// No description provided for @subscription_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Plans and subscriptions'**
  String get subscription_screen_title;

  /// No description provided for @subscription_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Save more with plans'**
  String get subscription_hero_title;

  /// No description provided for @subscription_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that fits your lifestyle and enjoy healthy meals every day'**
  String get subscription_hero_subtitle;

  /// No description provided for @subscription_choose_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Choose the package that suits you'**
  String get subscription_choose_plan_title;

  /// No description provided for @subscription_choose_plan_button.
  ///
  /// In en, this message translates to:
  /// **'Choose plan'**
  String get subscription_choose_plan_button;

  /// No description provided for @subscription_individual_packages.
  ///
  /// In en, this message translates to:
  /// **'Individual packages'**
  String get subscription_individual_packages;

  /// No description provided for @subscription_family_packages.
  ///
  /// In en, this message translates to:
  /// **'Family packages'**
  String get subscription_family_packages;

  /// No description provided for @subscription_best_value.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get subscription_best_value;

  /// No description provided for @subscription_view_family_package.
  ///
  /// In en, this message translates to:
  /// **'View family package'**
  String get subscription_view_family_package;

  /// No description provided for @subscription_selected_program_label.
  ///
  /// In en, this message translates to:
  /// **'Selected program:'**
  String get subscription_selected_program_label;

  /// No description provided for @subscription_weight_loss_title.
  ///
  /// In en, this message translates to:
  /// **'Weight loss'**
  String get subscription_weight_loss_title;

  /// No description provided for @subscription_weight_loss_description.
  ///
  /// In en, this message translates to:
  /// **'A low-calorie program to help you lose weight in a healthy and safe way'**
  String get subscription_weight_loss_description;

  /// No description provided for @subscription_less_calories.
  ///
  /// In en, this message translates to:
  /// **'Less calories'**
  String get subscription_less_calories;

  /// No description provided for @subscription_effective_results.
  ///
  /// In en, this message translates to:
  /// **'Effective results'**
  String get subscription_effective_results;

  /// No description provided for @subscription_four_meals_package.
  ///
  /// In en, this message translates to:
  /// **'4 meals package'**
  String get subscription_four_meals_package;

  /// No description provided for @subscription_four_meals_details.
  ///
  /// In en, this message translates to:
  /// **'Breakfast - Lunch - Dinner - Snack'**
  String get subscription_four_meals_details;

  /// No description provided for @subscription_three_meals_package.
  ///
  /// In en, this message translates to:
  /// **'3 meals package'**
  String get subscription_three_meals_package;

  /// No description provided for @subscription_three_meals_details.
  ///
  /// In en, this message translates to:
  /// **'14 days - 3 meals daily'**
  String get subscription_three_meals_details;

  /// No description provided for @subscription_two_meals_package.
  ///
  /// In en, this message translates to:
  /// **'2 meals package'**
  String get subscription_two_meals_package;

  /// No description provided for @subscription_two_meals_details.
  ///
  /// In en, this message translates to:
  /// **'7 days - 2 meals daily'**
  String get subscription_two_meals_details;

  /// No description provided for @subscription_month_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Monthly plan'**
  String get subscription_month_plan_title;

  /// No description provided for @subscription_half_month_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Half-month plan'**
  String get subscription_half_month_plan_title;

  /// No description provided for @subscription_week_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get subscription_week_plan_title;

  /// No description provided for @subscription_week_plan_price.
  ///
  /// In en, this message translates to:
  /// **'930'**
  String get subscription_week_plan_price;

  /// No description provided for @subscription_month_duration.
  ///
  /// In en, this message translates to:
  /// **'26 days'**
  String get subscription_month_duration;

  /// No description provided for @subscription_duration_title.
  ///
  /// In en, this message translates to:
  /// **'Subscription duration'**
  String get subscription_duration_title;

  /// No description provided for @subscription_custom_duration.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get subscription_custom_duration;

  /// No description provided for @subscription_add_friday.
  ///
  /// In en, this message translates to:
  /// **'Add Friday'**
  String get subscription_add_friday;

  /// No description provided for @subscription_days_range_hint.
  ///
  /// In en, this message translates to:
  /// **'You can enter any number of days (1-30 days)'**
  String get subscription_days_range_hint;

  /// No description provided for @subscription_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get subscription_day;

  /// No description provided for @subscription_half_month_duration.
  ///
  /// In en, this message translates to:
  /// **'12 days'**
  String get subscription_half_month_duration;

  /// No description provided for @subscription_week_duration.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get subscription_week_duration;

  /// No description provided for @subscription_meals_per_day.
  ///
  /// In en, this message translates to:
  /// **'4 meals daily'**
  String get subscription_meals_per_day;

  /// No description provided for @subscription_healthy_balanced.
  ///
  /// In en, this message translates to:
  /// **'Healthy balanced meals'**
  String get subscription_healthy_balanced;

  /// No description provided for @subscription_free_delivery.
  ///
  /// In en, this message translates to:
  /// **'Free delivery'**
  String get subscription_free_delivery;

  /// No description provided for @subscription_month_period.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subscription_month_period;

  /// No description provided for @subscription_half_month_period.
  ///
  /// In en, this message translates to:
  /// **'Half month'**
  String get subscription_half_month_period;

  /// No description provided for @subscription_week_period.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get subscription_week_period;

  /// No description provided for @subscription_discount_20.
  ///
  /// In en, this message translates to:
  /// **'20% off'**
  String get subscription_discount_20;

  /// No description provided for @subscription_note.
  ///
  /// In en, this message translates to:
  /// **'All plans include 20% off all orders. You can pause or edit the plan anytime'**
  String get subscription_note;

  /// No description provided for @subscription_program_title.
  ///
  /// In en, this message translates to:
  /// **'Choose your program'**
  String get subscription_program_title;

  /// No description provided for @subscription_program_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the goal that suits you so we can show the right plans'**
  String get subscription_program_subtitle;

  /// No description provided for @subscription_type_title.
  ///
  /// In en, this message translates to:
  /// **'Choose subscription type'**
  String get subscription_type_title;

  /// No description provided for @subscription_type_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by choosing whether you want an individual subscription or a family subscription'**
  String get subscription_type_subtitle;

  /// No description provided for @subscription_type_hero_label.
  ///
  /// In en, this message translates to:
  /// **'Healthy food, better life'**
  String get subscription_type_hero_label;

  /// No description provided for @subscription_type_individual_label.
  ///
  /// In en, this message translates to:
  /// **'Individual subscription'**
  String get subscription_type_individual_label;

  /// No description provided for @subscription_type_individual_description.
  ///
  /// In en, this message translates to:
  /// **'For one person with a meal program that fits your goal'**
  String get subscription_type_individual_description;

  /// No description provided for @subscription_type_individual_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Varied restaurants'**
  String get subscription_type_individual_restaurants;

  /// No description provided for @subscription_type_individual_meal_flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexible meal count'**
  String get subscription_type_individual_meal_flexibility;

  /// No description provided for @subscription_type_individual_customization.
  ///
  /// In en, this message translates to:
  /// **'Program customization'**
  String get subscription_type_individual_customization;

  /// No description provided for @subscription_type_family_label.
  ///
  /// In en, this message translates to:
  /// **'Family subscription'**
  String get subscription_type_family_label;

  /// No description provided for @subscription_type_family_description.
  ///
  /// In en, this message translates to:
  /// **'Add family members and set a suitable program for each person'**
  String get subscription_type_family_description;

  /// No description provided for @subscription_type_family_members.
  ///
  /// In en, this message translates to:
  /// **'Up to 6 members'**
  String get subscription_type_family_members;

  /// No description provided for @subscription_type_family_customization.
  ///
  /// In en, this message translates to:
  /// **'Personalized for each person'**
  String get subscription_type_family_customization;

  /// No description provided for @subscription_type_family_management.
  ///
  /// In en, this message translates to:
  /// **'Easy family management'**
  String get subscription_type_family_management;

  /// No description provided for @subscription_type_notice_label.
  ///
  /// In en, this message translates to:
  /// **'After choosing the subscription type, you will move to the next step'**
  String get subscription_type_notice_label;

  /// No description provided for @subscription_details_view_mode.
  ///
  /// In en, this message translates to:
  /// **'View mode'**
  String get subscription_details_view_mode;

  /// No description provided for @subscription_details_explore_meals.
  ///
  /// In en, this message translates to:
  /// **'Explore plan meals'**
  String get subscription_details_explore_meals;

  /// No description provided for @subscription_details_meals_count.
  ///
  /// In en, this message translates to:
  /// **'More than 120 varied healthy meals'**
  String get subscription_details_meals_count;

  /// No description provided for @subscription_details_popular_meals.
  ///
  /// In en, this message translates to:
  /// **'Popular meals'**
  String get subscription_details_popular_meals;

  /// No description provided for @subscription_details_features_title.
  ///
  /// In en, this message translates to:
  /// **'Plan features'**
  String get subscription_details_features_title;

  /// No description provided for @subscription_details_meal_suffix.
  ///
  /// In en, this message translates to:
  /// **'meals'**
  String get subscription_details_meal_suffix;

  /// No description provided for @subscription_details_meals_in_plan.
  ///
  /// In en, this message translates to:
  /// **'meals in the plan'**
  String get subscription_details_meals_in_plan;

  /// No description provided for @subscription_details_most_selected.
  ///
  /// In en, this message translates to:
  /// **'Most selected'**
  String get subscription_details_most_selected;

  /// No description provided for @subscription_details_subscribe_now.
  ///
  /// In en, this message translates to:
  /// **'Subscribe now'**
  String get subscription_details_subscribe_now;

  /// No description provided for @subscription_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Subscription summary'**
  String get subscription_summary_title;

  /// No description provided for @subscription_summary_duration_label.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get subscription_summary_duration_label;

  /// No description provided for @subscription_summary_duration_value.
  ///
  /// In en, this message translates to:
  /// **'One month'**
  String get subscription_summary_duration_value;

  /// No description provided for @subscription_summary_package_label.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get subscription_summary_package_label;

  /// No description provided for @subscription_summary_restaurant_tier_label.
  ///
  /// In en, this message translates to:
  /// **'Restaurant tier'**
  String get subscription_summary_restaurant_tier_label;

  /// No description provided for @subscription_summary_restaurant_tier_value.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get subscription_summary_restaurant_tier_value;

  /// No description provided for @subscription_summary_includes_label.
  ///
  /// In en, this message translates to:
  /// **'Your subscription includes'**
  String get subscription_summary_includes_label;

  /// No description provided for @subscription_summary_daily_meals.
  ///
  /// In en, this message translates to:
  /// **'4 meals daily (breakfast - lunch - dinner - snack)'**
  String get subscription_summary_daily_meals;

  /// No description provided for @subscription_summary_restaurants.
  ///
  /// In en, this message translates to:
  /// **'More than 100 restaurants'**
  String get subscription_summary_restaurants;

  /// No description provided for @subscription_summary_quality.
  ///
  /// In en, this message translates to:
  /// **'High-quality ingredients'**
  String get subscription_summary_quality;

  /// No description provided for @subscription_summary_variety.
  ///
  /// In en, this message translates to:
  /// **'Daily meal variety'**
  String get subscription_summary_variety;

  /// No description provided for @subscription_summary_total_price_label.
  ///
  /// In en, this message translates to:
  /// **'Total price'**
  String get subscription_summary_total_price_label;

  /// No description provided for @family_details_title.
  ///
  /// In en, this message translates to:
  /// **'Family plan details'**
  String get family_details_title;

  /// No description provided for @family_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Family plan'**
  String get family_plan_title;

  /// No description provided for @family_plan_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete plan for up to 6 members'**
  String get family_plan_subtitle;

  /// No description provided for @family_plan_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get family_plan_new;

  /// No description provided for @family_plan_feature_group_delivery.
  ///
  /// In en, this message translates to:
  /// **'Group delivery'**
  String get family_plan_feature_group_delivery;

  /// No description provided for @family_plan_feature_one_invoice.
  ///
  /// In en, this message translates to:
  /// **'One invoice'**
  String get family_plan_feature_one_invoice;

  /// No description provided for @family_plan_feature_group_discount.
  ///
  /// In en, this message translates to:
  /// **'Group discount'**
  String get family_plan_feature_group_discount;

  /// No description provided for @family_plan_feature_all_meals.
  ///
  /// In en, this message translates to:
  /// **'Meals for everyone'**
  String get family_plan_feature_all_meals;

  /// No description provided for @family_plan_feature_individual_plan.
  ///
  /// In en, this message translates to:
  /// **'Plan for each member'**
  String get family_plan_feature_individual_plan;

  /// No description provided for @family_add_member.
  ///
  /// In en, this message translates to:
  /// **'Add new member'**
  String get family_add_member;

  /// No description provided for @family_add_member_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize a nutrition plan for each family member'**
  String get family_add_member_subtitle;

  /// No description provided for @family_owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get family_owner;

  /// No description provided for @family_member_ahmed.
  ///
  /// In en, this message translates to:
  /// **'Ahmed'**
  String get family_member_ahmed;

  /// No description provided for @family_member_sarah.
  ///
  /// In en, this message translates to:
  /// **'Sarah'**
  String get family_member_sarah;

  /// No description provided for @family_member_yousef.
  ///
  /// In en, this message translates to:
  /// **'Yousef'**
  String get family_member_yousef;

  /// No description provided for @family_member_mariam.
  ///
  /// In en, this message translates to:
  /// **'Mariam'**
  String get family_member_mariam;

  /// No description provided for @family_member_laila.
  ///
  /// In en, this message translates to:
  /// **'Laila'**
  String get family_member_laila;

  /// No description provided for @family_member_omar.
  ///
  /// In en, this message translates to:
  /// **'Omar'**
  String get family_member_omar;

  /// No description provided for @family_member_hana.
  ///
  /// In en, this message translates to:
  /// **'Hana'**
  String get family_member_hana;

  /// No description provided for @family_member_khaled.
  ///
  /// In en, this message translates to:
  /// **'Khaled'**
  String get family_member_khaled;

  /// No description provided for @family_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Family plan summary'**
  String get family_summary_title;

  /// No description provided for @family_current_members.
  ///
  /// In en, this message translates to:
  /// **'Current members'**
  String get family_current_members;

  /// No description provided for @family_max_members.
  ///
  /// In en, this message translates to:
  /// **'Plan member limit'**
  String get family_max_members;

  /// No description provided for @family_total_daily_meals.
  ///
  /// In en, this message translates to:
  /// **'Total daily meals'**
  String get family_total_daily_meals;

  /// No description provided for @family_total_daily_calories.
  ///
  /// In en, this message translates to:
  /// **'Total daily calories'**
  String get family_total_daily_calories;

  /// No description provided for @family_one_delivery.
  ///
  /// In en, this message translates to:
  /// **'One delivery for the family'**
  String get family_one_delivery;

  /// No description provided for @family_group_delivery.
  ///
  /// In en, this message translates to:
  /// **'Group delivery'**
  String get family_group_delivery;

  /// No description provided for @family_meals_each_member.
  ///
  /// In en, this message translates to:
  /// **'Meals for each member'**
  String get family_meals_each_member;

  /// No description provided for @family_table_member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get family_table_member;

  /// No description provided for @family_table_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get family_table_breakfast;

  /// No description provided for @family_table_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get family_table_lunch;

  /// No description provided for @family_table_snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get family_table_snack;

  /// No description provided for @family_table_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get family_table_dinner;

  /// No description provided for @family_table_meals_count.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get family_table_meals_count;

  /// No description provided for @family_meals_3.
  ///
  /// In en, this message translates to:
  /// **'3 meals'**
  String get family_meals_3;

  /// No description provided for @family_meals_4.
  ///
  /// In en, this message translates to:
  /// **'4 meals'**
  String get family_meals_4;

  /// No description provided for @family_meals_5.
  ///
  /// In en, this message translates to:
  /// **'5 meals'**
  String get family_meals_5;

  /// No description provided for @family_price_details.
  ///
  /// In en, this message translates to:
  /// **'Price details'**
  String get family_price_details;

  /// No description provided for @family_base_price_two_members.
  ///
  /// In en, this message translates to:
  /// **'Base price (for 2 members)'**
  String get family_base_price_two_members;

  /// No description provided for @family_extra_members_price.
  ///
  /// In en, this message translates to:
  /// **'Extra members (2 x 7.500 KWD)'**
  String get family_extra_members_price;

  /// No description provided for @family_total.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get family_total;

  /// No description provided for @family_confirm_plan.
  ///
  /// In en, this message translates to:
  /// **'Confirm plan'**
  String get family_confirm_plan;

  /// No description provided for @family_add_member_dialog_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter member details to add them to the family plan'**
  String get family_add_member_dialog_subtitle;

  /// No description provided for @family_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get family_full_name;

  /// No description provided for @family_full_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Write the name here'**
  String get family_full_name_hint;

  /// No description provided for @family_relation.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get family_relation;

  /// No description provided for @family_relation_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose relationship'**
  String get family_relation_hint;

  /// No description provided for @family_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get family_age;

  /// No description provided for @family_age_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter age'**
  String get family_age_hint;

  /// No description provided for @family_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get family_year;

  /// No description provided for @family_nutrition_goal.
  ///
  /// In en, this message translates to:
  /// **'Nutrition goal'**
  String get family_nutrition_goal;

  /// No description provided for @family_nutrition_goal_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose goal'**
  String get family_nutrition_goal_hint;

  /// No description provided for @family_activity_level.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get family_activity_level;

  /// No description provided for @family_activity_low.
  ///
  /// In en, this message translates to:
  /// **'Low activity'**
  String get family_activity_low;

  /// No description provided for @family_activity_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get family_activity_medium;

  /// No description provided for @family_activity_high.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get family_activity_high;

  /// No description provided for @family_daily_meals_count.
  ///
  /// In en, this message translates to:
  /// **'Daily meals count'**
  String get family_daily_meals_count;

  /// No description provided for @family_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get family_info;

  /// No description provided for @family_info_message.
  ///
  /// In en, this message translates to:
  /// **'You can edit the data anytime from member settings'**
  String get family_info_message;

  /// No description provided for @family_add_member_button.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get family_add_member_button;

  /// No description provided for @family_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get family_cancel;

  /// No description provided for @family_setup_title.
  ///
  /// In en, this message translates to:
  /// **'Family subscription setup'**
  String get family_setup_title;

  /// No description provided for @family_setup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize the perfect plan for each family member'**
  String get family_setup_subtitle;

  /// No description provided for @family_name.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get family_name;

  /// No description provided for @family_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Write the family name here'**
  String get family_name_hint;

  /// No description provided for @family_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get family_location;

  /// No description provided for @family_location_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose member location'**
  String get family_location_hint;

  /// No description provided for @family_member_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get family_member_completed;

  /// No description provided for @family_next_program.
  ///
  /// In en, this message translates to:
  /// **'Next: program'**
  String get family_next_program;

  /// No description provided for @family_header_badge.
  ///
  /// In en, this message translates to:
  /// **'Ahmed family'**
  String get family_header_badge;

  /// No description provided for @family_setup_step_one.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get family_setup_step_one;

  /// No description provided for @family_setup_step_two.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get family_setup_step_two;

  /// No description provided for @family_setup_step_three.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get family_setup_step_three;

  /// No description provided for @family_step_create_family.
  ///
  /// In en, this message translates to:
  /// **'Create family'**
  String get family_step_create_family;

  /// No description provided for @family_step_program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get family_step_program;

  /// No description provided for @family_step_package_days.
  ///
  /// In en, this message translates to:
  /// **'Package and days'**
  String get family_step_package_days;

  /// No description provided for @family_step_payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get family_step_payment;

  /// No description provided for @family_member_not_started.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get family_member_not_started;

  /// No description provided for @family_member_in_progress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get family_member_in_progress;

  /// No description provided for @family_selected_member_age.
  ///
  /// In en, this message translates to:
  /// **'24 years'**
  String get family_selected_member_age;

  /// No description provided for @family_selected_member_gender.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get family_selected_member_gender;

  /// No description provided for @family_selected_member_goal_label.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get family_selected_member_goal_label;

  /// No description provided for @family_program_choose_title.
  ///
  /// In en, this message translates to:
  /// **'Choose the right program'**
  String get family_program_choose_title;

  /// No description provided for @family_program_balanced_title.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get family_program_balanced_title;

  /// No description provided for @family_program_balanced_description.
  ///
  /// In en, this message translates to:
  /// **'A balanced diet for better food and health'**
  String get family_program_balanced_description;

  /// No description provided for @family_program_weight_loss_title.
  ///
  /// In en, this message translates to:
  /// **'Weight loss'**
  String get family_program_weight_loss_title;

  /// No description provided for @family_program_weight_loss_description.
  ///
  /// In en, this message translates to:
  /// **'Lower calories to support weight loss'**
  String get family_program_weight_loss_description;

  /// No description provided for @family_program_muscle_title.
  ///
  /// In en, this message translates to:
  /// **'Muscle gain'**
  String get family_program_muscle_title;

  /// No description provided for @family_program_muscle_description.
  ///
  /// In en, this message translates to:
  /// **'Protein-rich to support muscle building'**
  String get family_program_muscle_description;

  /// No description provided for @family_program_keto_title.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get family_program_keto_title;

  /// No description provided for @family_program_keto_description.
  ///
  /// In en, this message translates to:
  /// **'Low carbs and high fat'**
  String get family_program_keto_description;

  /// No description provided for @family_next_package_days.
  ///
  /// In en, this message translates to:
  /// **'Next: package and days'**
  String get family_next_package_days;

  /// No description provided for @family_previous_program.
  ///
  /// In en, this message translates to:
  /// **'Previous: program'**
  String get family_previous_program;

  /// No description provided for @family_package_choose_title.
  ///
  /// In en, this message translates to:
  /// **'2. Choose package and days'**
  String get family_package_choose_title;

  /// No description provided for @family_package_choose_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the suitable package'**
  String get family_package_choose_subtitle;

  /// No description provided for @family_package_three_meals_title.
  ///
  /// In en, this message translates to:
  /// **'3 meals daily'**
  String get family_package_three_meals_title;

  /// No description provided for @family_package_three_meals_description.
  ///
  /// In en, this message translates to:
  /// **'Includes breakfast, lunch and dinner'**
  String get family_package_three_meals_description;

  /// No description provided for @family_package_two_meals_title.
  ///
  /// In en, this message translates to:
  /// **'2 meals daily'**
  String get family_package_two_meals_title;

  /// No description provided for @family_package_two_meals_description.
  ///
  /// In en, this message translates to:
  /// **'Includes lunch and dinner'**
  String get family_package_two_meals_description;

  /// No description provided for @family_days_choose_title.
  ///
  /// In en, this message translates to:
  /// **'Choose number of days in the week'**
  String get family_days_choose_title;

  /// No description provided for @family_days_7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get family_days_7;

  /// No description provided for @family_days_14.
  ///
  /// In en, this message translates to:
  /// **'14 days'**
  String get family_days_14;

  /// No description provided for @family_days_30.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get family_days_30;

  /// No description provided for @family_friday_delivery_title.
  ///
  /// In en, this message translates to:
  /// **'Add Friday'**
  String get family_friday_delivery_title;

  /// No description provided for @family_friday_delivery_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add Friday delivery for this member'**
  String get family_friday_delivery_subtitle;

  /// No description provided for @family_friday_delivery_added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get family_friday_delivery_added;

  /// No description provided for @family_weekly_price.
  ///
  /// In en, this message translates to:
  /// **'Weekly price'**
  String get family_weekly_price;

  /// No description provided for @family_weekly_price_value.
  ///
  /// In en, this message translates to:
  /// **'245 KWD'**
  String get family_weekly_price_value;

  /// No description provided for @family_monthly_price.
  ///
  /// In en, this message translates to:
  /// **'Monthly price'**
  String get family_monthly_price;

  /// No description provided for @family_monthly_price_value.
  ///
  /// In en, this message translates to:
  /// **'980 KWD'**
  String get family_monthly_price_value;

  /// No description provided for @family_member_selection_summary.
  ///
  /// In en, this message translates to:
  /// **'Ahmed selection summary'**
  String get family_member_selection_summary;

  /// No description provided for @family_payment_note.
  ///
  /// In en, this message translates to:
  /// **'After payment, each member can choose their favorite restaurants and meals from the restaurants available in each city'**
  String get family_payment_note;

  /// No description provided for @family_payment_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'3. Payment and subscription confirmation'**
  String get family_payment_confirm_title;

  /// No description provided for @family_subscription_summary.
  ///
  /// In en, this message translates to:
  /// **'Subscription summary'**
  String get family_subscription_summary;

  /// No description provided for @family_primary_member.
  ///
  /// In en, this message translates to:
  /// **'Primary member'**
  String get family_primary_member;

  /// No description provided for @family_subscription_program_label.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get family_subscription_program_label;

  /// No description provided for @family_subscription_package_label.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get family_subscription_package_label;

  /// No description provided for @family_subscription_days_label.
  ///
  /// In en, this message translates to:
  /// **'Number of days'**
  String get family_subscription_days_label;

  /// No description provided for @family_subscription_program_value.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get family_subscription_program_value;

  /// No description provided for @family_subscription_package_value.
  ///
  /// In en, this message translates to:
  /// **'4 meals + snack'**
  String get family_subscription_package_value;

  /// No description provided for @family_subscription_days_value.
  ///
  /// In en, this message translates to:
  /// **'7 days a week'**
  String get family_subscription_days_value;

  /// No description provided for @family_price_duration_total.
  ///
  /// In en, this message translates to:
  /// **'Total duration'**
  String get family_price_duration_total;

  /// No description provided for @family_price_discount.
  ///
  /// In en, this message translates to:
  /// **'Family discount (10%)'**
  String get family_price_discount;

  /// No description provided for @family_price_tax_total.
  ///
  /// In en, this message translates to:
  /// **'Total including tax (15%)'**
  String get family_price_tax_total;

  /// No description provided for @family_monthly_total_label.
  ///
  /// In en, this message translates to:
  /// **'Monthly total (4 weeks)'**
  String get family_monthly_total_label;

  /// No description provided for @family_payment_method_title.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get family_payment_method_title;

  /// No description provided for @family_payment_card_label.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get family_payment_card_label;

  /// No description provided for @family_payment_apple_pay_label.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get family_payment_apple_pay_label;

  /// No description provided for @family_payment_mada_label.
  ///
  /// In en, this message translates to:
  /// **'Mada'**
  String get family_payment_mada_label;

  /// No description provided for @family_overview_title.
  ///
  /// In en, this message translates to:
  /// **'Family overview'**
  String get family_overview_title;

  /// No description provided for @family_confirm_payment.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment'**
  String get family_confirm_payment;

  /// No description provided for @family_next_payment.
  ///
  /// In en, this message translates to:
  /// **'Next: payment'**
  String get family_next_payment;

  /// No description provided for @calendar_title.
  ///
  /// In en, this message translates to:
  /// **'Meal calendar'**
  String get calendar_title;

  /// No description provided for @calendar_month_progress.
  ///
  /// In en, this message translates to:
  /// **'Monthly progress'**
  String get calendar_month_progress;

  /// No description provided for @calendar_month_progress_value.
  ///
  /// In en, this message translates to:
  /// **'Completed 30 meals out of 30'**
  String get calendar_month_progress_value;

  /// No description provided for @calendar_commitment.
  ///
  /// In en, this message translates to:
  /// **'Great commitment 👏'**
  String get calendar_commitment;

  /// No description provided for @calendar_change_meal.
  ///
  /// In en, this message translates to:
  /// **'Change meal'**
  String get calendar_change_meal;

  /// No description provided for @calendar_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause temporarily'**
  String get calendar_pause;

  /// No description provided for @calendar_add_meal.
  ///
  /// In en, this message translates to:
  /// **'Add meal'**
  String get calendar_add_meal;

  /// No description provided for @calendar_reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule meal'**
  String get calendar_reschedule;

  /// No description provided for @calendar_full_plan.
  ///
  /// In en, this message translates to:
  /// **'Full plan'**
  String get calendar_full_plan;

  /// No description provided for @calendar_week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get calendar_week;

  /// No description provided for @calendar_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendar_today;

  /// No description provided for @calendar_day_plan.
  ///
  /// In en, this message translates to:
  /// **'Plan for September 25'**
  String get calendar_day_plan;

  /// No description provided for @calendar_day_plan_date.
  ///
  /// In en, this message translates to:
  /// **'Plan for {date}'**
  String calendar_day_plan_date(String date);

  /// No description provided for @calendar_scheduled_count.
  ///
  /// In en, this message translates to:
  /// **'4 meals scheduled for today'**
  String get calendar_scheduled_count;

  /// No description provided for @calendar_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get calendar_completed;

  /// No description provided for @calendar_current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get calendar_current;

  /// No description provided for @calendar_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get calendar_upcoming;

  /// No description provided for @calendar_breakfast_time.
  ///
  /// In en, this message translates to:
  /// **'Breakfast • 07:30 AM'**
  String get calendar_breakfast_time;

  /// No description provided for @calendar_breakfast_meal.
  ///
  /// In en, this message translates to:
  /// **'Oatmeal with fruit and honey'**
  String get calendar_breakfast_meal;

  /// No description provided for @calendar_breakfast_calories.
  ///
  /// In en, this message translates to:
  /// **'450 calories'**
  String get calendar_breakfast_calories;

  /// No description provided for @calendar_lunch_time.
  ///
  /// In en, this message translates to:
  /// **'Lunch • 01:00 PM'**
  String get calendar_lunch_time;

  /// No description provided for @calendar_lunch_meal.
  ///
  /// In en, this message translates to:
  /// **'Grilled chicken with brown rice'**
  String get calendar_lunch_meal;

  /// No description provided for @calendar_lunch_calories.
  ///
  /// In en, this message translates to:
  /// **'550 calories'**
  String get calendar_lunch_calories;

  /// No description provided for @calendar_lunch_protein.
  ///
  /// In en, this message translates to:
  /// **'32g protein'**
  String get calendar_lunch_protein;

  /// No description provided for @calendar_dinner_time.
  ///
  /// In en, this message translates to:
  /// **'Dinner • 07:00 PM'**
  String get calendar_dinner_time;

  /// No description provided for @calendar_dinner_meal.
  ///
  /// In en, this message translates to:
  /// **'Healthy chicken sandwich'**
  String get calendar_dinner_meal;

  /// No description provided for @calendar_dinner_calories.
  ///
  /// In en, this message translates to:
  /// **'420 calories'**
  String get calendar_dinner_calories;

  /// No description provided for @calendar_snack_time.
  ///
  /// In en, this message translates to:
  /// **'Snack • 09:00 PM'**
  String get calendar_snack_time;

  /// No description provided for @calendar_snack_meal.
  ///
  /// In en, this message translates to:
  /// **'Fresh fruit snack'**
  String get calendar_snack_meal;

  /// No description provided for @calendar_snack_calories.
  ///
  /// In en, this message translates to:
  /// **'180 calories'**
  String get calendar_snack_calories;

  /// No description provided for @calendar_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get calendar_friday;

  /// No description provided for @calendar_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get calendar_saturday;

  /// No description provided for @calendar_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get calendar_sunday;

  /// No description provided for @calendar_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get calendar_monday;

  /// No description provided for @calendar_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get calendar_tuesday;

  /// No description provided for @calendar_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get calendar_wednesday;

  /// No description provided for @calendar_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get calendar_thursday;

  /// No description provided for @calendar_weekday_sat_short.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get calendar_weekday_sat_short;

  /// No description provided for @calendar_weekday_sun_short.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get calendar_weekday_sun_short;

  /// No description provided for @calendar_weekday_mon_short.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get calendar_weekday_mon_short;

  /// No description provided for @calendar_weekday_tue_short.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get calendar_weekday_tue_short;

  /// No description provided for @calendar_weekday_wed_short.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get calendar_weekday_wed_short;

  /// No description provided for @calendar_weekday_thu_short.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get calendar_weekday_thu_short;

  /// No description provided for @calendar_weekday_fri_short.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get calendar_weekday_fri_short;

  /// No description provided for @calendar_ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get calendar_ingredients;

  /// No description provided for @calendar_calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calendar_calories;

  /// No description provided for @calendar_protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get calendar_protein;

  /// No description provided for @calendar_carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get calendar_carbs;

  /// No description provided for @calendar_fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get calendar_fat;

  /// No description provided for @calendar_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get calendar_breakfast;

  /// No description provided for @calendar_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get calendar_lunch;

  /// No description provided for @calendar_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get calendar_dinner;

  /// No description provided for @calendar_meals_for.
  ///
  /// In en, this message translates to:
  /// **'{mealType} meals'**
  String calendar_meals_for(String mealType);

  /// No description provided for @calendar_restaurant_name.
  ///
  /// In en, this message translates to:
  /// **'Restaurant name'**
  String get calendar_restaurant_name;

  /// No description provided for @calendar_restaurant_description.
  ///
  /// In en, this message translates to:
  /// **'We serve high-quality healthy meals using fresh, natural ingredients\nto help you achieve your nutrition and fitness goals.'**
  String get calendar_restaurant_description;

  /// No description provided for @calendar_ingredient_origin_title.
  ///
  /// In en, this message translates to:
  /// **'Origin country for main ingredients'**
  String get calendar_ingredient_origin_title;

  /// No description provided for @calendar_meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get calendar_meat;

  /// No description provided for @calendar_poultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get calendar_poultry;

  /// No description provided for @calendar_fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get calendar_fish;

  /// No description provided for @calendar_oils.
  ///
  /// In en, this message translates to:
  /// **'Oils'**
  String get calendar_oils;

  /// No description provided for @calendar_imported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get calendar_imported;

  /// No description provided for @calendar_fresh_local.
  ///
  /// In en, this message translates to:
  /// **'Fresh local'**
  String get calendar_fresh_local;

  /// No description provided for @calendar_australia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get calendar_australia;

  /// No description provided for @calendar_local.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get calendar_local;

  /// No description provided for @calendar_norway.
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get calendar_norway;

  /// No description provided for @calendar_spain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get calendar_spain;

  /// No description provided for @calendar_meal_name.
  ///
  /// In en, this message translates to:
  /// **'Meal name'**
  String get calendar_meal_name;

  /// No description provided for @calendar_meal_overnight_oats.
  ///
  /// In en, this message translates to:
  /// **'Overnight oats with berries'**
  String get calendar_meal_overnight_oats;

  /// No description provided for @calendar_meal_egg_avocado_toast.
  ///
  /// In en, this message translates to:
  /// **'Egg and avocado toast'**
  String get calendar_meal_egg_avocado_toast;

  /// No description provided for @calendar_meal_greek_yogurt_parfait.
  ///
  /// In en, this message translates to:
  /// **'Greek yogurt parfait'**
  String get calendar_meal_greek_yogurt_parfait;

  /// No description provided for @calendar_meal_turkey_cheese_wrap.
  ///
  /// In en, this message translates to:
  /// **'Turkey cheese breakfast wrap'**
  String get calendar_meal_turkey_cheese_wrap;

  /// No description provided for @calendar_meal_banana_protein_pancakes.
  ///
  /// In en, this message translates to:
  /// **'Banana protein pancakes'**
  String get calendar_meal_banana_protein_pancakes;

  /// No description provided for @calendar_meal_smoked_salmon_bagel.
  ///
  /// In en, this message translates to:
  /// **'Smoked salmon bagel'**
  String get calendar_meal_smoked_salmon_bagel;

  /// No description provided for @calendar_meal_grilled_chicken_bowl.
  ///
  /// In en, this message translates to:
  /// **'Grilled chicken quinoa bowl'**
  String get calendar_meal_grilled_chicken_bowl;

  /// No description provided for @calendar_meal_salmon_rice_plate.
  ///
  /// In en, this message translates to:
  /// **'Salmon rice plate'**
  String get calendar_meal_salmon_rice_plate;

  /// No description provided for @calendar_meal_beef_vegetable_box.
  ///
  /// In en, this message translates to:
  /// **'Beef and vegetable box'**
  String get calendar_meal_beef_vegetable_box;

  /// No description provided for @calendar_meal_shrimp_noodle_bowl.
  ///
  /// In en, this message translates to:
  /// **'Shrimp noodle bowl'**
  String get calendar_meal_shrimp_noodle_bowl;

  /// No description provided for @calendar_meal_chicken_caesar_wrap.
  ///
  /// In en, this message translates to:
  /// **'Chicken Caesar wrap'**
  String get calendar_meal_chicken_caesar_wrap;

  /// No description provided for @calendar_meal_veggie_pasta_box.
  ///
  /// In en, this message translates to:
  /// **'Vegetable pasta box'**
  String get calendar_meal_veggie_pasta_box;

  /// No description provided for @calendar_meal_lemon_chicken_salad.
  ///
  /// In en, this message translates to:
  /// **'Lemon chicken salad'**
  String get calendar_meal_lemon_chicken_salad;

  /// No description provided for @calendar_meal_tuna_potato_plate.
  ///
  /// In en, this message translates to:
  /// **'Tuna potato plate'**
  String get calendar_meal_tuna_potato_plate;

  /// No description provided for @calendar_meal_steak_mushroom_plate.
  ///
  /// In en, this message translates to:
  /// **'Steak mushroom plate'**
  String get calendar_meal_steak_mushroom_plate;

  /// No description provided for @calendar_meal_chicken_soup_box.
  ///
  /// In en, this message translates to:
  /// **'Chicken soup box'**
  String get calendar_meal_chicken_soup_box;

  /// No description provided for @calendar_meal_halloumi_salad.
  ///
  /// In en, this message translates to:
  /// **'Halloumi salad'**
  String get calendar_meal_halloumi_salad;

  /// No description provided for @calendar_meal_light_fajita_bowl.
  ///
  /// In en, this message translates to:
  /// **'Light fajita bowl'**
  String get calendar_meal_light_fajita_bowl;

  /// No description provided for @calendar_grilled_chicken.
  ///
  /// In en, this message translates to:
  /// **'Grilled chicken'**
  String get calendar_grilled_chicken;

  /// No description provided for @calendar_brown_rice.
  ///
  /// In en, this message translates to:
  /// **'Brown rice'**
  String get calendar_brown_rice;

  /// No description provided for @calendar_broccoli.
  ///
  /// In en, this message translates to:
  /// **'Broccoli'**
  String get calendar_broccoli;

  /// No description provided for @calendar_carrot.
  ///
  /// In en, this message translates to:
  /// **'Carrot'**
  String get calendar_carrot;

  /// No description provided for @calendar_more.
  ///
  /// In en, this message translates to:
  /// **'More ..'**
  String get calendar_more;

  /// No description provided for @calendar_browse_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Browse restaurants'**
  String get calendar_browse_restaurants;

  /// No description provided for @calendar_choose_restaurant_for_day.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred restaurant for '**
  String get calendar_choose_restaurant_for_day;

  /// No description provided for @calendar_restaurant_picker_date.
  ///
  /// In en, this message translates to:
  /// **'Saturday, September 20'**
  String get calendar_restaurant_picker_date;

  /// No description provided for @calendar_search_restaurant_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for a restaurant or cuisine...'**
  String get calendar_search_restaurant_hint;

  /// No description provided for @calendar_meal_suffix.
  ///
  /// In en, this message translates to:
  /// **' meal'**
  String get calendar_meal_suffix;

  /// No description provided for @calendar_change_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Change restaurant'**
  String get calendar_change_restaurant;

  /// No description provided for @calendar_pick_restaurant_first.
  ///
  /// In en, this message translates to:
  /// **'Choose '**
  String get calendar_pick_restaurant_first;

  /// No description provided for @calendar_pick_restaurant_second.
  ///
  /// In en, this message translates to:
  /// **'restaurant'**
  String get calendar_pick_restaurant_second;

  /// No description provided for @meal_details_optional_notes_title.
  ///
  /// In en, this message translates to:
  /// **'Optional notes'**
  String get meal_details_optional_notes_title;

  /// No description provided for @meal_details_optional_notes_hint.
  ///
  /// In en, this message translates to:
  /// **'Example: no onion, no garlic, extra vegetables...'**
  String get meal_details_optional_notes_hint;

  /// No description provided for @meal_details_select_meal_button.
  ///
  /// In en, this message translates to:
  /// **'Select this meal'**
  String get meal_details_select_meal_button;

  /// No description provided for @meal_details_select_meal_hint.
  ///
  /// In en, this message translates to:
  /// **'This meal will be fixed for the selected day'**
  String get meal_details_select_meal_hint;

  /// No description provided for @profile_settings_title.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get profile_settings_title;

  /// No description provided for @profile_settings_application_section.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get profile_settings_application_section;

  /// No description provided for @profile_settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_settings_notifications;

  /// No description provided for @profile_settings_notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences and alerts'**
  String get profile_settings_notifications_subtitle;

  /// No description provided for @profile_settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_settings_language;

  /// No description provided for @profile_settings_language_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred app language'**
  String get profile_settings_language_subtitle;

  /// No description provided for @profile_settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profile_settings_appearance;

  /// No description provided for @profile_settings_appearance_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the display mode that suits you'**
  String get profile_settings_appearance_subtitle;

  /// No description provided for @profile_settings_support_section.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profile_settings_support_section;

  /// No description provided for @profile_settings_help_center.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get profile_settings_help_center;

  /// No description provided for @profile_settings_help_center_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Find answers to frequently asked questions'**
  String get profile_settings_help_center_subtitle;

  /// No description provided for @profile_settings_contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get profile_settings_contact_us;

  /// No description provided for @profile_settings_contact_us_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Message the MealMate support team'**
  String get profile_settings_contact_us_subtitle;

  /// No description provided for @profile_settings_complaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get profile_settings_complaints;

  /// No description provided for @profile_settings_complaints_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Submit a complaint and we will review it soon'**
  String get profile_settings_complaints_subtitle;

  /// No description provided for @profile_settings_information_section.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get profile_settings_information_section;

  /// No description provided for @profile_settings_about.
  ///
  /// In en, this message translates to:
  /// **'About MealMate'**
  String get profile_settings_about;

  /// No description provided for @profile_settings_about_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn about our vision and mission'**
  String get profile_settings_about_subtitle;

  /// No description provided for @profile_settings_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get profile_settings_privacy_policy;

  /// No description provided for @profile_settings_privacy_policy_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn how we protect your data'**
  String get profile_settings_privacy_policy_subtitle;

  /// No description provided for @profile_settings_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get profile_settings_terms;

  /// No description provided for @profile_settings_terms_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions for using the app'**
  String get profile_settings_terms_subtitle;

  /// No description provided for @profile_settings_version.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get profile_settings_version;

  /// No description provided for @profile_settings_version_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You are using the latest version'**
  String get profile_settings_version_subtitle;

  /// No description provided for @profile_settings_version_label.
  ///
  /// In en, this message translates to:
  /// **'Version 2.4.0'**
  String get profile_settings_version_label;

  /// No description provided for @health_goals_title.
  ///
  /// In en, this message translates to:
  /// **'My health goals'**
  String get health_goals_title;

  /// No description provided for @health_goals_current_goal.
  ///
  /// In en, this message translates to:
  /// **'Your current goal'**
  String get health_goals_current_goal;

  /// No description provided for @health_goals_weight_loss.
  ///
  /// In en, this message translates to:
  /// **'Weight loss'**
  String get health_goals_weight_loss;

  /// No description provided for @health_goals_current_weight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get health_goals_current_weight;

  /// No description provided for @health_goals_target_weight.
  ///
  /// In en, this message translates to:
  /// **'Target weight'**
  String get health_goals_target_weight;

  /// No description provided for @health_goals_progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get health_goals_progress;

  /// No description provided for @health_goals_body_data.
  ///
  /// In en, this message translates to:
  /// **'Body data'**
  String get health_goals_body_data;

  /// No description provided for @health_goals_height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get health_goals_height;

  /// No description provided for @health_goals_activity_level.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get health_goals_activity_level;

  /// No description provided for @health_goals_activity_low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get health_goals_activity_low;

  /// No description provided for @health_goals_activity_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get health_goals_activity_medium;

  /// No description provided for @health_goals_activity_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get health_goals_activity_active;

  /// No description provided for @health_goals_activity_high.
  ///
  /// In en, this message translates to:
  /// **'High activity'**
  String get health_goals_activity_high;

  /// No description provided for @health_goals_weekly_summary.
  ///
  /// In en, this message translates to:
  /// **'This week\'s summary'**
  String get health_goals_weekly_summary;

  /// No description provided for @health_goals_decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get health_goals_decrease;

  /// No description provided for @health_goals_since_plan_start.
  ///
  /// In en, this message translates to:
  /// **'Since your plan started'**
  String get health_goals_since_plan_start;

  /// No description provided for @health_goals_days.
  ///
  /// In en, this message translates to:
  /// **'45 days'**
  String get health_goals_days;

  /// No description provided for @health_goals_continuous.
  ///
  /// In en, this message translates to:
  /// **'Continuous'**
  String get health_goals_continuous;

  /// No description provided for @health_goals_keep_progress.
  ///
  /// In en, this message translates to:
  /// **'Keep up the great progress'**
  String get health_goals_keep_progress;

  /// No description provided for @health_goals_save.
  ///
  /// In en, this message translates to:
  /// **'Save goals'**
  String get health_goals_save;

  /// No description provided for @health_goals_weight_value.
  ///
  /// In en, this message translates to:
  /// **'78 kg'**
  String get health_goals_weight_value;

  /// No description provided for @health_goals_target_weight_value.
  ///
  /// In en, this message translates to:
  /// **'72 kg'**
  String get health_goals_target_weight_value;

  /// No description provided for @health_goals_height_value.
  ///
  /// In en, this message translates to:
  /// **'175 cm'**
  String get health_goals_height_value;

  /// No description provided for @health_goals_progress_value.
  ///
  /// In en, this message translates to:
  /// **'60%'**
  String get health_goals_progress_value;

  /// No description provided for @health_goals_decrease_value.
  ///
  /// In en, this message translates to:
  /// **'4.2 kg'**
  String get health_goals_decrease_value;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for a meal, restaurant, or healthy plan'**
  String get search_hint;

  /// No description provided for @search_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get search_cancel;

  /// No description provided for @search_recent.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get search_recent;

  /// No description provided for @search_popular.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get search_popular;

  /// No description provided for @search_categories.
  ///
  /// In en, this message translates to:
  /// **'Browse by category'**
  String get search_categories;

  /// No description provided for @search_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get search_recommended;

  /// No description provided for @search_quick_results.
  ///
  /// In en, this message translates to:
  /// **'Quick results'**
  String get search_quick_results;

  /// No description provided for @search_suggestions_all.
  ///
  /// In en, this message translates to:
  /// **'View all suggestions'**
  String get search_suggestions_all;

  /// No description provided for @search_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get search_filter_all;

  /// No description provided for @search_filter_meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get search_filter_meals;

  /// No description provided for @search_filter_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get search_filter_restaurants;

  /// No description provided for @search_filter_plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get search_filter_plans;

  /// No description provided for @search_filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filter results'**
  String get search_filter_title;

  /// No description provided for @search_filter_programs.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get search_filter_programs;

  /// No description provided for @search_filter_weight_gain.
  ///
  /// In en, this message translates to:
  /// **'Weight gain'**
  String get search_filter_weight_gain;

  /// No description provided for @search_filter_muscle_gain.
  ///
  /// In en, this message translates to:
  /// **'Muscle gain'**
  String get search_filter_muscle_gain;

  /// No description provided for @search_filter_allergy_suitable.
  ///
  /// In en, this message translates to:
  /// **'Allergy friendly'**
  String get search_filter_allergy_suitable;

  /// No description provided for @search_filter_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply filter'**
  String get search_filter_apply;

  /// No description provided for @search_filter_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get search_filter_reset;

  /// No description provided for @search_filter_calories_unit.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get search_filter_calories_unit;

  /// No description provided for @search_filter_grams_unit.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get search_filter_grams_unit;

  /// No description provided for @search_recent_grilled_chicken.
  ///
  /// In en, this message translates to:
  /// **'Grilled chicken'**
  String get search_recent_grilled_chicken;

  /// No description provided for @search_recent_healthy_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Healthy chicken restaurants'**
  String get search_recent_healthy_restaurants;

  /// No description provided for @search_recent_high_protein.
  ///
  /// In en, this message translates to:
  /// **'High-protein meals'**
  String get search_recent_high_protein;

  /// No description provided for @search_category_salad.
  ///
  /// In en, this message translates to:
  /// **'Healthy salads'**
  String get search_category_salad;

  /// No description provided for @search_category_protein.
  ///
  /// In en, this message translates to:
  /// **'Protein meals'**
  String get search_category_protein;

  /// No description provided for @search_category_juice.
  ///
  /// In en, this message translates to:
  /// **'Juices and drinks'**
  String get search_category_juice;

  /// No description provided for @search_category_snack.
  ///
  /// In en, this message translates to:
  /// **'Light snacks'**
  String get search_category_snack;

  /// No description provided for @search_category_salad_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Light choices'**
  String get search_category_salad_subtitle;

  /// No description provided for @search_category_protein_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Filling and balanced'**
  String get search_category_protein_subtitle;

  /// No description provided for @search_category_juice_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Natural and refreshing'**
  String get search_category_juice_subtitle;

  /// No description provided for @search_category_snack_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Low calories'**
  String get search_category_snack_subtitle;

  /// No description provided for @search_meal_badge.
  ///
  /// In en, this message translates to:
  /// **'Featured meal'**
  String get search_meal_badge;

  /// No description provided for @search_restaurant_badge.
  ///
  /// In en, this message translates to:
  /// **'Healthy restaurant'**
  String get search_restaurant_badge;

  /// No description provided for @search_meal_title.
  ///
  /// In en, this message translates to:
  /// **'Grilled chicken with quinoa'**
  String get search_meal_title;

  /// No description provided for @search_meal_description.
  ///
  /// In en, this message translates to:
  /// **'A balanced meal rich in protein and fiber'**
  String get search_meal_description;

  /// No description provided for @search_restaurant_title.
  ///
  /// In en, this message translates to:
  /// **'Green Light Kitchen'**
  String get search_restaurant_title;

  /// No description provided for @search_restaurant_description.
  ///
  /// In en, this message translates to:
  /// **'Healthy, natural, and nutritious options'**
  String get search_restaurant_description;

  /// No description provided for @search_show_details.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get search_show_details;

  /// No description provided for @search_show_restaurant.
  ///
  /// In en, this message translates to:
  /// **'View restaurant'**
  String get search_show_restaurant;

  /// No description provided for @search_calories.
  ///
  /// In en, this message translates to:
  /// **'550 calories'**
  String get search_calories;

  /// No description provided for @search_protein.
  ///
  /// In en, this message translates to:
  /// **'35 g protein'**
  String get search_protein;

  /// No description provided for @search_carbs.
  ///
  /// In en, this message translates to:
  /// **'55 g carbs'**
  String get search_carbs;

  /// No description provided for @search_fat.
  ///
  /// In en, this message translates to:
  /// **'18 g fat'**
  String get search_fat;

  /// No description provided for @search_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get search_open;

  /// No description provided for @search_empty_query.
  ///
  /// In en, this message translates to:
  /// **'Keto sushi'**
  String get search_empty_query;

  /// No description provided for @search_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No suitable results found'**
  String get search_empty_title;

  /// No description provided for @search_empty_message_prefix.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any results for \"'**
  String get search_empty_message_prefix;

  /// No description provided for @search_empty_message_suffix.
  ///
  /// In en, this message translates to:
  /// **'\"'**
  String get search_empty_message_suffix;

  /// No description provided for @search_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword or explore the available options'**
  String get search_empty_description;

  /// No description provided for @search_empty_suggestions_title.
  ///
  /// In en, this message translates to:
  /// **'Suggestions you may like'**
  String get search_empty_suggestions_title;

  /// No description provided for @search_empty_nearby_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Nearby restaurants'**
  String get search_empty_nearby_restaurants;

  /// No description provided for @search_empty_explore.
  ///
  /// In en, this message translates to:
  /// **'Back to explore'**
  String get search_empty_explore;

  /// No description provided for @search_empty_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get search_empty_clear;

  /// No description provided for @search_cuisine_fast_food.
  ///
  /// In en, this message translates to:
  /// **'Fast food'**
  String get search_cuisine_fast_food;

  /// No description provided for @search_cuisine_chicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get search_cuisine_chicken;

  /// No description provided for @search_cuisine_rice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get search_cuisine_rice;

  /// No description provided for @search_minutes.
  ///
  /// In en, this message translates to:
  /// **'15-20 min'**
  String get search_minutes;

  /// No description provided for @search_rating.
  ///
  /// In en, this message translates to:
  /// **'4.0'**
  String get search_rating;

  /// No description provided for @home_greeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Mohammed'**
  String get home_greeting;

  /// No description provided for @home_greeting_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for a great healthy day?'**
  String get home_greeting_subtitle;

  /// No description provided for @home_main_nutrients.
  ///
  /// In en, this message translates to:
  /// **'Main nutrients'**
  String get home_main_nutrients;

  /// No description provided for @nutrition_details_title.
  ///
  /// In en, this message translates to:
  /// **'Main nutrients details'**
  String get nutrition_details_title;

  /// No description provided for @nutrition_details_date_prefix.
  ///
  /// In en, this message translates to:
  /// **'Today - Saturday '**
  String get nutrition_details_date_prefix;

  /// No description provided for @nutrition_details_date_day.
  ///
  /// In en, this message translates to:
  /// **'24'**
  String get nutrition_details_date_day;

  /// No description provided for @nutrition_details_date_suffix.
  ///
  /// In en, this message translates to:
  /// **' May'**
  String get nutrition_details_date_suffix;

  /// No description provided for @nutrition_details_burned.
  ///
  /// In en, this message translates to:
  /// **'Burned'**
  String get nutrition_details_burned;

  /// No description provided for @nutrition_details_goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get nutrition_details_goal;

  /// No description provided for @nutrition_details_remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get nutrition_details_remaining;

  /// No description provided for @nutrition_details_calorie_unit.
  ///
  /// In en, this message translates to:
  /// **'calorie'**
  String get nutrition_details_calorie_unit;

  /// No description provided for @nutrition_details_fiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get nutrition_details_fiber;

  /// No description provided for @nutrition_details_sugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get nutrition_details_sugar;

  /// No description provided for @nutrition_details_macro_separator.
  ///
  /// In en, this message translates to:
  /// **' / '**
  String get nutrition_details_macro_separator;

  /// No description provided for @nutrition_details_gram_suffix.
  ///
  /// In en, this message translates to:
  /// **' g'**
  String get nutrition_details_gram_suffix;

  /// No description provided for @nutrition_details_percent_value.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String nutrition_details_percent_value(int percent);

  /// No description provided for @nutrition_details_tip_title.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tip'**
  String get nutrition_details_tip_title;

  /// No description provided for @nutrition_details_tip_message.
  ///
  /// In en, this message translates to:
  /// **'You are on the right track! Try increasing protein\nand drinking more water to achieve your daily goal.'**
  String get nutrition_details_tip_message;

  /// No description provided for @home_protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get home_protein;

  /// No description provided for @home_protein_value.
  ///
  /// In en, this message translates to:
  /// **'89'**
  String get home_protein_value;

  /// No description provided for @home_protein_goal.
  ///
  /// In en, this message translates to:
  /// **'120 g'**
  String get home_protein_goal;

  /// No description provided for @home_carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get home_carbs;

  /// No description provided for @home_carbs_value.
  ///
  /// In en, this message translates to:
  /// **'210'**
  String get home_carbs_value;

  /// No description provided for @home_carbs_goal.
  ///
  /// In en, this message translates to:
  /// **'260 g'**
  String get home_carbs_goal;

  /// No description provided for @home_fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get home_fat;

  /// No description provided for @home_fat_value.
  ///
  /// In en, this message translates to:
  /// **'58'**
  String get home_fat_value;

  /// No description provided for @home_fat_goal.
  ///
  /// In en, this message translates to:
  /// **'70 g'**
  String get home_fat_goal;

  /// No description provided for @home_remaining_calories.
  ///
  /// In en, this message translates to:
  /// **'Calories remaining'**
  String get home_remaining_calories;

  /// No description provided for @home_remaining_calories_value.
  ///
  /// In en, this message translates to:
  /// **'560'**
  String get home_remaining_calories_value;

  /// No description provided for @home_calories_of_goal.
  ///
  /// In en, this message translates to:
  /// **'of 2000 calories'**
  String get home_calories_of_goal;

  /// No description provided for @home_details.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get home_details;

  /// No description provided for @home_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for meals or restaurants'**
  String get home_search_hint;

  /// No description provided for @home_subscribe_now.
  ///
  /// In en, this message translates to:
  /// **'Subscribe now'**
  String get home_subscribe_now;

  /// No description provided for @home_today_meals.
  ///
  /// In en, this message translates to:
  /// **'Today\'s meals'**
  String get home_today_meals;

  /// No description provided for @home_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get home_restaurants;

  /// No description provided for @home_view_calendar.
  ///
  /// In en, this message translates to:
  /// **'View calendar'**
  String get home_view_calendar;

  /// No description provided for @home_next_box.
  ///
  /// In en, this message translates to:
  /// **'Next box'**
  String get home_next_box;

  /// No description provided for @home_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'11 AM - 3 PM'**
  String get home_delivery_time;

  /// No description provided for @home_edit_meals.
  ///
  /// In en, this message translates to:
  /// **'Edit meals'**
  String get home_edit_meals;

  /// No description provided for @home_next_week_meals.
  ///
  /// In en, this message translates to:
  /// **'You can edit next week\'s meals'**
  String get home_next_week_meals;

  /// No description provided for @home_reminder.
  ///
  /// In en, this message translates to:
  /// **'Important reminder'**
  String get home_reminder;

  /// No description provided for @home_reminder_copy.
  ///
  /// In en, this message translates to:
  /// **'You have 72 hours before your next box is prepared.'**
  String get home_reminder_copy;

  /// No description provided for @home_promo_discount.
  ///
  /// In en, this message translates to:
  /// **'30% off'**
  String get home_promo_discount;

  /// No description provided for @home_promo_all_subscriptions.
  ///
  /// In en, this message translates to:
  /// **'on all subscriptions'**
  String get home_promo_all_subscriptions;

  /// No description provided for @home_shortcut_offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get home_shortcut_offers;

  /// No description provided for @home_shortcut_allergy.
  ///
  /// In en, this message translates to:
  /// **'Allergy'**
  String get home_shortcut_allergy;

  /// No description provided for @home_shortcut_subscription.
  ///
  /// In en, this message translates to:
  /// **'My plan'**
  String get home_shortcut_subscription;

  /// No description provided for @home_shortcut_my_meals.
  ///
  /// In en, this message translates to:
  /// **'My meals'**
  String get home_shortcut_my_meals;

  /// No description provided for @home_meal_omelet_vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetable omelet'**
  String get home_meal_omelet_vegetables;

  /// No description provided for @home_meal_omelet_calories.
  ///
  /// In en, this message translates to:
  /// **'430 calories'**
  String get home_meal_omelet_calories;

  /// No description provided for @home_meal_chicken_calories.
  ///
  /// In en, this message translates to:
  /// **'650 calories'**
  String get home_meal_chicken_calories;

  /// No description provided for @home_meal_herb_salmon.
  ///
  /// In en, this message translates to:
  /// **'Herb salmon'**
  String get home_meal_herb_salmon;

  /// No description provided for @home_meal_salmon_calories.
  ///
  /// In en, this message translates to:
  /// **'520 calories'**
  String get home_meal_salmon_calories;

  /// No description provided for @home_restaurant_protein_kitchen.
  ///
  /// In en, this message translates to:
  /// **'Protein Kitchen'**
  String get home_restaurant_protein_kitchen;

  /// No description provided for @home_restaurant_healthy_bite.
  ///
  /// In en, this message translates to:
  /// **'Healthy Bite'**
  String get home_restaurant_healthy_bite;

  /// No description provided for @home_restaurant_diet_house.
  ///
  /// In en, this message translates to:
  /// **'Diet House'**
  String get home_restaurant_diet_house;

  /// No description provided for @home_restaurant_balanced_meals.
  ///
  /// In en, this message translates to:
  /// **'Balanced healthy meals'**
  String get home_restaurant_balanced_meals;

  /// No description provided for @home_restaurant_browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get home_restaurant_browse;

  /// No description provided for @home_calendar_card_title.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get home_calendar_card_title;

  /// No description provided for @home_calendar_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View your upcoming meals'**
  String get home_calendar_card_subtitle;

  /// No description provided for @home_subscription_tab.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get home_subscription_tab;

  /// No description provided for @home_nutrition_tab.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get home_nutrition_tab;

  /// No description provided for @home_current_plan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get home_current_plan;

  /// No description provided for @home_weight_loss_program.
  ///
  /// In en, this message translates to:
  /// **'Weight loss program'**
  String get home_weight_loss_program;

  /// No description provided for @home_renewal_date.
  ///
  /// In en, this message translates to:
  /// **'Renews on June 24, 2026'**
  String get home_renewal_date;

  /// No description provided for @home_average_calories.
  ///
  /// In en, this message translates to:
  /// **'Average calories'**
  String get home_average_calories;

  /// No description provided for @home_average_calories_value.
  ///
  /// In en, this message translates to:
  /// **'612'**
  String get home_average_calories_value;

  /// No description provided for @home_calories_per_meal.
  ///
  /// In en, this message translates to:
  /// **'cal / meal'**
  String get home_calories_per_meal;

  /// No description provided for @home_completed_meals.
  ///
  /// In en, this message translates to:
  /// **'Completed meals'**
  String get home_completed_meals;

  /// No description provided for @home_completed_meals_value.
  ///
  /// In en, this message translates to:
  /// **'18'**
  String get home_completed_meals_value;

  /// No description provided for @home_completed_meals_total.
  ///
  /// In en, this message translates to:
  /// **'of 30 meals'**
  String get home_completed_meals_total;

  /// No description provided for @home_subscription_days_value.
  ///
  /// In en, this message translates to:
  /// **'12'**
  String get home_subscription_days_value;

  /// No description provided for @home_days_remaining_label.
  ///
  /// In en, this message translates to:
  /// **'days remaining'**
  String get home_days_remaining_label;

  /// No description provided for @home_subscription_days_total.
  ///
  /// In en, this message translates to:
  /// **'of 30 days'**
  String get home_subscription_days_total;

  /// No description provided for @home_subscription_days_total_alt.
  ///
  /// In en, this message translates to:
  /// **'of 30 days'**
  String get home_subscription_days_total_alt;

  /// No description provided for @home_subscription_details.
  ///
  /// In en, this message translates to:
  /// **'Subscription details'**
  String get home_subscription_details;

  /// No description provided for @home_next_delivery.
  ///
  /// In en, this message translates to:
  /// **'Next delivery'**
  String get home_next_delivery;

  /// No description provided for @home_tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get home_tomorrow;

  /// No description provided for @home_before_noon.
  ///
  /// In en, this message translates to:
  /// **'before 12:00 PM'**
  String get home_before_noon;

  /// No description provided for @home_commitment.
  ///
  /// In en, this message translates to:
  /// **'Commitment'**
  String get home_commitment;

  /// No description provided for @home_commitment_value.
  ///
  /// In en, this message translates to:
  /// **'86%'**
  String get home_commitment_value;

  /// No description provided for @home_excellent_performance.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get home_excellent_performance;

  /// No description provided for @home_selected_meals.
  ///
  /// In en, this message translates to:
  /// **'Selected meals'**
  String get home_selected_meals;

  /// No description provided for @home_selected_meals_value.
  ///
  /// In en, this message translates to:
  /// **'18 /30'**
  String get home_selected_meals_value;

  /// No description provided for @home_meal.
  ///
  /// In en, this message translates to:
  /// **'meal'**
  String get home_meal;

  /// No description provided for @home_remaining_days.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get home_remaining_days;

  /// No description provided for @home_on_track.
  ///
  /// In en, this message translates to:
  /// **'You are on the right track! Keep making healthy choices.'**
  String get home_on_track;

  /// No description provided for @search_suggestion_chicken_protein.
  ///
  /// In en, this message translates to:
  /// **'Chicken protein'**
  String get search_suggestion_chicken_protein;

  /// No description provided for @search_suggestion_chicken_rice.
  ///
  /// In en, this message translates to:
  /// **'Chicken with brown rice'**
  String get search_suggestion_chicken_rice;

  /// No description provided for @search_suggestion_chicken_healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy chicken restaurants'**
  String get search_suggestion_chicken_healthy;

  /// No description provided for @search_suggestion_chicken_vegetables.
  ///
  /// In en, this message translates to:
  /// **'Chicken with grilled vegetables'**
  String get search_suggestion_chicken_vegetables;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
