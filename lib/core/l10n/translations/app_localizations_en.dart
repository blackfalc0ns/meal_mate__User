// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get error_no_internet_connection => 'No internet connection';

  @override
  String get error_no_internet_connection_desc =>
      'Please check your internet connection and try again';

  @override
  String get error_connection_timeout => 'Connection timeout';

  @override
  String get error_connection_timeout_desc =>
      'The connection took too long to establish. Please try again';

  @override
  String get error_receive_timeout => 'Receive timeout';

  @override
  String get error_receive_timeout_desc =>
      'The server took too long to respond. Please try again';

  @override
  String get error_send_timeout => 'Send timeout';

  @override
  String get error_send_timeout_desc =>
      'Failed to send data to the server. Please try again';

  @override
  String get error_server_error => 'Server error';

  @override
  String get error_server_error_desc =>
      'Something went wrong on the server. Please try again later';

  @override
  String get error_internal_server_error => 'Internal server error';

  @override
  String get error_internal_server_error_desc =>
      'The server encountered an internal error. Please try again later';

  @override
  String get error_bad_gateway => 'Temporary error';

  @override
  String get error_bad_gateway_desc =>
      'Something went wrong while connecting to the server. Please try again';

  @override
  String get error_service_unavailable => 'Service unavailable';

  @override
  String get error_service_unavailable_desc =>
      'The service is temporarily unavailable. Please try again later';

  @override
  String get error_gateway_timeout => 'Gateway timeout';

  @override
  String get error_gateway_timeout_desc =>
      'The gateway timed out. Please try again later';

  @override
  String get error_bad_request => 'Bad request';

  @override
  String get properties_empty_message_favourite =>
      'You have not added any properties to your favorites.';

  @override
  String get reviewsFor => 'Reviews for';

  @override
  String get error_bad_request_desc =>
      'The request contains invalid data. Please check your input';

  @override
  String get error_unauthorized => 'Unauthorized';

  @override
  String get error_unauthorized_desc =>
      'You are not authorized to access this resource. Please login again';

  @override
  String get error_forbidden => 'Access denied';

  @override
  String get error_forbidden_desc =>
      'You don\'t have permission to access this resource';

  @override
  String get error_not_found => 'Not found';

  @override
  String get error_not_found_desc => 'The requested resource was not found';

  @override
  String get error_method_not_allowed => 'Method not allowed';

  @override
  String get error_method_not_allowed_desc =>
      'This method is not allowed for this resource';

  @override
  String get error_not_acceptable => 'Not acceptable';

  @override
  String get error_not_acceptable_desc => 'The request is not acceptable';

  @override
  String get error_request_timeout => 'Request timeout';

  @override
  String get error_request_timeout_desc =>
      'The request timed out. Please try again';

  @override
  String get error_conflict => 'Conflict';

  @override
  String get error_conflict_desc =>
      'There is a conflict with the current state of the resource';

  @override
  String get error_gone => 'Resource gone';

  @override
  String get error_gone_desc => 'The requested resource is no longer available';

  @override
  String get error_length_required => 'Length required';

  @override
  String get error_length_required_desc =>
      'The request must specify the content length';

  @override
  String get error_precondition_failed => 'Precondition failed';

  @override
  String get error_precondition_failed_desc =>
      'One or more preconditions failed';

  @override
  String get error_payload_too_large => 'Payload too large';

  @override
  String get error_payload_too_large_desc => 'The request payload is too large';

  @override
  String get error_uri_too_long => 'URI too long';

  @override
  String get error_uri_too_long_desc => 'The request URI is too long';

  @override
  String get lead_send_error =>
      'An error occurred while sending the contact request';

  @override
  String get lead_info_collected => 'Lead information collected successfully';

  @override
  String get lead_offline_mode => 'Contact information saved offline';

  @override
  String get error_unsupported_media_type => 'Unsupported media type';

  @override
  String get error_unsupported_media_type_desc =>
      'The media type is not supported';

  @override
  String get error_range_not_satisfiable => 'Range not satisfiable';

  @override
  String get error_range_not_satisfiable_desc =>
      'The requested range cannot be satisfied';

  @override
  String get error_expectation_failed => 'Expectation failed';

  @override
  String get error_expectation_failed_desc =>
      'The expectation given in the request header field could not be met';

  @override
  String get error_too_many_requests => 'Too many requests';

  @override
  String get error_too_many_requests_desc =>
      'You have sent too many requests. Please try again later';

  @override
  String get error_unknown => 'Unknown error';

  @override
  String get error_unknown_desc =>
      'An unknown error occurred. Please try again';

  @override
  String get error_cancelled => 'Request cancelled';

  @override
  String get error_cancelled_desc => 'The request was cancelled';

  @override
  String get error_other => 'Error occurred';

  @override
  String get error_other_desc => 'An error occurred. Please try again';

  @override
  String get retry => 'Retry';

  @override
  String get contact_support => 'Contact Support';

  @override
  String get go_back => 'Go Back';

  @override
  String get refresh => 'Refresh';

  @override
  String get check_connection => 'Check Connection';

  @override
  String get login => 'Login';

  @override
  String get continue_as_guest => 'Continue as guest';

  @override
  String get name_is_required => 'Name is required!';

  @override
  String get name_is_not_valid => 'This name is not valid';

  @override
  String get email_is_required => 'Email is required!';

  @override
  String get email_is_not_valid => 'This email is not valid';

  @override
  String get password_is_required => 'Password is required!';

  @override
  String get password_is_not_valid => 'This password is not valid';

  @override
  String get password_must_be_at_least_6_characters =>
      'Password must be at least 6 characters';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get confirm_password_is_required => 'Confirm password is required!';

  @override
  String get confirm_password_is_not_valid =>
      'This confirm password is not valid';

  @override
  String get password_and_confirm_password_must_be_same =>
      'Password and confirm password must be same!';

  @override
  String get phone_number_is_required => 'Phone number is required!';

  @override
  String get phone_number_is_not_valid => 'This phone number is not valid';

  @override
  String get this_field_is_required => 'This field is required';

  @override
  String get error => 'Error';

  @override
  String get error_bad_certificate => 'Security certificate error';

  @override
  String get error_request_cancelled => 'Request was cancelled';

  @override
  String get error_no_internet => 'No internet connection';

  @override
  String get error_no_response => 'No response from server';

  @override
  String get error_validation => 'Validation error';

  @override
  String get error_server => 'Server error';

  @override
  String get location_service_disabled => 'Location services are disabled';

  @override
  String get location_permission_denied => 'Location permission denied';

  @override
  String get location_permission_denied_forever =>
      'Location permission permanently denied. Please enable it from settings';

  @override
  String get location_service_disabled_message =>
      'Please enable location services to continue';

  @override
  String get location_permission_denied_message =>
      'Please grant location permission to continue';

  @override
  String get location_permission_denied_forever_message =>
      'Location permission is permanently denied. Please enable it from your device settings';

  @override
  String get verification_code_required => 'Verification code is required';

  @override
  String get verification_code_invalid => 'Verification code is invalid';

  @override
  String get start_button => 'start now';

  @override
  String get welcome_back => 'Welcome to';

  @override
  String get login_subtitle =>
      'Log in to access your meal plan and track your health goals';

  @override
  String get login_title => 'Login';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get phone_hint => '000 000 00 00';

  @override
  String get password => 'Password';

  @override
  String get password_hint => 'Enter your password';

  @override
  String get remember_me => 'Remember me';

  @override
  String get forgot_password => 'Forgot password?';

  @override
  String get login_button => 'Login';

  @override
  String get or => 'Or';

  @override
  String get login_with_google => 'Sign in with Google';

  @override
  String get dont_have_account => 'Don\'t have an account?';

  @override
  String get sign_up => 'Sign up';

  @override
  String get auth_welcome_title => 'Welcome to';

  @override
  String get auth_welcome_subtitle =>
      'Log in to access your meal plan and track your health goals.';

  @override
  String get auth_sign_in_title => 'Sign in';

  @override
  String get auth_sign_in_button => 'Sign in';

  @override
  String get auth_no_account => 'Don\'t have an account?';

  @override
  String get auth_create_account_link => 'Create account';

  @override
  String get auth_have_account_prompt => 'Already have an account?';

  @override
  String get auth_sign_in_link => 'Sign in';

  @override
  String get auth_create_account_title => 'Create account';

  @override
  String get auth_create_account_subtitle =>
      'Join MealMate and start your healthier journey.';

  @override
  String get auth_name_label => 'Name';

  @override
  String get auth_name_hint => 'Enter your name';

  @override
  String get auth_confirm_password_label => 'Confirm password';

  @override
  String get auth_confirm_password_hint => 'Re-enter your password';

  @override
  String get auth_terms_label => 'I agree to the terms and conditions';

  @override
  String get auth_create_account_button => 'Create account';

  @override
  String get auth_reset_password_title => 'Reset your password';

  @override
  String get auth_reset_password_subtitle =>
      'Enter your phone number to receive an OTP code.';

  @override
  String get auth_reset_password_hint =>
      'We will send an OTP code to your phone number.';

  @override
  String get auth_send_otp_button => 'Send OTP';

  @override
  String get auth_otp_title => 'Verify your code';

  @override
  String get auth_otp_subtitle =>
      'Enter the 6-digit OTP code sent to your phone.';

  @override
  String get auth_otp_hint => 'Enter the 6-digit OTP code to continue.';

  @override
  String get auth_verify_code_button => 'Verify code';

  @override
  String get auth_no_code_title => 'Didn\'t receive the code?';

  @override
  String get auth_resend_code => 'Resend code';

  @override
  String get auth_resend_code_in => 'Resend code in';

  @override
  String get auth_seconds_label => 'seconds';

  @override
  String get auth_new_password_title => 'Set a new password';

  @override
  String get auth_new_password_subtitle =>
      'Choose a strong password for your account.';

  @override
  String get auth_new_password_hint => 'Enter your new password.';

  @override
  String get auth_new_password_label => 'Password';

  @override
  String get auth_new_password_hint_field => 'Enter your new password';

  @override
  String get auth_new_password_button => 'Save password';

  @override
  String get onboarding_first_subtitle => 'Your healthy companion every day.';

  @override
  String get onboarding_second_title => 'Healthy and tasty meals';

  @override
  String get onboarding_second_subtitle => 'Delivered right to your door...';

  @override
  String get onboarding_third_title => 'Healthy food';

  @override
  String get onboarding_third_subtitle => 'For a better mood!';

  @override
  String get skip => 'Skip';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_meals => 'Meals';

  @override
  String get nav_offers => 'Offers';

  @override
  String get nav_subscription => 'Membership';

  @override
  String get nav_profile => 'Profile';

  @override
  String get coming_soon_subtitle =>
      'This section is being prepared and will be available soon.';

  @override
  String get offers_title => 'Offers';

  @override
  String get offers_hero_badge => 'Limited time';

  @override
  String get offers_hero_discount => '20%';

  @override
  String get offers_hero_title => 'Off on monthly plans';

  @override
  String get offers_hero_subtitle => 'Fresh bundles made for your routine';

  @override
  String get offers_hero_description =>
      'Pick a plan that fits your day and enjoy healthy meals with better savings.';

  @override
  String get offers_hero_button => 'Redeem now';

  @override
  String get offers_filter_all => 'All';

  @override
  String get offers_filter_offers => 'Offers';

  @override
  String get offers_filter_restaurants => 'Restaurants';

  @override
  String get offers_filter_meals => 'Meals';

  @override
  String get offers_featured_section_title => 'Featured offers';

  @override
  String get offers_view_all => 'View all';

  @override
  String get offers_restaurants_section_title => 'Popular restaurants';

  @override
  String get offers_invite_title => 'Invite friends and earn';

  @override
  String get offers_invite_subtitle =>
      'Share a tasty reward with your friends and unlock your own benefit.';

  @override
  String get offers_invite_button => 'Invite now';

  @override
  String get offers_featured_button => 'Claim offer';

  @override
  String get offers_featured_burger_title => 'Burger King combo';

  @override
  String get offers_featured_burger_subtitle =>
      'Large family meal with fries and drinks.';

  @override
  String get offers_featured_burger_discount => 'Save 15%';

  @override
  String get offers_featured_burger_badge => 'Best seller';

  @override
  String get offers_featured_burger_delivery => 'Delivery in 15 min';

  @override
  String get offers_featured_burger_reviews => '4.9';

  @override
  String get offers_featured_salad_title => 'Protein bowl';

  @override
  String get offers_featured_salad_subtitle =>
      'Protein-packed meals for a lighter day.';

  @override
  String get offers_featured_salad_discount => 'Save 12%';

  @override
  String get offers_featured_salad_badge => 'Healthy pick';

  @override
  String get offers_featured_salad_delivery => 'Delivery in 20 min';

  @override
  String get offers_featured_salad_reviews => '4.8';

  @override
  String get offers_featured_gift_title => 'Gift box offer';

  @override
  String get offers_featured_gift_subtitle =>
      'Perfect for gifting a full week of meals.';

  @override
  String get offers_featured_gift_discount => 'Save 25%';

  @override
  String get offers_featured_gift_badge => 'Gift ready';

  @override
  String get offers_featured_gift_delivery => 'Delivery in 30 min';

  @override
  String get offers_featured_gift_reviews => '5.0';

  @override
  String get offers_restaurant_burger_title => 'Burger King deal';

  @override
  String get offers_restaurant_burger_subtitle =>
      'Special offer on your favorite classic meals.';

  @override
  String get offers_restaurant_burger_discount => '30% off';

  @override
  String get offers_restaurant_burger_badge => 'Hot deal';

  @override
  String get offers_restaurant_burger_delivery => 'Delivery in 15 min';

  @override
  String get offers_restaurant_burger_reviews => '4.9';

  @override
  String get offers_restaurant_mcdonalds_title => 'McDonald\'s';

  @override
  String get offers_restaurant_mcdonalds_subtitle =>
      'Discount on all menu items.';

  @override
  String get offers_restaurant_mcdonalds_discount => '30% off';

  @override
  String get offers_restaurant_mcdonalds_badge => 'Popular';

  @override
  String get offers_restaurant_mcdonalds_delivery => 'Delivery in 20 min';

  @override
  String get offers_restaurant_mcdonalds_reviews => '4.0';

  @override
  String get offers_restaurant_starbucks_title => 'Starbucks';

  @override
  String get offers_restaurant_starbucks_subtitle =>
      'Special deal on drinks and snacks.';

  @override
  String get offers_restaurant_starbucks_discount => '30% off';

  @override
  String get offers_restaurant_starbucks_badge => 'Fresh pick';

  @override
  String get offers_restaurant_starbucks_delivery => 'Delivery in 25 min';

  @override
  String get offers_restaurant_starbucks_reviews => '4.8';

  @override
  String get offers_restaurant_bowls_title => 'Green bowls';

  @override
  String get offers_restaurant_bowls_subtitle =>
      'Balanced bowls with fresh ingredients.';

  @override
  String get offers_restaurant_bowls_discount => '20% off';

  @override
  String get offers_restaurant_bowls_badge => 'Top rated';

  @override
  String get offers_restaurant_bowls_delivery => 'Delivery in 18 min';

  @override
  String get offers_restaurant_bowls_reviews => '4.8';
}
