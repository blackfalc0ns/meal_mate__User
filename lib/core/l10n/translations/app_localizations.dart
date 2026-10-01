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

  /// No description provided for @meal_details_restaurant_rating.
  ///
  /// In en, this message translates to:
  /// **'Restaurant rating'**
  String get meal_details_restaurant_rating;

  /// No description provided for @meal_details_meal_type.
  ///
  /// In en, this message translates to:
  /// **'Meal type'**
  String get meal_details_meal_type;

  /// No description provided for @meal_details_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Delivery time'**
  String get meal_details_delivery_time;

  /// No description provided for @meal_details_nutrition_facts.
  ///
  /// In en, this message translates to:
  /// **'Nutrition facts'**
  String get meal_details_nutrition_facts;

  /// No description provided for @meal_details_macro_distribution.
  ///
  /// In en, this message translates to:
  /// **'Macro distribution'**
  String get meal_details_macro_distribution;

  /// No description provided for @meal_details_allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get meal_details_allergens;

  /// No description provided for @meal_details_gram_value.
  ///
  /// In en, this message translates to:
  /// **'{value}g'**
  String meal_details_gram_value(String value);

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

  /// No description provided for @auth_register_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully. OTP code has been sent.'**
  String get auth_register_success;

  /// No description provided for @auth_login_success.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully.'**
  String get auth_login_success;

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

  /// No description provided for @auth_otp_sent_success.
  ///
  /// In en, this message translates to:
  /// **'OTP code sent successfully.'**
  String get auth_otp_sent_success;

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

  /// No description provided for @auth_reset_password_otp_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm reset code'**
  String get auth_reset_password_otp_title;

  /// No description provided for @auth_reset_password_otp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP code sent to your phone.'**
  String get auth_reset_password_otp_subtitle;

  /// No description provided for @auth_reset_password_otp_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the code to continue setting your new password.'**
  String get auth_reset_password_otp_hint;

  /// No description provided for @auth_reset_password_otp_button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get auth_reset_password_otp_button;

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

  /// No description provided for @auth_otp_resent_success.
  ///
  /// In en, this message translates to:
  /// **'OTP code resent successfully.'**
  String get auth_otp_resent_success;

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
  /// **'Enter a new password for your account.'**
  String get auth_new_password_subtitle;

  /// No description provided for @auth_new_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Create a new password so you can sign in'**
  String get auth_new_password_hint;

  /// No description provided for @auth_new_password_label.
  ///
  /// In en, this message translates to:
  /// **'New password'**
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

  /// No description provided for @auth_reset_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully.'**
  String get auth_reset_password_success;

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

  /// No description provided for @profile_change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get profile_change_photo;

  /// No description provided for @profile_photo_source_title.
  ///
  /// In en, this message translates to:
  /// **'Choose profile photo'**
  String get profile_photo_source_title;

  /// No description provided for @profile_photo_source_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get profile_photo_source_camera;

  /// No description provided for @profile_photo_source_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profile_photo_source_gallery;

  /// No description provided for @profile_photo_upload_success.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully.'**
  String get profile_photo_upload_success;

  /// No description provided for @profile_photo_upload_error.
  ///
  /// In en, this message translates to:
  /// **'Could not update profile photo. Please try again.'**
  String get profile_photo_upload_error;

  /// No description provided for @profile_photo_permission_error.
  ///
  /// In en, this message translates to:
  /// **'Please allow camera or photo access to update your profile photo.'**
  String get profile_photo_permission_error;

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

  /// No description provided for @profile_personal_info_save.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profile_personal_info_save;

  /// No description provided for @profile_personal_info_update_success.
  ///
  /// In en, this message translates to:
  /// **'Personal information updated successfully.'**
  String get profile_personal_info_update_success;

  /// No description provided for @profile_personal_info_update_error.
  ///
  /// In en, this message translates to:
  /// **'Could not update personal information. Please try again.'**
  String get profile_personal_info_update_error;

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

  /// No description provided for @dietary_preferences_update_success.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved successfully.'**
  String get dietary_preferences_update_success;

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

  /// No description provided for @add_allergy_update_success.
  ///
  /// In en, this message translates to:
  /// **'Allergies updated successfully.'**
  String get add_allergy_update_success;

  /// No description provided for @add_allergy_update_error.
  ///
  /// In en, this message translates to:
  /// **'Could not update allergies. Please try again.'**
  String get add_allergy_update_error;

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

  /// No description provided for @billing_renewal_date_value.
  ///
  /// In en, this message translates to:
  /// **'Next renewal: {date}'**
  String billing_renewal_date_value(String date);

  /// No description provided for @billing_days_remaining.
  ///
  /// In en, this message translates to:
  /// **'18 days remaining'**
  String get billing_days_remaining;

  /// No description provided for @billing_days_remaining_value.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String billing_days_remaining_value(int days);

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

  /// No description provided for @billing_plan_usage_remaining_value.
  ///
  /// In en, this message translates to:
  /// **'of {days} days'**
  String billing_plan_usage_remaining_value(int days);

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

  /// No description provided for @billing_upgrade_tier.
  ///
  /// In en, this message translates to:
  /// **'Upgrade tier'**
  String get billing_upgrade_tier;

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

  /// No description provided for @billing_no_subscription_title.
  ///
  /// In en, this message translates to:
  /// **'No current subscription'**
  String get billing_no_subscription_title;

  /// No description provided for @billing_no_subscription_description.
  ///
  /// In en, this message translates to:
  /// **'Your subscription details will appear here once you subscribe.'**
  String get billing_no_subscription_description;

  /// No description provided for @billing_no_active_subscription_title.
  ///
  /// In en, this message translates to:
  /// **'No active subscription'**
  String get billing_no_active_subscription_title;

  /// No description provided for @billing_no_active_subscription_desc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t subscribed to any package yet.\nChoose the right package and start your healthy journey.'**
  String get billing_no_active_subscription_desc;

  /// No description provided for @billing_browse_subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Explore Subscriptions'**
  String get billing_browse_subscriptions;

  /// No description provided for @billing_no_invoices_title.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get billing_no_invoices_title;

  /// No description provided for @billing_no_invoices_desc.
  ///
  /// In en, this message translates to:
  /// **'Your subscription invoices will appear here after completing your first payment.'**
  String get billing_no_invoices_desc;

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

  /// No description provided for @billing_pending_upgrade_notice.
  ///
  /// In en, this message translates to:
  /// **'There is a pending upgrade request currently being processed.'**
  String get billing_pending_upgrade_notice;

  /// No description provided for @billing_action_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This action is not available right now.'**
  String get billing_action_unavailable;

  /// No description provided for @billing_renew_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Renew subscription'**
  String get billing_renew_confirm_title;

  /// No description provided for @billing_renew_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Submit a renewal request for this subscription?'**
  String get billing_renew_confirm_message;

  /// No description provided for @billing_freeze_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Freeze subscription'**
  String get billing_freeze_confirm_title;

  /// No description provided for @billing_freeze_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Choose the freeze dates, then confirm the request.'**
  String get billing_freeze_confirm_message;

  /// No description provided for @billing_pick_freeze_dates.
  ///
  /// In en, this message translates to:
  /// **'Pick freeze dates'**
  String get billing_pick_freeze_dates;

  /// No description provided for @billing_selected_freeze_dates.
  ///
  /// In en, this message translates to:
  /// **'{startDate} - {endDate}'**
  String billing_selected_freeze_dates(String startDate, String endDate);

  /// No description provided for @billing_optional_reason.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get billing_optional_reason;

  /// No description provided for @billing_freeze_range_too_long.
  ///
  /// In en, this message translates to:
  /// **'Freeze duration cannot exceed {days} days.'**
  String billing_freeze_range_too_long(int days);

  /// No description provided for @billing_freeze_locked_days_cannot_be_frozen.
  ///
  /// In en, this message translates to:
  /// **'Locked days cannot be frozen. Choose later dates.'**
  String get billing_freeze_locked_days_cannot_be_frozen;

  /// No description provided for @billing_cancel_quote_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel subscription'**
  String get billing_cancel_quote_title;

  /// No description provided for @billing_cancel_quote_message.
  ///
  /// In en, this message translates to:
  /// **'Refundable days: {days}\nRefund amount: {amount} {currency}'**
  String billing_cancel_quote_message(int days, String amount, String currency);

  /// No description provided for @billing_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get billing_confirm;

  /// No description provided for @billing_dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get billing_dismiss;

  /// No description provided for @billing_renew_success.
  ///
  /// In en, this message translates to:
  /// **'Renewal request submitted.'**
  String get billing_renew_success;

  /// No description provided for @billing_freeze_success.
  ///
  /// In en, this message translates to:
  /// **'Freeze request submitted.'**
  String get billing_freeze_success;

  /// No description provided for @billing_cancel_success.
  ///
  /// In en, this message translates to:
  /// **'Cancellation request submitted.'**
  String get billing_cancel_success;

  /// No description provided for @billing_action_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the request. Please try again.'**
  String get billing_action_failed;

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

  /// No description provided for @addresses_active_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get addresses_active_delivery;

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

  /// No description provided for @addresses_save_success.
  ///
  /// In en, this message translates to:
  /// **'Address saved successfully.'**
  String get addresses_save_success;

  /// No description provided for @addresses_choose_location_title.
  ///
  /// In en, this message translates to:
  /// **'Choose home location'**
  String get addresses_choose_location_title;

  /// No description provided for @addresses_choose_location_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the main delivery location for home'**
  String get addresses_choose_location_subtitle;

  /// No description provided for @addresses_confirm_location.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get addresses_confirm_location;

  /// No description provided for @addresses_home_address_title.
  ///
  /// In en, this message translates to:
  /// **'Home address'**
  String get addresses_home_address_title;

  /// No description provided for @addresses_home_address_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your home address to set the main delivery location'**
  String get addresses_home_address_subtitle;

  /// No description provided for @addresses_governorate_label.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get addresses_governorate_label;

  /// No description provided for @addresses_governorate_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose governorate'**
  String get addresses_governorate_hint;

  /// No description provided for @addresses_area_label.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get addresses_area_label;

  /// No description provided for @addresses_area_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose area'**
  String get addresses_area_hint;

  /// No description provided for @addresses_area_required.
  ///
  /// In en, this message translates to:
  /// **'Please choose an area from the list.'**
  String get addresses_area_required;

  /// No description provided for @addresses_block_label.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get addresses_block_label;

  /// No description provided for @addresses_block_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose block'**
  String get addresses_block_hint;

  /// No description provided for @addresses_street_label.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get addresses_street_label;

  /// No description provided for @addresses_street_hint.
  ///
  /// In en, this message translates to:
  /// **'Write street name'**
  String get addresses_street_hint;

  /// No description provided for @addresses_avenue_label.
  ///
  /// In en, this message translates to:
  /// **'Avenue'**
  String get addresses_avenue_label;

  /// No description provided for @addresses_avenue_hint.
  ///
  /// In en, this message translates to:
  /// **'Write avenue name'**
  String get addresses_avenue_hint;

  /// No description provided for @addresses_optional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get addresses_optional;

  /// No description provided for @addresses_building_type_label.
  ///
  /// In en, this message translates to:
  /// **'Building type'**
  String get addresses_building_type_label;

  /// No description provided for @addresses_building_type_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get addresses_building_type_home;

  /// No description provided for @addresses_building_type_building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get addresses_building_type_building;

  /// No description provided for @addresses_floor_label.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get addresses_floor_label;

  /// No description provided for @addresses_floor_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose floor'**
  String get addresses_floor_hint;

  /// No description provided for @addresses_building_number_label.
  ///
  /// In en, this message translates to:
  /// **'House / building number'**
  String get addresses_building_number_label;

  /// No description provided for @addresses_building_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Write number'**
  String get addresses_building_number_hint;

  /// No description provided for @addresses_apartment_number_label.
  ///
  /// In en, this message translates to:
  /// **'Apartment number'**
  String get addresses_apartment_number_label;

  /// No description provided for @addresses_apartment_number_hint.
  ///
  /// In en, this message translates to:
  /// **'Write apartment number'**
  String get addresses_apartment_number_hint;

  /// No description provided for @addresses_use_current_location.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get addresses_use_current_location;

  /// No description provided for @addresses_use_current_location_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Set my current location as home address'**
  String get addresses_use_current_location_subtitle;

  /// No description provided for @addresses_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for address, area or street'**
  String get addresses_search_hint;

  /// No description provided for @addresses_choose_from_map.
  ///
  /// In en, this message translates to:
  /// **'Choose from map'**
  String get addresses_choose_from_map;

  /// No description provided for @addresses_choose_from_map_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your location on the map'**
  String get addresses_choose_from_map_subtitle;

  /// No description provided for @addresses_use_current_location_desc.
  ///
  /// In en, this message translates to:
  /// **'Automatically detects your current location'**
  String get addresses_use_current_location_desc;

  /// No description provided for @address_active_delivery_cannot_delete.
  ///
  /// In en, this message translates to:
  /// **'This address is currently used for delivery. Set another default address and wait 72 hours for it to activate before deleting this one.'**
  String get address_active_delivery_cannot_delete;

  /// No description provided for @addresses_out_of_kuwait_bounds.
  ///
  /// In en, this message translates to:
  /// **'The selected location must be within Kuwait bounds.'**
  String get addresses_out_of_kuwait_bounds;

  /// No description provided for @addresses_delivery_notice_title.
  ///
  /// In en, this message translates to:
  /// **'Delivery address update'**
  String get addresses_delivery_notice_title;

  /// No description provided for @addresses_delivery_notice_action.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get addresses_delivery_notice_action;

  /// No description provided for @addresses_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get addresses_edit;

  /// No description provided for @addresses_set_default.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get addresses_set_default;

  /// No description provided for @addresses_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get addresses_delete;

  /// No description provided for @addresses_delete_confirmation_title.
  ///
  /// In en, this message translates to:
  /// **'Delete address?'**
  String get addresses_delete_confirmation_title;

  /// No description provided for @addresses_delete_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get addresses_delete_confirmation_message;

  /// No description provided for @addresses_delete_confirmation_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get addresses_delete_confirmation_cancel;

  /// No description provided for @addresses_delete_confirmation_action.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get addresses_delete_confirmation_action;

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

  /// No description provided for @profile_logout_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profile_logout_confirmation_message;

  /// No description provided for @profile_logout_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profile_logout_cancel;

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

  /// No description provided for @payment_calendar_preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing your subscription days...'**
  String get payment_calendar_preparing;

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

  /// No description provided for @subscription_packages_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No packages available right now'**
  String get subscription_packages_empty_title;

  /// No description provided for @subscription_packages_empty_description.
  ///
  /// In en, this message translates to:
  /// **'There are no packages for this program yet. Try another program or check again later.'**
  String get subscription_packages_empty_description;

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

  /// No description provided for @subscription_month_package_prefix.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get subscription_month_package_prefix;

  /// No description provided for @subscription_month_package_highlight.
  ///
  /// In en, this message translates to:
  /// **'package'**
  String get subscription_month_package_highlight;

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
  /// **'You can enter any number of days ({minDays}-{maxDays} days)'**
  String subscription_days_range_hint(int minDays, int maxDays);

  /// No description provided for @subscription_custom_duration_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter days'**
  String get subscription_custom_duration_input_hint;

  /// No description provided for @subscription_custom_duration_invalid_error.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from {minDays} to {maxDays}'**
  String subscription_custom_duration_invalid_error(int minDays, int maxDays);

  /// No description provided for @subscription_custom_duration_duplicate_error.
  ///
  /// In en, this message translates to:
  /// **'This duration is already available as a preset'**
  String get subscription_custom_duration_duplicate_error;

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

  /// No description provided for @subscription_limited_discount.
  ///
  /// In en, this message translates to:
  /// **'20% off for a limited time'**
  String get subscription_limited_discount;

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

  /// No description provided for @subscription_programs_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No programs available right now'**
  String get subscription_programs_empty_title;

  /// No description provided for @subscription_programs_empty_description.
  ///
  /// In en, this message translates to:
  /// **'There are no subscription programs available at the moment. Please check back later'**
  String get subscription_programs_empty_description;

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

  /// No description provided for @subscription_conversion_title.
  ///
  /// In en, this message translates to:
  /// **'Choose conversion option'**
  String get subscription_conversion_title;

  /// No description provided for @subscription_conversion_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your current individual subscription can be converted before starting the family flow.'**
  String get subscription_conversion_subtitle;

  /// No description provided for @subscription_conversion_create_family_manager.
  ///
  /// In en, this message translates to:
  /// **'Create a family and become manager'**
  String get subscription_conversion_create_family_manager;

  /// No description provided for @subscription_conversion_create_family_manager_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Convert your current subscription and continue setting up family members.'**
  String get subscription_conversion_create_family_manager_subtitle;

  /// No description provided for @subscription_conversion_change_individual_plan.
  ///
  /// In en, this message translates to:
  /// **'Change my individual plan'**
  String get subscription_conversion_change_individual_plan;

  /// No description provided for @subscription_conversion_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get subscription_conversion_coming_soon;

  /// No description provided for @subscription_conversion_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This option is not available now.'**
  String get subscription_conversion_unavailable;

  /// No description provided for @subscription_conversion_option_available.
  ///
  /// In en, this message translates to:
  /// **'Available option'**
  String get subscription_conversion_option_available;

  /// No description provided for @subscription_conversion_option_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable option'**
  String get subscription_conversion_option_unavailable;

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

  /// No description provided for @subscription_restaurant_categories_title.
  ///
  /// In en, this message translates to:
  /// **'Browse categories'**
  String get subscription_restaurant_categories_title;

  /// No description provided for @subscription_restaurant_categories_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Each category includes a curated selection of featured restaurants.'**
  String get subscription_restaurant_categories_subtitle;

  /// No description provided for @subscription_tier_elite.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get subscription_tier_elite;

  /// No description provided for @subscription_tier_plus.
  ///
  /// In en, this message translates to:
  /// **'Plus'**
  String get subscription_tier_plus;

  /// No description provided for @subscription_tier_max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get subscription_tier_max;

  /// No description provided for @subscription_until_end_of_subscription.
  ///
  /// In en, this message translates to:
  /// **'Until subscription ends'**
  String get subscription_until_end_of_subscription;

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

  /// No description provided for @subscription_summary_show_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get subscription_summary_show_more;

  /// No description provided for @subscription_summary_all_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Available restaurants'**
  String get subscription_summary_all_restaurants;

  /// No description provided for @subscription_summary_no_restaurants_for_address.
  ///
  /// In en, this message translates to:
  /// **'No restaurants currently cover this delivery address.'**
  String get subscription_summary_no_restaurants_for_address;

  /// No description provided for @subscription_no_restaurants_for_area.
  ///
  /// In en, this message translates to:
  /// **'No restaurants are available for your area.'**
  String get subscription_no_restaurants_for_area;

  /// No description provided for @subscription_change_address.
  ///
  /// In en, this message translates to:
  /// **'Change address'**
  String get subscription_change_address;

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

  /// No description provided for @subscription_start_date_picker_label.
  ///
  /// In en, this message translates to:
  /// **'Subscription starts from'**
  String get subscription_start_date_picker_label;

  /// No description provided for @subscription_chosen_start_date_label.
  ///
  /// In en, this message translates to:
  /// **'Start/payment day'**
  String get subscription_chosen_start_date_label;

  /// No description provided for @subscription_first_delivery_date_label.
  ///
  /// In en, this message translates to:
  /// **'First delivery day'**
  String get subscription_first_delivery_date_label;

  /// No description provided for @subscription_restaurant_repetition_label.
  ///
  /// In en, this message translates to:
  /// **'Restaurant repetition'**
  String get subscription_restaurant_repetition_label;

  /// No description provided for @subscription_restaurant_repetition_message.
  ///
  /// In en, this message translates to:
  /// **'You can choose the same restaurant for up to {limit} days during the subscription.'**
  String subscription_restaurant_repetition_message(int limit);

  /// No description provided for @subscription_payment_confirmation_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm subscription dates'**
  String get subscription_payment_confirmation_title;

  /// No description provided for @subscription_continue_to_payment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get subscription_continue_to_payment;

  /// No description provided for @checkout_start_date_required.
  ///
  /// In en, this message translates to:
  /// **'Please choose a subscription start date.'**
  String get checkout_start_date_required;

  /// No description provided for @checkout_start_date_invalid.
  ///
  /// In en, this message translates to:
  /// **'The selected date is in the past. Please choose another date.'**
  String get checkout_start_date_invalid;

  /// No description provided for @subscription_flow_profile_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile before checkout.'**
  String get subscription_flow_profile_incomplete;

  /// No description provided for @checkout_address_required.
  ///
  /// In en, this message translates to:
  /// **'Please add a delivery address before checkout.'**
  String get checkout_address_required;

  /// No description provided for @checkout_allergies_required.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your allergy preferences before checkout.'**
  String get checkout_allergies_required;

  /// No description provided for @checkout_dietary_preferences_required.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your dietary preferences before checkout.'**
  String get checkout_dietary_preferences_required;

  /// No description provided for @checkout_existing_subscription.
  ///
  /// In en, this message translates to:
  /// **'You already have an active individual subscription.'**
  String get checkout_existing_subscription;

  /// No description provided for @checkout_restaurant_not_eligible.
  ///
  /// In en, this message translates to:
  /// **'This address is not covered by the selected restaurants. Please change your address or area.'**
  String get checkout_restaurant_not_eligible;

  /// No description provided for @checkout_redirect_url_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'The payment return link is not allowed. Please try again later.'**
  String get checkout_redirect_url_not_allowed;

  /// No description provided for @family_restaurants_date_label.
  ///
  /// In en, this message translates to:
  /// **'Monday, May 26'**
  String get family_restaurants_date_label;

  /// No description provided for @family_restaurants_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for a restaurant or meal'**
  String get family_restaurants_search_hint;

  /// No description provided for @family_restaurants_title_prefix.
  ///
  /// In en, this message translates to:
  /// **'Choose restaurants'**
  String get family_restaurants_title_prefix;

  /// No description provided for @family_restaurants_subtitle.
  ///
  /// In en, this message translates to:
  /// **'These restaurants were recommended based on your goal and preferences'**
  String get family_restaurants_subtitle;

  /// No description provided for @family_restaurants_summary_selected_meals_value.
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get family_restaurants_summary_selected_meals_value;

  /// No description provided for @family_restaurants_summary_selected_meals_total.
  ///
  /// In en, this message translates to:
  /// **'/2'**
  String get family_restaurants_summary_selected_meals_total;

  /// No description provided for @family_restaurants_summary_selected_meals_label.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get family_restaurants_summary_selected_meals_label;

  /// No description provided for @family_restaurants_summary_daily_meals_value.
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get family_restaurants_summary_daily_meals_value;

  /// No description provided for @family_restaurants_summary_daily_meals_label.
  ///
  /// In en, this message translates to:
  /// **'daily meals'**
  String get family_restaurants_summary_daily_meals_label;

  /// No description provided for @family_restaurants_summary_calories_value.
  ///
  /// In en, this message translates to:
  /// **'1500'**
  String get family_restaurants_summary_calories_value;

  /// No description provided for @family_restaurants_summary_calories_label.
  ///
  /// In en, this message translates to:
  /// **'calories daily'**
  String get family_restaurants_summary_calories_label;

  /// No description provided for @family_restaurants_filter_balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get family_restaurants_filter_balanced;

  /// No description provided for @family_restaurants_filter_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get family_restaurants_filter_dinner;

  /// No description provided for @family_restaurants_filter_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get family_restaurants_filter_lunch;

  /// No description provided for @family_restaurants_filter_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get family_restaurants_filter_breakfast;

  /// No description provided for @family_restaurants_filter_high_protein.
  ///
  /// In en, this message translates to:
  /// **'High protein'**
  String get family_restaurants_filter_high_protein;

  /// No description provided for @family_restaurants_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get family_restaurants_filter_all;

  /// No description provided for @family_restaurants_diet_house.
  ///
  /// In en, this message translates to:
  /// **'Diet House'**
  String get family_restaurants_diet_house;

  /// No description provided for @family_restaurants_card_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Delicious and complete diet meals'**
  String get family_restaurants_card_subtitle;

  /// No description provided for @family_restaurants_logo_diet_house_line1.
  ///
  /// In en, this message translates to:
  /// **'DIET'**
  String get family_restaurants_logo_diet_house_line1;

  /// No description provided for @family_restaurants_logo_diet_house_line2.
  ///
  /// In en, this message translates to:
  /// **'HOUSE'**
  String get family_restaurants_logo_diet_house_line2;

  /// No description provided for @family_restaurants_rating_diet_house.
  ///
  /// In en, this message translates to:
  /// **'4.7'**
  String get family_restaurants_rating_diet_house;

  /// No description provided for @family_restaurants_browse_meals.
  ///
  /// In en, this message translates to:
  /// **'Browse meals'**
  String get family_restaurants_browse_meals;

  /// No description provided for @family_restaurants_healthy_bowl.
  ///
  /// In en, this message translates to:
  /// **'Healthy Bowl'**
  String get family_restaurants_healthy_bowl;

  /// No description provided for @family_restaurants_logo_healthy_bowl_line1.
  ///
  /// In en, this message translates to:
  /// **'HEALTHY'**
  String get family_restaurants_logo_healthy_bowl_line1;

  /// No description provided for @family_restaurants_logo_healthy_bowl_line2.
  ///
  /// In en, this message translates to:
  /// **'BOWL'**
  String get family_restaurants_logo_healthy_bowl_line2;

  /// No description provided for @family_restaurants_rating_healthy_bowl.
  ///
  /// In en, this message translates to:
  /// **'4.6'**
  String get family_restaurants_rating_healthy_bowl;

  /// No description provided for @family_restaurants_protein_kitchen.
  ///
  /// In en, this message translates to:
  /// **'Protein Kitchen'**
  String get family_restaurants_protein_kitchen;

  /// No description provided for @family_restaurants_logo_protein_kitchen_line1.
  ///
  /// In en, this message translates to:
  /// **'THE'**
  String get family_restaurants_logo_protein_kitchen_line1;

  /// No description provided for @family_restaurants_logo_protein_kitchen_line2.
  ///
  /// In en, this message translates to:
  /// **'PROTEIN'**
  String get family_restaurants_logo_protein_kitchen_line2;

  /// No description provided for @family_restaurants_logo_protein_kitchen_line3.
  ///
  /// In en, this message translates to:
  /// **'KITCHEN'**
  String get family_restaurants_logo_protein_kitchen_line3;

  /// No description provided for @family_restaurants_rating_protein_kitchen.
  ///
  /// In en, this message translates to:
  /// **'4.3'**
  String get family_restaurants_rating_protein_kitchen;

  /// No description provided for @family_restaurants_salad_station.
  ///
  /// In en, this message translates to:
  /// **'Salad Station'**
  String get family_restaurants_salad_station;

  /// No description provided for @family_restaurants_logo_salad_station_line1.
  ///
  /// In en, this message translates to:
  /// **'SALAD'**
  String get family_restaurants_logo_salad_station_line1;

  /// No description provided for @family_restaurants_logo_salad_station_line2.
  ///
  /// In en, this message translates to:
  /// **'STATION'**
  String get family_restaurants_logo_salad_station_line2;

  /// No description provided for @family_restaurants_rating_salad_station.
  ///
  /// In en, this message translates to:
  /// **'4.6'**
  String get family_restaurants_rating_salad_station;

  /// No description provided for @family_restaurants_assurance_title.
  ///
  /// In en, this message translates to:
  /// **'All recommendations respect your preferences and allergies'**
  String get family_restaurants_assurance_title;

  /// No description provided for @family_restaurants_assurance_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose confidently. All meals are suitable and support your health goal'**
  String get family_restaurants_assurance_subtitle;

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

  /// No description provided for @family_manage_title.
  ///
  /// In en, this message translates to:
  /// **'Family package management'**
  String get family_manage_title;

  /// No description provided for @family_manage_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get family_manage_active;

  /// No description provided for @family_manage_instead_of.
  ///
  /// In en, this message translates to:
  /// **'Instead of'**
  String get family_manage_instead_of;

  /// No description provided for @family_manage_ends_on.
  ///
  /// In en, this message translates to:
  /// **'Ends on May 26, 2024'**
  String get family_manage_ends_on;

  /// No description provided for @family_manage_family_members.
  ///
  /// In en, this message translates to:
  /// **'Family members'**
  String get family_manage_family_members;

  /// No description provided for @family_manage_show_all.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get family_manage_show_all;

  /// No description provided for @family_manage_quick_access.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get family_manage_quick_access;

  /// No description provided for @family_manage_meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get family_manage_meals;

  /// No description provided for @family_manage_subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get family_manage_subscription;

  /// No description provided for @family_manage_invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get family_manage_invoice;

  /// No description provided for @family_manage_permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get family_manage_permissions;

  /// No description provided for @family_manage_missing_selection.
  ///
  /// In en, this message translates to:
  /// **'Missing selection'**
  String get family_manage_missing_selection;

  /// No description provided for @family_manage_today_meals_status.
  ///
  /// In en, this message translates to:
  /// **'Today\'s meal status'**
  String get family_manage_today_meals_status;

  /// No description provided for @family_manage_today_date.
  ///
  /// In en, this message translates to:
  /// **'Monday, May 26'**
  String get family_manage_today_date;

  /// No description provided for @family_manage_meal_count_4.
  ///
  /// In en, this message translates to:
  /// **'4/4 meals'**
  String get family_manage_meal_count_4;

  /// No description provided for @family_manage_meal_count_2.
  ///
  /// In en, this message translates to:
  /// **'2/4 meals'**
  String get family_manage_meal_count_2;

  /// No description provided for @family_manage_meal_count_0.
  ///
  /// In en, this message translates to:
  /// **'0/4 meals'**
  String get family_manage_meal_count_0;

  /// No description provided for @family_manage_completed_status.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get family_manage_completed_status;

  /// No description provided for @family_manage_selected_status.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get family_manage_selected_status;

  /// No description provided for @family_manage_not_started_status.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get family_manage_not_started_status;

  /// No description provided for @family_manage_complete_missing_meals.
  ///
  /// In en, this message translates to:
  /// **'Complete missing meals'**
  String get family_manage_complete_missing_meals;

  /// No description provided for @family_manage_warning_title.
  ///
  /// In en, this message translates to:
  /// **'Some members have not selected their meals'**
  String get family_manage_warning_title;

  /// No description provided for @family_manage_warning_message.
  ///
  /// In en, this message translates to:
  /// **'Please select today\'s meals for: Ahmed'**
  String get family_manage_warning_message;

  /// No description provided for @family_member_permissions_title.
  ///
  /// In en, this message translates to:
  /// **'Permissions for {memberName}'**
  String family_member_permissions_title(String memberName);

  /// No description provided for @family_member_permissions_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what {memberName} can do inside the account'**
  String family_member_permissions_subtitle(String memberName);

  /// No description provided for @family_member_permissions_note.
  ///
  /// In en, this message translates to:
  /// **'The family manager remains in primary control of the family plan settings\nand can edit permissions at any time'**
  String get family_member_permissions_note;

  /// No description provided for @family_member_permissions_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get family_member_permissions_save;

  /// No description provided for @family_member_permissions_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Save Permissions'**
  String get family_member_permissions_confirm_title;

  /// No description provided for @family_member_permissions_confirm_desc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save the permission changes for {memberName}?'**
  String family_member_permissions_confirm_desc(String memberName);

  /// No description provided for @family_member_permissions_confirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get family_member_permissions_confirm_cancel;

  /// No description provided for @family_member_permissions_confirm_action.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get family_member_permissions_confirm_action;

  /// No description provided for @family_member_permissions_meals_section.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get family_member_permissions_meals_section;

  /// No description provided for @family_member_permissions_program_section.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get family_member_permissions_program_section;

  /// No description provided for @family_member_permissions_settings_section.
  ///
  /// In en, this message translates to:
  /// **'Account and settings'**
  String get family_member_permissions_settings_section;

  /// No description provided for @family_member_permission_choose_daily_meals.
  ///
  /// In en, this message translates to:
  /// **'Choose daily meals'**
  String get family_member_permission_choose_daily_meals;

  /// No description provided for @family_member_permission_edit_meals_before_lock.
  ///
  /// In en, this message translates to:
  /// **'Edit meals before lock time'**
  String get family_member_permission_edit_meals_before_lock;

  /// No description provided for @family_member_permission_view_meal_details.
  ///
  /// In en, this message translates to:
  /// **'View meal details'**
  String get family_member_permission_view_meal_details;

  /// No description provided for @family_member_permission_view_nutrition_program.
  ///
  /// In en, this message translates to:
  /// **'View nutrition program'**
  String get family_member_permission_view_nutrition_program;

  /// No description provided for @family_member_permission_change_nutrition_program.
  ///
  /// In en, this message translates to:
  /// **'Change nutrition program'**
  String get family_member_permission_change_nutrition_program;

  /// No description provided for @family_member_permission_edit_meals_and_days_count.
  ///
  /// In en, this message translates to:
  /// **'Edit meals and days count'**
  String get family_member_permission_edit_meals_and_days_count;

  /// No description provided for @family_member_permission_edit_address.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get family_member_permission_edit_address;

  /// No description provided for @family_member_permission_replace_meal.
  ///
  /// In en, this message translates to:
  /// **'Replace meal'**
  String get family_member_permission_replace_meal;

  /// No description provided for @family_member_permission_view_reports_and_payments.
  ///
  /// In en, this message translates to:
  /// **'View reports and payments'**
  String get family_member_permission_view_reports_and_payments;

  /// No description provided for @family_member_permission_leave_family_plan.
  ///
  /// In en, this message translates to:
  /// **'Leave family plan'**
  String get family_member_permission_leave_family_plan;

  /// No description provided for @family_member_access_title.
  ///
  /// In en, this message translates to:
  /// **'Access management for {memberName}'**
  String family_member_access_title(String memberName);

  /// No description provided for @family_member_access_status_title.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get family_member_access_status_title;

  /// No description provided for @family_member_access_status_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get family_member_access_status_active;

  /// No description provided for @family_member_access_status_paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get family_member_access_status_paused;

  /// No description provided for @family_member_access_permissions_tile_title.
  ///
  /// In en, this message translates to:
  /// **'App Usage Permissions'**
  String get family_member_access_permissions_tile_title;

  /// No description provided for @family_member_access_permissions_tile_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Control meal selection, replacement, and address editing'**
  String get family_member_access_permissions_tile_subtitle;

  /// No description provided for @family_member_access_last_login.
  ///
  /// In en, this message translates to:
  /// **'Last login {timeAgo}'**
  String family_member_access_last_login(String timeAgo);

  /// No description provided for @family_member_access_credentials_section.
  ///
  /// In en, this message translates to:
  /// **'Login Credentials'**
  String get family_member_access_credentials_section;

  /// No description provided for @family_member_access_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get family_member_access_email_label;

  /// No description provided for @family_member_access_password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get family_member_access_password_label;

  /// No description provided for @family_member_access_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get family_member_access_edit;

  /// No description provided for @family_member_access_independent_title.
  ///
  /// In en, this message translates to:
  /// **'Has Independent Account'**
  String get family_member_access_independent_title;

  /// No description provided for @family_member_access_independent_subtitle.
  ///
  /// In en, this message translates to:
  /// **'When enabled, {memberName} can log in and independently manage meals and settings'**
  String family_member_access_independent_subtitle(String memberName);

  /// No description provided for @family_member_access_membership_section.
  ///
  /// In en, this message translates to:
  /// **'Membership Management'**
  String get family_member_access_membership_section;

  /// No description provided for @family_member_access_membership_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Control {memberName}\'s membership status in the family plan'**
  String family_member_access_membership_subtitle(String memberName);

  /// No description provided for @family_member_access_active_desc.
  ///
  /// In en, this message translates to:
  /// **'Can access all features and use the plan'**
  String get family_member_access_active_desc;

  /// No description provided for @family_member_access_paused_desc.
  ///
  /// In en, this message translates to:
  /// **'Access is temporarily suspended while retaining data and settings'**
  String get family_member_access_paused_desc;

  /// No description provided for @family_member_access_deactivate_button.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Account'**
  String get family_member_access_deactivate_button;

  /// No description provided for @family_member_access_deactivate_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Member Account'**
  String get family_member_access_deactivate_confirm_title;

  /// No description provided for @family_member_access_deactivate_confirm_desc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate {memberName}\'s account? Access to the plan will be suspended.'**
  String family_member_access_deactivate_confirm_desc(String memberName);

  /// No description provided for @family_member_access_deactivate_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get family_member_access_deactivate_cancel;

  /// No description provided for @family_member_access_deactivate_confirm_action.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deactivation'**
  String get family_member_access_deactivate_confirm_action;

  /// No description provided for @family_member_access_save_button.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get family_member_access_save_button;

  /// No description provided for @family_member_access_save_success.
  ///
  /// In en, this message translates to:
  /// **'Access changes saved successfully'**
  String get family_member_access_save_success;

  /// No description provided for @family_member_permissions_save_success.
  ///
  /// In en, this message translates to:
  /// **'Permissions saved successfully'**
  String get family_member_permissions_save_success;

  /// No description provided for @family_member_renewal_success.
  ///
  /// In en, this message translates to:
  /// **'Renewal request submitted successfully'**
  String get family_member_renewal_success;

  /// No description provided for @family_members_title.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get family_members_title;

  /// No description provided for @family_members_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for a member'**
  String get family_members_search_hint;

  /// No description provided for @family_members_add_member.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get family_members_add_member;

  /// No description provided for @family_member_has_account.
  ///
  /// In en, this message translates to:
  /// **'Has account'**
  String get family_member_has_account;

  /// No description provided for @family_member_all_meals_manager.
  ///
  /// In en, this message translates to:
  /// **'All meals managed by manager'**
  String get family_member_all_meals_manager;

  /// No description provided for @family_member_some_meals_customized.
  ///
  /// In en, this message translates to:
  /// **'Some meals customized'**
  String get family_member_some_meals_customized;

  /// No description provided for @family_member_no_plan_selected.
  ///
  /// In en, this message translates to:
  /// **'No plan selected'**
  String get family_member_no_plan_selected;

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

  /// No description provided for @family_edit_member.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get family_edit_member;

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

  /// No description provided for @family_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get family_phone_number;

  /// No description provided for @family_phone_number_hint.
  ///
  /// In en, this message translates to:
  /// **'+965 0000 0000'**
  String get family_phone_number_hint;

  /// No description provided for @family_phone_lookup.
  ///
  /// In en, this message translates to:
  /// **'Find member'**
  String get family_phone_lookup;

  /// No description provided for @family_error_already_in_family.
  ///
  /// In en, this message translates to:
  /// **'This phone number already belongs to another family.'**
  String get family_error_already_in_family;

  /// No description provided for @family_error_plan_locked.
  ///
  /// In en, this message translates to:
  /// **'This member already has an active subscription. Their plan cannot be changed here.'**
  String get family_error_plan_locked;

  /// No description provided for @family_error_plan_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Complete this member\'s program, package, tier, and duration.'**
  String get family_error_plan_incomplete;

  /// No description provided for @family_error_member_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one member and complete their subscription details.'**
  String get family_error_member_incomplete;

  /// No description provided for @family_occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get family_occupation;

  /// No description provided for @family_occupation_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter occupation (optional)'**
  String get family_occupation_hint;

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

  /// No description provided for @family_relation_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter relationship'**
  String get family_relation_input_hint;

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

  /// No description provided for @family_age_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an age between 1 and 120'**
  String get family_age_invalid;

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

  /// No description provided for @family_delete_member_confirmation_title.
  ///
  /// In en, this message translates to:
  /// **'Delete member?'**
  String get family_delete_member_confirmation_title;

  /// No description provided for @family_delete_member_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this member?'**
  String get family_delete_member_confirmation_message;

  /// No description provided for @family_delete_member_success.
  ///
  /// In en, this message translates to:
  /// **'Member deleted successfully'**
  String get family_delete_member_success;

  /// No description provided for @family_add_member_success.
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get family_add_member_success;

  /// No description provided for @family_update_member_success.
  ///
  /// In en, this message translates to:
  /// **'Member updated successfully'**
  String get family_update_member_success;

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

  /// No description provided for @family_step_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get family_step_location;

  /// No description provided for @family_step_allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get family_step_allergies;

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

  /// No description provided for @family_setup_step_four.
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get family_setup_step_four;

  /// No description provided for @family_setup_step_five.
  ///
  /// In en, this message translates to:
  /// **'5'**
  String get family_setup_step_five;

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

  /// No description provided for @family_new_members_subtotal.
  ///
  /// In en, this message translates to:
  /// **'New members subtotal'**
  String get family_new_members_subtotal;

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

  /// No description provided for @calendar_empty_meals_title.
  ///
  /// In en, this message translates to:
  /// **'No meals right now'**
  String get calendar_empty_meals_title;

  /// No description provided for @calendar_empty_meals_description.
  ///
  /// In en, this message translates to:
  /// **'You have not added any meals yet.\nStart now by adding your healthy meals.'**
  String get calendar_empty_meals_description;

  /// No description provided for @calendar_empty_meals_button.
  ///
  /// In en, this message translates to:
  /// **'Add meals'**
  String get calendar_empty_meals_button;

  /// No description provided for @calendar_no_subscription_title.
  ///
  /// In en, this message translates to:
  /// **'No meals yet'**
  String get calendar_no_subscription_title;

  /// No description provided for @calendar_no_subscription_description.
  ///
  /// In en, this message translates to:
  /// **'It looks like you are not subscribed to a plan.\nSubscribe now and enjoy healthy meals suited to your goals.'**
  String get calendar_no_subscription_description;

  /// No description provided for @calendar_no_subscription_button.
  ///
  /// In en, this message translates to:
  /// **'View subscriptions'**
  String get calendar_no_subscription_button;

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

  /// No description provided for @calendar_daily_nutrition_total.
  ///
  /// In en, this message translates to:
  /// **'Total nutrition for this day'**
  String get calendar_daily_nutrition_total;

  /// No description provided for @calendar_usual_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Usual delivery time'**
  String get calendar_usual_delivery_time;

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

  /// No description provided for @calendar_meals_changed.
  ///
  /// In en, this message translates to:
  /// **'Meal changed'**
  String get calendar_meals_changed;

  /// No description provided for @calendar_selection_locked_before_72_hours.
  ///
  /// In en, this message translates to:
  /// **'Last change is 72 hours before delivery'**
  String get calendar_selection_locked_before_72_hours;

  /// No description provided for @family_member_day_closed_button.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get family_member_day_closed_button;

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

  /// No description provided for @calendar_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get calendar_done;

  /// No description provided for @calendar_meals_save_success.
  ///
  /// In en, this message translates to:
  /// **'Meal added successfully.'**
  String get calendar_meals_save_success;

  /// No description provided for @calendar_confirm_meals.
  ///
  /// In en, this message translates to:
  /// **'Confirm Meals'**
  String get calendar_confirm_meals;

  /// No description provided for @calendar_confirm_selections.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selections'**
  String get calendar_confirm_selections;

  /// No description provided for @calendar_confirm_selection_header.
  ///
  /// In en, this message translates to:
  /// **'Confirm Meal Selection'**
  String get calendar_confirm_selection_header;

  /// No description provided for @calendar_confirm_meals_success.
  ///
  /// In en, this message translates to:
  /// **'Meals sent to the restaurant for review'**
  String get calendar_confirm_meals_success;

  /// No description provided for @calendar_confirmed_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Meals Confirmed'**
  String get calendar_confirmed_sheet_title;

  /// No description provided for @calendar_confirmed_sheet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your selections have been saved successfully and meals will be prepared for the selected day.'**
  String get calendar_confirmed_sheet_subtitle;

  /// No description provided for @calendar_confirmed_sheet_status_label.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get calendar_confirmed_sheet_status_label;

  /// No description provided for @calendar_status_awaiting_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Restaurant Confirmation'**
  String get calendar_status_awaiting_restaurant;

  /// No description provided for @calendar_confirmed_sheet_note.
  ///
  /// In en, this message translates to:
  /// **'You can edit meals before the daily cutoff time.'**
  String get calendar_confirmed_sheet_note;

  /// No description provided for @calendar_confirmed_sheet_back_to_calendar.
  ///
  /// In en, this message translates to:
  /// **'Back to Calendar'**
  String get calendar_confirmed_sheet_back_to_calendar;

  /// No description provided for @calendar_confirmed_sheet_view_meals.
  ///
  /// In en, this message translates to:
  /// **'View Meals'**
  String get calendar_confirmed_sheet_view_meals;

  /// No description provided for @calendar_error_box_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Please select all required meals first'**
  String get calendar_error_box_incomplete;

  /// No description provided for @calendar_error_selection_locked.
  ///
  /// In en, this message translates to:
  /// **'This day is locked and can no longer be edited'**
  String get calendar_error_selection_locked;

  /// No description provided for @calendar_error_day_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This day is currently unavailable'**
  String get calendar_error_day_unavailable;

  /// No description provided for @calendar_error_fulfillment_not_ready.
  ///
  /// In en, this message translates to:
  /// **'Subscription is not ready yet, please try again later'**
  String get calendar_error_fulfillment_not_ready;

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

  /// No description provided for @profile_settings_language_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get profile_settings_language_sheet_title;

  /// No description provided for @profile_settings_language_arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get profile_settings_language_arabic;

  /// No description provided for @profile_settings_language_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profile_settings_language_english;

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

  /// No description provided for @wallet_title.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet_title;

  /// No description provided for @wallet_total_refundable_balance_title.
  ///
  /// In en, this message translates to:
  /// **'Total refundable balance'**
  String get wallet_total_refundable_balance_title;

  /// No description provided for @wallet_total_refundable_balance_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Balance from subscription cancellations or settlements'**
  String get wallet_total_refundable_balance_subtitle;

  /// No description provided for @wallet_transactions_history.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get wallet_transactions_history;

  /// No description provided for @wallet_refund_to_card.
  ///
  /// In en, this message translates to:
  /// **'Refund to card'**
  String get wallet_refund_to_card;

  /// No description provided for @wallet_important_info_title.
  ///
  /// In en, this message translates to:
  /// **'Important information'**
  String get wallet_important_info_title;

  /// No description provided for @wallet_important_info_body.
  ///
  /// In en, this message translates to:
  /// **'This balance is only for receiving refunded amounts\nfrom subscription cancellations or special settlements.\nYou cannot top up the wallet or add amounts to it.'**
  String get wallet_important_info_body;

  /// No description provided for @wallet_recent_transactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get wallet_recent_transactions;

  /// No description provided for @wallet_view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get wallet_view_all;

  /// No description provided for @wallet_security_note.
  ///
  /// In en, this message translates to:
  /// **'We protect your data and transactions according to the highest security standards'**
  String get wallet_security_note;

  /// No description provided for @wallet_refundable_balance.
  ///
  /// In en, this message translates to:
  /// **'Refundable balance'**
  String get wallet_refundable_balance;

  /// No description provided for @wallet_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String wallet_last_updated(String date);

  /// No description provided for @wallet_filter_settlements.
  ///
  /// In en, this message translates to:
  /// **'Settlements'**
  String get wallet_filter_settlements;

  /// No description provided for @wallet_filter_card_refund.
  ///
  /// In en, this message translates to:
  /// **'Card refunds'**
  String get wallet_filter_card_refund;

  /// No description provided for @wallet_filter_refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get wallet_filter_refunds;

  /// No description provided for @wallet_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get wallet_filter_all;

  /// No description provided for @wallet_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get wallet_search_hint;

  /// No description provided for @wallet_group_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get wallet_group_today;

  /// No description provided for @wallet_group_this_week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get wallet_group_this_week;

  /// No description provided for @wallet_group_april_2026.
  ///
  /// In en, this message translates to:
  /// **'April 2026'**
  String get wallet_group_april_2026;

  /// No description provided for @wallet_transactions_notice.
  ///
  /// In en, this message translates to:
  /// **'Transaction history contains payments, refunds,\nand wallet settlements only.'**
  String get wallet_transactions_notice;

  /// No description provided for @wallet_status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get wallet_status_completed;

  /// No description provided for @wallet_status_processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get wallet_status_processing;

  /// No description provided for @wallet_select_card.
  ///
  /// In en, this message translates to:
  /// **'Choose card'**
  String get wallet_select_card;

  /// No description provided for @wallet_refund_notice_body.
  ///
  /// In en, this message translates to:
  /// **'• The amount will be deducted from your wallet balance when the request is sent\n• You cannot undo after processing starts'**
  String get wallet_refund_notice_body;

  /// No description provided for @wallet_order_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get wallet_order_summary_title;

  /// No description provided for @wallet_confirm_refund.
  ///
  /// In en, this message translates to:
  /// **'Confirm refund request'**
  String get wallet_confirm_refund;

  /// No description provided for @wallet_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get wallet_cancel;

  /// No description provided for @wallet_refund_available_balance.
  ///
  /// In en, this message translates to:
  /// **'Available refundable balance'**
  String get wallet_refund_available_balance;

  /// No description provided for @wallet_refund_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'The amount will be transferred to your card within 3-7 business days'**
  String get wallet_refund_hero_subtitle;

  /// No description provided for @wallet_refund_amount.
  ///
  /// In en, this message translates to:
  /// **'Refund amount'**
  String get wallet_refund_amount;

  /// No description provided for @wallet_refund_custom_amount.
  ///
  /// In en, this message translates to:
  /// **'Custom amount'**
  String get wallet_refund_custom_amount;

  /// No description provided for @wallet_refund_full_balance.
  ///
  /// In en, this message translates to:
  /// **'Full balance'**
  String get wallet_refund_full_balance;

  /// No description provided for @wallet_summary_receiving_card.
  ///
  /// In en, this message translates to:
  /// **'Receiving card'**
  String get wallet_summary_receiving_card;

  /// No description provided for @wallet_summary_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get wallet_summary_amount;

  /// No description provided for @wallet_summary_fees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get wallet_summary_fees;

  /// No description provided for @wallet_summary_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get wallet_summary_free;

  /// No description provided for @wallet_summary_expected_receipt.
  ///
  /// In en, this message translates to:
  /// **'Expected receipt'**
  String get wallet_summary_expected_receipt;

  /// No description provided for @wallet_summary_expected_receipt_value.
  ///
  /// In en, this message translates to:
  /// **'Within 7-14 business days'**
  String get wallet_summary_expected_receipt_value;

  /// No description provided for @wallet_card_expires_at.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get wallet_card_expires_at;

  /// No description provided for @biometric_login_title.
  ///
  /// In en, this message translates to:
  /// **'Biometric Sign-In'**
  String get biometric_login_title;

  /// No description provided for @biometric_login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID or Fingerprint for quick access'**
  String get biometric_login_subtitle;

  /// No description provided for @biometric_face_id.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get biometric_face_id;

  /// No description provided for @biometric_fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get biometric_fingerprint;

  /// No description provided for @biometric_generic.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get biometric_generic;

  /// No description provided for @biometric_enable_reason.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to enable biometric sign-in'**
  String get biometric_enable_reason;

  /// No description provided for @biometric_auth_reason.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to sign in to your account'**
  String get biometric_auth_reason;

  /// No description provided for @biometric_enabled_success.
  ///
  /// In en, this message translates to:
  /// **'Biometric sign-in enabled successfully'**
  String get biometric_enabled_success;

  /// No description provided for @biometric_disabled_success.
  ///
  /// In en, this message translates to:
  /// **'Biometric sign-in disabled'**
  String get biometric_disabled_success;

  /// No description provided for @biometric_not_supported.
  ///
  /// In en, this message translates to:
  /// **'Biometrics are not supported on this device'**
  String get biometric_not_supported;

  /// No description provided for @biometric_not_enrolled.
  ///
  /// In en, this message translates to:
  /// **'No biometrics or Face ID enrolled on this device'**
  String get biometric_not_enrolled;

  /// No description provided for @biometric_locked_out.
  ///
  /// In en, this message translates to:
  /// **'Biometrics temporarily locked due to too many failed attempts'**
  String get biometric_locked_out;

  /// No description provided for @biometric_permanently_locked_out.
  ///
  /// In en, this message translates to:
  /// **'Biometrics permanently locked. Use device passcode.'**
  String get biometric_permanently_locked_out;

  /// No description provided for @biometric_failed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed, please try again'**
  String get biometric_failed;

  /// No description provided for @biometric_prompt_enable_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Enable Quick Sign-In'**
  String get biometric_prompt_enable_dialog_title;

  /// No description provided for @biometric_prompt_enable_dialog_body.
  ///
  /// In en, this message translates to:
  /// **'Would you like to enable Face ID / Fingerprint for quick login next time?'**
  String get biometric_prompt_enable_dialog_body;

  /// No description provided for @biometric_enable_button.
  ///
  /// In en, this message translates to:
  /// **'Enable Now'**
  String get biometric_enable_button;

  /// No description provided for @biometric_skip_button.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get biometric_skip_button;

  /// No description provided for @biometric_quick_login.
  ///
  /// In en, this message translates to:
  /// **'Biometric Sign-In'**
  String get biometric_quick_login;

  /// No description provided for @family_packages_selection_title.
  ///
  /// In en, this message translates to:
  /// **'Choose Family Package'**
  String get family_packages_selection_title;

  /// No description provided for @family_packages_selection_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the suitable size package for your family members to get the discount'**
  String get family_packages_selection_subtitle;

  /// No description provided for @family_package_members_range.
  ///
  /// In en, this message translates to:
  /// **'From {min} to {max} members'**
  String family_package_members_range(int min, int max);

  /// No description provided for @family_package_discount_badge.
  ///
  /// In en, this message translates to:
  /// **'{discount} discount'**
  String family_package_discount_badge(String discount);

  /// No description provided for @family_package_select_button.
  ///
  /// In en, this message translates to:
  /// **'Select Package'**
  String get family_package_select_button;

  /// No description provided for @family_package_continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue Family Setup'**
  String get family_package_continue_button;

  /// No description provided for @family_members_count_indicator.
  ///
  /// In en, this message translates to:
  /// **'{current} / {max} members'**
  String family_members_count_indicator(int current, int max);

  /// No description provided for @family_members_count_label.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get family_members_count_label;

  /// No description provided for @family_members_max_reached.
  ///
  /// In en, this message translates to:
  /// **'Maximum members limit reached for this package'**
  String get family_members_max_reached;

  /// No description provided for @family_members_min_warning.
  ///
  /// In en, this message translates to:
  /// **'Please add at least {min} members to activate this package discount and proceed to checkout'**
  String family_members_min_warning(int min);

  /// No description provided for @family_step_package_selection.
  ///
  /// In en, this message translates to:
  /// **'Size Package'**
  String get family_step_package_selection;

  /// No description provided for @family_gender_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get family_gender_male;

  /// No description provided for @family_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get family_gender;

  /// No description provided for @family_gender_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get family_gender_female;

  /// No description provided for @family_address_select.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get family_address_select;

  /// No description provided for @family_address_select_hint.
  ///
  /// In en, this message translates to:
  /// **'Select delivery address'**
  String get family_address_select_hint;

  /// No description provided for @family_tier_basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get family_tier_basic;

  /// No description provided for @family_tier_platinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get family_tier_platinum;

  /// No description provided for @family_tier_elite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get family_tier_elite;

  /// No description provided for @family_change_package.
  ///
  /// In en, this message translates to:
  /// **'Change Package'**
  String get family_change_package;

  /// No description provided for @family_packages_empty.
  ///
  /// In en, this message translates to:
  /// **'No family packages available at the moment'**
  String get family_packages_empty;

  /// No description provided for @family_restaurants_member_ahmed.
  ///
  /// In en, this message translates to:
  /// **'Ahmed'**
  String get family_restaurants_member_ahmed;

  /// No description provided for @family_restaurants_title.
  ///
  /// In en, this message translates to:
  /// **'{memberName}\'s restaurants'**
  String family_restaurants_title(String memberName);

  /// No description provided for @family_restaurants_suitable_title.
  ///
  /// In en, this message translates to:
  /// **'Restaurants suitable for {memberName}'**
  String family_restaurants_suitable_title(String memberName);

  /// No description provided for @profile_influencer_partner.
  ///
  /// In en, this message translates to:
  /// **'Influencer Partner'**
  String get profile_influencer_partner;

  /// No description provided for @profile_influencer_partner_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track referrals, links, and earnings'**
  String get profile_influencer_partner_subtitle;

  /// No description provided for @influencer_dashboard_title.
  ///
  /// In en, this message translates to:
  /// **'Influencer'**
  String get influencer_dashboard_title;

  /// No description provided for @influencer_user_name.
  ///
  /// In en, this message translates to:
  /// **'Hello, Mohamed'**
  String get influencer_user_name;

  /// No description provided for @influencer_partner_label.
  ///
  /// In en, this message translates to:
  /// **'Influencer Partner'**
  String get influencer_partner_label;

  /// No description provided for @influencer_statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get influencer_statistics;

  /// No description provided for @influencer_statistics_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your performance and business growth'**
  String get influencer_statistics_subtitle;

  /// No description provided for @influencer_tools.
  ///
  /// In en, this message translates to:
  /// **'Partner tools'**
  String get influencer_tools;

  /// No description provided for @influencer_total_earnings.
  ///
  /// In en, this message translates to:
  /// **'Total commissions'**
  String get influencer_total_earnings;

  /// No description provided for @influencer_total_earnings_value.
  ///
  /// In en, this message translates to:
  /// **'845'**
  String get influencer_total_earnings_value;

  /// No description provided for @influencer_period_7_days.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get influencer_period_7_days;

  /// No description provided for @influencer_period_30_days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get influencer_period_30_days;

  /// No description provided for @influencer_period_90_days.
  ///
  /// In en, this message translates to:
  /// **'90 days'**
  String get influencer_period_90_days;

  /// No description provided for @influencer_period_6_months.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get influencer_period_6_months;

  /// No description provided for @influencer_period_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get influencer_period_year;

  /// No description provided for @influencer_previous_30_days_comparison.
  ///
  /// In en, this message translates to:
  /// **'Compared with the previous 30 days'**
  String get influencer_previous_30_days_comparison;

  /// No description provided for @influencer_growth_percent.
  ///
  /// In en, this message translates to:
  /// **'+4.3%'**
  String get influencer_growth_percent;

  /// No description provided for @influencer_this_month.
  ///
  /// In en, this message translates to:
  /// **'Monthly goal'**
  String get influencer_this_month;

  /// No description provided for @influencer_referrals.
  ///
  /// In en, this message translates to:
  /// **'Registered customers'**
  String get influencer_referrals;

  /// No description provided for @influencer_referrals_value.
  ///
  /// In en, this message translates to:
  /// **'230'**
  String get influencer_referrals_value;

  /// No description provided for @influencer_active_codes.
  ///
  /// In en, this message translates to:
  /// **'This week 7+'**
  String get influencer_active_codes;

  /// No description provided for @influencer_conversion_rate.
  ///
  /// In en, this message translates to:
  /// **'Conversion rate'**
  String get influencer_conversion_rate;

  /// No description provided for @influencer_conversion_rate_value.
  ///
  /// In en, this message translates to:
  /// **'35%'**
  String get influencer_conversion_rate_value;

  /// No description provided for @influencer_from_visits.
  ///
  /// In en, this message translates to:
  /// **'This week 7+'**
  String get influencer_from_visits;

  /// No description provided for @influencer_pending_withdrawals.
  ///
  /// In en, this message translates to:
  /// **'Link clicks'**
  String get influencer_pending_withdrawals;

  /// No description provided for @influencer_pending_withdrawals_value.
  ///
  /// In en, this message translates to:
  /// **'520'**
  String get influencer_pending_withdrawals_value;

  /// No description provided for @influencer_under_review.
  ///
  /// In en, this message translates to:
  /// **'This week 7+'**
  String get influencer_under_review;

  /// No description provided for @influencer_completed_subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Completed subscriptions'**
  String get influencer_completed_subscriptions;

  /// No description provided for @influencer_completed_subscriptions_value.
  ///
  /// In en, this message translates to:
  /// **'81'**
  String get influencer_completed_subscriptions_value;

  /// No description provided for @influencer_generated_orders.
  ///
  /// In en, this message translates to:
  /// **'Generated orders'**
  String get influencer_generated_orders;

  /// No description provided for @influencer_generated_orders_value.
  ///
  /// In en, this message translates to:
  /// **'68'**
  String get influencer_generated_orders_value;

  /// No description provided for @influencer_overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get influencer_overview;

  /// No description provided for @influencer_revenue_growth.
  ///
  /// In en, this message translates to:
  /// **'Revenue growth'**
  String get influencer_revenue_growth;

  /// No description provided for @influencer_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get influencer_daily;

  /// No description provided for @influencer_earnings_label.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get influencer_earnings_label;

  /// No description provided for @influencer_top_products.
  ///
  /// In en, this message translates to:
  /// **'Top performing products'**
  String get influencer_top_products;

  /// No description provided for @influencer_top_product_name.
  ///
  /// In en, this message translates to:
  /// **'Complete diet box'**
  String get influencer_top_product_name;

  /// No description provided for @influencer_top_product_orders_value.
  ///
  /// In en, this message translates to:
  /// **'124'**
  String get influencer_top_product_orders_value;

  /// No description provided for @influencer_orders_label.
  ///
  /// In en, this message translates to:
  /// **'orders'**
  String get influencer_orders_label;

  /// No description provided for @influencer_product_revenue_label.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get influencer_product_revenue_label;

  /// No description provided for @influencer_top_product_revenue_value.
  ///
  /// In en, this message translates to:
  /// **'245 KWD'**
  String get influencer_top_product_revenue_value;

  /// No description provided for @influencer_chart_20_april.
  ///
  /// In en, this message translates to:
  /// **'20 Apr'**
  String get influencer_chart_20_april;

  /// No description provided for @influencer_chart_27_april.
  ///
  /// In en, this message translates to:
  /// **'27 Apr'**
  String get influencer_chart_27_april;

  /// No description provided for @influencer_chart_4_may.
  ///
  /// In en, this message translates to:
  /// **'4 May'**
  String get influencer_chart_4_may;

  /// No description provided for @influencer_chart_11_may.
  ///
  /// In en, this message translates to:
  /// **'11 May'**
  String get influencer_chart_11_may;

  /// No description provided for @influencer_chart_18_may.
  ///
  /// In en, this message translates to:
  /// **'18 May'**
  String get influencer_chart_18_may;

  /// No description provided for @influencer_chart_25_may.
  ///
  /// In en, this message translates to:
  /// **'25 May'**
  String get influencer_chart_25_may;

  /// No description provided for @influencer_weekly_commission_gain.
  ///
  /// In en, this message translates to:
  /// **'+35 KWD'**
  String get influencer_weekly_commission_gain;

  /// No description provided for @influencer_this_week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get influencer_this_week;

  /// No description provided for @influencer_month_goal_progress.
  ///
  /// In en, this message translates to:
  /// **'80%'**
  String get influencer_month_goal_progress;

  /// No description provided for @influencer_month_goal_value.
  ///
  /// In en, this message translates to:
  /// **'680 KWD / 850 KWD'**
  String get influencer_month_goal_value;

  /// No description provided for @influencer_view_details.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get influencer_view_details;

  /// No description provided for @influencer_share_links_title.
  ///
  /// In en, this message translates to:
  /// **'Share links'**
  String get influencer_share_links_title;

  /// No description provided for @influencer_share_links_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your link and code'**
  String get influencer_share_links_subtitle;

  /// No description provided for @influencer_social_connections_title.
  ///
  /// In en, this message translates to:
  /// **'Social accounts'**
  String get influencer_social_connections_title;

  /// No description provided for @influencer_social_connections_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your public channels'**
  String get influencer_social_connections_subtitle;

  /// No description provided for @influencer_wallet_title.
  ///
  /// In en, this message translates to:
  /// **'Earnings wallet'**
  String get influencer_wallet_title;

  /// No description provided for @influencer_wallet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View balance and transactions'**
  String get influencer_wallet_subtitle;

  /// No description provided for @influencer_wallet_figma_title.
  ///
  /// In en, this message translates to:
  /// **'My wallet'**
  String get influencer_wallet_figma_title;

  /// No description provided for @influencer_wallet_figma_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your earnings and financial transactions'**
  String get influencer_wallet_figma_subtitle;

  /// No description provided for @influencer_available_balance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get influencer_available_balance;

  /// No description provided for @influencer_total_earnings_colon.
  ///
  /// In en, this message translates to:
  /// **'Total earnings:'**
  String get influencer_total_earnings_colon;

  /// No description provided for @influencer_wallet_total_balance_value.
  ///
  /// In en, this message translates to:
  /// **'1.245'**
  String get influencer_wallet_total_balance_value;

  /// No description provided for @influencer_wallet_withdraw_action.
  ///
  /// In en, this message translates to:
  /// **'Withdraw earnings'**
  String get influencer_wallet_withdraw_action;

  /// No description provided for @influencer_wallet_history_action.
  ///
  /// In en, this message translates to:
  /// **'Transaction history'**
  String get influencer_wallet_history_action;

  /// No description provided for @influencer_wallet_month_summary.
  ///
  /// In en, this message translates to:
  /// **'This month\'s summary'**
  String get influencer_wallet_month_summary;

  /// No description provided for @influencer_wallet_summary_total_earnings.
  ///
  /// In en, this message translates to:
  /// **'Total earnings'**
  String get influencer_wallet_summary_total_earnings;

  /// No description provided for @influencer_wallet_summary_withdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get influencer_wallet_summary_withdrawn;

  /// No description provided for @influencer_wallet_withdrawn_value.
  ///
  /// In en, this message translates to:
  /// **'400'**
  String get influencer_wallet_withdrawn_value;

  /// No description provided for @influencer_wallet_latest_transactions.
  ///
  /// In en, this message translates to:
  /// **'Latest transactions'**
  String get influencer_wallet_latest_transactions;

  /// No description provided for @influencer_referral_code_title.
  ///
  /// In en, this message translates to:
  /// **'Your discount code'**
  String get influencer_referral_code_title;

  /// No description provided for @influencer_referral_code_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Earn more commissions'**
  String get influencer_referral_code_subtitle;

  /// No description provided for @influencer_referral_code_value.
  ///
  /// In en, this message translates to:
  /// **'AMMAR20'**
  String get influencer_referral_code_value;

  /// No description provided for @influencer_share_code_title.
  ///
  /// In en, this message translates to:
  /// **'Share your link and code'**
  String get influencer_share_code_title;

  /// No description provided for @influencer_recent_activities.
  ///
  /// In en, this message translates to:
  /// **'Recent activities'**
  String get influencer_recent_activities;

  /// No description provided for @influencer_view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get influencer_view_all;

  /// No description provided for @influencer_activity_first_user.
  ///
  /// In en, this message translates to:
  /// **'User #gdf55'**
  String get influencer_activity_first_user;

  /// No description provided for @influencer_activity_first_plan.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to a monthly package'**
  String get influencer_activity_first_plan;

  /// No description provided for @influencer_activity_second_user.
  ///
  /// In en, this message translates to:
  /// **'Mohamed Ali'**
  String get influencer_activity_second_user;

  /// No description provided for @influencer_activity_second_plan.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to a weekly package'**
  String get influencer_activity_second_plan;

  /// No description provided for @influencer_activity_third_user.
  ///
  /// In en, this message translates to:
  /// **'Abdullah Nasser'**
  String get influencer_activity_third_user;

  /// No description provided for @influencer_activity_third_plan.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to a monthly package'**
  String get influencer_activity_third_plan;

  /// No description provided for @influencer_activity_amount.
  ///
  /// In en, this message translates to:
  /// **'+5 KWD'**
  String get influencer_activity_amount;

  /// No description provided for @influencer_activity_time.
  ///
  /// In en, this message translates to:
  /// **'2 hours ago'**
  String get influencer_activity_time;

  /// No description provided for @influencer_tab_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get influencer_tab_home;

  /// No description provided for @influencer_tab_links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get influencer_tab_links;

  /// No description provided for @influencer_tab_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get influencer_tab_wallet;

  /// No description provided for @influencer_tab_stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get influencer_tab_stats;

  /// No description provided for @influencer_tab_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get influencer_tab_profile;

  /// No description provided for @influencer_share_links_header.
  ///
  /// In en, this message translates to:
  /// **'Share now'**
  String get influencer_share_links_header;

  /// No description provided for @influencer_share_links_body.
  ///
  /// In en, this message translates to:
  /// **'Share easily across social platforms'**
  String get influencer_share_links_body;

  /// No description provided for @influencer_share_now.
  ///
  /// In en, this message translates to:
  /// **'Share now'**
  String get influencer_share_now;

  /// No description provided for @influencer_add_social_accounts.
  ///
  /// In en, this message translates to:
  /// **'Add social accounts'**
  String get influencer_add_social_accounts;

  /// No description provided for @influencer_social_connections_header.
  ///
  /// In en, this message translates to:
  /// **'Add social accounts'**
  String get influencer_social_connections_header;

  /// No description provided for @influencer_social_connections_body.
  ///
  /// In en, this message translates to:
  /// **'Add your social accounts to start the partnership and earn more commissions'**
  String get influencer_social_connections_body;

  /// No description provided for @influencer_save_continue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get influencer_save_continue;

  /// No description provided for @influencer_skip_now.
  ///
  /// In en, this message translates to:
  /// **'Skip now'**
  String get influencer_skip_now;

  /// No description provided for @influencer_instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get influencer_instagram;

  /// No description provided for @influencer_tiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get influencer_tiktok;

  /// No description provided for @influencer_snapchat.
  ///
  /// In en, this message translates to:
  /// **'Snapchat'**
  String get influencer_snapchat;

  /// No description provided for @influencer_whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get influencer_whatsapp;

  /// No description provided for @influencer_telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get influencer_telegram;

  /// No description provided for @influencer_youtube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get influencer_youtube;

  /// No description provided for @influencer_tiktok_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your TikTok account'**
  String get influencer_tiktok_subtitle;

  /// No description provided for @influencer_instagram_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your Instagram account'**
  String get influencer_instagram_subtitle;

  /// No description provided for @influencer_whatsapp_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your WhatsApp Business number'**
  String get influencer_whatsapp_subtitle;

  /// No description provided for @influencer_telegram_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your Telegram account'**
  String get influencer_telegram_subtitle;

  /// No description provided for @influencer_youtube_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your YouTube channel'**
  String get influencer_youtube_subtitle;

  /// No description provided for @influencer_snapchat_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your Snapchat account'**
  String get influencer_snapchat_subtitle;

  /// No description provided for @influencer_social_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get influencer_social_add;

  /// No description provided for @influencer_social_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get influencer_social_edit;

  /// No description provided for @influencer_privacy_title.
  ///
  /// In en, this message translates to:
  /// **'We protect your data privacy'**
  String get influencer_privacy_title;

  /// No description provided for @influencer_privacy_body.
  ///
  /// In en, this message translates to:
  /// **'We only use your data to improve partnership opportunities and brand communication.'**
  String get influencer_privacy_body;

  /// No description provided for @influencer_enter_account.
  ///
  /// In en, this message translates to:
  /// **'Enter account handle or link'**
  String get influencer_enter_account;

  /// No description provided for @influencer_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get influencer_confirm;

  /// No description provided for @influencer_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get influencer_cancel;

  /// No description provided for @influencer_not_connected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get influencer_not_connected;

  /// No description provided for @influencer_currency.
  ///
  /// In en, this message translates to:
  /// **'KWD'**
  String get influencer_currency;

  /// No description provided for @influencer_wallet_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last updated today at 09:15 AM'**
  String get influencer_wallet_last_updated;

  /// No description provided for @influencer_available_earnings.
  ///
  /// In en, this message translates to:
  /// **'Available earnings'**
  String get influencer_available_earnings;

  /// No description provided for @influencer_request_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Request withdrawal'**
  String get influencer_request_withdraw;

  /// No description provided for @influencer_request_withdraw_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer earnings to your bank account'**
  String get influencer_request_withdraw_subtitle;

  /// No description provided for @influencer_withdraw_history_title.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal history'**
  String get influencer_withdraw_history_title;

  /// No description provided for @influencer_withdraw_history_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track previous and pending requests'**
  String get influencer_withdraw_history_subtitle;

  /// No description provided for @influencer_recent_commissions.
  ///
  /// In en, this message translates to:
  /// **'Recent commissions'**
  String get influencer_recent_commissions;

  /// No description provided for @influencer_withdraw_arrival_hint.
  ///
  /// In en, this message translates to:
  /// **'The amount will be reviewed before transfer'**
  String get influencer_withdraw_arrival_hint;

  /// No description provided for @influencer_withdraw_method.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal method'**
  String get influencer_withdraw_method;

  /// No description provided for @influencer_withdraw_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Profits'**
  String get influencer_withdraw_screen_title;

  /// No description provided for @influencer_withdraw_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select withdrawal method and enter details'**
  String get influencer_withdraw_screen_subtitle;

  /// No description provided for @influencer_available_for_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Available balance for withdrawal'**
  String get influencer_available_for_withdraw;

  /// No description provided for @influencer_choose_withdraw_method.
  ///
  /// In en, this message translates to:
  /// **'Select withdrawal method'**
  String get influencer_choose_withdraw_method;

  /// No description provided for @influencer_bank_transfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get influencer_bank_transfer;

  /// No description provided for @influencer_bank_transfer_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer to your bank account'**
  String get influencer_bank_transfer_subtitle;

  /// No description provided for @influencer_electronic_wallet.
  ///
  /// In en, this message translates to:
  /// **'Electronic Wallet'**
  String get influencer_electronic_wallet;

  /// No description provided for @influencer_electronic_wallet_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer to your electronic wallet'**
  String get influencer_electronic_wallet_subtitle;

  /// No description provided for @influencer_bank_transfer_details.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer Details'**
  String get influencer_bank_transfer_details;

  /// No description provided for @influencer_account_holder_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get influencer_account_holder_hint;

  /// No description provided for @influencer_iban_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter IBAN number'**
  String get influencer_iban_hint;

  /// No description provided for @influencer_select_bank_hint.
  ///
  /// In en, this message translates to:
  /// **'Select bank'**
  String get influencer_select_bank_hint;

  /// No description provided for @influencer_withdraw_notice_text.
  ///
  /// In en, this message translates to:
  /// **'The full amount will be transferred to your account. The operation may take 1 to 3 business days'**
  String get influencer_withdraw_notice_text;

  /// No description provided for @influencer_bank_account_holder.
  ///
  /// In en, this message translates to:
  /// **'Account holder name'**
  String get influencer_bank_account_holder;

  /// No description provided for @influencer_bank_account_holder_value.
  ///
  /// In en, this message translates to:
  /// **'Mohamed Ahmed'**
  String get influencer_bank_account_holder_value;

  /// No description provided for @influencer_bank_iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get influencer_bank_iban;

  /// No description provided for @influencer_bank_iban_value.
  ///
  /// In en, this message translates to:
  /// **'KW81CBKU0000000000001234560101'**
  String get influencer_bank_iban_value;

  /// No description provided for @influencer_bank_name.
  ///
  /// In en, this message translates to:
  /// **'Bank name'**
  String get influencer_bank_name;

  /// No description provided for @influencer_bank_name_value.
  ///
  /// In en, this message translates to:
  /// **'Kuwait National Bank'**
  String get influencer_bank_name_value;

  /// No description provided for @influencer_continue_review.
  ///
  /// In en, this message translates to:
  /// **'Continue to review'**
  String get influencer_continue_review;

  /// No description provided for @influencer_withdraw_review_title.
  ///
  /// In en, this message translates to:
  /// **'Review withdrawal request'**
  String get influencer_withdraw_review_title;

  /// No description provided for @influencer_withdraw_review_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Review your request details before confirming'**
  String get influencer_withdraw_review_subtitle;

  /// No description provided for @influencer_withdraw_amount.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal amount'**
  String get influencer_withdraw_amount;

  /// No description provided for @influencer_confirm_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Confirm withdrawal request'**
  String get influencer_confirm_withdraw;

  /// No description provided for @influencer_transfer_details.
  ///
  /// In en, this message translates to:
  /// **'Transfer Details'**
  String get influencer_transfer_details;

  /// No description provided for @influencer_bank_label.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get influencer_bank_label;

  /// No description provided for @influencer_account_number.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get influencer_account_number;

  /// No description provided for @influencer_account_number_sample.
  ///
  /// In en, this message translates to:
  /// **'**** **** **** 1234'**
  String get influencer_account_number_sample;

  /// No description provided for @influencer_iban_with_label.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get influencer_iban_with_label;

  /// No description provided for @influencer_operation_summary.
  ///
  /// In en, this message translates to:
  /// **'Operation Summary'**
  String get influencer_operation_summary;

  /// No description provided for @influencer_requested_withdraw_amount.
  ///
  /// In en, this message translates to:
  /// **'Requested withdrawal amount'**
  String get influencer_requested_withdraw_amount;

  /// No description provided for @influencer_transfer_fees.
  ///
  /// In en, this message translates to:
  /// **'Transfer fees'**
  String get influencer_transfer_fees;

  /// No description provided for @influencer_transfer_fees_value.
  ///
  /// In en, this message translates to:
  /// **'0.000 KWD'**
  String get influencer_transfer_fees_value;

  /// No description provided for @influencer_final_received_amount.
  ///
  /// In en, this message translates to:
  /// **'Final received amount'**
  String get influencer_final_received_amount;

  /// No description provided for @influencer_important_info.
  ///
  /// In en, this message translates to:
  /// **'Important Information'**
  String get influencer_important_info;

  /// No description provided for @influencer_important_info_message.
  ///
  /// In en, this message translates to:
  /// **'The full amount will be transferred to your bank account. The operation may take 1 to 3 business days'**
  String get influencer_important_info_message;

  /// No description provided for @influencer_back_button.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get influencer_back_button;

  /// No description provided for @influencer_transaction_subscription_commission.
  ///
  /// In en, this message translates to:
  /// **'Subscription commission'**
  String get influencer_transaction_subscription_commission;

  /// No description provided for @influencer_transaction_withdraw_request.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request'**
  String get influencer_transaction_withdraw_request;

  /// No description provided for @influencer_transaction_referral_bonus.
  ///
  /// In en, this message translates to:
  /// **'Referral bonus'**
  String get influencer_transaction_referral_bonus;

  /// No description provided for @influencer_transaction_new_referral.
  ///
  /// In en, this message translates to:
  /// **'New referral'**
  String get influencer_transaction_new_referral;

  /// No description provided for @influencer_transaction_bank_withdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal to bank account'**
  String get influencer_transaction_bank_withdrawal;

  /// No description provided for @influencer_transaction_premium_order_completed.
  ///
  /// In en, this message translates to:
  /// **'Premium order completed'**
  String get influencer_transaction_premium_order_completed;

  /// No description provided for @influencer_transaction_25_may_2025.
  ///
  /// In en, this message translates to:
  /// **'25 May 2025'**
  String get influencer_transaction_25_may_2025;

  /// No description provided for @influencer_transaction_amount_positive_120.
  ///
  /// In en, this message translates to:
  /// **'+120 KWD'**
  String get influencer_transaction_amount_positive_120;

  /// No description provided for @influencer_transaction_amount_negative_120.
  ///
  /// In en, this message translates to:
  /// **'-120 KWD'**
  String get influencer_transaction_amount_negative_120;

  /// No description provided for @influencer_transaction_today.
  ///
  /// In en, this message translates to:
  /// **'Today, 09:15 AM'**
  String get influencer_transaction_today;

  /// No description provided for @influencer_transaction_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, 02:40 PM'**
  String get influencer_transaction_yesterday;

  /// No description provided for @influencer_transaction_week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get influencer_transaction_week;

  /// No description provided for @influencer_transaction_amount_large.
  ///
  /// In en, this message translates to:
  /// **'+24.000 KWD'**
  String get influencer_transaction_amount_large;

  /// No description provided for @influencer_transaction_amount_medium.
  ///
  /// In en, this message translates to:
  /// **'-32.500 KWD'**
  String get influencer_transaction_amount_medium;

  /// No description provided for @influencer_transaction_amount_small.
  ///
  /// In en, this message translates to:
  /// **'+6.250 KWD'**
  String get influencer_transaction_amount_small;

  /// No description provided for @billing_freeze_rules_title.
  ///
  /// In en, this message translates to:
  /// **'Freeze Policy & Rules'**
  String get billing_freeze_rules_title;

  /// No description provided for @billing_confirm_overwrite_selections_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Meal Selections Cancellation'**
  String get billing_confirm_overwrite_selections_title;

  /// No description provided for @billing_confirm_overwrite_selections_message.
  ///
  /// In en, this message translates to:
  /// **'You have selected meals on days within the freeze period. These selections will be cancelled and compensatory days will be added at the end of your subscription. Do you want to continue?'**
  String get billing_confirm_overwrite_selections_message;

  /// No description provided for @calendar_selection_locked.
  ///
  /// In en, this message translates to:
  /// **'Modifications are locked for this day.'**
  String get calendar_selection_locked;

  /// No description provided for @calendar_day_frozen_title.
  ///
  /// In en, this message translates to:
  /// **'This day is frozen'**
  String get calendar_day_frozen_title;

  /// No description provided for @calendar_day_frozen_description.
  ///
  /// In en, this message translates to:
  /// **'Meal preparation and delivery are temporarily paused for this day. You can unfreeze it to resume meals.'**
  String get calendar_day_frozen_description;

  /// No description provided for @calendar_day_frozen_badge.
  ///
  /// In en, this message translates to:
  /// **'Day frozen'**
  String get calendar_day_frozen_badge;

  /// No description provided for @subscription_day_frozen.
  ///
  /// In en, this message translates to:
  /// **'This day is frozen as part of your subscription freeze.'**
  String get subscription_day_frozen;

  /// No description provided for @billing_pending_freeze_title.
  ///
  /// In en, this message translates to:
  /// **'Subscription Freeze Details'**
  String get billing_pending_freeze_title;

  /// No description provided for @billing_pending_freeze_message.
  ///
  /// In en, this message translates to:
  /// **'Your subscription freeze is active. Start and end dates are detailed below:'**
  String get billing_pending_freeze_message;

  /// No description provided for @billing_pending_freeze_start_date.
  ///
  /// In en, this message translates to:
  /// **'Freeze start date'**
  String get billing_pending_freeze_start_date;

  /// No description provided for @billing_pending_freeze_end_date.
  ///
  /// In en, this message translates to:
  /// **'Freeze end date'**
  String get billing_pending_freeze_end_date;

  /// No description provided for @billing_pending_freeze_days.
  ///
  /// In en, this message translates to:
  /// **'Duration: {days} days'**
  String billing_pending_freeze_days(int days);

  /// No description provided for @billing_pending_freeze_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get billing_pending_freeze_status;

  /// No description provided for @billing_pending_freeze_notice_banner.
  ///
  /// In en, this message translates to:
  /// **'Subscription frozen from {startDate} to {endDate}'**
  String billing_pending_freeze_notice_banner(String startDate, String endDate);

  /// No description provided for @billing_status_approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get billing_status_approved;

  /// No description provided for @billing_active_freeze_service_days.
  ///
  /// In en, this message translates to:
  /// **'Frozen service days: {days}'**
  String billing_active_freeze_service_days(int days);

  /// No description provided for @billing_active_freeze_compensation_days.
  ///
  /// In en, this message translates to:
  /// **'Compensation days: {days}'**
  String billing_active_freeze_compensation_days(int days);

  /// No description provided for @billing_active_freeze_new_end_date.
  ///
  /// In en, this message translates to:
  /// **'New end date: {date}'**
  String billing_active_freeze_new_end_date(String date);

  /// No description provided for @billing_active_freeze_compensation_dates.
  ///
  /// In en, this message translates to:
  /// **'Compensation dates'**
  String get billing_active_freeze_compensation_dates;

  /// No description provided for @address_restaurant_does_not_service_region.
  ///
  /// In en, this message translates to:
  /// **'The currently subscribed restaurant does not deliver to this area. Please select another address.'**
  String get address_restaurant_does_not_service_region;

  /// No description provided for @address_coverage_notice_title.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Coverage Notice'**
  String get address_coverage_notice_title;

  /// No description provided for @address_no_serving_restaurants.
  ///
  /// In en, this message translates to:
  /// **'No restaurants currently serve this area'**
  String get address_no_serving_restaurants;

  /// No description provided for @address_serving_restaurants_title.
  ///
  /// In en, this message translates to:
  /// **'Restaurants serving your new area'**
  String get address_serving_restaurants_title;

  /// No description provided for @address_coverage_notice_action.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get address_coverage_notice_action;

  /// No description provided for @address_preview_check_button.
  ///
  /// In en, this message translates to:
  /// **'Continue & Check Coverage'**
  String get address_preview_check_button;

  /// No description provided for @address_coverage_covered_title.
  ///
  /// In en, this message translates to:
  /// **'Your area is covered by your subscription'**
  String get address_coverage_covered_title;

  /// No description provided for @address_coverage_uncovered_title.
  ///
  /// In en, this message translates to:
  /// **'Area not covered by your subscription'**
  String get address_coverage_uncovered_title;

  /// No description provided for @address_coverage_confirm_save.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Save Address'**
  String get address_coverage_confirm_save;

  /// No description provided for @address_coverage_confirm_set_default.
  ///
  /// In en, this message translates to:
  /// **'Confirm Set as Default'**
  String get address_coverage_confirm_set_default;

  /// No description provided for @address_coverage_choose_another.
  ///
  /// In en, this message translates to:
  /// **'Choose Another Location'**
  String get address_coverage_choose_another;

  /// No description provided for @address_coverage_uncovered_desc.
  ///
  /// In en, this message translates to:
  /// **'Your current subscription restaurant does not deliver to this area.'**
  String get address_coverage_uncovered_desc;

  /// No description provided for @upgrade_summary_operational_title.
  ///
  /// In en, this message translates to:
  /// **'Upgrade activation details'**
  String get upgrade_summary_operational_title;

  /// No description provided for @upgrade_summary_effective_date.
  ///
  /// In en, this message translates to:
  /// **'Activation start date'**
  String get upgrade_summary_effective_date;

  /// No description provided for @upgrade_summary_repetition.
  ///
  /// In en, this message translates to:
  /// **'You can repeat a restaurant up to {limit} times during {days} days'**
  String upgrade_summary_repetition(int limit, int days);

  /// No description provided for @upgrade_summary_new_restaurants.
  ///
  /// In en, this message translates to:
  /// **'New restaurants joining your package'**
  String get upgrade_summary_new_restaurants;

  /// No description provided for @upgrade_summary_no_new_restaurants.
  ///
  /// In en, this message translates to:
  /// **'No additional restaurants in this tier'**
  String get upgrade_summary_no_new_restaurants;

  /// No description provided for @upgrade_summary_load_error.
  ///
  /// In en, this message translates to:
  /// **'Unable to load the upgrade summary. Please try again.'**
  String get upgrade_summary_load_error;

  /// No description provided for @billing_uncompleted_title.
  ///
  /// In en, this message translates to:
  /// **'Incomplete subscriptions'**
  String get billing_uncompleted_title;

  /// No description provided for @billing_uncompleted_hold_active.
  ///
  /// In en, this message translates to:
  /// **'Your reservation is held temporarily'**
  String get billing_uncompleted_hold_active;

  /// No description provided for @billing_uncompleted_hold_expired.
  ///
  /// In en, this message translates to:
  /// **'Reservation hold expired'**
  String get billing_uncompleted_hold_expired;

  /// No description provided for @billing_uncompleted_duration.
  ///
  /// In en, this message translates to:
  /// **'Subscription duration'**
  String get billing_uncompleted_duration;

  /// No description provided for @billing_uncompleted_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get billing_uncompleted_days;

  /// No description provided for @billing_uncompleted_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get billing_uncompleted_delete;

  /// No description provided for @billing_uncompleted_resume.
  ///
  /// In en, this message translates to:
  /// **'Complete subscription'**
  String get billing_uncompleted_resume;

  /// No description provided for @billing_uncompleted_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete incomplete subscription?'**
  String get billing_uncompleted_delete_title;

  /// No description provided for @billing_uncompleted_delete_message.
  ///
  /// In en, this message translates to:
  /// **'This draft and its temporary reservation will be cancelled.'**
  String get billing_uncompleted_delete_message;

  /// No description provided for @billing_uncompleted_delete_success.
  ///
  /// In en, this message translates to:
  /// **'Incomplete subscription deleted'**
  String get billing_uncompleted_delete_success;

  /// No description provided for @billing_uncompleted_resume_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm subscription start date'**
  String get billing_uncompleted_resume_title;

  /// No description provided for @billing_uncompleted_resume_message.
  ///
  /// In en, this message translates to:
  /// **'The temporary reservation expired. Continue with the suggested start date?'**
  String get billing_uncompleted_resume_message;

  /// No description provided for @billing_uncompleted_resume_success.
  ///
  /// In en, this message translates to:
  /// **'Continue in the payment page'**
  String get billing_uncompleted_resume_success;

  /// No description provided for @billing_uncompleted_action_failed.
  ///
  /// In en, this message translates to:
  /// **'The request could not be completed. Please try again.'**
  String get billing_uncompleted_action_failed;

  /// No description provided for @family_packages_header_title.
  ///
  /// In en, this message translates to:
  /// **'Family Subscriptions'**
  String get family_packages_header_title;

  /// No description provided for @family_packages_header_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the subscription that suits you'**
  String get family_packages_header_subtitle;

  /// No description provided for @family_packages_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Meals for everyone'**
  String get family_packages_hero_badge;

  /// No description provided for @family_packages_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Complete plans from 2 to 8 members'**
  String get family_packages_hero_title;

  /// No description provided for @family_packages_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'With suitable subscriptions and fast delivery'**
  String get family_packages_hero_subtitle;

  /// No description provided for @family_packages_section_title.
  ///
  /// In en, this message translates to:
  /// **'Choose subscription type'**
  String get family_packages_section_title;

  /// No description provided for @family_packages_default_meals_range.
  ///
  /// In en, this message translates to:
  /// **'2-4 meals'**
  String get family_packages_default_meals_range;

  /// No description provided for @family_packages_members_count.
  ///
  /// In en, this message translates to:
  /// **'{min}-{max} members'**
  String family_packages_members_count(int min, int max);

  /// No description provided for @family_packages_continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue subscription selection'**
  String get family_packages_continue_button;

  /// No description provided for @family_allergies_title.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get family_allergies_title;

  /// No description provided for @family_allergies_member.
  ///
  /// In en, this message translates to:
  /// **'Allergies for {name}'**
  String family_allergies_member(String name);

  /// No description provided for @family_allergies_none.
  ///
  /// In en, this message translates to:
  /// **'No allergies'**
  String get family_allergies_none;

  /// No description provided for @family_allergies_save_next_member.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get family_allergies_save_next_member;

  /// No description provided for @family_allergies_next_location.
  ///
  /// In en, this message translates to:
  /// **'Next: location'**
  String get family_allergies_next_location;

  /// No description provided for @family_allergies_next_payment.
  ///
  /// In en, this message translates to:
  /// **'Next: payment'**
  String get family_allergies_next_payment;

  /// No description provided for @family_allergies_food_title.
  ///
  /// In en, this message translates to:
  /// **'Food allergies'**
  String get family_allergies_food_title;

  /// No description provided for @family_allergies_food_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the allergies that should be avoided for this member'**
  String get family_allergies_food_subtitle;

  /// No description provided for @family_allergies_common.
  ///
  /// In en, this message translates to:
  /// **'Common allergies'**
  String get family_allergies_common;

  /// No description provided for @family_allergies_search.
  ///
  /// In en, this message translates to:
  /// **'Search for an allergy'**
  String get family_allergies_search;

  /// No description provided for @family_allergies_rejected.
  ///
  /// In en, this message translates to:
  /// **'Ingredients they dislike'**
  String get family_allergies_rejected;

  /// No description provided for @family_allergies_ingredient_search.
  ///
  /// In en, this message translates to:
  /// **'Search for an ingredient'**
  String get family_allergies_ingredient_search;

  /// No description provided for @family_allergies_show_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get family_allergies_show_more;

  /// No description provided for @family_allergies_show_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get family_allergies_show_less;

  /// No description provided for @family_allergies_information_note.
  ///
  /// In en, this message translates to:
  /// **'We use this information to personalize suitable meals for each member.'**
  String get family_allergies_information_note;

  /// No description provided for @family_addresses_title.
  ///
  /// In en, this message translates to:
  /// **'Delivery addresses'**
  String get family_addresses_title;

  /// No description provided for @family_addresses_member.
  ///
  /// In en, this message translates to:
  /// **'Address for {name}'**
  String family_addresses_member(String name);

  /// No description provided for @family_addresses_add.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get family_addresses_add;

  /// No description provided for @family_addresses_use.
  ///
  /// In en, this message translates to:
  /// **'Use this address'**
  String get family_addresses_use;

  /// No description provided for @family_addresses_next_member.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get family_addresses_next_member;

  /// No description provided for @family_addresses_next_payment.
  ///
  /// In en, this message translates to:
  /// **'Next: payment'**
  String get family_addresses_next_payment;

  /// No description provided for @family_addresses_label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get family_addresses_label;

  /// No description provided for @family_addresses_area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get family_addresses_area;

  /// No description provided for @family_addresses_line.
  ///
  /// In en, this message translates to:
  /// **'Address details'**
  String get family_addresses_line;

  /// No description provided for @family_meal_selection_title.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Meals'**
  String family_meal_selection_title(String name);

  /// No description provided for @family_meal_selection_context.
  ///
  /// In en, this message translates to:
  /// **'{restaurant} • {slot}'**
  String family_meal_selection_context(String restaurant, String slot);

  /// No description provided for @family_meal_stepper_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Select Restaurant'**
  String get family_meal_stepper_restaurant;

  /// No description provided for @family_meal_stepper_meal.
  ///
  /// In en, this message translates to:
  /// **'Select Meal'**
  String get family_meal_stepper_meal;

  /// No description provided for @family_meal_stepper_review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get family_meal_stepper_review;

  /// No description provided for @family_meal_macros_title.
  ///
  /// In en, this message translates to:
  /// **'Macros Summary'**
  String get family_meal_macros_title;

  /// No description provided for @family_meal_macros_selected_badge.
  ///
  /// In en, this message translates to:
  /// **'From selected meals'**
  String get family_meal_macros_selected_badge;

  /// No description provided for @family_meal_macros_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Updates automatically based on chosen meals'**
  String get family_meal_macros_subtitle;

  /// No description provided for @family_meal_macros_calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get family_meal_macros_calories;

  /// No description provided for @family_meal_macros_carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get family_meal_macros_carbs;

  /// No description provided for @family_meal_macros_protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get family_meal_macros_protein;

  /// No description provided for @family_meal_macros_fat.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get family_meal_macros_fat;

  /// No description provided for @family_meal_gram_unit.
  ///
  /// In en, this message translates to:
  /// **'{count}g'**
  String family_meal_gram_unit(String count);

  /// No description provided for @family_meal_calorie_unit.
  ///
  /// In en, this message translates to:
  /// **'{count} kcal'**
  String family_meal_calorie_unit(String count);

  /// No description provided for @family_meal_tab_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get family_meal_tab_all;

  /// No description provided for @family_meal_tab_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get family_meal_tab_breakfast;

  /// No description provided for @family_meal_tab_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get family_meal_tab_lunch;

  /// No description provided for @family_meal_tab_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get family_meal_tab_dinner;

  /// No description provided for @family_meal_status_selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get family_meal_status_selected;

  /// No description provided for @family_meal_button_select.
  ///
  /// In en, this message translates to:
  /// **'Select Meal'**
  String get family_meal_button_select;

  /// No description provided for @family_meal_selected_counter.
  ///
  /// In en, this message translates to:
  /// **'{selected} of {total} meals selected'**
  String family_meal_selected_counter(int selected, int total);

  /// No description provided for @family_meal_continue_review.
  ///
  /// In en, this message translates to:
  /// **'Continue to Review'**
  String get family_meal_continue_review;

  /// No description provided for @family_review_title.
  ///
  /// In en, this message translates to:
  /// **'Review {name}\'s Meals'**
  String family_review_title(String name);

  /// No description provided for @family_review_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Review today\'s choices before confirmation'**
  String get family_review_subtitle;

  /// No description provided for @family_review_status_ready.
  ///
  /// In en, this message translates to:
  /// **'Ready to confirm'**
  String get family_review_status_ready;

  /// No description provided for @family_review_selected_day_label.
  ///
  /// In en, this message translates to:
  /// **'Selected Day'**
  String get family_review_selected_day_label;

  /// No description provided for @family_review_goal_label.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get family_review_goal_label;

  /// No description provided for @family_review_goal_balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get family_review_goal_balanced;

  /// No description provided for @family_review_selected_meals_section.
  ///
  /// In en, this message translates to:
  /// **'Selected Meals'**
  String get family_review_selected_meals_section;

  /// No description provided for @family_slot_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get family_slot_breakfast;

  /// No description provided for @family_slot_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get family_slot_lunch;

  /// No description provided for @family_slot_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get family_slot_dinner;

  /// No description provided for @family_slot_snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get family_slot_snack;

  /// No description provided for @family_review_edit_button.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get family_review_edit_button;

  /// No description provided for @family_review_nutrition_summary_section.
  ///
  /// In en, this message translates to:
  /// **'Nutritional Summary'**
  String get family_review_nutrition_summary_section;

  /// No description provided for @family_review_calories_progress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target} kcal'**
  String family_review_calories_progress(String current, String target);

  /// No description provided for @family_review_grams_progress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target}g'**
  String family_review_grams_progress(String current, String target);

  /// No description provided for @family_review_member_instructions_section.
  ///
  /// In en, this message translates to:
  /// **'Member Instructions'**
  String get family_review_member_instructions_section;

  /// No description provided for @family_review_preferences_note.
  ///
  /// In en, this message translates to:
  /// **'Your preferences will be respected if any meal needs replacement'**
  String get family_review_preferences_note;

  /// No description provided for @family_review_cutoff_title.
  ///
  /// In en, this message translates to:
  /// **'You can edit today\'s meals until cutoff time'**
  String get family_review_cutoff_title;

  /// No description provided for @family_review_cutoff_desc.
  ///
  /// In en, this message translates to:
  /// **'Once cutoff is reached, meals will be prepared and cannot be edited or canceled.'**
  String get family_review_cutoff_desc;

  /// No description provided for @family_review_cutoff_time.
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String family_review_cutoff_time(String time);

  /// No description provided for @family_review_cutoff_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'If remaining meals are not chosen, they will be assigned automatically based on preferences'**
  String get family_review_cutoff_disclaimer;

  /// No description provided for @family_review_edit_meals_button.
  ///
  /// In en, this message translates to:
  /// **'Edit Meals'**
  String get family_review_edit_meals_button;

  /// No description provided for @family_review_confirm_meals_button.
  ///
  /// In en, this message translates to:
  /// **'Confirm {name}\'s Meals'**
  String family_review_confirm_meals_button(String name);

  /// No description provided for @family_review_success_message.
  ///
  /// In en, this message translates to:
  /// **'Meals confirmed successfully'**
  String get family_review_success_message;

  /// No description provided for @family_meal_item_1_title.
  ///
  /// In en, this message translates to:
  /// **'Herb-Grilled Chicken'**
  String get family_meal_item_1_title;

  /// No description provided for @family_meal_item_1_desc.
  ///
  /// In en, this message translates to:
  /// **'Herb-marinated grilled chicken with brown rice and mixed vegetables'**
  String get family_meal_item_1_desc;

  /// No description provided for @family_meal_item_2_title.
  ///
  /// In en, this message translates to:
  /// **'Lemon-Grilled Salmon'**
  String get family_meal_item_2_title;

  /// No description provided for @family_meal_item_2_desc.
  ///
  /// In en, this message translates to:
  /// **'Grilled salmon with quinoa, roasted vegetables, and lemon sauce'**
  String get family_meal_item_2_desc;

  /// No description provided for @family_meal_item_3_title.
  ///
  /// In en, this message translates to:
  /// **'Meat Kofta in Tomato Sauce'**
  String get family_meal_item_3_title;

  /// No description provided for @family_meal_item_3_desc.
  ///
  /// In en, this message translates to:
  /// **'Beef kofta in tomato sauce with mashed potatoes and broccoli'**
  String get family_meal_item_3_desc;

  /// No description provided for @family_meal_item_4_title.
  ///
  /// In en, this message translates to:
  /// **'Balanced Vegan Bowl'**
  String get family_meal_item_4_title;

  /// No description provided for @family_meal_item_4_desc.
  ///
  /// In en, this message translates to:
  /// **'Plant-based bowl with chickpeas, quinoa, greens, and tahini sauce'**
  String get family_meal_item_4_desc;

  /// No description provided for @family_meal_tag_gluten_free.
  ///
  /// In en, this message translates to:
  /// **'Gluten-Free'**
  String get family_meal_tag_gluten_free;

  /// No description provided for @family_meal_tag_contains_nuts.
  ///
  /// In en, this message translates to:
  /// **'Contains Nuts'**
  String get family_meal_tag_contains_nuts;

  /// No description provided for @family_meal_tag_omega3.
  ///
  /// In en, this message translates to:
  /// **'Omega-3 Source'**
  String get family_meal_tag_omega3;

  /// No description provided for @family_review_meal_1_name.
  ///
  /// In en, this message translates to:
  /// **'Oatmeal with Honey & Banana'**
  String get family_review_meal_1_name;

  /// No description provided for @family_review_meal_2_name.
  ///
  /// In en, this message translates to:
  /// **'Grilled Chicken with Brown Rice & Veggies'**
  String get family_review_meal_2_name;

  /// No description provided for @family_review_meal_3_name.
  ///
  /// In en, this message translates to:
  /// **'Lemon Salmon with Quinoa & Green Salad'**
  String get family_review_meal_3_name;

  /// No description provided for @family_review_meal_4_name.
  ///
  /// In en, this message translates to:
  /// **'Greek Yogurt with Berries & Honey'**
  String get family_review_meal_4_name;

  /// No description provided for @family_review_tag_no_nuts.
  ///
  /// In en, this message translates to:
  /// **'No Nuts'**
  String get family_review_tag_no_nuts;

  /// No description provided for @family_review_tag_brown_rice.
  ///
  /// In en, this message translates to:
  /// **'Prefers Brown Rice'**
  String get family_review_tag_brown_rice;

  /// No description provided for @family_review_tag_not_spicy.
  ///
  /// In en, this message translates to:
  /// **'No Spicy Food'**
  String get family_review_tag_not_spicy;

  /// No description provided for @subscription_upgrade_target_invalid.
  ///
  /// In en, this message translates to:
  /// **'The selected tier is not valid for upgrade.'**
  String get subscription_upgrade_target_invalid;

  /// No description provided for @upgrade_redirect_urls_required.
  ///
  /// In en, this message translates to:
  /// **'Payment redirect information is incomplete.'**
  String get upgrade_redirect_urls_required;

  /// No description provided for @upgrade_customer_not_found.
  ///
  /// In en, this message translates to:
  /// **'Customer information is incomplete for payment.'**
  String get upgrade_customer_not_found;

  /// No description provided for @subscription_upgrade_not_available.
  ///
  /// In en, this message translates to:
  /// **'The subscription is currently not available for upgrade.'**
  String get subscription_upgrade_not_available;

  /// No description provided for @subscription_upgrade_request_already_pending.
  ///
  /// In en, this message translates to:
  /// **'An upgrade request is already pending review.'**
  String get subscription_upgrade_request_already_pending;

  /// No description provided for @subscription_not_found.
  ///
  /// In en, this message translates to:
  /// **'Subscription not found.'**
  String get subscription_not_found;

  /// No description provided for @subscription_upgrade_default_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while initiating the upgrade, please try again.'**
  String get subscription_upgrade_default_error;

  /// No description provided for @restaurant_tier_upgrade_success.
  ///
  /// In en, this message translates to:
  /// **'Tier upgraded successfully and the updated subscription is active immediately.'**
  String get restaurant_tier_upgrade_success;

  /// No description provided for @restaurant_tier_upgrade_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Tier Upgrade'**
  String get restaurant_tier_upgrade_confirm_title;

  /// No description provided for @restaurant_tier_upgrade_no_data.
  ///
  /// In en, this message translates to:
  /// **'No data available for upgrade request.'**
  String get restaurant_tier_upgrade_no_data;

  /// No description provided for @family_error_cannot_remove_manager.
  ///
  /// In en, this message translates to:
  /// **'The family manager cannot be removed.'**
  String get family_error_cannot_remove_manager;

  /// No description provided for @family_error_member_not_found.
  ///
  /// In en, this message translates to:
  /// **'This family member could not be found.'**
  String get family_error_member_not_found;

  /// No description provided for @family_error_not_manager.
  ///
  /// In en, this message translates to:
  /// **'Only the family manager can perform this action.'**
  String get family_error_not_manager;

  /// No description provided for @family_error_use_checkout_flow.
  ///
  /// In en, this message translates to:
  /// **'Add family members through the subscription checkout flow.'**
  String get family_error_use_checkout_flow;

  /// No description provided for @family_error_manager_permissions_immutable.
  ///
  /// In en, this message translates to:
  /// **'The family manager\'s permissions cannot be changed.'**
  String get family_error_manager_permissions_immutable;

  /// No description provided for @family_error_member_paused.
  ///
  /// In en, this message translates to:
  /// **'This family member is paused.'**
  String get family_error_member_paused;

  /// No description provided for @family_error_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'This family member does not have permission to edit meals.'**
  String get family_error_permission_denied;

  /// No description provided for @family_error_renewal_not_available.
  ///
  /// In en, this message translates to:
  /// **'This subscription cannot be renewed right now.'**
  String get family_error_renewal_not_available;

  /// No description provided for @family_error_subscription_not_found.
  ///
  /// In en, this message translates to:
  /// **'The requested family subscription was not found.'**
  String get family_error_subscription_not_found;

  /// No description provided for @family_error_customer_only.
  ///
  /// In en, this message translates to:
  /// **'This action is only available to customers.'**
  String get family_error_customer_only;

  /// No description provided for @family_member_no_plan.
  ///
  /// In en, this message translates to:
  /// **'No plan'**
  String get family_member_no_plan;

  /// No description provided for @family_member_paused_label.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get family_member_paused_label;

  /// No description provided for @family_member_active_label.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get family_member_active_label;

  /// No description provided for @family_member_days_remaining.
  ///
  /// In en, this message translates to:
  /// **'{count} days remaining'**
  String family_member_days_remaining(int count);

  /// No description provided for @family_member_age_years.
  ///
  /// In en, this message translates to:
  /// **'{count} years'**
  String family_member_age_years(int count);

  /// No description provided for @family_member_details_title.
  ///
  /// In en, this message translates to:
  /// **'Details for {name}'**
  String family_member_details_title(String name);

  /// No description provided for @family_member_manager_label.
  ///
  /// In en, this message translates to:
  /// **'Family manager'**
  String get family_member_manager_label;

  /// No description provided for @family_member_member_label.
  ///
  /// In en, this message translates to:
  /// **'Family member'**
  String get family_member_member_label;

  /// No description provided for @family_member_program_title.
  ///
  /// In en, this message translates to:
  /// **'Nutrition program'**
  String get family_member_program_title;

  /// No description provided for @family_member_change_program.
  ///
  /// In en, this message translates to:
  /// **'Change program'**
  String get family_member_change_program;

  /// No description provided for @family_member_package_title.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get family_member_package_title;

  /// No description provided for @family_member_subscription_dates.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String family_member_subscription_dates(String start, String end);

  /// No description provided for @family_member_renew_subscription.
  ///
  /// In en, this message translates to:
  /// **'Renew subscription'**
  String get family_member_renew_subscription;

  /// No description provided for @family_member_today_nutrition.
  ///
  /// In en, this message translates to:
  /// **'Today\'s nutrition'**
  String get family_member_today_nutrition;

  /// No description provided for @family_member_calories_value.
  ///
  /// In en, this message translates to:
  /// **'{count} kcal'**
  String family_member_calories_value(String count);

  /// No description provided for @family_member_show_calendar.
  ///
  /// In en, this message translates to:
  /// **'Show calendar'**
  String get family_member_show_calendar;

  /// No description provided for @family_member_access_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get family_member_access_phone_label;

  /// No description provided for @family_member_access_pause_label.
  ///
  /// In en, this message translates to:
  /// **'Pause member'**
  String get family_member_access_pause_label;

  /// No description provided for @family_member_access_remove_label.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get family_member_access_remove_label;

  /// No description provided for @family_member_access_generated_password_title.
  ///
  /// In en, this message translates to:
  /// **'One-time password'**
  String get family_member_access_generated_password_title;

  /// No description provided for @family_member_access_generated_password_message.
  ///
  /// In en, this message translates to:
  /// **'Share this password now. It will not be shown again.'**
  String get family_member_access_generated_password_message;

  /// No description provided for @family_member_access_existing_login.
  ///
  /// In en, this message translates to:
  /// **'This phone number already has a MealMate account. The member can use the existing password.'**
  String get family_member_access_existing_login;

  /// No description provided for @family_member_access_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get family_member_access_copy;

  /// No description provided for @family_member_shortcut_daily_meals.
  ///
  /// In en, this message translates to:
  /// **'Daily Meals'**
  String get family_member_shortcut_daily_meals;

  /// No description provided for @family_member_shortcut_daily_meals_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View meals and plans'**
  String get family_member_shortcut_daily_meals_subtitle;

  /// No description provided for @family_member_shortcut_permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get family_member_shortcut_permissions;

  /// No description provided for @family_member_shortcut_permissions_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage permissions'**
  String get family_member_shortcut_permissions_subtitle;

  /// No description provided for @family_member_calendar_title.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Calendar'**
  String family_member_calendar_title(String name);

  /// No description provided for @family_member_no_active_subscription.
  ///
  /// In en, this message translates to:
  /// **'This member currently has no active subscription.'**
  String get family_member_no_active_subscription;

  /// No description provided for @family_member_no_meals_selected.
  ///
  /// In en, this message translates to:
  /// **'No meals selected for this day.'**
  String get family_member_no_meals_selected;

  /// No description provided for @family_member_selected_meals_count.
  ///
  /// In en, this message translates to:
  /// **'{count} meals selected'**
  String family_member_selected_meals_count(int count);

  /// No description provided for @family_member_day_details_button.
  ///
  /// In en, this message translates to:
  /// **'View Day Details'**
  String get family_member_day_details_button;

  /// No description provided for @family_member_choose_meals_button.
  ///
  /// In en, this message translates to:
  /// **'Choose Meals'**
  String get family_member_choose_meals_button;

  /// No description provided for @family_member_selected_meals_title.
  ///
  /// In en, this message translates to:
  /// **'Selected Meals'**
  String get family_member_selected_meals_title;

  /// No description provided for @family_member_selected_meals_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Selected meals for {name} on {date}'**
  String family_member_selected_meals_subtitle(String name, String date);

  /// No description provided for @family_member_meal_chosen.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get family_member_meal_chosen;

  /// No description provided for @family_member_choose_meal.
  ///
  /// In en, this message translates to:
  /// **'Choose meal'**
  String get family_member_choose_meal;

  /// No description provided for @family_day_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Day Details'**
  String get family_day_screen_title;

  /// No description provided for @family_day_current_restaurant_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Current restaurant'**
  String get family_day_current_restaurant_subtitle;

  /// No description provided for @family_day_review_meals_button.
  ///
  /// In en, this message translates to:
  /// **'Review day meals'**
  String get family_day_review_meals_button;

  /// No description provided for @family_day_all_meals_selected.
  ///
  /// In en, this message translates to:
  /// **'All meals selected'**
  String get family_day_all_meals_selected;

  /// No description provided for @family_day_default_restaurant_name.
  ///
  /// In en, this message translates to:
  /// **'Green Chef Restaurant'**
  String get family_day_default_restaurant_name;

  /// No description provided for @influencer_header_greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, Mohammed'**
  String get influencer_header_greeting;

  /// No description provided for @currency_kwd.
  ///
  /// In en, this message translates to:
  /// **'KWD'**
  String get currency_kwd;

  /// No description provided for @offer_browse_title.
  ///
  /// In en, this message translates to:
  /// **'Available Offers'**
  String get offer_browse_title;

  /// No description provided for @offer_browse_empty.
  ///
  /// In en, this message translates to:
  /// **'No offers available right now'**
  String get offer_browse_empty;

  /// No description provided for @offer_browse_tab_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get offer_browse_tab_all;

  /// No description provided for @offer_browse_tab_offers.
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get offer_browse_tab_offers;

  /// No description provided for @offer_browse_tab_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get offer_browse_tab_restaurants;

  /// No description provided for @offer_browse_tab_subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get offer_browse_tab_subscriptions;

  /// No description provided for @offer_browse_remaining_spots.
  ///
  /// In en, this message translates to:
  /// **'spots remaining'**
  String get offer_browse_remaining_spots;

  /// No description provided for @offer_browse_action_button.
  ///
  /// In en, this message translates to:
  /// **'Claim Offer'**
  String get offer_browse_action_button;

  /// No description provided for @offer_hub_view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get offer_hub_view_all;

  /// No description provided for @offer_hub_share_message.
  ///
  /// In en, this message translates to:
  /// **'Share link copied!'**
  String get offer_hub_share_message;

  /// No description provided for @offer_deal_best_seller.
  ///
  /// In en, this message translates to:
  /// **'Best Seller'**
  String get offer_deal_best_seller;

  /// No description provided for @offer_deal_action_button.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get offer_deal_action_button;

  /// No description provided for @offer_deal_free_delivery.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery'**
  String get offer_deal_free_delivery;

  /// No description provided for @offer_details_code_label.
  ///
  /// In en, this message translates to:
  /// **'Promo Code'**
  String get offer_details_code_label;

  /// No description provided for @offer_details_copy_code.
  ///
  /// In en, this message translates to:
  /// **'Code copied successfully'**
  String get offer_details_copy_code;

  /// No description provided for @offer_countdown_prefix.
  ///
  /// In en, this message translates to:
  /// **'Offer ends in'**
  String get offer_countdown_prefix;

  /// No description provided for @offer_countdown_expired.
  ///
  /// In en, this message translates to:
  /// **'This offer has expired'**
  String get offer_countdown_expired;

  /// No description provided for @offer_status_expired.
  ///
  /// In en, this message translates to:
  /// **'Offer Expired'**
  String get offer_status_expired;

  /// No description provided for @offer_status_sold_out.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get offer_status_sold_out;

  /// No description provided for @offer_promo_title.
  ///
  /// In en, this message translates to:
  /// **'Enter Promo Code'**
  String get offer_promo_title;

  /// No description provided for @offer_promo_headline.
  ///
  /// In en, this message translates to:
  /// **'Have a promo code or coupon?'**
  String get offer_promo_headline;

  /// No description provided for @offer_promo_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the promo code to get the best exclusive offers on your subscriptions'**
  String get offer_promo_subtitle;

  /// No description provided for @offer_promo_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter code here (e.g. SAVE20)'**
  String get offer_promo_hint;

  /// No description provided for @offer_promo_paste_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get offer_promo_paste_tooltip;

  /// No description provided for @offer_promo_apply_button.
  ///
  /// In en, this message translates to:
  /// **'Apply Code'**
  String get offer_promo_apply_button;

  /// No description provided for @offer_promo_empty_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a promo code first'**
  String get offer_promo_empty_error;

  /// No description provided for @offer_promo_invalid_error.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired promo code'**
  String get offer_promo_invalid_error;

  /// No description provided for @offer_promo_available_codes_title.
  ///
  /// In en, this message translates to:
  /// **'Suggested Promo Codes'**
  String get offer_promo_available_codes_title;

  /// No description provided for @offer_promo_apply_code.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get offer_promo_apply_code;

  /// No description provided for @offer_promo_save20_title.
  ///
  /// In en, this message translates to:
  /// **'20% off all monthly packages'**
  String get offer_promo_save20_title;

  /// No description provided for @offer_promo_fit10_title.
  ///
  /// In en, this message translates to:
  /// **'10% off fitness programs'**
  String get offer_promo_fit10_title;

  /// No description provided for @offer_promo_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'15% off for new subscribers'**
  String get offer_promo_welcome_title;

  /// No description provided for @offer_redeem_title.
  ///
  /// In en, this message translates to:
  /// **'Apply Offer & Select Package'**
  String get offer_redeem_title;

  /// No description provided for @offer_redeem_select_package_title.
  ///
  /// In en, this message translates to:
  /// **'Select Your Package Duration'**
  String get offer_redeem_select_package_title;

  /// No description provided for @offer_package_month_title.
  ///
  /// In en, this message translates to:
  /// **'Full Month Package (26 Days)'**
  String get offer_package_month_title;

  /// No description provided for @offer_package_half_month_title.
  ///
  /// In en, this message translates to:
  /// **'Half Month Package (13 Days)'**
  String get offer_package_half_month_title;

  /// No description provided for @offer_package_week_title.
  ///
  /// In en, this message translates to:
  /// **'Weekly Package (6 Days)'**
  String get offer_package_week_title;

  /// No description provided for @offer_redeem_min_days_notice.
  ///
  /// In en, this message translates to:
  /// **'This offer requires a minimum of {days} days'**
  String offer_redeem_min_days_notice(String days);

  /// No description provided for @offer_redeem_total_after_discount.
  ///
  /// In en, this message translates to:
  /// **'Total After Discount'**
  String get offer_redeem_total_after_discount;

  /// No description provided for @offer_redeem_proceed_button.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Confirmation'**
  String get offer_redeem_proceed_button;

  /// No description provided for @offer_redeem_safe_payment_notice.
  ///
  /// In en, this message translates to:
  /// **'100% Secure & Encrypted Payment'**
  String get offer_redeem_safe_payment_notice;

  /// No description provided for @offer_checkout_title.
  ///
  /// In en, this message translates to:
  /// **'Offer Checkout Confirmation'**
  String get offer_checkout_title;

  /// No description provided for @offer_checkout_applied_title.
  ///
  /// In en, this message translates to:
  /// **'Offer Applied Successfully!'**
  String get offer_checkout_applied_title;

  /// No description provided for @offer_checkout_applied_code.
  ///
  /// In en, this message translates to:
  /// **'Applied Code'**
  String get offer_checkout_applied_code;

  /// No description provided for @offer_checkout_applied_description.
  ///
  /// In en, this message translates to:
  /// **'The best available discount has been applied to your selected package'**
  String get offer_checkout_applied_description;

  /// No description provided for @offer_checkout_order_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Subscription Summary'**
  String get offer_checkout_order_summary_title;

  /// No description provided for @offer_checkout_package_label.
  ///
  /// In en, this message translates to:
  /// **'Selected Package'**
  String get offer_checkout_package_label;

  /// No description provided for @offer_checkout_meals_per_day.
  ///
  /// In en, this message translates to:
  /// **'Meals Per Day'**
  String get offer_checkout_meals_per_day;

  /// No description provided for @offer_checkout_original_price.
  ///
  /// In en, this message translates to:
  /// **'Original Price'**
  String get offer_checkout_original_price;

  /// No description provided for @offer_checkout_discount_amount.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get offer_checkout_discount_amount;

  /// No description provided for @offer_checkout_final_total.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get offer_checkout_final_total;

  /// No description provided for @offer_checkout_secure_badge.
  ///
  /// In en, this message translates to:
  /// **'Payment is secure and protected via safe gateway'**
  String get offer_checkout_secure_badge;

  /// No description provided for @offer_checkout_proceed_button.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay Now'**
  String get offer_checkout_proceed_button;

  /// No description provided for @offer_checkout_change_package_button.
  ///
  /// In en, this message translates to:
  /// **'Change Package or Offer'**
  String get offer_checkout_change_package_button;

  /// No description provided for @offer_activation_success_title.
  ///
  /// In en, this message translates to:
  /// **'Subscription Activated'**
  String get offer_activation_success_title;

  /// No description provided for @offer_activation_congrats.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your offer is active'**
  String get offer_activation_congrats;

  /// No description provided for @offer_activation_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your package is ready to use. You can now select and schedule your meals'**
  String get offer_activation_subtitle;

  /// No description provided for @offer_activation_order_title.
  ///
  /// In en, this message translates to:
  /// **'Activated Subscription Details'**
  String get offer_activation_order_title;

  /// No description provided for @offer_activation_paid_total.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get offer_activation_paid_total;

  /// No description provided for @offer_activation_choose_plan_button.
  ///
  /// In en, this message translates to:
  /// **'Schedule & Choose Meals'**
  String get offer_activation_choose_plan_button;

  /// No description provided for @meals_count.
  ///
  /// In en, this message translates to:
  /// **'meals'**
  String get meals_count;

  /// No description provided for @notifications_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_screen_title;

  /// No description provided for @notifications_mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notifications_mark_all_read;

  /// No description provided for @notifications_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notifications_filter_all;

  /// No description provided for @notifications_filter_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders & Delivery'**
  String get notifications_filter_orders;

  /// No description provided for @notifications_filter_reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notifications_filter_reminders;

  /// No description provided for @notifications_filter_offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get notifications_filter_offers;

  /// No description provided for @notifications_group_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notifications_group_today;

  /// No description provided for @notifications_group_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notifications_group_yesterday;

  /// No description provided for @notifications_group_earlier.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get notifications_group_earlier;

  /// No description provided for @notifications_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifications_empty_title;

  /// No description provided for @notifications_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We will notify you when there are updates on your meals or subscriptions'**
  String get notifications_empty_subtitle;

  /// No description provided for @notifications_time_just_now.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notifications_time_just_now;

  /// No description provided for @notifications_time_minutes_ago.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String notifications_time_minutes_ago(int minutes);

  /// No description provided for @notifications_time_hours_ago.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String notifications_time_hours_ago(int hours);

  /// No description provided for @notifications_action_track.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get notifications_action_track;

  /// No description provided for @notifications_action_select_meal.
  ///
  /// In en, this message translates to:
  /// **'Choose Meal'**
  String get notifications_action_select_meal;

  /// No description provided for @notifications_action_view_offer.
  ///
  /// In en, this message translates to:
  /// **'View Offer'**
  String get notifications_action_view_offer;

  /// No description provided for @notifications_tab_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notifications_tab_all;

  /// No description provided for @notifications_tab_subscription.
  ///
  /// In en, this message translates to:
  /// **'Package & Subscription'**
  String get notifications_tab_subscription;

  /// No description provided for @notifications_tab_meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get notifications_tab_meals;

  /// No description provided for @notifications_tab_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notifications_tab_system;

  /// No description provided for @notifications_clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear Notifications'**
  String get notifications_clear_all;

  /// No description provided for @notif_today_meals_title.
  ///
  /// In en, this message translates to:
  /// **'Today\'s meals ready to choose'**
  String get notif_today_meals_title;

  /// No description provided for @notif_today_meals_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You have not chosen meals for 2 family members'**
  String get notif_today_meals_subtitle;

  /// No description provided for @notif_meals_selected_title.
  ///
  /// In en, this message translates to:
  /// **'Meals selected successfully'**
  String get notif_meals_selected_title;

  /// No description provided for @notif_meals_selected_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ahmed\'s meals for Monday have been chosen'**
  String get notif_meals_selected_subtitle;

  /// No description provided for @notif_package_renew_title.
  ///
  /// In en, this message translates to:
  /// **'Package Renewal'**
  String get notif_package_renew_title;

  /// No description provided for @notif_package_renew_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your family package has been renewed successfully'**
  String get notif_package_renew_subtitle;

  /// No description provided for @notif_delivery_coming_title.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Delivery'**
  String get notif_delivery_coming_title;

  /// No description provided for @notif_delivery_coming_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s meals delivery between 8:00 AM - 10:00 AM'**
  String get notif_delivery_coming_subtitle;

  /// No description provided for @notif_new_offer_title.
  ///
  /// In en, this message translates to:
  /// **'New Offer'**
  String get notif_new_offer_title;

  /// No description provided for @notif_new_offer_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a free meal when you invite a friend'**
  String get notif_new_offer_subtitle;

  /// No description provided for @notif_system_update_title.
  ///
  /// In en, this message translates to:
  /// **'System Update'**
  String get notif_system_update_title;

  /// No description provided for @notif_system_update_subtitle.
  ///
  /// In en, this message translates to:
  /// **'The app has been updated to the latest version'**
  String get notif_system_update_subtitle;

  /// No description provided for @notifications_prefs_title.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notifications_prefs_title;

  /// No description provided for @notifications_prefs_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the types of notifications you want to receive'**
  String get notifications_prefs_subtitle;

  /// No description provided for @notifications_prefs_allow_all.
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get notifications_prefs_allow_all;

  /// No description provided for @notifications_prefs_allow_all_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable all notifications'**
  String get notifications_prefs_allow_all_subtitle;

  /// No description provided for @notifications_prefs_meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get notifications_prefs_meals;

  /// No description provided for @notifications_prefs_meals_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications regarding meal selection and preparation'**
  String get notifications_prefs_meals_subtitle;

  /// No description provided for @notifications_prefs_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get notifications_prefs_delivery;

  /// No description provided for @notifications_prefs_delivery_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications regarding delivery status'**
  String get notifications_prefs_delivery_subtitle;

  /// No description provided for @notifications_prefs_subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription & Payment'**
  String get notifications_prefs_subscription;

  /// No description provided for @notifications_prefs_subscription_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications regarding subscription and payments'**
  String get notifications_prefs_subscription_subtitle;

  /// No description provided for @notifications_prefs_offers.
  ///
  /// In en, this message translates to:
  /// **'Offers & Rewards'**
  String get notifications_prefs_offers;

  /// No description provided for @notifications_prefs_offers_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Special notifications for offers and rewards'**
  String get notifications_prefs_offers_subtitle;

  /// No description provided for @notifications_prefs_family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get notifications_prefs_family;

  /// No description provided for @notifications_prefs_family_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications related to family members'**
  String get notifications_prefs_family_subtitle;

  /// No description provided for @notifications_prefs_family_badge.
  ///
  /// In en, this message translates to:
  /// **'Visible only to family manager'**
  String get notifications_prefs_family_badge;

  /// No description provided for @notifications_prefs_account.
  ///
  /// In en, this message translates to:
  /// **'Account & System'**
  String get notifications_prefs_account;

  /// No description provided for @notifications_prefs_account_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications about your account and app data'**
  String get notifications_prefs_account_subtitle;

  /// No description provided for @notifications_prefs_footer_info.
  ///
  /// In en, this message translates to:
  /// **'You will receive notifications according to your settings; you can change them anytime.'**
  String get notifications_prefs_footer_info;
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
