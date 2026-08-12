// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get billing_days_remaining => '18 days remaining';

  @override
  String get billing_plan_usage => 'Plan usage this month';

  @override
  String get billing_plan_usage_value => '22 of 30 days';

  @override
  String get billing_plan_usage_current => '22';

  @override
  String get billing_plan_usage_remaining => 'of 30 days';

  @override
  String get billing_renew => 'Renew';

  @override
  String get billing_freeze => 'Freeze';

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
  String get billing_manage_subscription => 'Manage subscription';

  @override
  String get billing_notice =>
      'You can freeze your subscription for up to 30 days once every 6 months. Once cancelled, you can still enjoy your meals until the end of the current billing cycle.';

  @override
  String get profile_addresses => 'Addresses';

  @override
  String get profile_addresses_subtitle => 'Manage delivery addresses';

  @override
  String get addresses_default => 'Default';

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
  String get subscription_days_range_hint =>
      'You can enter any number of days (1-30 days)';

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
  String get subscription_summary_quality => 'High-quality ingredients';

  @override
  String get subscription_summary_variety => 'Daily meal variety';

  @override
  String get subscription_summary_total_price_label => 'Total price';

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
  String get family_members_title => 'Members';

  @override
  String get family_members_search_hint => 'Search for a member';

  @override
  String get family_members_add_member => 'Add member';

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
  String get family_relation => 'Relationship';

  @override
  String get family_relation_hint => 'Choose relationship';

  @override
  String get family_age => 'Age';

  @override
  String get family_age_hint => 'Enter age';

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
  String get family_step_package_days => 'Package and days';

  @override
  String get family_step_payment => 'Payment';

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
  String get calendar_pick_restaurant_first => 'Choose ';

  @override
  String get calendar_pick_restaurant_second => 'restaurant';

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
}
