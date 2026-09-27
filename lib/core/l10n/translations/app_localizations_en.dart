// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get meal_details_restaurant_rating => 'Restaurant rating';

  @override
  String get meal_details_meal_type => 'Meal type';

  @override
  String get meal_details_delivery_time => 'Delivery time';

  @override
  String get meal_details_nutrition_facts => 'Nutrition facts';

  @override
  String get meal_details_macro_distribution => 'Macro distribution';

  @override
  String get meal_details_allergens => 'Allergens';

  @override
  String meal_details_gram_value(String value) {
    return '${value}g';
  }

  @override
  String get app_brand_name => 'MealMate';

  @override
  String get app_brand_tagline => 'Your Daily Meal Mate';

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
  String get auth_register_success =>
      'Account created successfully. OTP code has been sent.';

  @override
  String get auth_login_success => 'Signed in successfully.';

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
  String get auth_otp_sent_success => 'OTP code sent successfully.';

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
  String get auth_reset_password_otp_title => 'Confirm reset code';

  @override
  String get auth_reset_password_otp_subtitle =>
      'Enter the OTP code sent to your phone.';

  @override
  String get auth_reset_password_otp_hint =>
      'Enter the code to continue setting your new password.';

  @override
  String get auth_reset_password_otp_button => 'Continue';

  @override
  String get auth_no_code_title => 'Didn\'t receive the code?';

  @override
  String get auth_resend_code => 'Resend code';

  @override
  String get auth_otp_resent_success => 'OTP code resent successfully.';

  @override
  String get auth_resend_code_in => 'Resend code in';

  @override
  String get auth_seconds_label => 'seconds';

  @override
  String get auth_new_password_title => 'Set a new password';

  @override
  String get auth_new_password_subtitle =>
      'Enter a new password for your account.';

  @override
  String get auth_new_password_hint =>
      'Create a new password so you can sign in';

  @override
  String get auth_new_password_label => 'New password';

  @override
  String get auth_new_password_hint_field => 'Enter your new password';

  @override
  String get auth_new_password_button => 'Save password';

  @override
  String get auth_reset_password_success => 'Password changed successfully.';

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
  String get profile_user_name => 'Ahmed Mohamed';

  @override
  String get profile_user_email => 'ahmed.mohamed@gemil.com';

  @override
  String get profile_premium_member => 'Premium member';

  @override
  String get profile_change_photo => 'Change profile photo';

  @override
  String get profile_photo_source_title => 'Choose profile photo';

  @override
  String get profile_photo_source_camera => 'Camera';

  @override
  String get profile_photo_source_gallery => 'Gallery';

  @override
  String get profile_photo_upload_success =>
      'Profile photo updated successfully.';

  @override
  String get profile_photo_upload_error =>
      'Could not update profile photo. Please try again.';

  @override
  String get profile_photo_permission_error =>
      'Please allow camera or photo access to update your profile photo.';

  @override
  String get profile_completed_plans => 'Completed plans';

  @override
  String get profile_streak_days => 'Consecutive days';

  @override
  String get profile_points => 'Your points';

  @override
  String get profile_weight_lost => 'kg lost';

  @override
  String get profile_personal_info => 'Personal information';

  @override
  String get profile_personal_info_subtitle => 'Edit your personal details';

  @override
  String get profile_personal_info_save => 'Save changes';

  @override
  String get profile_personal_info_update_success =>
      'Personal information updated successfully.';

  @override
  String get profile_personal_info_update_error =>
      'Could not update personal information. Please try again.';

  @override
  String get profile_goals => 'My goals';

  @override
  String get profile_goals_subtitle => 'Manage your health goals';

  @override
  String get profile_dietary_preferences => 'Dietary preferences';

  @override
  String get profile_dietary_preferences_subtitle =>
      'Manage your preferences and allergies';

  @override
  String get dietary_preferences_diet_title => 'Diet type';

  @override
  String get dietary_preferences_diet_balanced => 'Balanced';

  @override
  String get dietary_preferences_diet_vegetarian => 'Vegetarian';

  @override
  String get dietary_preferences_diet_vegan => 'Vegan';

  @override
  String get dietary_preferences_diet_keto => 'Keto';

  @override
  String get dietary_preferences_diet_high_protein => 'High protein';

  @override
  String get dietary_preferences_dislikes_title => 'Foods you dislike';

  @override
  String get dietary_preferences_dislike_onion => 'Onion';

  @override
  String get dietary_preferences_dislike_mushroom => 'Mushroom';

  @override
  String get dietary_preferences_dislike_olives => 'Olives';

  @override
  String get dietary_preferences_dislike_coriander => 'Coriander';

  @override
  String get dietary_preferences_allergies_title => 'Allergies';

  @override
  String get dietary_preferences_allergy_nuts => 'Nuts';

  @override
  String get dietary_preferences_allergy_lactose => 'Lactose';

  @override
  String get dietary_preferences_manage_allergies => 'Manage allergies';

  @override
  String get dietary_preferences_notes_title => 'Dietary notes';

  @override
  String get dietary_preferences_notes_hint =>
      'Example: I want low-sodium meals...';

  @override
  String get dietary_preferences_allergy_notice_title =>
      'Important allergy information';

  @override
  String get dietary_preferences_allergy_notice_message =>
      'Allergy information helps us customize safe meals for you and avoid ingredients that may affect your health.';

  @override
  String get dietary_preferences_save => 'Save preferences';

  @override
  String get dietary_preferences_update_success =>
      'Preferences saved successfully.';

  @override
  String get add_allergy_title => 'Add allergy';

  @override
  String get add_allergy_subtitle =>
      'Choose the allergies you have so we can avoid showing meals that are not suitable for you.';

  @override
  String get add_allergy_selected => 'selected';

  @override
  String get add_allergy_current_allergies => 'Your current allergies';

  @override
  String get add_allergy_search_hint => 'Search for an ingredient or allergy';

  @override
  String get add_allergy_sesame => 'Sesame';

  @override
  String get add_allergy_eggs => 'Eggs';

  @override
  String get add_allergy_gluten => 'Gluten';

  @override
  String get add_allergy_peanuts => 'Peanuts';

  @override
  String get add_allergy_seafood => 'Seafood';

  @override
  String get add_allergy_soy => 'Soy';

  @override
  String get add_allergy_wheat => 'Wheat';

  @override
  String get add_allergy_fish => 'Fish';

  @override
  String get add_allergy_shellfish => 'Shellfish';

  @override
  String get add_allergy_common_allergies => 'Common allergies';

  @override
  String get add_allergy_celery => 'Celery';

  @override
  String get add_allergy_mustard => 'Mustard';

  @override
  String get add_allergy_lupin => 'Lupin';

  @override
  String get add_allergy_note_title => 'Important note';

  @override
  String get add_allergy_note_message =>
      'We rely on ingredient information from our partners; recipes may change.';

  @override
  String get add_allergy_save => 'Save allergies';

  @override
  String get add_allergy_update_success => 'Allergies updated successfully.';

  @override
  String get add_allergy_update_error =>
      'Could not update allergies. Please try again.';

  @override
  String get profile_billing => 'Subscriptions and billing';

  @override
  String get profile_billing_subtitle =>
      'Manage your subscription and payment details';

  @override
  String get billing_plan_name => 'Fitness plan';

  @override
  String get billing_plan_tier => 'Platinum';

  @override
  String get billing_active => 'Active';

  @override
  String get billing_renewal_date => 'Next renewal: June 15, 2025';

  @override
  String billing_renewal_date_value(String date) {
    return 'Next renewal: $date';
  }

  @override
  String get billing_days_remaining => '18 days remaining';

  @override
  String billing_days_remaining_value(int days) {
    return '$days days remaining';
  }

  @override
  String get billing_plan_usage => 'Plan usage this month';

  @override
  String get billing_plan_usage_value => '22 of 30 days';

  @override
  String get billing_plan_usage_current => '22';

  @override
  String get billing_plan_usage_remaining => 'of 30 days';

  @override
  String billing_plan_usage_remaining_value(int days) {
    return 'of $days days';
  }

  @override
  String get billing_renew => 'Renew';

  @override
  String get billing_freeze => 'Freeze';

  @override
  String get billing_upgrade_tier => 'Upgrade tier';

  @override
  String get billing_cancel => 'Cancel';

  @override
  String get billing_default_payment_method => 'Default payment method';

  @override
  String get billing_expiration_date => 'Expiration date';

  @override
  String get billing_invoices => 'Invoices';

  @override
  String get billing_paid => 'Paid';

  @override
  String get billing_invoice_date => 'May 15, 2025';

  @override
  String get billing_no_subscription_title => 'No current subscription';

  @override
  String get billing_no_subscription_description =>
      'Your subscription details will appear here once you subscribe.';

  @override
  String get billing_no_active_subscription_title => 'No active subscription';

  @override
  String get billing_no_active_subscription_desc =>
      'You haven\'t subscribed to any package yet.\nChoose the right package and start your healthy journey.';

  @override
  String get billing_browse_subscriptions => 'Explore Subscriptions';

  @override
  String get billing_no_invoices_title => 'No invoices yet';

  @override
  String get billing_no_invoices_desc =>
      'Your subscription invoices will appear here after completing your first payment.';

  @override
  String get billing_manage_subscription => 'Manage subscription';

  @override
  String get billing_notice =>
      'You can freeze your subscription for up to 30 days once every 6 months. Once cancelled, you can still enjoy your meals until the end of the current billing cycle.';

  @override
  String get billing_pending_upgrade_notice =>
      'There is a pending upgrade request currently being processed.';

  @override
  String get billing_action_unavailable =>
      'This action is not available right now.';

  @override
  String get billing_renew_confirm_title => 'Renew subscription';

  @override
  String get billing_renew_confirm_message =>
      'Submit a renewal request for this subscription?';

  @override
  String get billing_freeze_confirm_title => 'Freeze subscription';

  @override
  String get billing_freeze_confirm_message =>
      'Choose the freeze dates, then confirm the request.';

  @override
  String get billing_pick_freeze_dates => 'Pick freeze dates';

  @override
  String billing_selected_freeze_dates(String startDate, String endDate) {
    return '$startDate - $endDate';
  }

  @override
  String get billing_optional_reason => 'Reason (optional)';

  @override
  String billing_freeze_range_too_long(int days) {
    return 'Freeze duration cannot exceed $days days.';
  }

  @override
  String get billing_freeze_locked_days_cannot_be_frozen =>
      'Locked days cannot be frozen. Choose later dates.';

  @override
  String get billing_cancel_quote_title => 'Cancel subscription';

  @override
  String billing_cancel_quote_message(
    int days,
    String amount,
    String currency,
  ) {
    return 'Refundable days: $days\nRefund amount: $amount $currency';
  }

  @override
  String get billing_confirm => 'Confirm';

  @override
  String get billing_dismiss => 'Dismiss';

  @override
  String get billing_renew_success => 'Renewal request submitted.';

  @override
  String get billing_freeze_success => 'Freeze request submitted.';

  @override
  String get billing_cancel_success => 'Cancellation request submitted.';

  @override
  String get billing_action_failed =>
      'Could not complete the request. Please try again.';

  @override
  String get profile_addresses => 'Addresses';

  @override
  String get profile_addresses_subtitle => 'Manage delivery addresses';

  @override
  String get addresses_default => 'Default';

  @override
  String get addresses_active_delivery => 'Delivery address';

  @override
  String get addresses_access_instructions => 'Access instructions';

  @override
  String get addresses_current_home => 'Home';

  @override
  String get addresses_current_home_details =>
      'Apartment 525\nAhmed Mohamed Street\nFaiyum, Egypt';

  @override
  String get addresses_saved_section => 'Saved addresses';

  @override
  String get addresses_home_address => '1174 Roy Alley, Colorado 80205';

  @override
  String get addresses_work => 'Work';

  @override
  String get addresses_work_address =>
      '1801 California Street, Denver, Colorado 80202';

  @override
  String get addresses_other => 'Other address';

  @override
  String get addresses_other_address =>
      '3200 South Cherry Creek Street, Denver 80209';

  @override
  String get addresses_delivery_preferences => 'Delivery preferences';

  @override
  String get addresses_contact_on_arrival => 'Contact on arrival';

  @override
  String get addresses_contact_on_arrival_description =>
      'We will notify you when the courier arrives';

  @override
  String get addresses_leave_at_door => 'Leave the order at the door';

  @override
  String get addresses_leave_at_door_description =>
      'Leave the order in a safe place at the door';

  @override
  String get addresses_add_new => 'Add new address';

  @override
  String get addresses_availability_notice =>
      'Available meals and restaurants may vary by delivery area';

  @override
  String get addresses_save => 'Save address';

  @override
  String get addresses_save_success => 'Address saved successfully.';

  @override
  String get addresses_choose_location_title => 'Choose home location';

  @override
  String get addresses_choose_location_subtitle =>
      'Choose the main delivery location for home';

  @override
  String get addresses_confirm_location => 'Confirm location';

  @override
  String get addresses_home_address_title => 'Home address';

  @override
  String get addresses_home_address_subtitle =>
      'Enter your home address to set the main delivery location';

  @override
  String get addresses_governorate_label => 'Governorate';

  @override
  String get addresses_governorate_hint => 'Choose governorate';

  @override
  String get addresses_area_label => 'Area';

  @override
  String get addresses_area_hint => 'Choose area';

  @override
  String get addresses_area_required => 'Please choose an area from the list.';

  @override
  String get addresses_block_label => 'Block';

  @override
  String get addresses_block_hint => 'Choose block';

  @override
  String get addresses_street_label => 'Street';

  @override
  String get addresses_street_hint => 'Write street name';

  @override
  String get addresses_avenue_label => 'Avenue';

  @override
  String get addresses_avenue_hint => 'Write avenue name';

  @override
  String get addresses_optional => '(optional)';

  @override
  String get addresses_building_type_label => 'Building type';

  @override
  String get addresses_building_type_home => 'Home';

  @override
  String get addresses_building_type_building => 'Building';

  @override
  String get addresses_floor_label => 'Floor';

  @override
  String get addresses_floor_hint => 'Choose floor';

  @override
  String get addresses_building_number_label => 'House / building number';

  @override
  String get addresses_building_number_hint => 'Write number';

  @override
  String get addresses_apartment_number_label => 'Apartment number';

  @override
  String get addresses_apartment_number_hint => 'Write apartment number';

  @override
  String get addresses_use_current_location => 'Use my current location';

  @override
  String get addresses_use_current_location_subtitle =>
      'Set my current location as home address';

  @override
  String get addresses_search_hint => 'Search for address, area or street';

  @override
  String get addresses_choose_from_map => 'Choose from map';

  @override
  String get addresses_choose_from_map_subtitle =>
      'Select your location on the map';

  @override
  String get addresses_use_current_location_desc =>
      'Automatically detects your current location';

  @override
  String get address_active_delivery_cannot_delete =>
      'This address is currently used for delivery. Set another default address and wait 72 hours for it to activate before deleting this one.';

  @override
  String get addresses_out_of_kuwait_bounds =>
      'The selected location must be within Kuwait bounds.';

  @override
  String get addresses_delivery_notice_title => 'Delivery address update';

  @override
  String get addresses_delivery_notice_action => 'Got it';

  @override
  String get addresses_edit => 'Edit';

  @override
  String get addresses_set_default => 'Set as default';

  @override
  String get addresses_delete => 'Delete';

  @override
  String get addresses_delete_confirmation_title => 'Delete address?';

  @override
  String get addresses_delete_confirmation_message =>
      'Are you sure you want to delete this address?';

  @override
  String get addresses_delete_confirmation_cancel => 'Cancel';

  @override
  String get addresses_delete_confirmation_action => 'Delete';

  @override
  String get profile_security => 'Security and privacy';

  @override
  String get profile_security_subtitle =>
      'Change your password and privacy settings';

  @override
  String get profile_privacy_security_section => 'Security';

  @override
  String get profile_privacy_section => 'Privacy';

  @override
  String get profile_privacy_change_password => 'Change password';

  @override
  String get profile_privacy_change_password_subtitle =>
      'Update the password for your account';

  @override
  String get profile_privacy_phone_verification => 'Verify phone number';

  @override
  String get profile_privacy_phone_verification_subtitle =>
      'Verify your phone number to keep your account secure';

  @override
  String get profile_privacy_email_verification => 'Verify email address';

  @override
  String get profile_privacy_email_verification_subtitle =>
      'Verify your email address to secure your account';

  @override
  String get profile_privacy_location_permission => 'Location permission';

  @override
  String get profile_privacy_location_permission_subtitle =>
      'Allow access to your location for better services';

  @override
  String get profile_privacy_notifications => 'Notifications';

  @override
  String get profile_privacy_notifications_subtitle =>
      'Customize alerts and updates';

  @override
  String get profile_privacy_policy => 'Privacy policy';

  @override
  String get profile_privacy_policy_subtitle =>
      'Learn how we collect and use your data';

  @override
  String get profile_privacy_terms => 'Terms and conditions';

  @override
  String get profile_privacy_terms_subtitle =>
      'Review the terms and conditions of the service';

  @override
  String get profile_privacy_permissions_title =>
      'Enable permissions for a better experience';

  @override
  String get profile_privacy_permissions_message =>
      'Permissions help us provide more accurate services and recommendations.';

  @override
  String get profile_privacy_password_reminder_title =>
      'We recommend updating your password regularly';

  @override
  String get profile_privacy_password_reminder_message =>
      'Regular updates increase account security and protect your personal data.';

  @override
  String get profile_privacy_manage_security => 'Manage security';

  @override
  String get coming_soon_subtitle =>
      'This section is being prepared and will be available soon.';

  @override
  String get drawer_guest_name => 'Ahmed Mohamed';

  @override
  String get drawer_welcome => 'Welcome,';

  @override
  String get drawer_weight_loss_program => 'Weight loss program';

  @override
  String get drawer_month_package => 'Monthly package';

  @override
  String get drawer_account => 'Account';

  @override
  String get drawer_my_account => 'My account';

  @override
  String get drawer_payment_methods => 'Payment methods';

  @override
  String get drawer_notifications => 'Notifications';

  @override
  String get drawer_subscription => 'Subscription';

  @override
  String get drawer_current_subscription => 'Current subscription';

  @override
  String get drawer_family_members => 'Family members';

  @override
  String get drawer_orders => 'Orders';

  @override
  String get drawer_previous_orders => 'Previous orders';

  @override
  String get drawer_track_current_order => 'Track current order';

  @override
  String get drawer_rewards_offers => 'Rewards and offers';

  @override
  String get drawer_points_rewards => 'Points and rewards';

  @override
  String get drawer_invite_friends => 'Invite friends';

  @override
  String get drawer_special_offers => 'Special offers';

  @override
  String get drawer_support_help => 'Support and help';

  @override
  String get drawer_technical_support => 'Technical support';

  @override
  String get drawer_faq => 'FAQ';

  @override
  String get drawer_contact_us => 'Contact us';

  @override
  String get drawer_settings => 'Settings';

  @override
  String get drawer_language => 'Language';

  @override
  String get drawer_logout => 'Log out';

  @override
  String get profile_logout_confirmation_message =>
      'Are you sure you want to log out?';

  @override
  String get profile_logout_cancel => 'Cancel';

  @override
  String get offers_title => 'Offers';

  @override
  String get offers_hero_badge => 'Off';

  @override
  String get offers_hero_discount => '30%';

  @override
  String get offers_hero_title => '30% off';

  @override
  String get offers_hero_subtitle => 'on all plans';

  @override
  String get offers_hero_description => 'Start your healthy journey today';

  @override
  String get offers_hero_button => 'Subscribe now';

  @override
  String get offers_filter_all => 'All';

  @override
  String get offers_filter_offers => 'Subscriptions';

  @override
  String get offers_filter_restaurants => 'Coupons';

  @override
  String get offers_filter_meals => 'Limited time';

  @override
  String get offers_filter_gifts => 'Gifts';

  @override
  String get offers_featured_section_title => 'Featured offers';

  @override
  String get offers_view_all => 'View all';

  @override
  String get offers_restaurants_section_title => 'Popular restaurants';

  @override
  String get offers_invite_title => 'Invite friends and get';

  @override
  String get offers_invite_subtitle => '30% off';

  @override
  String get offers_invite_button => 'Invite friends';

  @override
  String get offers_coupon_prefix => 'Use ';

  @override
  String get offers_coupon_highlight => 'discount code';

  @override
  String get offers_coupon_suffix => ' to get';

  @override
  String get offers_coupon_second_line => 'a discount on your subscription';

  @override
  String get offers_coupon_button => 'Redeem now';

  @override
  String get offers_countdown_label => 'Ends in';

  @override
  String get offers_countdown_value => '10:18:24';

  @override
  String get offers_featured_button => 'Subscribe now';

  @override
  String get offers_featured_burger_title => 'Monthly package';

  @override
  String get offers_featured_burger_subtitle => 'Balanced meals all month';

  @override
  String get offers_featured_burger_discount => '-20%';

  @override
  String get offers_featured_burger_badge => '-20%';

  @override
  String get offers_featured_burger_delivery => '10:18:24';

  @override
  String get offers_featured_burger_reviews => '4.9';

  @override
  String get offers_featured_salad_title => 'Protein package';

  @override
  String get offers_featured_salad_subtitle => '20 protein-rich meals';

  @override
  String get offers_featured_salad_discount => 'Most useful';

  @override
  String get offers_featured_salad_badge => 'Healthy pick';

  @override
  String get offers_featured_salad_delivery => '10:18:24';

  @override
  String get offers_featured_salad_reviews => '4.8';

  @override
  String get offers_featured_gift_title => '3-month subscription';

  @override
  String get offers_featured_gift_subtitle =>
      'Bigger savings with a complete 3-month nutrition plan';

  @override
  String get offers_featured_gift_discount => '-15%';

  @override
  String get offers_featured_gift_badge => '-15%';

  @override
  String get offers_featured_gift_delivery => '10:18:24';

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

  @override
  String get offer_details_title => 'Offer details';

  @override
  String get offer_details_hero_heading => '20% off monthly plans';

  @override
  String get offer_details_hero_subtitle => 'Complete nutrition plans';

  @override
  String get offer_details_hero_description =>
      'Helps you stay on track with your goals';

  @override
  String get offer_details_hero_timer_label => 'Ends in';

  @override
  String get offer_details_info_title => 'Offer details';

  @override
  String get offer_details_info_summary => '20% off on all monthly plans';

  @override
  String get offer_details_info_duration_label => 'Offer duration';

  @override
  String get offer_details_info_coupon_label => 'Coupon code';

  @override
  String get offer_details_info_terms_label => 'Terms and conditions';

  @override
  String get offer_details_info_terms_description =>
      'This offer applies to monthly plans only and cannot be combined with other offers.';

  @override
  String get offer_details_info_copy_code => 'Copy';

  @override
  String get offer_details_plan_section_title => 'Choose the right plan';

  @override
  String get offer_details_plan_month_title => 'Monthly plan';

  @override
  String get offer_details_plan_half_month_title => 'Half-month plan';

  @override
  String get offer_details_plan_week_title => 'Weekly plan';

  @override
  String get offer_details_plan_duration_month => '26 days';

  @override
  String get offer_details_plan_duration_half_month => '12 days';

  @override
  String get offer_details_plan_duration_week => '6 days';

  @override
  String get offer_details_plan_meals => '4 meals per day';

  @override
  String get offer_details_summary_title => 'Total after discount';

  @override
  String get offer_details_summary_button => 'Continue purchase';

  @override
  String get offer_details_summary_secure_payment => 'Secure payment';

  @override
  String get offer_details_open_plans_button => 'Choose plan';

  @override
  String get currency => 'KWD';

  @override
  String get payment_title => 'Payment';

  @override
  String get payment_order_summary_title => 'Order Summary';

  @override
  String get payment_plan_month => 'Monthly Plan';

  @override
  String get payment_plan_duration => '26 days';

  @override
  String get payment_plan_meals => '4 meals per day';

  @override
  String get payment_base_price_label => 'Base price';

  @override
  String get payment_discount_label => 'Discount (20%)';

  @override
  String get payment_total_after_discount => 'Total after discount';

  @override
  String get payment_coupon_hint => 'User discount code';

  @override
  String get payment_method_section_title => 'Choose payment method';

  @override
  String get payment_method_mada => 'Mada Card';

  @override
  String get payment_method_mada_subtitle => 'Pay using Mada cards';

  @override
  String get payment_method_visa => 'Credit / Debit Card';

  @override
  String get payment_method_visa_subtitle => 'Visa, Mastercard';

  @override
  String get payment_method_apple => 'Apple Pay';

  @override
  String get payment_method_apple_subtitle => 'Pay using Apple Pay';

  @override
  String get payment_method_wallet => 'MealMate Wallet';

  @override
  String get payment_method_wallet_balance => 'Available balance:';

  @override
  String get payment_card_details_title => 'Card Details';

  @override
  String get payment_card_number_label => 'Card number';

  @override
  String get payment_card_number_hint => '•••• •••• •••• ••••';

  @override
  String get payment_expiry_hint => 'MM / YY';

  @override
  String get payment_cvv_hint => '•••';

  @override
  String get payment_expiry_label => 'Expiry date';

  @override
  String get payment_cvv_label => 'CVV';

  @override
  String get payment_card_holder_hint => 'Name as on card';

  @override
  String get payment_card_holder_label => 'Card holder name';

  @override
  String get payment_total_label => 'Total amount due';

  @override
  String get payment_total_includes_tax => 'Includes tax';

  @override
  String get payment_pay_now_button => 'Pay Now';

  @override
  String get payment_secure_label => 'Secure payment';

  @override
  String get payment_success_title => 'Payment Successful!';

  @override
  String get payment_success_subtitle =>
      'Your subscription is now active. Enjoy your healthy meals.';

  @override
  String get payment_success_button => 'Back to Home';

  @override
  String get payment_calendar_preparing =>
      'Preparing your subscription days...';

  @override
  String get subscription_screen_title => 'Plans and subscriptions';

  @override
  String get subscription_hero_title => 'Save more with plans';

  @override
  String get subscription_hero_subtitle =>
      'Choose the plan that fits your lifestyle and enjoy healthy meals every day';

  @override
  String get subscription_choose_plan_title =>
      'Choose the package that suits you';

  @override
  String get subscription_choose_plan_button => 'Choose plan';

  @override
  String get subscription_packages_empty_title =>
      'No packages available right now';

  @override
  String get subscription_packages_empty_description =>
      'There are no packages for this program yet. Try another program or check again later.';

  @override
  String get subscription_individual_packages => 'Individual packages';

  @override
  String get subscription_family_packages => 'Family packages';

  @override
  String get subscription_best_value => 'Best value';

  @override
  String get subscription_view_family_package => 'View family package';

  @override
  String get subscription_selected_program_label => 'Selected program:';

  @override
  String get subscription_weight_loss_title => 'Weight loss';

  @override
  String get subscription_weight_loss_description =>
      'A low-calorie program to help you lose weight in a healthy and safe way';

  @override
  String get subscription_less_calories => 'Less calories';

  @override
  String get subscription_effective_results => 'Effective results';

  @override
  String get subscription_four_meals_package => '4 meals package';

  @override
  String get subscription_four_meals_details =>
      'Breakfast - Lunch - Dinner - Snack';

  @override
  String get subscription_three_meals_package => '3 meals package';

  @override
  String get subscription_three_meals_details => '14 days - 3 meals daily';

  @override
  String get subscription_two_meals_package => '2 meals package';

  @override
  String get subscription_two_meals_details => '7 days - 2 meals daily';

  @override
  String get subscription_month_plan_title => 'Monthly plan';

  @override
  String get subscription_month_package_prefix => 'Month';

  @override
  String get subscription_month_package_highlight => 'package';

  @override
  String get subscription_half_month_plan_title => 'Half-month plan';

  @override
  String get subscription_week_plan_title => 'Week';

  @override
  String get subscription_week_plan_price => '930';

  @override
  String get subscription_month_duration => '26 days';

  @override
  String get subscription_duration_title => 'Subscription duration';

  @override
  String get subscription_custom_duration => 'Custom';

  @override
  String get subscription_add_friday => 'Add Friday';

  @override
  String subscription_days_range_hint(int minDays, int maxDays) {
    return 'You can enter any number of days ($minDays-$maxDays days)';
  }

  @override
  String get subscription_custom_duration_input_hint => 'Enter days';

  @override
  String subscription_custom_duration_invalid_error(int minDays, int maxDays) {
    return 'Enter a number from $minDays to $maxDays';
  }

  @override
  String get subscription_custom_duration_duplicate_error =>
      'This duration is already available as a preset';

  @override
  String get subscription_day => 'Day';

  @override
  String get subscription_half_month_duration => '12 days';

  @override
  String get subscription_week_duration => '7 days';

  @override
  String get subscription_meals_per_day => '4 meals daily';

  @override
  String get subscription_healthy_balanced => 'Healthy balanced meals';

  @override
  String get subscription_free_delivery => 'Free delivery';

  @override
  String get subscription_month_period => 'Monthly';

  @override
  String get subscription_half_month_period => 'Half month';

  @override
  String get subscription_week_period => 'Weekly';

  @override
  String get subscription_discount_20 => '20% off';

  @override
  String get subscription_limited_discount => '20% off for a limited time';

  @override
  String get subscription_note =>
      'All plans include 20% off all orders. You can pause or edit the plan anytime';

  @override
  String get subscription_program_title => 'Choose your program';

  @override
  String get subscription_program_subtitle =>
      'Choose the goal that suits you so we can show the right plans';

  @override
  String get subscription_type_title => 'Choose subscription type';

  @override
  String get subscription_type_subtitle =>
      'Start by choosing whether you want an individual subscription or a family subscription';

  @override
  String get subscription_type_hero_label => 'Healthy food, better life';

  @override
  String get subscription_type_individual_label => 'Individual subscription';

  @override
  String get subscription_type_individual_description =>
      'For one person with a meal program that fits your goal';

  @override
  String get subscription_type_individual_restaurants => 'Varied restaurants';

  @override
  String get subscription_type_individual_meal_flexibility =>
      'Flexible meal count';

  @override
  String get subscription_type_individual_customization =>
      'Program customization';

  @override
  String get subscription_type_family_label => 'Family subscription';

  @override
  String get subscription_type_family_description =>
      'Add family members and set a suitable program for each person';

  @override
  String get subscription_type_family_members => 'Up to 6 members';

  @override
  String get subscription_type_family_customization =>
      'Personalized for each person';

  @override
  String get subscription_type_family_management => 'Easy family management';

  @override
  String get subscription_type_notice_label =>
      'After choosing the subscription type, you will move to the next step';

  @override
  String get subscription_conversion_title => 'Choose conversion option';

  @override
  String get subscription_conversion_subtitle =>
      'Your current individual subscription can be converted before starting the family flow.';

  @override
  String get subscription_conversion_create_family_manager =>
      'Create a family and become manager';

  @override
  String get subscription_conversion_create_family_manager_subtitle =>
      'Convert your current subscription and continue setting up family members.';

  @override
  String get subscription_conversion_change_individual_plan =>
      'Change my individual plan';

  @override
  String get subscription_conversion_coming_soon => 'Coming soon';

  @override
  String get subscription_conversion_unavailable =>
      'This option is not available now.';

  @override
  String get subscription_conversion_option_available => 'Available option';

  @override
  String get subscription_conversion_option_unavailable => 'Unavailable option';

  @override
  String get subscription_details_view_mode => 'View mode';

  @override
  String get subscription_details_explore_meals => 'Explore plan meals';

  @override
  String get subscription_details_meals_count =>
      'More than 120 varied healthy meals';

  @override
  String get subscription_details_popular_meals => 'Popular meals';

  @override
  String get subscription_details_features_title => 'Plan features';

  @override
  String get subscription_details_meal_suffix => 'meals';

  @override
  String get subscription_details_meals_in_plan => 'meals in the plan';

  @override
  String get subscription_details_most_selected => 'Most selected';

  @override
  String get subscription_details_subscribe_now => 'Subscribe now';

  @override
  String get subscription_restaurant_categories_title => 'Browse categories';

  @override
  String get subscription_restaurant_categories_subtitle =>
      'Each category includes a curated selection of featured restaurants.';

  @override
  String get subscription_tier_elite => 'Select';

  @override
  String get subscription_tier_plus => 'Plus';

  @override
  String get subscription_tier_max => 'Max';

  @override
  String get subscription_summary_title => 'Subscription summary';

  @override
  String get subscription_summary_duration_label => 'Duration';

  @override
  String get subscription_summary_duration_value => 'One month';

  @override
  String get subscription_summary_package_label => 'Package';

  @override
  String get subscription_summary_restaurant_tier_label => 'Restaurant tier';

  @override
  String get subscription_summary_restaurant_tier_value => 'Platinum';

  @override
  String get subscription_summary_includes_label =>
      'Your subscription includes';

  @override
  String get subscription_summary_daily_meals =>
      '4 meals daily (breakfast - lunch - dinner - snack)';

  @override
  String get subscription_summary_restaurants => 'More than 100 restaurants';

  @override
  String get subscription_summary_show_more => 'Show more';

  @override
  String get subscription_summary_all_restaurants => 'Available restaurants';

  @override
  String get subscription_summary_no_restaurants_for_address =>
      'No restaurants currently cover this delivery address.';

  @override
  String get subscription_no_restaurants_for_area =>
      'No restaurants are available for your area.';

  @override
  String get subscription_change_address => 'Change address';

  @override
  String get subscription_summary_quality => 'High-quality ingredients';

  @override
  String get subscription_summary_variety => 'Daily meal variety';

  @override
  String get subscription_summary_total_price_label => 'Total price';

  @override
  String get subscription_start_date_picker_label => 'Subscription starts from';

  @override
  String get subscription_chosen_start_date_label => 'Start/payment day';

  @override
  String get subscription_first_delivery_date_label => 'First delivery day';

  @override
  String get subscription_restaurant_repetition_label =>
      'Restaurant repetition';

  @override
  String subscription_restaurant_repetition_message(int limit) {
    return 'You can choose the same restaurant for up to $limit days during the subscription.';
  }

  @override
  String get subscription_payment_confirmation_title =>
      'Confirm subscription dates';

  @override
  String get subscription_continue_to_payment => 'Continue to payment';

  @override
  String get checkout_start_date_required =>
      'Please choose a subscription start date.';

  @override
  String get checkout_start_date_invalid =>
      'The selected date is in the past. Please choose another date.';

  @override
  String get subscription_flow_profile_incomplete =>
      'Please complete your profile before checkout.';

  @override
  String get checkout_address_required =>
      'Please add a delivery address before checkout.';

  @override
  String get checkout_allergies_required =>
      'Please confirm your allergy preferences before checkout.';

  @override
  String get checkout_dietary_preferences_required =>
      'Please confirm your dietary preferences before checkout.';

  @override
  String get checkout_existing_subscription =>
      'You already have an active individual subscription.';

  @override
  String get checkout_restaurant_not_eligible =>
      'This address is not covered by the selected restaurants. Please change your address or area.';

  @override
  String get checkout_redirect_url_not_allowed =>
      'The payment return link is not allowed. Please try again later.';

  @override
  String get family_restaurants_date_label => 'Monday, May 26';

  @override
  String get family_restaurants_search_hint =>
      'Search for a restaurant or meal';

  @override
  String get family_restaurants_title_prefix => 'Choose restaurants';

  @override
  String get family_restaurants_subtitle =>
      'These restaurants were recommended based on your goal and preferences';

  @override
  String get family_restaurants_summary_selected_meals_value => '4';

  @override
  String get family_restaurants_summary_selected_meals_total => '/2';

  @override
  String get family_restaurants_summary_selected_meals_label => 'selected';

  @override
  String get family_restaurants_summary_daily_meals_value => '4';

  @override
  String get family_restaurants_summary_daily_meals_label => 'daily meals';

  @override
  String get family_restaurants_summary_calories_value => '1500';

  @override
  String get family_restaurants_summary_calories_label => 'calories daily';

  @override
  String get family_restaurants_filter_balanced => 'Balanced';

  @override
  String get family_restaurants_filter_dinner => 'Dinner';

  @override
  String get family_restaurants_filter_lunch => 'Lunch';

  @override
  String get family_restaurants_filter_breakfast => 'Breakfast';

  @override
  String get family_restaurants_filter_high_protein => 'High protein';

  @override
  String get family_restaurants_filter_all => 'All';

  @override
  String get family_restaurants_diet_house => 'Diet House';

  @override
  String get family_restaurants_card_subtitle =>
      'Delicious and complete diet meals';

  @override
  String get family_restaurants_logo_diet_house_line1 => 'DIET';

  @override
  String get family_restaurants_logo_diet_house_line2 => 'HOUSE';

  @override
  String get family_restaurants_rating_diet_house => '4.7';

  @override
  String get family_restaurants_browse_meals => 'Browse meals';

  @override
  String get family_restaurants_healthy_bowl => 'Healthy Bowl';

  @override
  String get family_restaurants_logo_healthy_bowl_line1 => 'HEALTHY';

  @override
  String get family_restaurants_logo_healthy_bowl_line2 => 'BOWL';

  @override
  String get family_restaurants_rating_healthy_bowl => '4.6';

  @override
  String get family_restaurants_protein_kitchen => 'Protein Kitchen';

  @override
  String get family_restaurants_logo_protein_kitchen_line1 => 'THE';

  @override
  String get family_restaurants_logo_protein_kitchen_line2 => 'PROTEIN';

  @override
  String get family_restaurants_logo_protein_kitchen_line3 => 'KITCHEN';

  @override
  String get family_restaurants_rating_protein_kitchen => '4.3';

  @override
  String get family_restaurants_salad_station => 'Salad Station';

  @override
  String get family_restaurants_logo_salad_station_line1 => 'SALAD';

  @override
  String get family_restaurants_logo_salad_station_line2 => 'STATION';

  @override
  String get family_restaurants_rating_salad_station => '4.6';

  @override
  String get family_restaurants_assurance_title =>
      'All recommendations respect your preferences and allergies';

  @override
  String get family_restaurants_assurance_subtitle =>
      'Choose confidently. All meals are suitable and support your health goal';

  @override
  String get family_details_title => 'Family plan details';

  @override
  String get family_plan_title => 'Family plan';

  @override
  String get family_plan_subtitle => 'Complete plan for up to 6 members';

  @override
  String get family_plan_new => 'New';

  @override
  String get family_manage_title => 'Family package management';

  @override
  String get family_manage_active => 'Active';

  @override
  String get family_manage_instead_of => 'Instead of';

  @override
  String get family_manage_ends_on => 'Ends on May 26, 2024';

  @override
  String get family_manage_family_members => 'Family members';

  @override
  String get family_manage_show_all => 'Show all';

  @override
  String get family_manage_quick_access => 'Quick access';

  @override
  String get family_manage_meals => 'Meals';

  @override
  String get family_manage_subscription => 'Subscription';

  @override
  String get family_manage_invoice => 'Invoice';

  @override
  String get family_manage_permissions => 'Permissions';

  @override
  String get family_manage_missing_selection => 'Missing selection';

  @override
  String get family_manage_today_meals_status => 'Today\'s meal status';

  @override
  String get family_manage_today_date => 'Monday, May 26';

  @override
  String get family_manage_meal_count_4 => '4/4 meals';

  @override
  String get family_manage_meal_count_2 => '2/4 meals';

  @override
  String get family_manage_meal_count_0 => '0/4 meals';

  @override
  String get family_manage_completed_status => 'Completed';

  @override
  String get family_manage_selected_status => 'Selected';

  @override
  String get family_manage_not_started_status => 'Not started';

  @override
  String get family_manage_complete_missing_meals => 'Complete missing meals';

  @override
  String get family_manage_warning_title =>
      'Some members have not selected their meals';

  @override
  String get family_manage_warning_message =>
      'Please select today\'s meals for: Ahmed';

  @override
  String family_member_permissions_title(String memberName) {
    return 'Permissions for $memberName';
  }

  @override
  String family_member_permissions_subtitle(String memberName) {
    return 'Choose what $memberName can do inside the account';
  }

  @override
  String get family_member_permissions_note =>
      'The family manager remains in primary control of the family plan settings\nand can edit permissions at any time';

  @override
  String get family_member_permissions_save => 'Save';

  @override
  String get family_member_permissions_confirm_title => 'Save Permissions';

  @override
  String family_member_permissions_confirm_desc(String memberName) {
    return 'Are you sure you want to save the permission changes for $memberName?';
  }

  @override
  String get family_member_permissions_confirm_cancel => 'Cancel';

  @override
  String get family_member_permissions_confirm_action => 'Confirm';

  @override
  String get family_member_permissions_meals_section => 'Meals';

  @override
  String get family_member_permissions_program_section => 'Program';

  @override
  String get family_member_permissions_settings_section =>
      'Account and settings';

  @override
  String get family_member_permission_choose_daily_meals =>
      'Choose daily meals';

  @override
  String get family_member_permission_edit_meals_before_lock =>
      'Edit meals before lock time';

  @override
  String get family_member_permission_view_meal_details => 'View meal details';

  @override
  String get family_member_permission_view_nutrition_program =>
      'View nutrition program';

  @override
  String get family_member_permission_change_nutrition_program =>
      'Change nutrition program';

  @override
  String get family_member_permission_edit_meals_and_days_count =>
      'Edit meals and days count';

  @override
  String get family_member_permission_edit_address => 'Edit address';

  @override
  String get family_member_permission_replace_meal => 'Replace meal';

  @override
  String get family_member_permission_view_reports_and_payments =>
      'View reports and payments';

  @override
  String get family_member_permission_leave_family_plan => 'Leave family plan';

  @override
  String family_member_access_title(String memberName) {
    return 'Access management for $memberName';
  }

  @override
  String get family_member_access_status_title => 'Account Status';

  @override
  String get family_member_access_status_active => 'Active';

  @override
  String get family_member_access_status_paused => 'Paused';

  @override
  String get family_member_access_permissions_tile_title =>
      'App Usage Permissions';

  @override
  String get family_member_access_permissions_tile_subtitle =>
      'Control meal selection, replacement, and address editing';

  @override
  String family_member_access_last_login(String timeAgo) {
    return 'Last login $timeAgo';
  }

  @override
  String get family_member_access_credentials_section => 'Login Credentials';

  @override
  String get family_member_access_email_label => 'Email';

  @override
  String get family_member_access_password_label => 'Password';

  @override
  String get family_member_access_edit => 'Edit';

  @override
  String get family_member_access_independent_title =>
      'Has Independent Account';

  @override
  String family_member_access_independent_subtitle(String memberName) {
    return 'When enabled, $memberName can log in and independently manage meals and settings';
  }

  @override
  String get family_member_access_membership_section => 'Membership Management';

  @override
  String family_member_access_membership_subtitle(String memberName) {
    return 'Control $memberName\'s membership status in the family plan';
  }

  @override
  String get family_member_access_active_desc =>
      'Can access all features and use the plan';

  @override
  String get family_member_access_paused_desc =>
      'Access is temporarily suspended while retaining data and settings';

  @override
  String get family_member_access_deactivate_button => 'Deactivate Account';

  @override
  String get family_member_access_deactivate_confirm_title =>
      'Deactivate Member Account';

  @override
  String family_member_access_deactivate_confirm_desc(String memberName) {
    return 'Are you sure you want to deactivate $memberName\'s account? Access to the plan will be suspended.';
  }

  @override
  String get family_member_access_deactivate_cancel => 'Cancel';

  @override
  String get family_member_access_deactivate_confirm_action =>
      'Confirm Deactivation';

  @override
  String get family_member_access_save_button => 'Save Changes';

  @override
  String get family_member_access_save_success =>
      'Access changes saved successfully';

  @override
  String get family_member_permissions_save_success =>
      'Permissions saved successfully';

  @override
  String get family_member_renewal_success =>
      'Renewal request submitted successfully';

  @override
  String get family_members_title => 'Members';

  @override
  String get family_members_search_hint => 'Search for a member';

  @override
  String get family_members_add_member => 'Add member';

  @override
  String get family_member_has_account => 'Has account';

  @override
  String get family_member_all_meals_manager => 'All meals managed by manager';

  @override
  String get family_member_some_meals_customized => 'Some meals customized';

  @override
  String get family_member_no_plan_selected => 'No plan selected';

  @override
  String get family_plan_feature_group_delivery => 'Group delivery';

  @override
  String get family_plan_feature_one_invoice => 'One invoice';

  @override
  String get family_plan_feature_group_discount => 'Group discount';

  @override
  String get family_plan_feature_all_meals => 'Meals for everyone';

  @override
  String get family_plan_feature_individual_plan => 'Plan for each member';

  @override
  String get family_add_member => 'Add new member';

  @override
  String get family_add_member_subtitle =>
      'Customize a nutrition plan for each family member';

  @override
  String get family_edit_member => 'Edit';

  @override
  String get family_owner => 'Owner';

  @override
  String get family_member_ahmed => 'Ahmed';

  @override
  String get family_member_sarah => 'Sarah';

  @override
  String get family_member_yousef => 'Yousef';

  @override
  String get family_member_mariam => 'Mariam';

  @override
  String get family_member_laila => 'Laila';

  @override
  String get family_member_omar => 'Omar';

  @override
  String get family_member_hana => 'Hana';

  @override
  String get family_member_khaled => 'Khaled';

  @override
  String get family_summary_title => 'Family plan summary';

  @override
  String get family_current_members => 'Current members';

  @override
  String get family_max_members => 'Plan member limit';

  @override
  String get family_total_daily_meals => 'Total daily meals';

  @override
  String get family_total_daily_calories => 'Total daily calories';

  @override
  String get family_one_delivery => 'One delivery for the family';

  @override
  String get family_group_delivery => 'Group delivery';

  @override
  String get family_meals_each_member => 'Meals for each member';

  @override
  String get family_table_member => 'Member';

  @override
  String get family_table_breakfast => 'Breakfast';

  @override
  String get family_table_lunch => 'Lunch';

  @override
  String get family_table_snack => 'Snack';

  @override
  String get family_table_dinner => 'Dinner';

  @override
  String get family_table_meals_count => 'Meals';

  @override
  String get family_meals_3 => '3 meals';

  @override
  String get family_meals_4 => '4 meals';

  @override
  String get family_meals_5 => '5 meals';

  @override
  String get family_price_details => 'Price details';

  @override
  String get family_base_price_two_members => 'Base price (for 2 members)';

  @override
  String get family_extra_members_price => 'Extra members (2 x 7.500 KWD)';

  @override
  String get family_total => 'Total:';

  @override
  String get family_confirm_plan => 'Confirm plan';

  @override
  String get family_add_member_dialog_subtitle =>
      'Enter member details to add them to the family plan';

  @override
  String get family_full_name => 'Full name';

  @override
  String get family_full_name_hint => 'Write the name here';

  @override
  String get family_phone_number => 'Phone number';

  @override
  String get family_phone_number_hint => '+965 0000 0000';

  @override
  String get family_phone_lookup => 'Find member';

  @override
  String get family_error_already_in_family =>
      'This phone number already belongs to another family.';

  @override
  String get family_error_plan_locked =>
      'This member already has an active subscription. Their plan cannot be changed here.';

  @override
  String get family_error_plan_incomplete =>
      'Complete this member\'s program, package, tier, and duration.';

  @override
  String get family_error_member_incomplete =>
      'Choose at least one member and complete their subscription details.';

  @override
  String get family_occupation => 'Occupation';

  @override
  String get family_occupation_hint => 'Enter occupation (optional)';

  @override
  String get family_relation => 'Relationship';

  @override
  String get family_relation_hint => 'Choose relationship';

  @override
  String get family_relation_input_hint => 'Enter relationship';

  @override
  String get family_age => 'Age';

  @override
  String get family_age_hint => 'Enter age';

  @override
  String get family_age_invalid => 'Enter an age between 1 and 120';

  @override
  String get family_year => 'Year';

  @override
  String get family_nutrition_goal => 'Nutrition goal';

  @override
  String get family_nutrition_goal_hint => 'Choose goal';

  @override
  String get family_activity_level => 'Activity level';

  @override
  String get family_activity_low => 'Low activity';

  @override
  String get family_activity_medium => 'Medium';

  @override
  String get family_activity_high => 'Active';

  @override
  String get family_daily_meals_count => 'Daily meals count';

  @override
  String get family_info => 'Info';

  @override
  String get family_info_message =>
      'You can edit the data anytime from member settings';

  @override
  String get family_add_member_button => 'Add member';

  @override
  String get family_cancel => 'Cancel';

  @override
  String get family_delete_member_confirmation_title => 'Delete member?';

  @override
  String get family_delete_member_confirmation_message =>
      'Are you sure you want to delete this member?';

  @override
  String get family_delete_member_success => 'Member deleted successfully';

  @override
  String get family_add_member_success => 'Member added successfully';

  @override
  String get family_update_member_success => 'Member updated successfully';

  @override
  String get family_setup_title => 'Family subscription setup';

  @override
  String get family_setup_subtitle =>
      'Customize the perfect plan for each family member';

  @override
  String get family_name => 'Family name';

  @override
  String get family_name_hint => 'Write the family name here';

  @override
  String get family_location => 'Location';

  @override
  String get family_location_hint => 'Choose member location';

  @override
  String get family_member_completed => 'Completed';

  @override
  String get family_next_program => 'Next: program';

  @override
  String get family_header_badge => 'Ahmed family';

  @override
  String get family_setup_step_one => '1';

  @override
  String get family_setup_step_two => '2';

  @override
  String get family_setup_step_three => '3';

  @override
  String get family_step_create_family => 'Create family';

  @override
  String get family_step_program => 'Program';

  @override
  String get family_step_location => 'Location';

  @override
  String get family_step_allergies => 'Allergies';

  @override
  String get family_step_package_days => 'Package and days';

  @override
  String get family_step_payment => 'Payment';

  @override
  String get family_setup_step_four => '4';

  @override
  String get family_setup_step_five => '5';

  @override
  String get family_member_not_started => 'Not started';

  @override
  String get family_member_in_progress => 'In progress';

  @override
  String get family_selected_member_age => '24 years';

  @override
  String get family_selected_member_gender => 'Male';

  @override
  String get family_selected_member_goal_label => 'Goal';

  @override
  String get family_program_choose_title => 'Choose the right program';

  @override
  String get family_program_balanced_title => 'Balanced';

  @override
  String get family_program_balanced_description =>
      'A balanced diet for better food and health';

  @override
  String get family_program_weight_loss_title => 'Weight loss';

  @override
  String get family_program_weight_loss_description =>
      'Lower calories to support weight loss';

  @override
  String get family_program_muscle_title => 'Muscle gain';

  @override
  String get family_program_muscle_description =>
      'Protein-rich to support muscle building';

  @override
  String get family_program_keto_title => 'Keto';

  @override
  String get family_program_keto_description => 'Low carbs and high fat';

  @override
  String get family_next_package_days => 'Next: package and days';

  @override
  String get family_previous_program => 'Previous: program';

  @override
  String get family_package_choose_title => '2. Choose package and days';

  @override
  String get family_package_choose_subtitle => 'Choose the suitable package';

  @override
  String get family_package_three_meals_title => '3 meals daily';

  @override
  String get family_package_three_meals_description =>
      'Includes breakfast, lunch and dinner';

  @override
  String get family_package_two_meals_title => '2 meals daily';

  @override
  String get family_package_two_meals_description =>
      'Includes lunch and dinner';

  @override
  String get family_days_choose_title => 'Choose number of days in the week';

  @override
  String get family_days_7 => '7 days';

  @override
  String get family_days_14 => '14 days';

  @override
  String get family_days_30 => '30 days';

  @override
  String get family_friday_delivery_title => 'Add Friday';

  @override
  String get family_friday_delivery_subtitle =>
      'Add Friday delivery for this member';

  @override
  String get family_friday_delivery_added => 'Added';

  @override
  String get family_weekly_price => 'Weekly price';

  @override
  String get family_weekly_price_value => '245 KWD';

  @override
  String get family_monthly_price => 'Monthly price';

  @override
  String get family_monthly_price_value => '980 KWD';

  @override
  String get family_member_selection_summary => 'Ahmed selection summary';

  @override
  String get family_payment_note =>
      'After payment, each member can choose their favorite restaurants and meals from the restaurants available in each city';

  @override
  String get family_payment_confirm_title =>
      '3. Payment and subscription confirmation';

  @override
  String get family_subscription_summary => 'Subscription summary';

  @override
  String get family_primary_member => 'Primary member';

  @override
  String get family_subscription_program_label => 'Program';

  @override
  String get family_subscription_package_label => 'Package';

  @override
  String get family_subscription_days_label => 'Number of days';

  @override
  String get family_subscription_program_value => 'Balanced';

  @override
  String get family_subscription_package_value => '4 meals + snack';

  @override
  String get family_subscription_days_value => '7 days a week';

  @override
  String get family_price_duration_total => 'Total duration';

  @override
  String get family_new_members_subtotal => 'New members subtotal';

  @override
  String get family_price_discount => 'Family discount (10%)';

  @override
  String get family_price_tax_total => 'Total including tax (15%)';

  @override
  String get family_monthly_total_label => 'Monthly total (4 weeks)';

  @override
  String get family_payment_method_title => 'Payment method';

  @override
  String get family_payment_card_label => 'Credit card';

  @override
  String get family_payment_apple_pay_label => 'Apple Pay';

  @override
  String get family_payment_mada_label => 'Mada';

  @override
  String get family_overview_title => 'Family overview';

  @override
  String get family_confirm_payment => 'Confirm payment';

  @override
  String get family_next_payment => 'Next: payment';

  @override
  String get calendar_title => 'Meal calendar';

  @override
  String get calendar_month_progress => 'Monthly progress';

  @override
  String get calendar_month_progress_value => 'Completed 30 meals out of 30';

  @override
  String get calendar_commitment => 'Great commitment 👏';

  @override
  String get calendar_change_meal => 'Change meal';

  @override
  String get calendar_pause => 'Pause temporarily';

  @override
  String get calendar_add_meal => 'Add meal';

  @override
  String get calendar_empty_meals_title => 'No meals right now';

  @override
  String get calendar_empty_meals_description =>
      'You have not added any meals yet.\nStart now by adding your healthy meals.';

  @override
  String get calendar_empty_meals_button => 'Add meals';

  @override
  String get calendar_no_subscription_title => 'No meals yet';

  @override
  String get calendar_no_subscription_description =>
      'It looks like you are not subscribed to a plan.\nSubscribe now and enjoy healthy meals suited to your goals.';

  @override
  String get calendar_no_subscription_button => 'View subscriptions';

  @override
  String get calendar_reschedule => 'Reschedule meal';

  @override
  String get calendar_full_plan => 'Full plan';

  @override
  String get calendar_week => 'Week';

  @override
  String get calendar_today => 'Today';

  @override
  String get calendar_day_plan => 'Plan for September 25';

  @override
  String calendar_day_plan_date(String date) {
    return 'Plan for $date';
  }

  @override
  String get calendar_scheduled_count => '4 meals scheduled for today';

  @override
  String get calendar_completed => 'Completed';

  @override
  String get calendar_current => 'Current';

  @override
  String get calendar_upcoming => 'Upcoming';

  @override
  String get calendar_breakfast_time => 'Breakfast • 07:30 AM';

  @override
  String get calendar_breakfast_meal => 'Oatmeal with fruit and honey';

  @override
  String get calendar_breakfast_calories => '450 calories';

  @override
  String get calendar_lunch_time => 'Lunch • 01:00 PM';

  @override
  String get calendar_lunch_meal => 'Grilled chicken with brown rice';

  @override
  String get calendar_lunch_calories => '550 calories';

  @override
  String get calendar_lunch_protein => '32g protein';

  @override
  String get calendar_dinner_time => 'Dinner • 07:00 PM';

  @override
  String get calendar_dinner_meal => 'Healthy chicken sandwich';

  @override
  String get calendar_dinner_calories => '420 calories';

  @override
  String get calendar_snack_time => 'Snack • 09:00 PM';

  @override
  String get calendar_snack_meal => 'Fresh fruit snack';

  @override
  String get calendar_snack_calories => '180 calories';

  @override
  String get calendar_friday => 'Friday';

  @override
  String get calendar_saturday => 'Saturday';

  @override
  String get calendar_sunday => 'Sunday';

  @override
  String get calendar_monday => 'Monday';

  @override
  String get calendar_tuesday => 'Tuesday';

  @override
  String get calendar_wednesday => 'Wednesday';

  @override
  String get calendar_thursday => 'Thursday';

  @override
  String get calendar_weekday_sat_short => 'Sat';

  @override
  String get calendar_weekday_sun_short => 'Sun';

  @override
  String get calendar_weekday_mon_short => 'Mon';

  @override
  String get calendar_weekday_tue_short => 'Tue';

  @override
  String get calendar_weekday_wed_short => 'Wed';

  @override
  String get calendar_weekday_thu_short => 'Thu';

  @override
  String get calendar_weekday_fri_short => 'Fri';

  @override
  String get calendar_ingredients => 'Ingredients';

  @override
  String get calendar_daily_nutrition_total => 'Total nutrition for this day';

  @override
  String get calendar_usual_delivery_time => 'Usual delivery time';

  @override
  String get calendar_calories => 'Calories';

  @override
  String get calendar_protein => 'Protein';

  @override
  String get calendar_carbs => 'Carbs';

  @override
  String get calendar_fat => 'Fat';

  @override
  String get calendar_breakfast => 'Breakfast';

  @override
  String get calendar_lunch => 'Lunch';

  @override
  String get calendar_dinner => 'Dinner';

  @override
  String calendar_meals_for(String mealType) {
    return '$mealType meals';
  }

  @override
  String get calendar_restaurant_name => 'Restaurant name';

  @override
  String get calendar_restaurant_description =>
      'We serve high-quality healthy meals using fresh, natural ingredients\nto help you achieve your nutrition and fitness goals.';

  @override
  String get calendar_ingredient_origin_title =>
      'Origin country for main ingredients';

  @override
  String get calendar_meat => 'Meat';

  @override
  String get calendar_poultry => 'Poultry';

  @override
  String get calendar_fish => 'Fish';

  @override
  String get calendar_oils => 'Oils';

  @override
  String get calendar_imported => 'Imported';

  @override
  String get calendar_fresh_local => 'Fresh local';

  @override
  String get calendar_australia => 'Australia';

  @override
  String get calendar_local => 'Local';

  @override
  String get calendar_norway => 'Norway';

  @override
  String get calendar_spain => 'Spain';

  @override
  String get calendar_meal_name => 'Meal name';

  @override
  String get calendar_meal_overnight_oats => 'Overnight oats with berries';

  @override
  String get calendar_meal_egg_avocado_toast => 'Egg and avocado toast';

  @override
  String get calendar_meal_greek_yogurt_parfait => 'Greek yogurt parfait';

  @override
  String get calendar_meal_turkey_cheese_wrap => 'Turkey cheese breakfast wrap';

  @override
  String get calendar_meal_banana_protein_pancakes => 'Banana protein pancakes';

  @override
  String get calendar_meal_smoked_salmon_bagel => 'Smoked salmon bagel';

  @override
  String get calendar_meal_grilled_chicken_bowl =>
      'Grilled chicken quinoa bowl';

  @override
  String get calendar_meal_salmon_rice_plate => 'Salmon rice plate';

  @override
  String get calendar_meal_beef_vegetable_box => 'Beef and vegetable box';

  @override
  String get calendar_meal_shrimp_noodle_bowl => 'Shrimp noodle bowl';

  @override
  String get calendar_meal_chicken_caesar_wrap => 'Chicken Caesar wrap';

  @override
  String get calendar_meal_veggie_pasta_box => 'Vegetable pasta box';

  @override
  String get calendar_meal_lemon_chicken_salad => 'Lemon chicken salad';

  @override
  String get calendar_meal_tuna_potato_plate => 'Tuna potato plate';

  @override
  String get calendar_meal_steak_mushroom_plate => 'Steak mushroom plate';

  @override
  String get calendar_meal_chicken_soup_box => 'Chicken soup box';

  @override
  String get calendar_meal_halloumi_salad => 'Halloumi salad';

  @override
  String get calendar_meal_light_fajita_bowl => 'Light fajita bowl';

  @override
  String get calendar_grilled_chicken => 'Grilled chicken';

  @override
  String get calendar_brown_rice => 'Brown rice';

  @override
  String get calendar_broccoli => 'Broccoli';

  @override
  String get calendar_carrot => 'Carrot';

  @override
  String get calendar_more => 'More ..';

  @override
  String get calendar_browse_restaurants => 'Browse restaurants';

  @override
  String get calendar_choose_restaurant_for_day =>
      'Choose your preferred restaurant for ';

  @override
  String get calendar_restaurant_picker_date => 'Saturday, September 20';

  @override
  String get calendar_search_restaurant_hint =>
      'Search for a restaurant or cuisine...';

  @override
  String get calendar_meal_suffix => ' meal';

  @override
  String get calendar_change_restaurant => 'Change restaurant';

  @override
  String get calendar_meals_changed => 'Meal changed';

  @override
  String get calendar_selection_locked_before_72_hours =>
      'Last change is 72 hours before delivery';

  @override
  String get family_member_day_closed_button => 'Closed';

  @override
  String get calendar_pick_restaurant_first => 'Choose ';

  @override
  String get calendar_pick_restaurant_second => 'restaurant';

  @override
  String get calendar_done => 'Done';

  @override
  String get calendar_meals_save_success => 'Meal added successfully.';

  @override
  String get meal_details_optional_notes_title => 'Optional notes';

  @override
  String get meal_details_optional_notes_hint =>
      'Example: no onion, no garlic, extra vegetables...';

  @override
  String get meal_details_select_meal_button => 'Select this meal';

  @override
  String get meal_details_select_meal_hint =>
      'This meal will be fixed for the selected day';

  @override
  String get profile_settings_title => 'App settings';

  @override
  String get profile_settings_application_section => 'Application';

  @override
  String get profile_settings_notifications => 'Notifications';

  @override
  String get profile_settings_notifications_subtitle =>
      'Manage notification preferences and alerts';

  @override
  String get profile_settings_language => 'Language';

  @override
  String get profile_settings_language_subtitle =>
      'Choose your preferred app language';

  @override
  String get profile_settings_language_sheet_title => 'Choose language';

  @override
  String get profile_settings_language_arabic => 'Arabic';

  @override
  String get profile_settings_language_english => 'English';

  @override
  String get profile_settings_appearance => 'Appearance';

  @override
  String get profile_settings_appearance_subtitle =>
      'Choose the display mode that suits you';

  @override
  String get profile_settings_support_section => 'Support';

  @override
  String get profile_settings_help_center => 'Help center';

  @override
  String get profile_settings_help_center_subtitle =>
      'Find answers to frequently asked questions';

  @override
  String get profile_settings_contact_us => 'Contact us';

  @override
  String get profile_settings_contact_us_subtitle =>
      'Message the MealMate support team';

  @override
  String get profile_settings_complaints => 'Complaints';

  @override
  String get profile_settings_complaints_subtitle =>
      'Submit a complaint and we will review it soon';

  @override
  String get profile_settings_information_section => 'Information';

  @override
  String get profile_settings_about => 'About MealMate';

  @override
  String get profile_settings_about_subtitle =>
      'Learn about our vision and mission';

  @override
  String get profile_settings_privacy_policy => 'Privacy policy';

  @override
  String get profile_settings_privacy_policy_subtitle =>
      'Learn how we protect your data';

  @override
  String get profile_settings_terms => 'Terms and conditions';

  @override
  String get profile_settings_terms_subtitle =>
      'Terms and conditions for using the app';

  @override
  String get profile_settings_version => 'App version';

  @override
  String get profile_settings_version_subtitle =>
      'You are using the latest version';

  @override
  String get profile_settings_version_label => 'Version 2.4.0';

  @override
  String get health_goals_title => 'My health goals';

  @override
  String get health_goals_current_goal => 'Your current goal';

  @override
  String get health_goals_weight_loss => 'Weight loss';

  @override
  String get health_goals_current_weight => 'Current weight';

  @override
  String get health_goals_target_weight => 'Target weight';

  @override
  String get health_goals_progress => 'Progress';

  @override
  String get health_goals_body_data => 'Body data';

  @override
  String get health_goals_height => 'Height';

  @override
  String get health_goals_activity_level => 'Activity level';

  @override
  String get health_goals_activity_low => 'Low';

  @override
  String get health_goals_activity_medium => 'Medium';

  @override
  String get health_goals_activity_active => 'Active';

  @override
  String get health_goals_activity_high => 'High activity';

  @override
  String get health_goals_weekly_summary => 'This week\'s summary';

  @override
  String get health_goals_decrease => 'Decrease';

  @override
  String get health_goals_since_plan_start => 'Since your plan started';

  @override
  String get health_goals_days => '45 days';

  @override
  String get health_goals_continuous => 'Continuous';

  @override
  String get health_goals_keep_progress => 'Keep up the great progress';

  @override
  String get health_goals_save => 'Save goals';

  @override
  String get health_goals_weight_value => '78 kg';

  @override
  String get health_goals_target_weight_value => '72 kg';

  @override
  String get health_goals_height_value => '175 cm';

  @override
  String get health_goals_progress_value => '60%';

  @override
  String get health_goals_decrease_value => '4.2 kg';

  @override
  String get search_hint => 'Search for a meal, restaurant, or healthy plan';

  @override
  String get search_cancel => 'Cancel';

  @override
  String get search_recent => 'Recent searches';

  @override
  String get search_popular => 'Most popular';

  @override
  String get search_categories => 'Browse by category';

  @override
  String get search_recommended => 'Recommended for you';

  @override
  String get search_quick_results => 'Quick results';

  @override
  String get search_suggestions_all => 'View all suggestions';

  @override
  String get search_filter_all => 'All';

  @override
  String get search_filter_meals => 'Meals';

  @override
  String get search_filter_restaurants => 'Restaurants';

  @override
  String get search_filter_plans => 'Plans';

  @override
  String get search_filter_title => 'Filter results';

  @override
  String get search_filter_programs => 'Programs';

  @override
  String get search_filter_weight_gain => 'Weight gain';

  @override
  String get search_filter_muscle_gain => 'Muscle gain';

  @override
  String get search_filter_allergy_suitable => 'Allergy friendly';

  @override
  String get search_filter_apply => 'Apply filter';

  @override
  String get search_filter_reset => 'Reset';

  @override
  String get search_filter_calories_unit => 'kcal';

  @override
  String get search_filter_grams_unit => 'g';

  @override
  String get search_recent_grilled_chicken => 'Grilled chicken';

  @override
  String get search_recent_healthy_restaurants => 'Healthy chicken restaurants';

  @override
  String get search_recent_high_protein => 'High-protein meals';

  @override
  String get search_category_salad => 'Healthy salads';

  @override
  String get search_category_protein => 'Protein meals';

  @override
  String get search_category_juice => 'Juices and drinks';

  @override
  String get search_category_snack => 'Light snacks';

  @override
  String get search_category_salad_subtitle => 'Light choices';

  @override
  String get search_category_protein_subtitle => 'Filling and balanced';

  @override
  String get search_category_juice_subtitle => 'Natural and refreshing';

  @override
  String get search_category_snack_subtitle => 'Low calories';

  @override
  String get search_meal_badge => 'Featured meal';

  @override
  String get search_restaurant_badge => 'Healthy restaurant';

  @override
  String get search_meal_title => 'Grilled chicken with quinoa';

  @override
  String get search_meal_description =>
      'A balanced meal rich in protein and fiber';

  @override
  String get search_restaurant_title => 'Green Light Kitchen';

  @override
  String get search_restaurant_description =>
      'Healthy, natural, and nutritious options';

  @override
  String get search_show_details => 'View details';

  @override
  String get search_show_restaurant => 'View restaurant';

  @override
  String get search_calories => '550 calories';

  @override
  String get search_protein => '35 g protein';

  @override
  String get search_carbs => '55 g carbs';

  @override
  String get search_fat => '18 g fat';

  @override
  String get search_open => 'Open';

  @override
  String get search_empty_query => 'Keto sushi';

  @override
  String get search_empty_title => 'No suitable results found';

  @override
  String get search_empty_message_prefix =>
      'We couldn\'t find any results for \"';

  @override
  String get search_empty_message_suffix => '\"';

  @override
  String get search_empty_description =>
      'Try another keyword or explore the available options';

  @override
  String get search_empty_suggestions_title => 'Suggestions you may like';

  @override
  String get search_empty_nearby_restaurants => 'Nearby restaurants';

  @override
  String get search_empty_explore => 'Back to explore';

  @override
  String get search_empty_clear => 'Clear search';

  @override
  String get search_cuisine_fast_food => 'Fast food';

  @override
  String get search_cuisine_chicken => 'Chicken';

  @override
  String get search_cuisine_rice => 'Rice';

  @override
  String get search_minutes => '15-20 min';

  @override
  String get search_rating => '4.0';

  @override
  String get home_greeting => 'Welcome, Mohammed';

  @override
  String get home_greeting_subtitle => 'Ready for a great healthy day?';

  @override
  String get home_main_nutrients => 'Main nutrients';

  @override
  String get nutrition_details_title => 'Main nutrients details';

  @override
  String get nutrition_details_date_prefix => 'Today - Saturday ';

  @override
  String get nutrition_details_date_day => '24';

  @override
  String get nutrition_details_date_suffix => ' May';

  @override
  String get nutrition_details_burned => 'Burned';

  @override
  String get nutrition_details_goal => 'Goal';

  @override
  String get nutrition_details_remaining => 'Remaining';

  @override
  String get nutrition_details_calorie_unit => 'calorie';

  @override
  String get nutrition_details_fiber => 'Fiber';

  @override
  String get nutrition_details_sugar => 'Sugar';

  @override
  String get nutrition_details_macro_separator => ' / ';

  @override
  String get nutrition_details_gram_suffix => ' g';

  @override
  String nutrition_details_percent_value(int percent) {
    return '$percent%';
  }

  @override
  String get nutrition_details_tip_title => 'Today\'s tip';

  @override
  String get nutrition_details_tip_message =>
      'You are on the right track! Try increasing protein\nand drinking more water to achieve your daily goal.';

  @override
  String get home_protein => 'Protein';

  @override
  String get home_protein_value => '89';

  @override
  String get home_protein_goal => '120 g';

  @override
  String get home_carbs => 'Carbs';

  @override
  String get home_carbs_value => '210';

  @override
  String get home_carbs_goal => '260 g';

  @override
  String get home_fat => 'Fat';

  @override
  String get home_fat_value => '58';

  @override
  String get home_fat_goal => '70 g';

  @override
  String get home_remaining_calories => 'Calories remaining';

  @override
  String get home_remaining_calories_value => '560';

  @override
  String get home_calories_of_goal => 'of 2000 calories';

  @override
  String get home_details => 'View details';

  @override
  String get home_search_hint => 'Search for meals or restaurants';

  @override
  String get home_subscribe_now => 'Subscribe now';

  @override
  String get home_today_meals => 'Today\'s meals';

  @override
  String get home_restaurants => 'Restaurants';

  @override
  String get home_view_calendar => 'View calendar';

  @override
  String get home_next_box => 'Next box';

  @override
  String get home_delivery_time => '11 AM - 3 PM';

  @override
  String get home_edit_meals => 'Edit meals';

  @override
  String get home_next_week_meals => 'You can edit next week\'s meals';

  @override
  String get home_reminder => 'Important reminder';

  @override
  String get home_reminder_copy =>
      'You have 72 hours before your next box is prepared.';

  @override
  String get home_promo_discount => '30% off';

  @override
  String get home_promo_all_subscriptions => 'on all subscriptions';

  @override
  String get home_shortcut_offers => 'Offers';

  @override
  String get home_shortcut_allergy => 'Allergy';

  @override
  String get home_shortcut_subscription => 'My plan';

  @override
  String get home_shortcut_my_meals => 'My meals';

  @override
  String get home_meal_omelet_vegetables => 'Vegetable omelet';

  @override
  String get home_meal_omelet_calories => '430 calories';

  @override
  String get home_meal_chicken_calories => '650 calories';

  @override
  String get home_meal_herb_salmon => 'Herb salmon';

  @override
  String get home_meal_salmon_calories => '520 calories';

  @override
  String get home_restaurant_protein_kitchen => 'Protein Kitchen';

  @override
  String get home_restaurant_healthy_bite => 'Healthy Bite';

  @override
  String get home_restaurant_diet_house => 'Diet House';

  @override
  String get home_restaurant_balanced_meals => 'Balanced healthy meals';

  @override
  String get home_restaurant_browse => 'Browse';

  @override
  String get home_calendar_card_title => 'Calendar';

  @override
  String get home_calendar_card_subtitle => 'View your upcoming meals';

  @override
  String get home_subscription_tab => 'Subscription';

  @override
  String get home_nutrition_tab => 'Nutrition';

  @override
  String get home_current_plan => 'Current plan';

  @override
  String get home_weight_loss_program => 'Weight loss program';

  @override
  String get home_renewal_date => 'Renews on June 24, 2026';

  @override
  String get home_average_calories => 'Average calories';

  @override
  String get home_average_calories_value => '612';

  @override
  String get home_calories_per_meal => 'cal / meal';

  @override
  String get home_completed_meals => 'Completed meals';

  @override
  String get home_completed_meals_value => '18';

  @override
  String get home_completed_meals_total => 'of 30 meals';

  @override
  String get home_subscription_days_value => '12';

  @override
  String get home_days_remaining_label => 'days remaining';

  @override
  String get home_subscription_days_total => 'of 30 days';

  @override
  String get home_subscription_days_total_alt => 'of 30 days';

  @override
  String get home_subscription_details => 'Subscription details';

  @override
  String get home_next_delivery => 'Next delivery';

  @override
  String get home_tomorrow => 'Tomorrow';

  @override
  String get home_before_noon => 'before 12:00 PM';

  @override
  String get home_commitment => 'Commitment';

  @override
  String get home_commitment_value => '86%';

  @override
  String get home_excellent_performance => 'Excellent';

  @override
  String get home_selected_meals => 'Selected meals';

  @override
  String get home_selected_meals_value => '18 /30';

  @override
  String get home_meal => 'meal';

  @override
  String get home_remaining_days => 'Days left';

  @override
  String get home_on_track =>
      'You are on the right track! Keep making healthy choices.';

  @override
  String get search_suggestion_chicken_protein => 'Chicken protein';

  @override
  String get search_suggestion_chicken_rice => 'Chicken with brown rice';

  @override
  String get search_suggestion_chicken_healthy => 'Healthy chicken restaurants';

  @override
  String get search_suggestion_chicken_vegetables =>
      'Chicken with grilled vegetables';

  @override
  String get wallet_title => 'Wallet';

  @override
  String get wallet_total_refundable_balance_title =>
      'Total refundable balance';

  @override
  String get wallet_total_refundable_balance_subtitle =>
      'Balance from subscription cancellations or settlements';

  @override
  String get wallet_transactions_history => 'Transaction history';

  @override
  String get wallet_refund_to_card => 'Refund to card';

  @override
  String get wallet_important_info_title => 'Important information';

  @override
  String get wallet_important_info_body =>
      'This balance is only for receiving refunded amounts\nfrom subscription cancellations or special settlements.\nYou cannot top up the wallet or add amounts to it.';

  @override
  String get wallet_recent_transactions => 'Recent transactions';

  @override
  String get wallet_view_all => 'View all';

  @override
  String get wallet_security_note =>
      'We protect your data and transactions according to the highest security standards';

  @override
  String get wallet_refundable_balance => 'Refundable balance';

  @override
  String wallet_last_updated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get wallet_filter_settlements => 'Settlements';

  @override
  String get wallet_filter_card_refund => 'Card refunds';

  @override
  String get wallet_filter_refunds => 'Refunds';

  @override
  String get wallet_filter_all => 'All';

  @override
  String get wallet_search_hint => 'Search transactions';

  @override
  String get wallet_group_today => 'Today';

  @override
  String get wallet_group_this_week => 'This week';

  @override
  String get wallet_group_april_2026 => 'April 2026';

  @override
  String get wallet_transactions_notice =>
      'Transaction history contains payments, refunds,\nand wallet settlements only.';

  @override
  String get wallet_status_completed => 'Completed';

  @override
  String get wallet_status_processing => 'Processing';

  @override
  String get wallet_select_card => 'Choose card';

  @override
  String get wallet_refund_notice_body =>
      '• The amount will be deducted from your wallet balance when the request is sent\n• You cannot undo after processing starts';

  @override
  String get wallet_order_summary_title => 'Order summary';

  @override
  String get wallet_confirm_refund => 'Confirm refund request';

  @override
  String get wallet_cancel => 'Cancel';

  @override
  String get wallet_refund_available_balance => 'Available refundable balance';

  @override
  String get wallet_refund_hero_subtitle =>
      'The amount will be transferred to your card within 3-7 business days';

  @override
  String get wallet_refund_amount => 'Refund amount';

  @override
  String get wallet_refund_custom_amount => 'Custom amount';

  @override
  String get wallet_refund_full_balance => 'Full balance';

  @override
  String get wallet_summary_receiving_card => 'Receiving card';

  @override
  String get wallet_summary_amount => 'Amount';

  @override
  String get wallet_summary_fees => 'Fees';

  @override
  String get wallet_summary_free => 'Free';

  @override
  String get wallet_summary_expected_receipt => 'Expected receipt';

  @override
  String get wallet_summary_expected_receipt_value =>
      'Within 7-14 business days';

  @override
  String get wallet_card_expires_at => 'Expires';

  @override
  String get biometric_login_title => 'Biometric Sign-In';

  @override
  String get biometric_login_subtitle =>
      'Use Face ID or Fingerprint for quick access';

  @override
  String get biometric_face_id => 'Face ID';

  @override
  String get biometric_fingerprint => 'Fingerprint';

  @override
  String get biometric_generic => 'Biometrics';

  @override
  String get biometric_enable_reason =>
      'Please authenticate to enable biometric sign-in';

  @override
  String get biometric_auth_reason =>
      'Please authenticate to sign in to your account';

  @override
  String get biometric_enabled_success =>
      'Biometric sign-in enabled successfully';

  @override
  String get biometric_disabled_success => 'Biometric sign-in disabled';

  @override
  String get biometric_not_supported =>
      'Biometrics are not supported on this device';

  @override
  String get biometric_not_enrolled =>
      'No biometrics or Face ID enrolled on this device';

  @override
  String get biometric_locked_out =>
      'Biometrics temporarily locked due to too many failed attempts';

  @override
  String get biometric_permanently_locked_out =>
      'Biometrics permanently locked. Use device passcode.';

  @override
  String get biometric_failed =>
      'Biometric authentication failed, please try again';

  @override
  String get biometric_prompt_enable_dialog_title => 'Enable Quick Sign-In';

  @override
  String get biometric_prompt_enable_dialog_body =>
      'Would you like to enable Face ID / Fingerprint for quick login next time?';

  @override
  String get biometric_enable_button => 'Enable Now';

  @override
  String get biometric_skip_button => 'Later';

  @override
  String get biometric_quick_login => 'Biometric Sign-In';

  @override
  String get family_packages_selection_title => 'Choose Family Package';

  @override
  String get family_packages_selection_subtitle =>
      'Select the suitable size package for your family members to get the discount';

  @override
  String family_package_members_range(int min, int max) {
    return 'From $min to $max members';
  }

  @override
  String family_package_discount_badge(String discount) {
    return '$discount discount';
  }

  @override
  String get family_package_select_button => 'Select Package';

  @override
  String get family_package_continue_button => 'Continue Family Setup';

  @override
  String family_members_count_indicator(int current, int max) {
    return '$current / $max members';
  }

  @override
  String get family_members_count_label => 'Family Members';

  @override
  String get family_members_max_reached =>
      'Maximum members limit reached for this package';

  @override
  String family_members_min_warning(int min) {
    return 'Please add at least $min members to activate this package discount and proceed to checkout';
  }

  @override
  String get family_step_package_selection => 'Size Package';

  @override
  String get family_gender_male => 'Male';

  @override
  String get family_gender => 'Gender';

  @override
  String get family_gender_female => 'Female';

  @override
  String get family_address_select => 'Delivery Address';

  @override
  String get family_address_select_hint => 'Select delivery address';

  @override
  String get family_tier_basic => 'Basic';

  @override
  String get family_tier_platinum => 'Platinum';

  @override
  String get family_tier_elite => 'Elite';

  @override
  String get family_change_package => 'Change Package';

  @override
  String get family_packages_empty =>
      'No family packages available at the moment';

  @override
  String get family_restaurants_member_ahmed => 'Ahmed';

  @override
  String family_restaurants_title(String memberName) {
    return '$memberName\'s restaurants';
  }

  @override
  String family_restaurants_suitable_title(String memberName) {
    return 'Restaurants suitable for $memberName';
  }

  @override
  String get profile_influencer_partner => 'Influencer Partner';

  @override
  String get profile_influencer_partner_subtitle =>
      'Track referrals, links, and earnings';

  @override
  String get influencer_dashboard_title => 'Influencer';

  @override
  String get influencer_user_name => 'Hello, Mohamed';

  @override
  String get influencer_partner_label => 'Influencer Partner';

  @override
  String get influencer_statistics => 'Statistics';

  @override
  String get influencer_statistics_subtitle =>
      'Track your performance and business growth';

  @override
  String get influencer_tools => 'Partner tools';

  @override
  String get influencer_total_earnings => 'Total commissions';

  @override
  String get influencer_total_earnings_value => '845';

  @override
  String get influencer_period_7_days => '7 days';

  @override
  String get influencer_period_30_days => '30 days';

  @override
  String get influencer_period_90_days => '90 days';

  @override
  String get influencer_period_6_months => '6 months';

  @override
  String get influencer_period_year => 'Year';

  @override
  String get influencer_previous_30_days_comparison =>
      'Compared with the previous 30 days';

  @override
  String get influencer_growth_percent => '+4.3%';

  @override
  String get influencer_this_month => 'Monthly goal';

  @override
  String get influencer_referrals => 'Registered customers';

  @override
  String get influencer_referrals_value => '230';

  @override
  String get influencer_active_codes => 'This week 7+';

  @override
  String get influencer_conversion_rate => 'Conversion rate';

  @override
  String get influencer_conversion_rate_value => '35%';

  @override
  String get influencer_from_visits => 'This week 7+';

  @override
  String get influencer_pending_withdrawals => 'Link clicks';

  @override
  String get influencer_pending_withdrawals_value => '520';

  @override
  String get influencer_under_review => 'This week 7+';

  @override
  String get influencer_completed_subscriptions => 'Completed subscriptions';

  @override
  String get influencer_completed_subscriptions_value => '81';

  @override
  String get influencer_generated_orders => 'Generated orders';

  @override
  String get influencer_generated_orders_value => '68';

  @override
  String get influencer_overview => 'Overview';

  @override
  String get influencer_revenue_growth => 'Revenue growth';

  @override
  String get influencer_daily => 'Daily';

  @override
  String get influencer_earnings_label => 'Earnings';

  @override
  String get influencer_top_products => 'Top performing products';

  @override
  String get influencer_top_product_name => 'Complete diet box';

  @override
  String get influencer_top_product_orders_value => '124';

  @override
  String get influencer_orders_label => 'orders';

  @override
  String get influencer_product_revenue_label => 'Earnings';

  @override
  String get influencer_top_product_revenue_value => '245 KWD';

  @override
  String get influencer_chart_20_april => '20 Apr';

  @override
  String get influencer_chart_27_april => '27 Apr';

  @override
  String get influencer_chart_4_may => '4 May';

  @override
  String get influencer_chart_11_may => '11 May';

  @override
  String get influencer_chart_18_may => '18 May';

  @override
  String get influencer_chart_25_may => '25 May';

  @override
  String get influencer_weekly_commission_gain => '+35 KWD';

  @override
  String get influencer_this_week => 'This week';

  @override
  String get influencer_month_goal_progress => '80%';

  @override
  String get influencer_month_goal_value => '680 KWD / 850 KWD';

  @override
  String get influencer_view_details => 'View details';

  @override
  String get influencer_share_links_title => 'Share links';

  @override
  String get influencer_share_links_subtitle => 'Share your link and code';

  @override
  String get influencer_social_connections_title => 'Social accounts';

  @override
  String get influencer_social_connections_subtitle =>
      'Connect your public channels';

  @override
  String get influencer_wallet_title => 'Earnings wallet';

  @override
  String get influencer_wallet_subtitle => 'View balance and transactions';

  @override
  String get influencer_wallet_figma_title => 'My wallet';

  @override
  String get influencer_wallet_figma_subtitle =>
      'Manage your earnings and financial transactions';

  @override
  String get influencer_available_balance => 'Available balance';

  @override
  String get influencer_total_earnings_colon => 'Total earnings:';

  @override
  String get influencer_wallet_total_balance_value => '1.245';

  @override
  String get influencer_wallet_withdraw_action => 'Withdraw earnings';

  @override
  String get influencer_wallet_history_action => 'Transaction history';

  @override
  String get influencer_wallet_month_summary => 'This month\'s summary';

  @override
  String get influencer_wallet_summary_total_earnings => 'Total earnings';

  @override
  String get influencer_wallet_summary_withdrawn => 'Withdrawn';

  @override
  String get influencer_wallet_withdrawn_value => '400';

  @override
  String get influencer_wallet_latest_transactions => 'Latest transactions';

  @override
  String get influencer_referral_code_title => 'Your discount code';

  @override
  String get influencer_referral_code_subtitle => 'Earn more commissions';

  @override
  String get influencer_referral_code_value => 'AMMAR20';

  @override
  String get influencer_share_code_title => 'Share your link and code';

  @override
  String get influencer_recent_activities => 'Recent activities';

  @override
  String get influencer_view_all => 'View all';

  @override
  String get influencer_activity_first_user => 'User #gdf55';

  @override
  String get influencer_activity_first_plan =>
      'Subscribed to a monthly package';

  @override
  String get influencer_activity_second_user => 'Mohamed Ali';

  @override
  String get influencer_activity_second_plan =>
      'Subscribed to a weekly package';

  @override
  String get influencer_activity_third_user => 'Abdullah Nasser';

  @override
  String get influencer_activity_third_plan =>
      'Subscribed to a monthly package';

  @override
  String get influencer_activity_amount => '+5 KWD';

  @override
  String get influencer_activity_time => '2 hours ago';

  @override
  String get influencer_tab_home => 'Home';

  @override
  String get influencer_tab_links => 'Links';

  @override
  String get influencer_tab_wallet => 'Wallet';

  @override
  String get influencer_tab_stats => 'Stats';

  @override
  String get influencer_tab_profile => 'Profile';

  @override
  String get influencer_share_links_header => 'Share now';

  @override
  String get influencer_share_links_body =>
      'Share easily across social platforms';

  @override
  String get influencer_share_now => 'Share now';

  @override
  String get influencer_add_social_accounts => 'Add social accounts';

  @override
  String get influencer_social_connections_header => 'Add social accounts';

  @override
  String get influencer_social_connections_body =>
      'Add your social accounts to start the partnership and earn more commissions';

  @override
  String get influencer_save_continue => 'Save and continue';

  @override
  String get influencer_skip_now => 'Skip now';

  @override
  String get influencer_instagram => 'Instagram';

  @override
  String get influencer_tiktok => 'TikTok';

  @override
  String get influencer_snapchat => 'Snapchat';

  @override
  String get influencer_whatsapp => 'WhatsApp';

  @override
  String get influencer_telegram => 'Telegram';

  @override
  String get influencer_youtube => 'YouTube';

  @override
  String get influencer_tiktok_subtitle => 'Add your TikTok account';

  @override
  String get influencer_instagram_subtitle => 'Add your Instagram account';

  @override
  String get influencer_whatsapp_subtitle =>
      'Add your WhatsApp Business number';

  @override
  String get influencer_telegram_subtitle => 'Add your Telegram account';

  @override
  String get influencer_youtube_subtitle => 'Add your YouTube channel';

  @override
  String get influencer_snapchat_subtitle => 'Add your Snapchat account';

  @override
  String get influencer_social_add => 'Add';

  @override
  String get influencer_social_edit => 'Edit';

  @override
  String get influencer_privacy_title => 'We protect your data privacy';

  @override
  String get influencer_privacy_body =>
      'We only use your data to improve partnership opportunities and brand communication.';

  @override
  String get influencer_enter_account => 'Enter account handle or link';

  @override
  String get influencer_confirm => 'Confirm';

  @override
  String get influencer_cancel => 'Cancel';

  @override
  String get influencer_not_connected => 'Not connected';

  @override
  String get influencer_currency => 'KWD';

  @override
  String get influencer_wallet_last_updated => 'Last updated today at 09:15 AM';

  @override
  String get influencer_available_earnings => 'Available earnings';

  @override
  String get influencer_request_withdraw => 'Request withdrawal';

  @override
  String get influencer_request_withdraw_subtitle =>
      'Transfer earnings to your bank account';

  @override
  String get influencer_withdraw_history_title => 'Withdrawal history';

  @override
  String get influencer_withdraw_history_subtitle =>
      'Track previous and pending requests';

  @override
  String get influencer_recent_commissions => 'Recent commissions';

  @override
  String get influencer_withdraw_arrival_hint =>
      'The amount will be reviewed before transfer';

  @override
  String get influencer_withdraw_method => 'Withdrawal method';

  @override
  String get influencer_withdraw_screen_title => 'Withdraw Profits';

  @override
  String get influencer_withdraw_screen_subtitle =>
      'Select withdrawal method and enter details';

  @override
  String get influencer_available_for_withdraw =>
      'Available balance for withdrawal';

  @override
  String get influencer_choose_withdraw_method => 'Select withdrawal method';

  @override
  String get influencer_bank_transfer => 'Bank Transfer';

  @override
  String get influencer_bank_transfer_subtitle =>
      'Transfer to your bank account';

  @override
  String get influencer_electronic_wallet => 'Electronic Wallet';

  @override
  String get influencer_electronic_wallet_subtitle =>
      'Transfer to your electronic wallet';

  @override
  String get influencer_bank_transfer_details => 'Bank Transfer Details';

  @override
  String get influencer_account_holder_hint => 'Enter full name';

  @override
  String get influencer_iban_hint => 'Enter IBAN number';

  @override
  String get influencer_select_bank_hint => 'Select bank';

  @override
  String get influencer_withdraw_notice_text =>
      'The full amount will be transferred to your account. The operation may take 1 to 3 business days';

  @override
  String get influencer_bank_account_holder => 'Account holder name';

  @override
  String get influencer_bank_account_holder_value => 'Mohamed Ahmed';

  @override
  String get influencer_bank_iban => 'IBAN';

  @override
  String get influencer_bank_iban_value => 'KW81CBKU0000000000001234560101';

  @override
  String get influencer_bank_name => 'Bank name';

  @override
  String get influencer_bank_name_value => 'Kuwait National Bank';

  @override
  String get influencer_continue_review => 'Continue to review';

  @override
  String get influencer_withdraw_review_title => 'Review withdrawal request';

  @override
  String get influencer_withdraw_review_subtitle =>
      'Review your request details before confirming';

  @override
  String get influencer_withdraw_amount => 'Withdrawal amount';

  @override
  String get influencer_confirm_withdraw => 'Confirm withdrawal request';

  @override
  String get influencer_transfer_details => 'Transfer Details';

  @override
  String get influencer_bank_label => 'Bank';

  @override
  String get influencer_account_number => 'Account Number';

  @override
  String get influencer_account_number_sample => '**** **** **** 1234';

  @override
  String get influencer_iban_with_label => 'IBAN';

  @override
  String get influencer_operation_summary => 'Operation Summary';

  @override
  String get influencer_requested_withdraw_amount =>
      'Requested withdrawal amount';

  @override
  String get influencer_transfer_fees => 'Transfer fees';

  @override
  String get influencer_transfer_fees_value => '0.000 KWD';

  @override
  String get influencer_final_received_amount => 'Final received amount';

  @override
  String get influencer_important_info => 'Important Information';

  @override
  String get influencer_important_info_message =>
      'The full amount will be transferred to your bank account. The operation may take 1 to 3 business days';

  @override
  String get influencer_back_button => 'Back';

  @override
  String get influencer_transaction_subscription_commission =>
      'Subscription commission';

  @override
  String get influencer_transaction_withdraw_request => 'Withdrawal request';

  @override
  String get influencer_transaction_referral_bonus => 'Referral bonus';

  @override
  String get influencer_transaction_new_referral => 'New referral';

  @override
  String get influencer_transaction_bank_withdrawal =>
      'Withdrawal to bank account';

  @override
  String get influencer_transaction_premium_order_completed =>
      'Premium order completed';

  @override
  String get influencer_transaction_25_may_2025 => '25 May 2025';

  @override
  String get influencer_transaction_amount_positive_120 => '+120 KWD';

  @override
  String get influencer_transaction_amount_negative_120 => '-120 KWD';

  @override
  String get influencer_transaction_today => 'Today, 09:15 AM';

  @override
  String get influencer_transaction_yesterday => 'Yesterday, 02:40 PM';

  @override
  String get influencer_transaction_week => 'This week';

  @override
  String get influencer_transaction_amount_large => '+24.000 KWD';

  @override
  String get influencer_transaction_amount_medium => '-32.500 KWD';

  @override
  String get influencer_transaction_amount_small => '+6.250 KWD';

  @override
  String get billing_freeze_rules_title => 'Freeze Policy & Rules';

  @override
  String get billing_confirm_overwrite_selections_title =>
      'Confirm Meal Selections Cancellation';

  @override
  String get billing_confirm_overwrite_selections_message =>
      'You have selected meals on days within the freeze period. These selections will be cancelled and compensatory days will be added at the end of your subscription. Do you want to continue?';

  @override
  String get calendar_selection_locked =>
      'Modifications are locked for this day.';

  @override
  String get calendar_day_frozen_title => 'This day is frozen';

  @override
  String get calendar_day_frozen_description =>
      'Meal preparation and delivery are temporarily paused for this day. You can unfreeze it to resume meals.';

  @override
  String get calendar_day_frozen_badge => 'Day frozen';

  @override
  String get subscription_day_frozen =>
      'This day is frozen as part of your subscription freeze.';

  @override
  String get billing_pending_freeze_title => 'Subscription Freeze Details';

  @override
  String get billing_pending_freeze_message =>
      'Your subscription freeze is active. Start and end dates are detailed below:';

  @override
  String get billing_pending_freeze_start_date => 'Freeze start date';

  @override
  String get billing_pending_freeze_end_date => 'Freeze end date';

  @override
  String billing_pending_freeze_days(int days) {
    return 'Duration: $days days';
  }

  @override
  String get billing_pending_freeze_status => 'Status';

  @override
  String billing_pending_freeze_notice_banner(
    String startDate,
    String endDate,
  ) {
    return 'Subscription frozen from $startDate to $endDate';
  }

  @override
  String get billing_status_approved => 'Approved';

  @override
  String billing_active_freeze_service_days(int days) {
    return 'Frozen service days: $days';
  }

  @override
  String billing_active_freeze_compensation_days(int days) {
    return 'Compensation days: $days';
  }

  @override
  String billing_active_freeze_new_end_date(String date) {
    return 'New end date: $date';
  }

  @override
  String get billing_active_freeze_compensation_dates => 'Compensation dates';

  @override
  String get address_restaurant_does_not_service_region =>
      'The currently subscribed restaurant does not deliver to this area. Please select another address.';

  @override
  String get address_coverage_notice_title => 'Restaurant Coverage Notice';

  @override
  String get address_no_serving_restaurants =>
      'No restaurants currently serve this area';

  @override
  String get address_serving_restaurants_title =>
      'Restaurants serving your new area';

  @override
  String get address_coverage_notice_action => 'Got it';

  @override
  String get address_preview_check_button => 'Continue & Check Coverage';

  @override
  String get address_coverage_covered_title =>
      'Your area is covered by your subscription';

  @override
  String get address_coverage_uncovered_title =>
      'Area not covered by your subscription';

  @override
  String get address_coverage_confirm_save => 'Confirm & Save Address';

  @override
  String get address_coverage_confirm_set_default => 'Confirm Set as Default';

  @override
  String get address_coverage_choose_another => 'Choose Another Location';

  @override
  String get address_coverage_uncovered_desc =>
      'Your current subscription restaurant does not deliver to this area.';

  @override
  String get upgrade_summary_operational_title => 'Upgrade activation details';

  @override
  String get upgrade_summary_effective_date => 'Activation start date';

  @override
  String upgrade_summary_repetition(int limit, int days) {
    return 'You can repeat a restaurant up to $limit times during $days days';
  }

  @override
  String get upgrade_summary_new_restaurants =>
      'New restaurants joining your package';

  @override
  String get upgrade_summary_no_new_restaurants =>
      'No additional restaurants in this tier';

  @override
  String get upgrade_summary_load_error =>
      'Unable to load the upgrade summary. Please try again.';

  @override
  String get billing_uncompleted_title => 'Incomplete subscriptions';

  @override
  String get billing_uncompleted_hold_active =>
      'Your reservation is held temporarily';

  @override
  String get billing_uncompleted_hold_expired => 'Reservation hold expired';

  @override
  String get billing_uncompleted_duration => 'Subscription duration';

  @override
  String get billing_uncompleted_days => 'days';

  @override
  String get billing_uncompleted_delete => 'Delete';

  @override
  String get billing_uncompleted_resume => 'Complete subscription';

  @override
  String get billing_uncompleted_delete_title =>
      'Delete incomplete subscription?';

  @override
  String get billing_uncompleted_delete_message =>
      'This draft and its temporary reservation will be cancelled.';

  @override
  String get billing_uncompleted_delete_success =>
      'Incomplete subscription deleted';

  @override
  String get billing_uncompleted_resume_title =>
      'Confirm subscription start date';

  @override
  String get billing_uncompleted_resume_message =>
      'The temporary reservation expired. Continue with the suggested start date?';

  @override
  String get billing_uncompleted_resume_success =>
      'Continue in the payment page';

  @override
  String get billing_uncompleted_action_failed =>
      'The request could not be completed. Please try again.';

  @override
  String get family_packages_header_title => 'Family Subscriptions';

  @override
  String get family_packages_header_subtitle =>
      'Choose the subscription that suits you';

  @override
  String get family_packages_hero_badge => 'Meals for everyone';

  @override
  String get family_packages_hero_title => 'Complete plans from 2 to 8 members';

  @override
  String get family_packages_hero_subtitle =>
      'With suitable subscriptions and fast delivery';

  @override
  String get family_packages_section_title => 'Choose subscription type';

  @override
  String get family_packages_default_meals_range => '2-4 meals';

  @override
  String family_packages_members_count(int min, int max) {
    return '$min-$max members';
  }

  @override
  String get family_packages_continue_button =>
      'Continue subscription selection';

  @override
  String get family_allergies_title => 'Allergies';

  @override
  String family_allergies_member(String name) {
    return 'Allergies for $name';
  }

  @override
  String get family_allergies_none => 'No allergies';

  @override
  String get family_allergies_save_next_member => 'Save and continue';

  @override
  String get family_allergies_next_location => 'Next: location';

  @override
  String get family_allergies_next_payment => 'Next: payment';

  @override
  String get family_allergies_food_title => 'Food allergies';

  @override
  String get family_allergies_food_subtitle =>
      'Select the allergies that should be avoided for this member';

  @override
  String get family_allergies_common => 'Common allergies';

  @override
  String get family_allergies_search => 'Search for an allergy';

  @override
  String get family_allergies_rejected => 'Ingredients they dislike';

  @override
  String get family_allergies_ingredient_search => 'Search for an ingredient';

  @override
  String get family_allergies_show_more => 'Show more';

  @override
  String get family_allergies_show_less => 'Show less';

  @override
  String get family_allergies_information_note =>
      'We use this information to personalize suitable meals for each member.';

  @override
  String get family_addresses_title => 'Delivery addresses';

  @override
  String family_addresses_member(String name) {
    return 'Address for $name';
  }

  @override
  String get family_addresses_add => 'Add address';

  @override
  String get family_addresses_use => 'Use this address';

  @override
  String get family_addresses_next_member => 'Save and continue';

  @override
  String get family_addresses_next_payment => 'Next: payment';

  @override
  String get family_addresses_label => 'Label';

  @override
  String get family_addresses_area => 'Area';

  @override
  String get family_addresses_line => 'Address details';

  @override
  String family_meal_selection_title(String name) {
    return '$name\'s Meals';
  }

  @override
  String family_meal_selection_context(String restaurant, String slot) {
    return '$restaurant • $slot';
  }

  @override
  String get family_meal_stepper_restaurant => 'Select Restaurant';

  @override
  String get family_meal_stepper_meal => 'Select Meal';

  @override
  String get family_meal_stepper_review => 'Review';

  @override
  String get family_meal_macros_title => 'Macros Summary';

  @override
  String get family_meal_macros_selected_badge => 'From selected meals';

  @override
  String get family_meal_macros_subtitle =>
      'Updates automatically based on chosen meals';

  @override
  String get family_meal_macros_calories => 'Calories';

  @override
  String get family_meal_macros_carbs => 'Carbs';

  @override
  String get family_meal_macros_protein => 'Protein';

  @override
  String get family_meal_macros_fat => 'Fats';

  @override
  String family_meal_gram_unit(String count) {
    return '${count}g';
  }

  @override
  String family_meal_calorie_unit(String count) {
    return '$count kcal';
  }

  @override
  String get family_meal_tab_all => 'All';

  @override
  String get family_meal_tab_breakfast => 'Breakfast';

  @override
  String get family_meal_tab_lunch => 'Lunch';

  @override
  String get family_meal_tab_dinner => 'Dinner';

  @override
  String get family_meal_status_selected => 'Selected';

  @override
  String get family_meal_button_select => 'Select Meal';

  @override
  String family_meal_selected_counter(int selected, int total) {
    return '$selected of $total meals selected';
  }

  @override
  String get family_meal_continue_review => 'Continue to Review';

  @override
  String family_review_title(String name) {
    return 'Review $name\'s Meals';
  }

  @override
  String get family_review_subtitle =>
      'Review today\'s choices before confirmation';

  @override
  String get family_review_status_ready => 'Ready to confirm';

  @override
  String get family_review_selected_day_label => 'Selected Day';

  @override
  String get family_review_goal_label => 'Goal';

  @override
  String get family_review_goal_balanced => 'Balanced';

  @override
  String get family_review_selected_meals_section => 'Selected Meals';

  @override
  String get family_slot_breakfast => 'Breakfast';

  @override
  String get family_slot_lunch => 'Lunch';

  @override
  String get family_slot_dinner => 'Dinner';

  @override
  String get family_slot_snack => 'Snack';

  @override
  String get family_review_edit_button => 'Edit';

  @override
  String get family_review_nutrition_summary_section => 'Nutritional Summary';

  @override
  String family_review_calories_progress(String current, String target) {
    return '$current of $target kcal';
  }

  @override
  String family_review_grams_progress(String current, String target) {
    return '$current of ${target}g';
  }

  @override
  String get family_review_member_instructions_section => 'Member Instructions';

  @override
  String get family_review_preferences_note =>
      'Your preferences will be respected if any meal needs replacement';

  @override
  String get family_review_cutoff_title =>
      'You can edit today\'s meals until cutoff time';

  @override
  String get family_review_cutoff_desc =>
      'Once cutoff is reached, meals will be prepared and cannot be edited or canceled.';

  @override
  String family_review_cutoff_time(String time) {
    return 'Time remaining: $time';
  }

  @override
  String get family_review_cutoff_disclaimer =>
      'If remaining meals are not chosen, they will be assigned automatically based on preferences';

  @override
  String get family_review_edit_meals_button => 'Edit Meals';

  @override
  String family_review_confirm_meals_button(String name) {
    return 'Confirm $name\'s Meals';
  }

  @override
  String get family_review_success_message => 'Meals confirmed successfully';

  @override
  String get family_meal_item_1_title => 'Herb-Grilled Chicken';

  @override
  String get family_meal_item_1_desc =>
      'Herb-marinated grilled chicken with brown rice and mixed vegetables';

  @override
  String get family_meal_item_2_title => 'Lemon-Grilled Salmon';

  @override
  String get family_meal_item_2_desc =>
      'Grilled salmon with quinoa, roasted vegetables, and lemon sauce';

  @override
  String get family_meal_item_3_title => 'Meat Kofta in Tomato Sauce';

  @override
  String get family_meal_item_3_desc =>
      'Beef kofta in tomato sauce with mashed potatoes and broccoli';

  @override
  String get family_meal_item_4_title => 'Balanced Vegan Bowl';

  @override
  String get family_meal_item_4_desc =>
      'Plant-based bowl with chickpeas, quinoa, greens, and tahini sauce';

  @override
  String get family_meal_tag_gluten_free => 'Gluten-Free';

  @override
  String get family_meal_tag_contains_nuts => 'Contains Nuts';

  @override
  String get family_meal_tag_omega3 => 'Omega-3 Source';

  @override
  String get family_review_meal_1_name => 'Oatmeal with Honey & Banana';

  @override
  String get family_review_meal_2_name =>
      'Grilled Chicken with Brown Rice & Veggies';

  @override
  String get family_review_meal_3_name =>
      'Lemon Salmon with Quinoa & Green Salad';

  @override
  String get family_review_meal_4_name => 'Greek Yogurt with Berries & Honey';

  @override
  String get family_review_tag_no_nuts => 'No Nuts';

  @override
  String get family_review_tag_brown_rice => 'Prefers Brown Rice';

  @override
  String get family_review_tag_not_spicy => 'No Spicy Food';

  @override
  String get subscription_upgrade_target_invalid =>
      'The selected tier is not valid for upgrade.';

  @override
  String get upgrade_redirect_urls_required =>
      'Payment redirect information is incomplete.';

  @override
  String get upgrade_customer_not_found =>
      'Customer information is incomplete for payment.';

  @override
  String get subscription_upgrade_not_available =>
      'The subscription is currently not available for upgrade.';

  @override
  String get subscription_upgrade_request_already_pending =>
      'An upgrade request is already pending review.';

  @override
  String get subscription_not_found => 'Subscription not found.';

  @override
  String get subscription_upgrade_default_error =>
      'An error occurred while initiating the upgrade, please try again.';

  @override
  String get restaurant_tier_upgrade_success =>
      'Tier upgraded successfully and the updated subscription is active immediately.';

  @override
  String get restaurant_tier_upgrade_confirm_title => 'Confirm Tier Upgrade';

  @override
  String get restaurant_tier_upgrade_no_data =>
      'No data available for upgrade request.';

  @override
  String get family_error_cannot_remove_manager =>
      'The family manager cannot be removed.';

  @override
  String get family_error_member_not_found =>
      'This family member could not be found.';

  @override
  String get family_error_not_manager =>
      'Only the family manager can perform this action.';

  @override
  String get family_error_use_checkout_flow =>
      'Add family members through the subscription checkout flow.';

  @override
  String get family_error_manager_permissions_immutable =>
      'The family manager\'s permissions cannot be changed.';

  @override
  String get family_error_member_paused => 'This family member is paused.';

  @override
  String get family_error_permission_denied =>
      'This family member does not have permission to edit meals.';

  @override
  String get family_error_renewal_not_available =>
      'This subscription cannot be renewed right now.';

  @override
  String get family_error_subscription_not_found =>
      'The requested family subscription was not found.';

  @override
  String get family_error_customer_only =>
      'This action is only available to customers.';

  @override
  String get family_member_no_plan => 'No plan';

  @override
  String get family_member_paused_label => 'Paused';

  @override
  String get family_member_active_label => 'Active';

  @override
  String family_member_days_remaining(int count) {
    return '$count days remaining';
  }

  @override
  String family_member_age_years(int count) {
    return '$count years';
  }

  @override
  String family_member_details_title(String name) {
    return 'Details for $name';
  }

  @override
  String get family_member_manager_label => 'Family manager';

  @override
  String get family_member_member_label => 'Family member';

  @override
  String get family_member_program_title => 'Nutrition program';

  @override
  String get family_member_change_program => 'Change program';

  @override
  String get family_member_package_title => 'Subscription';

  @override
  String family_member_subscription_dates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get family_member_renew_subscription => 'Renew subscription';

  @override
  String get family_member_today_nutrition => 'Today\'s nutrition';

  @override
  String family_member_calories_value(String count) {
    return '$count kcal';
  }

  @override
  String get family_member_show_calendar => 'Show calendar';

  @override
  String get family_member_access_phone_label => 'Mobile number';

  @override
  String get family_member_access_pause_label => 'Pause member';

  @override
  String get family_member_access_remove_label => 'Remove member';

  @override
  String get family_member_access_generated_password_title =>
      'One-time password';

  @override
  String get family_member_access_generated_password_message =>
      'Share this password now. It will not be shown again.';

  @override
  String get family_member_access_existing_login =>
      'This phone number already has a MealMate account. The member can use the existing password.';

  @override
  String get family_member_access_copy => 'Copy';

  @override
  String get family_member_shortcut_daily_meals => 'Daily Meals';

  @override
  String get family_member_shortcut_daily_meals_subtitle =>
      'View meals and plans';

  @override
  String get family_member_shortcut_permissions => 'Permissions';

  @override
  String get family_member_shortcut_permissions_subtitle =>
      'View and manage permissions';

  @override
  String family_member_calendar_title(String name) {
    return '$name\'s Calendar';
  }

  @override
  String get family_member_no_active_subscription =>
      'This member currently has no active subscription.';

  @override
  String get family_member_no_meals_selected =>
      'No meals selected for this day.';

  @override
  String family_member_selected_meals_count(int count) {
    return '$count meals selected';
  }

  @override
  String get family_member_day_details_button => 'View Day Details';

  @override
  String get family_member_choose_meals_button => 'Choose Meals';

  @override
  String get family_member_selected_meals_title => 'Selected Meals';

  @override
  String family_member_selected_meals_subtitle(String name, String date) {
    return 'Selected meals for $name on $date';
  }

  @override
  String get family_member_meal_chosen => 'Selected';

  @override
  String get family_member_choose_meal => 'Choose meal';

  @override
  String get family_day_screen_title => 'Day Details';

  @override
  String get family_day_current_restaurant_subtitle => 'Current restaurant';

  @override
  String get family_day_review_meals_button => 'Review day meals';

  @override
  String get family_day_all_meals_selected => 'All meals selected';

  @override
  String get family_day_default_restaurant_name => 'Green Chef Restaurant';

  @override
  String get influencer_header_greeting => 'Hello, Mohammed';

  @override
  String get currency_kwd => 'KWD';

  @override
  String get offer_browse_title => 'Available Offers';

  @override
  String get offer_browse_empty => 'No offers available right now';

  @override
  String get offer_browse_tab_all => 'All';

  @override
  String get offer_browse_tab_offers => 'Special Offers';

  @override
  String get offer_browse_tab_restaurants => 'Restaurants';

  @override
  String get offer_browse_tab_subscriptions => 'Subscriptions';

  @override
  String get offer_browse_remaining_spots => 'spots remaining';

  @override
  String get offer_browse_action_button => 'Claim Offer';

  @override
  String get offer_hub_view_all => 'View All';

  @override
  String get offer_hub_share_message => 'Share link copied!';

  @override
  String get offer_deal_best_seller => 'Best Seller';

  @override
  String get offer_deal_action_button => 'Order Now';

  @override
  String get offer_deal_free_delivery => 'Free Delivery';

  @override
  String get offer_details_code_label => 'Promo Code';

  @override
  String get offer_details_copy_code => 'Code copied successfully';

  @override
  String get offer_countdown_prefix => 'Offer ends in';

  @override
  String get offer_countdown_expired => 'This offer has expired';

  @override
  String get offer_status_expired => 'Offer Expired';

  @override
  String get offer_status_sold_out => 'Sold Out';

  @override
  String get offer_promo_title => 'Enter Promo Code';

  @override
  String get offer_promo_headline => 'Have a promo code or coupon?';

  @override
  String get offer_promo_subtitle =>
      'Enter the promo code to get the best exclusive offers on your subscriptions';

  @override
  String get offer_promo_hint => 'Enter code here (e.g. SAVE20)';

  @override
  String get offer_promo_paste_tooltip => 'Paste from clipboard';

  @override
  String get offer_promo_apply_button => 'Apply Code';

  @override
  String get offer_promo_empty_error => 'Please enter a promo code first';

  @override
  String get offer_promo_invalid_error => 'Invalid or expired promo code';

  @override
  String get offer_promo_available_codes_title => 'Suggested Promo Codes';

  @override
  String get offer_promo_apply_code => 'Apply';

  @override
  String get offer_promo_save20_title => '20% off all monthly packages';

  @override
  String get offer_promo_fit10_title => '10% off fitness programs';

  @override
  String get offer_promo_welcome_title => '15% off for new subscribers';

  @override
  String get offer_redeem_title => 'Apply Offer & Select Package';

  @override
  String get offer_redeem_select_package_title =>
      'Select Your Package Duration';

  @override
  String get offer_package_month_title => 'Full Month Package (26 Days)';

  @override
  String get offer_package_half_month_title => 'Half Month Package (13 Days)';

  @override
  String get offer_package_week_title => 'Weekly Package (6 Days)';

  @override
  String offer_redeem_min_days_notice(String days) {
    return 'This offer requires a minimum of $days days';
  }

  @override
  String get offer_redeem_total_after_discount => 'Total After Discount';

  @override
  String get offer_redeem_proceed_button => 'Proceed to Confirmation';

  @override
  String get offer_redeem_safe_payment_notice =>
      '100% Secure & Encrypted Payment';

  @override
  String get offer_checkout_title => 'Offer Checkout Confirmation';

  @override
  String get offer_checkout_applied_title => 'Offer Applied Successfully!';

  @override
  String get offer_checkout_applied_code => 'Applied Code';

  @override
  String get offer_checkout_applied_description =>
      'The best available discount has been applied to your selected package';

  @override
  String get offer_checkout_order_summary_title => 'Subscription Summary';

  @override
  String get offer_checkout_package_label => 'Selected Package';

  @override
  String get offer_checkout_meals_per_day => 'Meals Per Day';

  @override
  String get offer_checkout_original_price => 'Original Price';

  @override
  String get offer_checkout_discount_amount => 'Discount Amount';

  @override
  String get offer_checkout_final_total => 'Total Payment';

  @override
  String get offer_checkout_secure_badge =>
      'Payment is secure and protected via safe gateway';

  @override
  String get offer_checkout_proceed_button => 'Confirm & Pay Now';

  @override
  String get offer_checkout_change_package_button => 'Change Package or Offer';

  @override
  String get offer_activation_success_title => 'Subscription Activated';

  @override
  String get offer_activation_congrats =>
      'Congratulations! Your offer is active';

  @override
  String get offer_activation_subtitle =>
      'Your package is ready to use. You can now select and schedule your meals';

  @override
  String get offer_activation_order_title => 'Activated Subscription Details';

  @override
  String get offer_activation_paid_total => 'Total Paid';

  @override
  String get offer_activation_choose_plan_button => 'Schedule & Choose Meals';

  @override
  String get meals_count => 'meals';
}
