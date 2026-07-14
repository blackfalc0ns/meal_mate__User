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

  @override
  String get offer_details_title => 'Redeem offer';

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
  String get offer_details_info_copy_code => 'Copy code';

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
  String get offer_activated_title => 'Offer activated successfully';

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
  String get subscription_choose_plan_title => 'Choose the right plan for you';

  @override
  String get subscription_choose_plan_button => 'Choose plan';

  @override
  String get subscription_month_plan_title => 'Monthly plan';

  @override
  String get subscription_half_month_plan_title => 'Half-month plan';

  @override
  String get subscription_week_plan_title => 'Weekly plan';

  @override
  String get subscription_month_duration => '26 days';

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
  String get subscription_note =>
      'All plans include 20% off all orders. You can pause or edit the plan anytime';

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
  String get family_details_title => 'Family plan details';

  @override
  String get family_plan_title => 'Family plan';

  @override
  String get family_plan_subtitle => 'Complete plan for up to 6 members';

  @override
  String get family_plan_new => 'New';

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
}
