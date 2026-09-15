// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/addresses/data/data_source/addresses_remote_data_source.dart'
    as _i737;
import '../../features/addresses/data/data_source/addresses_remote_data_source_impl.dart'
    as _i380;
import '../../features/addresses/data/repo/addresses_repository_impl.dart'
    as _i376;
import '../../features/addresses/domain/repo/addresses_repository.dart'
    as _i556;
import '../../features/addresses/domain/usecase/add_customer_address_usecase.dart'
    as _i898;
import '../../features/addresses/domain/usecase/confirm_set_default_address_usecase.dart'
    as _i267;
import '../../features/addresses/domain/usecase/delete_customer_address_usecase.dart'
    as _i624;
import '../../features/addresses/domain/usecase/geocode_address_usecase.dart'
    as _i563;
import '../../features/addresses/domain/usecase/get_customer_addresses_usecase.dart'
    as _i945;
import '../../features/addresses/domain/usecase/get_locations_catalog_usecase.dart'
    as _i2;
import '../../features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart'
    as _i577;
import '../../features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart'
    as _i1022;
import '../../features/addresses/domain/usecase/reverse_geocode_location_usecase.dart'
    as _i1019;
import '../../features/addresses/domain/usecase/update_customer_address_usecase.dart'
    as _i241;
import '../../features/addresses/presentation/manager/addresses_view_model.dart'
    as _i524;
import '../../features/auth/data/data_source/auth_remote_data_source.dart'
    as _i182;
import '../../features/auth/data/data_source/auth_remote_data_source_impl.dart'
    as _i508;
import '../../features/auth/data/repo/auth_repository_impl.dart' as _i607;
import '../../features/auth/domain/repo/auth_repository.dart' as _i2;
import '../../features/auth/domain/usecase/forgot_password_usecase.dart'
    as _i749;
import '../../features/auth/domain/usecase/get_calling_codes_usecase.dart'
    as _i171;
import '../../features/auth/domain/usecase/login_usecase.dart' as _i911;
import '../../features/auth/domain/usecase/logout_usecase.dart' as _i757;
import '../../features/auth/domain/usecase/refresh_token_usecase.dart' as _i501;
import '../../features/auth/domain/usecase/register_usecase.dart' as _i769;
import '../../features/auth/domain/usecase/resend_password_otp_usecase.dart'
    as _i610;
import '../../features/auth/domain/usecase/resend_phone_otp_usecase.dart'
    as _i621;
import '../../features/auth/domain/usecase/reset_password_usecase.dart'
    as _i1029;
import '../../features/auth/domain/usecase/verify_phone_usecase.dart' as _i918;
import '../../features/auth/presentation/manager/auth_view_model.dart' as _i892;
import '../../features/auth/presentation/manager/biometric_cubit.dart' as _i280;
import '../../features/calendar/data/data_source/calendar_remote_data_source.dart'
    as _i583;
import '../../features/calendar/data/data_source/calendar_remote_data_source_impl.dart'
    as _i970;
import '../../features/calendar/data/repo/calendar_repository_impl.dart'
    as _i787;
import '../../features/calendar/domain/repo/calendar_repository.dart' as _i333;
import '../../features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart'
    as _i147;
import '../../features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart'
    as _i389;
import '../../features/calendar/domain/usecase/get_calendar_day_usecase.dart'
    as _i705;
import '../../features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart'
    as _i389;
import '../../features/calendar/domain/usecase/get_calendar_usecase.dart'
    as _i200;
import '../../features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart'
    as _i896;
import '../../features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart'
    as _i133;
import '../../features/calendar/presentation/manager/calendar_view_model.dart'
    as _i127;
import '../../features/change_password/data/data_source/change_password_remote_data_source.dart'
    as _i263;
import '../../features/change_password/data/data_source/change_password_remote_data_source_impl.dart'
    as _i949;
import '../../features/change_password/data/repo/change_password_repository_impl.dart'
    as _i246;
import '../../features/change_password/domain/repo/change_password_repository.dart'
    as _i229;
import '../../features/change_password/domain/usecase/change_customer_password_usecase.dart'
    as _i845;
import '../../features/family_addresses/data/data_source/family_addresses_remote_data_source.dart'
    as _i1040;
import '../../features/family_addresses/data/data_source/family_addresses_remote_data_source_impl.dart'
    as _i517;
import '../../features/family_addresses/data/repo/family_addresses_repository_impl.dart'
    as _i52;
import '../../features/family_addresses/domain/repo/family_addresses_repository.dart'
    as _i982;
import '../../features/family_addresses/domain/usecase/family_addresses_usecases.dart'
    as _i643;
import '../../features/family_addresses/presentation/manager/family_addresses_view_model.dart'
    as _i603;
import '../../features/family_allergies/data/data_source/family_allergies_remote_data_source.dart'
    as _i322;
import '../../features/family_allergies/data/data_source/family_allergies_remote_data_source_impl.dart'
    as _i492;
import '../../features/family_allergies/data/repo/family_allergies_repository_impl.dart'
    as _i145;
import '../../features/family_allergies/domain/repo/family_allergies_repository.dart'
    as _i223;
import '../../features/family_allergies/domain/usecase/save_family_member_allergies_usecase.dart'
    as _i515;
import '../../features/family_allergies/presentation/manager/family_allergies_view_model.dart'
    as _i911;
import '../../features/family_checkout/data/data_source/family_checkout_remote_data_source.dart'
    as _i714;
import '../../features/family_checkout/data/data_source/family_checkout_remote_data_source_impl.dart'
    as _i809;
import '../../features/family_checkout/data/repo/family_checkout_repository_impl.dart'
    as _i205;
import '../../features/family_checkout/domain/repo/family_checkout_repository.dart'
    as _i802;
import '../../features/family_checkout/domain/usecase/checkout_family_subscription_usecase.dart'
    as _i856;
import '../../features/family_checkout/domain/usecase/get_family_payment_methods_usecase.dart'
    as _i605;
import '../../features/family_checkout/domain/usecase/get_family_summary_usecase.dart'
    as _i408;
import '../../features/family_checkout/presentation/manager/family_checkout_view_model.dart'
    as _i665;
import '../../features/family_package_days/data/data_source/family_package_days_remote_data_source.dart'
    as _i355;
import '../../features/family_package_days/data/data_source/family_package_days_remote_data_source_impl.dart'
    as _i400;
import '../../features/family_package_days/data/repo/family_package_days_repository_impl.dart'
    as _i471;
import '../../features/family_package_days/domain/repo/family_package_days_repository.dart'
    as _i306;
import '../../features/family_package_days/domain/usecase/get_family_plan_durations_usecase.dart'
    as _i570;
import '../../features/family_package_days/domain/usecase/get_family_plan_tiers_usecase.dart'
    as _i870;
import '../../features/family_package_days/domain/usecase/save_family_member_plan_usecase.dart'
    as _i600;
import '../../features/family_package_days/presentation/manager/family_package_days_view_model.dart'
    as _i597;
import '../../features/family_packages/data/data_source/family_packages_remote_data_source.dart'
    as _i986;
import '../../features/family_packages/data/data_source/family_packages_remote_data_source_impl.dart'
    as _i854;
import '../../features/family_packages/data/repo/family_packages_repository_impl.dart'
    as _i533;
import '../../features/family_packages/domain/repo/family_packages_repository.dart'
    as _i583;
import '../../features/family_packages/domain/usecase/get_family_size_packages_usecase.dart'
    as _i801;
import '../../features/family_packages/presentation/manager/family_packages_view_model.dart'
    as _i668;
import '../../features/family_programs/data/data_source/family_programs_remote_data_source.dart'
    as _i603;
import '../../features/family_programs/data/data_source/family_programs_remote_data_source_impl.dart'
    as _i567;
import '../../features/family_programs/data/repo/family_programs_repository_impl.dart'
    as _i377;
import '../../features/family_programs/domain/repo/family_programs_repository.dart'
    as _i964;
import '../../features/family_programs/domain/usecase/get_family_program_bundles_usecase.dart'
    as _i448;
import '../../features/family_programs/domain/usecase/get_family_programs_usecase.dart'
    as _i577;
import '../../features/family_programs/presentation/manager/family_programs_view_model.dart'
    as _i731;
import '../../features/family_subscription_setup/data/data_source/family_subscription_setup_remote_data_source.dart'
    as _i379;
import '../../features/family_subscription_setup/data/data_source/family_subscription_setup_remote_data_source_impl.dart'
    as _i60;
import '../../features/family_subscription_setup/data/repo/family_subscription_setup_repository_impl.dart'
    as _i922;
import '../../features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart'
    as _i41;
import '../../features/family_subscription_setup/domain/repo/family_subscription_setup_repository.dart'
    as _i925;
import '../../features/family_subscription_setup/domain/usecase/abandon_family_draft_usecase.dart'
    as _i873;
import '../../features/family_subscription_setup/domain/usecase/add_family_member_usecase.dart'
    as _i843;
import '../../features/family_subscription_setup/domain/usecase/delete_family_member_usecase.dart'
    as _i880;
import '../../features/family_subscription_setup/domain/usecase/get_family_flow_current_usecase.dart'
    as _i34;
import '../../features/family_subscription_setup/domain/usecase/get_family_relationships_usecase.dart'
    as _i804;
import '../../features/family_subscription_setup/domain/usecase/lookup_family_member_usecase.dart'
    as _i973;
import '../../features/family_subscription_setup/domain/usecase/update_family_group_usecase.dart'
    as _i482;
import '../../features/family_subscription_setup/domain/usecase/update_family_member_usecase.dart'
    as _i237;
import '../../features/family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart'
    as _i693;
import '../../features/food_preferences/data/data_source/food_preferences_remote_data_source.dart'
    as _i961;
import '../../features/food_preferences/data/data_source/food_preferences_remote_data_source_impl.dart'
    as _i194;
import '../../features/food_preferences/data/repo/food_preferences_repository_impl.dart'
    as _i1070;
import '../../features/food_preferences/domain/repo/food_preferences_repository.dart'
    as _i62;
import '../../features/food_preferences/domain/usecase/get_food_preferences_catalog_usecase.dart'
    as _i32;
import '../../features/food_preferences/domain/usecase/get_food_preferences_usecase.dart'
    as _i608;
import '../../features/food_preferences/domain/usecase/update_food_preferences_allergies_usecase.dart'
    as _i400;
import '../../features/food_preferences/domain/usecase/update_food_preferences_usecase.dart'
    as _i635;
import '../../features/food_preferences/presentation/manager/food_preferences_view_model.dart'
    as _i420;
import '../../features/influencer/analytics/data/data_source/influencer_analytics_remote_data_source.dart'
    as _i887;
import '../../features/influencer/analytics/data/data_source/influencer_analytics_remote_data_source_impl.dart'
    as _i467;
import '../../features/influencer/analytics/data/repo/influencer_analytics_repository_impl.dart'
    as _i166;
import '../../features/influencer/analytics/domain/repo/influencer_analytics_repository.dart'
    as _i588;
import '../../features/influencer/analytics/domain/usecase/get_influencer_analytics_usecase.dart'
    as _i502;
import '../../features/influencer/analytics/presentation/manager/influencer_analytics_view_model.dart'
    as _i776;
import '../../features/influencer/bank_account/data/data_source/influencer_bank_account_remote_data_source.dart'
    as _i575;
import '../../features/influencer/bank_account/data/data_source/influencer_bank_account_remote_data_source_impl.dart'
    as _i750;
import '../../features/influencer/bank_account/data/repo/influencer_bank_account_repository_impl.dart'
    as _i583;
import '../../features/influencer/bank_account/domain/repo/influencer_bank_account_repository.dart'
    as _i577;
import '../../features/influencer/bank_account/domain/usecase/delete_influencer_bank_account_usecase.dart'
    as _i5;
import '../../features/influencer/bank_account/domain/usecase/get_influencer_bank_account_usecase.dart'
    as _i327;
import '../../features/influencer/bank_account/domain/usecase/get_influencer_banks_usecase.dart'
    as _i937;
import '../../features/influencer/bank_account/domain/usecase/save_influencer_bank_account_usecase.dart'
    as _i602;
import '../../features/influencer/bank_account/presentation/manager/influencer_bank_account_view_model.dart'
    as _i907;
import '../../features/influencer/dashboard/data/data_source/influencer_dashboard_remote_data_source.dart'
    as _i217;
import '../../features/influencer/dashboard/data/data_source/influencer_dashboard_remote_data_source_impl.dart'
    as _i1001;
import '../../features/influencer/dashboard/data/repo/influencer_dashboard_repository_impl.dart'
    as _i210;
import '../../features/influencer/dashboard/domain/repo/influencer_dashboard_repository.dart'
    as _i601;
import '../../features/influencer/dashboard/domain/usecase/get_influencer_activities_usecase.dart'
    as _i899;
import '../../features/influencer/dashboard/domain/usecase/get_influencer_home_usecase.dart'
    as _i493;
import '../../features/influencer/dashboard/domain/usecase/get_influencer_links_usecase.dart'
    as _i460;
import '../../features/influencer/dashboard/presentation/manager/influencer_dashboard_view_model.dart'
    as _i760;
import '../../features/influencer/social_links/data/data_source/influencer_social_links_remote_data_source.dart'
    as _i963;
import '../../features/influencer/social_links/data/data_source/influencer_social_links_remote_data_source_impl.dart'
    as _i54;
import '../../features/influencer/social_links/data/repo/influencer_social_links_repository_impl.dart'
    as _i100;
import '../../features/influencer/social_links/domain/repo/influencer_social_links_repository.dart'
    as _i897;
import '../../features/influencer/social_links/domain/usecase/get_influencer_social_profile_usecase.dart'
    as _i127;
import '../../features/influencer/social_links/domain/usecase/update_influencer_social_links_usecase.dart'
    as _i320;
import '../../features/influencer/social_links/presentation/manager/influencer_social_links_view_model.dart'
    as _i626;
import '../../features/influencer/wallet/data/data_source/influencer_wallet_remote_data_source.dart'
    as _i798;
import '../../features/influencer/wallet/data/data_source/influencer_wallet_remote_data_source_impl.dart'
    as _i149;
import '../../features/influencer/wallet/data/repo/influencer_wallet_repository_impl.dart'
    as _i212;
import '../../features/influencer/wallet/domain/repo/influencer_wallet_repository.dart'
    as _i69;
import '../../features/influencer/wallet/domain/usecase/cancel_influencer_withdrawal_usecase.dart'
    as _i864;
import '../../features/influencer/wallet/domain/usecase/create_influencer_withdrawal_usecase.dart'
    as _i82;
import '../../features/influencer/wallet/domain/usecase/get_influencer_wallet_usecase.dart'
    as _i882;
import '../../features/influencer/wallet/domain/usecase/get_influencer_withdrawal_usecase.dart'
    as _i379;
import '../../features/influencer/wallet/domain/usecase/get_influencer_withdrawals_usecase.dart'
    as _i411;
import '../../features/influencer/wallet/presentation/manager/influencer_wallet_view_model.dart'
    as _i223;
import '../../features/meal_details/data/data_source/meal_details_remote_data_source.dart'
    as _i557;
import '../../features/meal_details/data/data_source/meal_details_remote_data_source_impl.dart'
    as _i90;
import '../../features/meal_details/data/repo/meal_details_repository_impl.dart'
    as _i49;
import '../../features/meal_details/domain/repo/meal_details_repository.dart'
    as _i62;
import '../../features/meal_details/domain/usecase/get_subscription_meal_details_usecase.dart'
    as _i832;
import '../../features/meal_details/presentation/manager/meal_details_view_model.dart'
    as _i293;
import '../../features/monthly_plans/data/data_source/subscription_plan_remote_data_source.dart'
    as _i755;
import '../../features/monthly_plans/data/data_source/subscription_plan_remote_data_source_impl.dart'
    as _i509;
import '../../features/monthly_plans/data/repo/subscription_plan_repository_impl.dart'
    as _i738;
import '../../features/monthly_plans/domain/repo/subscription_plan_repository.dart'
    as _i986;
import '../../features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart'
    as _i275;
import '../../features/monthly_plans/domain/usecase/get_subscription_restaurant_details_usecase.dart'
    as _i837;
import '../../features/monthly_plans/presentation/manager/subscription_plan_view_model.dart'
    as _i527;
import '../../features/monthly_plans/presentation/manager/subscription_restaurant_details_view_model.dart'
    as _i851;
import '../../features/notifications/data/data_source/notifications_remote_data_source.dart'
    as _i173;
import '../../features/notifications/data/data_source/notifications_remote_data_source_impl.dart'
    as _i2;
import '../../features/notifications/data/repo/notifications_repository_impl.dart'
    as _i166;
import '../../features/notifications/domain/repo/notifications_repository.dart'
    as _i341;
import '../../features/notifications/domain/usecase/register_device_token_usecase.dart'
    as _i350;
import '../../features/notifications/domain/usecase/unregister_device_token_usecase.dart'
    as _i546;
import '../../features/payment/data/data_source/payment_remote_data_source.dart'
    as _i957;
import '../../features/payment/data/data_source/payment_remote_data_source_impl.dart'
    as _i621;
import '../../features/payment/data/repo/payment_repository_impl.dart' as _i914;
import '../../features/payment/domain/repo/payment_repository.dart' as _i996;
import '../../features/payment/domain/usecase/checkout_subscription_usecase.dart'
    as _i895;
import '../../features/payment/domain/usecase/get_payment_methods_usecase.dart'
    as _i365;
import '../../features/payment/domain/usecase/get_subscription_calendar_usecase.dart'
    as _i182;
import '../../features/payment/domain/usecase/get_subscription_payment_status_usecase.dart'
    as _i173;
import '../../features/payment/presentation/manager/payment_view_model.dart'
    as _i502;
import '../../features/profile/data/data_source/profile_remote_data_source.dart'
    as _i998;
import '../../features/profile/data/data_source/profile_remote_data_source_impl.dart'
    as _i531;
import '../../features/profile/data/repo/profile_repository_impl.dart'
    as _i1015;
import '../../features/profile/data/repo/profile_uncompleted_subscription_repository_impl.dart'
    as _i983;
import '../../features/profile/domain/repo/profile_repository.dart' as _i311;
import '../../features/profile/domain/repo/profile_uncompleted_subscription_repository.dart'
    as _i914;
import '../../features/profile/domain/usecase/create_subscription_cancellation_request_usecase.dart'
    as _i406;
import '../../features/profile/domain/usecase/create_subscription_freeze_request_usecase.dart'
    as _i335;
import '../../features/profile/domain/usecase/create_subscription_renewal_request_usecase.dart'
    as _i995;
import '../../features/profile/domain/usecase/delete_customer_profile_image_usecase.dart'
    as _i186;
import '../../features/profile/domain/usecase/delete_uncompleted_subscription_usecase.dart'
    as _i324;
import '../../features/profile/domain/usecase/get_current_customer_subscription_usecase.dart'
    as _i750;
import '../../features/profile/domain/usecase/get_customer_profile_usecase.dart'
    as _i994;
import '../../features/profile/domain/usecase/get_profile_billing_usecase.dart'
    as _i768;
import '../../features/profile/domain/usecase/get_subscription_cancellation_quote_usecase.dart'
    as _i701;
import '../../features/profile/domain/usecase/get_subscription_freeze_details_usecase.dart'
    as _i999;
import '../../features/profile/domain/usecase/get_subscription_resume_preview_usecase.dart'
    as _i600;
import '../../features/profile/domain/usecase/resume_subscription_usecase.dart'
    as _i974;
import '../../features/profile/domain/usecase/update_customer_profile_image_usecase.dart'
    as _i399;
import '../../features/profile/domain/usecase/update_customer_profile_usecase.dart'
    as _i857;
import '../../features/profile/presentation/manager/profile_view_model.dart'
    as _i446;
import '../../features/subscription_checkout/data/data_source/subscription_summary_remote_data_source.dart'
    as _i155;
import '../../features/subscription_checkout/data/data_source/subscription_summary_remote_data_source_impl.dart'
    as _i846;
import '../../features/subscription_checkout/data/repo/subscription_summary_repository_impl.dart'
    as _i636;
import '../../features/subscription_checkout/domain/repo/subscription_summary_repository.dart'
    as _i1060;
import '../../features/subscription_checkout/domain/usecase/get_subscription_readiness_usecase.dart'
    as _i462;
import '../../features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart'
    as _i926;
import '../../features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart'
    as _i356;
import '../../features/subscription_programs/data/data_source/subscription_programs_remote_data_source.dart'
    as _i96;
import '../../features/subscription_programs/data/data_source/subscription_programs_remote_data_source_impl.dart'
    as _i905;
import '../../features/subscription_programs/data/repo/subscription_programs_repository_impl.dart'
    as _i1010;
import '../../features/subscription_programs/domain/repo/subscription_programs_repository.dart'
    as _i650;
import '../../features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart'
    as _i718;
import '../../features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart'
    as _i178;
import '../../features/subscription_programs/presentation/manager/subscription_programs_view_model.dart'
    as _i420;
import '../../features/subscription_settings/data/data_source/family_management_remote_data_source.dart'
    as _i322;
import '../../features/subscription_settings/data/data_source/family_management_remote_data_source_impl.dart'
    as _i751;
import '../../features/subscription_settings/data/data_source/restaurant_tier_upgrade_remote_data_source.dart'
    as _i549;
import '../../features/subscription_settings/data/data_source/restaurant_tier_upgrade_remote_data_source_impl.dart'
    as _i798;
import '../../features/subscription_settings/data/repo/family_management_repository_impl.dart'
    as _i1014;
import '../../features/subscription_settings/data/repo/restaurant_tier_upgrade_repository_impl.dart'
    as _i859;
import '../../features/subscription_settings/domain/repo/family_management_repository.dart'
    as _i851;
import '../../features/subscription_settings/domain/repo/restaurant_tier_upgrade_repository.dart'
    as _i603;
import '../../features/subscription_settings/domain/usecase/create_subscription_upgrade_request_usecase.dart'
    as _i261;
import '../../features/subscription_settings/domain/usecase/get_family_home_usecase.dart'
    as _i576;
import '../../features/subscription_settings/domain/usecase/get_family_member_usecase.dart'
    as _i201;
import '../../features/subscription_settings/domain/usecase/get_family_members_usecase.dart'
    as _i897;
import '../../features/subscription_settings/domain/usecase/get_subscription_upgrade_options_usecase.dart'
    as _i990;
import '../../features/subscription_settings/domain/usecase/get_subscription_upgrade_status_usecase.dart'
    as _i934;
import '../../features/subscription_settings/domain/usecase/get_subscription_upgrade_summary_usecase.dart'
    as _i279;
import '../../features/subscription_settings/domain/usecase/manage_family_member_access_usecase.dart'
    as _i977;
import '../../features/subscription_settings/domain/usecase/manage_family_member_permissions_usecase.dart'
    as _i671;
import '../../features/subscription_settings/domain/usecase/renew_family_member_subscription_usecase.dart'
    as _i141;
import '../../features/subscription_settings/presentation/manager/family_calendar_view_model.dart'
    as _i12;
import '../../features/subscription_settings/presentation/manager/family_management_view_model.dart'
    as _i69;
import '../../features/subscription_settings/presentation/manager/restaurant_tier_upgrade_view_model.dart'
    as _i528;
import '../../features/subscription_types/data/data_source/subscription_types_remote_data_source.dart'
    as _i735;
import '../../features/subscription_types/data/data_source/subscription_types_remote_data_source_impl.dart'
    as _i200;
import '../../features/subscription_types/data/repo/subscription_types_repository_impl.dart'
    as _i555;
import '../../features/subscription_types/domain/repo/subscription_types_repository.dart'
    as _i655;
import '../../features/subscription_types/domain/usecase/convert_from_individual_usecase.dart'
    as _i427;
import '../../features/subscription_types/domain/usecase/get_subscription_conversion_options_usecase.dart'
    as _i377;
import '../../features/subscription_types/domain/usecase/get_subscription_types_usecase.dart'
    as _i999;
import '../../features/subscription_types/presentation/manager/subscription_types_view_model.dart'
    as _i62;
import '../biometric/biometric_service.dart' as _i43;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
import '../services/app_navigator_service.dart' as _i179;
import '../services/device_id_service.dart' as _i148;
import '../services/language_interceptor.dart' as _i32;
import '../services/language_service.dart' as _i819;
import '../services/push_notification_service.dart' as _i63;
import '../services/retry_interceptor.dart' as _i844;
import '../services/token_interceptor.dart' as _i1056;
import '../services/token_service.dart' as _i227;
import '../subscription_duration/data/data_source/subscription_duration_remote_data_source.dart'
    as _i286;
import '../subscription_duration/data/data_source/subscription_duration_remote_data_source_impl.dart'
    as _i866;
import '../subscription_duration/data/repo/subscription_duration_repository_impl.dart'
    as _i593;
import '../subscription_duration/domain/repo/subscription_duration_repository.dart'
    as _i395;
import '../subscription_duration/domain/usecase/get_subscription_durations_usecase.dart'
    as _i809;
import '../subscription_packages/data/data_source/subscription_packages_remote_data_source.dart'
    as _i978;
import '../subscription_packages/data/data_source/subscription_packages_remote_data_source_impl.dart'
    as _i461;
import '../subscription_packages/data/repo/subscription_packages_repository_impl.dart'
    as _i384;
import '../subscription_packages/domain/repo/subscription_packages_repository.dart'
    as _i678;
import '../subscription_packages/domain/usecase/get_subscription_packages_usecase.dart'
    as _i537;
import '../subscription_programs/data/data_source/subscription_programs_remote_data_source.dart'
    as _i573;
import '../subscription_programs/data/data_source/subscription_programs_remote_data_source_impl.dart'
    as _i829;
import '../subscription_programs/data/repo/subscription_programs_repository_impl.dart'
    as _i995;
import '../subscription_programs/domain/repo/subscription_programs_repository.dart'
    as _i1047;
import '../subscription_programs/domain/usecase/get_subscription_programs_usecase.dart'
    as _i314;
import '../subscription_tiers/data/data_source/subscription_tier_remote_data_source.dart'
    as _i1038;
import '../subscription_tiers/data/data_source/subscription_tier_remote_data_source_impl.dart'
    as _i1039;
import '../subscription_tiers/data/repo/subscription_tier_repository_impl.dart'
    as _i897;
import '../subscription_tiers/domain/repo/subscription_tier_repository.dart'
    as _i317;
import '../subscription_tiers/domain/usecase/check_subscription_prerequisites_usecase.dart'
    as _i623;
import '../subscription_tiers/domain/usecase/get_subscription_tier_restaurants_usecase.dart'
    as _i726;
import '../subscription_tiers/domain/usecase/get_subscription_tiers_usecase.dart'
    as _i766;
import '../upload_file/data/data_source/upload_file_remote_data_source.dart'
    as _i99;
import '../upload_file/data/data_source/upload_file_remote_data_source_impl.dart'
    as _i963;
import '../upload_file/data/repo/upload_file_repository_impl.dart' as _i818;
import '../upload_file/domain/repo/upload_file_repository.dart' as _i422;
import '../upload_file/domain/usecase/upload_file_usecase.dart' as _i995;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModules = _$ExternalModules();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModules.provideSharedPreferences,
      preResolve: true,
    );
    gh.factory<_i844.RetryInterceptor>(() => _i844.RetryInterceptor());
    gh.lazySingleton<_i528.PrettyDioLogger>(
      () => externalModules.providePrettyDioLogger(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModules.flutterSecureStorage(),
    );
    gh.lazySingleton<_i152.LocalAuthentication>(
      () => externalModules.provideLocalAuthentication(),
    );
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => externalModules.provideFirebaseMessaging(),
    );
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => externalModules.provideFlutterLocalNotificationsPlugin(),
    );
    gh.lazySingleton<_i179.AppNavigatorService>(
      () => _i179.AppNavigatorService(),
    );
    gh.lazySingleton<_i41.FamilyFlowSnapshotStore>(
      () => _i41.FamilyFlowSnapshotStore(),
    );
    gh.factory<_i12.FamilyCalendarViewModel>(
      () => _i12.FamilyCalendarViewModel(
        gh<_i897.GetFamilyMembersUseCase>(),
        gh<_i200.GetCalendarUseCase>(),
        gh<_i705.GetCalendarDayUseCase>(),
        gh<_i389.GetCalendarRestaurantsUseCase>(),
        gh<_i389.GetCalendarAvailableMealsUseCase>(),
        gh<_i896.SaveCalendarDayMealsUseCase>(),
        gh<_i133.SetCalendarDayRestaurantUseCase>(),
      ),
    );
    gh.factory<_i42.SharedPrefHelper>(
      () => _i42.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i227.TokenService>(
      () => _i227.TokenService(
        prefs: gh<_i558.FlutterSecureStorage>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i1056.TokenInterceptor>(
      () => _i1056.TokenInterceptor(
        tokenService: gh<_i227.TokenService>(),
        languageService: gh<_i819.LanguageService>(),
        navigatorService: gh<_i179.AppNavigatorService>(),
      ),
    );
    gh.factory<_i819.LanguageService>(
      () => _i819.LanguageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i148.DeviceIdService>(
      () => _i148.DeviceIdService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i43.BiometricService>(
      () => _i43.BiometricService(
        gh<_i152.LocalAuthentication>(),
        gh<_i460.SharedPreferences>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i280.BiometricCubit>(
      () => _i280.BiometricCubit(gh<_i43.BiometricService>()),
    );
    gh.factory<_i32.LanguageInterceptor>(
      () => _i32.LanguageInterceptor(gh<_i819.LanguageService>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideDio(
        gh<_i528.PrettyDioLogger>(),
        gh<_i1056.TokenInterceptor>(),
        gh<_i32.LanguageInterceptor>(),
      ),
    );
    gh.factory<_i804.ApiServices>(() => _i804.ApiServices(gh<_i361.Dio>()));
    gh.factory<_i322.FamilyAllergiesRemoteDataSource>(
      () => _i492.FamilyAllergiesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i963.InfluencerSocialLinksRemoteDataSource>(
      () => _i54.InfluencerSocialLinksRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i155.SubscriptionSummaryRemoteDataSource>(
      () => _i846.SubscriptionSummaryRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i798.InfluencerWalletRemoteDataSource>(
      () => _i149.InfluencerWalletRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i217.InfluencerDashboardRemoteDataSource>(
      () => _i1001.InfluencerDashboardRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i286.SubscriptionDurationRemoteDataSource>(
      () => _i866.SubscriptionDurationRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i322.FamilyManagementRemoteDataSource>(
      () => _i751.FamilyManagementRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i986.FamilyPackagesRemoteDataSource>(
      () => _i854.FamilyPackagesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i961.FoodPreferencesRemoteDataSource>(
      () => _i194.FoodPreferencesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i355.FamilyPackageDaysRemoteDataSource>(
      () =>
          _i400.FamilyPackageDaysRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i182.AuthRemoteDataSource>(
      () => _i508.AuthRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i96.SubscriptionProgramsRemoteDataSource>(
      () => _i905.SubscriptionProgramsRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i957.PaymentRemoteDataSource>(
      () => _i621.PaymentRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i263.ChangePasswordRemoteDataSource>(
      () => _i949.ChangePasswordRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i714.FamilyCheckoutRemoteDataSource>(
      () => _i809.FamilyCheckoutRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i229.ChangePasswordRepository>(
      () => _i246.ChangePasswordRepositoryImpl(
        gh<_i263.ChangePasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i69.InfluencerWalletRepository>(
      () => _i212.InfluencerWalletRepositoryImpl(
        gh<_i798.InfluencerWalletRemoteDataSource>(),
      ),
    );
    gh.factory<_i575.InfluencerBankAccountRemoteDataSource>(
      () => _i750.InfluencerBankAccountRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i1038.SubscriptionTierRemoteDataSource>(
      () =>
          _i1039.SubscriptionTierRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i1060.SubscriptionSummaryRepository>(
      () => _i636.SubscriptionSummaryRepositoryImpl(
        gh<_i155.SubscriptionSummaryRemoteDataSource>(),
      ),
    );
    gh.factory<_i851.FamilyManagementRepository>(
      () => _i1014.FamilyManagementRepositoryImpl(
        gh<_i322.FamilyManagementRemoteDataSource>(),
      ),
    );
    gh.factory<_i317.SubscriptionTierRepository>(
      () => _i897.SubscriptionTierRepositoryImpl(
        gh<_i1038.SubscriptionTierRemoteDataSource>(),
      ),
    );
    gh.factory<_i395.SubscriptionDurationRepository>(
      () => _i593.SubscriptionDurationRepositoryImpl(
        gh<_i286.SubscriptionDurationRemoteDataSource>(),
      ),
    );
    gh.factory<_i996.PaymentRepository>(
      () => _i914.PaymentRepositoryImpl(gh<_i957.PaymentRemoteDataSource>()),
    );
    gh.factory<_i306.FamilyPackageDaysRepository>(
      () => _i471.FamilyPackageDaysRepositoryImpl(
        gh<_i355.FamilyPackageDaysRemoteDataSource>(),
        gh<_i41.FamilyFlowSnapshotStore>(),
      ),
    );
    gh.factory<_i802.FamilyCheckoutRepository>(
      () => _i205.FamilyCheckoutRepositoryImpl(
        gh<_i714.FamilyCheckoutRemoteDataSource>(),
      ),
    );
    gh.factory<_i650.SubscriptionProgramsRepository>(
      () => _i1010.SubscriptionProgramsRepositoryImpl(
        gh<_i96.SubscriptionProgramsRemoteDataSource>(),
      ),
    );
    gh.factory<_i856.CheckoutFamilySubscriptionUseCase>(
      () => _i856.CheckoutFamilySubscriptionUseCase(
        gh<_i802.FamilyCheckoutRepository>(),
      ),
    );
    gh.factory<_i605.GetFamilyPaymentMethodsUseCase>(
      () => _i605.GetFamilyPaymentMethodsUseCase(
        gh<_i802.FamilyCheckoutRepository>(),
      ),
    );
    gh.factory<_i408.GetFamilySummaryUseCase>(
      () => _i408.GetFamilySummaryUseCase(gh<_i802.FamilyCheckoutRepository>()),
    );
    gh.factory<_i897.InfluencerSocialLinksRepository>(
      () => _i100.InfluencerSocialLinksRepositoryImpl(
        gh<_i963.InfluencerSocialLinksRemoteDataSource>(),
      ),
    );
    gh.factory<_i223.FamilyAllergiesRepository>(
      () => _i145.FamilyAllergiesRepositoryImpl(
        gh<_i322.FamilyAllergiesRemoteDataSource>(),
        gh<_i41.FamilyFlowSnapshotStore>(),
      ),
    );
    gh.factory<_i735.SubscriptionTypesRemoteDataSource>(
      () =>
          _i200.SubscriptionTypesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i557.MealDetailsRemoteDataSource>(
      () => _i90.MealDetailsRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i570.GetFamilyPlanDurationsUseCase>(
      () => _i570.GetFamilyPlanDurationsUseCase(
        gh<_i306.FamilyPackageDaysRepository>(),
      ),
    );
    gh.factory<_i870.GetFamilyPlanTiersUseCase>(
      () => _i870.GetFamilyPlanTiersUseCase(
        gh<_i306.FamilyPackageDaysRepository>(),
      ),
    );
    gh.factory<_i600.SaveFamilyMemberPlanUseCase>(
      () => _i600.SaveFamilyMemberPlanUseCase(
        gh<_i306.FamilyPackageDaysRepository>(),
      ),
    );
    gh.factory<_i549.RestaurantTierUpgradeRemoteDataSource>(
      () => _i798.RestaurantTierUpgradeRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i755.SubscriptionPlanRemoteDataSource>(
      () => _i509.SubscriptionPlanRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i379.FamilySubscriptionSetupRemoteDataSource>(
      () => _i60.FamilySubscriptionSetupRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i583.CalendarRemoteDataSource>(
      () => _i970.CalendarRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i864.CancelInfluencerWithdrawalUseCase>(
      () => _i864.CancelInfluencerWithdrawalUseCase(
        gh<_i69.InfluencerWalletRepository>(),
      ),
    );
    gh.factory<_i82.CreateInfluencerWithdrawalUseCase>(
      () => _i82.CreateInfluencerWithdrawalUseCase(
        gh<_i69.InfluencerWalletRepository>(),
      ),
    );
    gh.factory<_i882.GetInfluencerWalletUseCase>(
      () => _i882.GetInfluencerWalletUseCase(
        gh<_i69.InfluencerWalletRepository>(),
      ),
    );
    gh.factory<_i379.GetInfluencerWithdrawalUseCase>(
      () => _i379.GetInfluencerWithdrawalUseCase(
        gh<_i69.InfluencerWalletRepository>(),
      ),
    );
    gh.factory<_i411.GetInfluencerWithdrawalsUseCase>(
      () => _i411.GetInfluencerWithdrawalsUseCase(
        gh<_i69.InfluencerWalletRepository>(),
      ),
    );
    gh.factory<_i601.InfluencerDashboardRepository>(
      () => _i210.InfluencerDashboardRepositoryImpl(
        gh<_i217.InfluencerDashboardRemoteDataSource>(),
      ),
    );
    gh.factory<_i99.UploadFileRemoteDataSource>(
      () => _i963.UploadFileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i1040.FamilyAddressesRemoteDataSource>(
      () => _i517.FamilyAddressesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i515.SaveFamilyMemberAllergiesUseCase>(
      () => _i515.SaveFamilyMemberAllergiesUseCase(
        gh<_i223.FamilyAllergiesRepository>(),
      ),
    );
    gh.factory<_i998.ProfileRemoteDataSource>(
      () => _i531.ProfileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i577.InfluencerBankAccountRepository>(
      () => _i583.InfluencerBankAccountRepositoryImpl(
        gh<_i575.InfluencerBankAccountRemoteDataSource>(),
      ),
    );
    gh.factory<_i737.AddressesRemoteDataSource>(
      () => _i380.AddressesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i603.FamilyProgramsRemoteDataSource>(
      () => _i567.FamilyProgramsRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i623.CheckSubscriptionPrerequisitesUseCase>(
      () => _i623.CheckSubscriptionPrerequisitesUseCase(
        gh<_i317.SubscriptionTierRepository>(),
      ),
    );
    gh.factory<_i726.GetSubscriptionTierRestaurantsUseCase>(
      () => _i726.GetSubscriptionTierRestaurantsUseCase(
        gh<_i317.SubscriptionTierRepository>(),
      ),
    );
    gh.factory<_i766.GetSubscriptionTiersUseCase>(
      () => _i766.GetSubscriptionTiersUseCase(
        gh<_i317.SubscriptionTierRepository>(),
      ),
    );
    gh.factory<_i576.GetFamilyHomeUseCase>(
      () => _i576.GetFamilyHomeUseCase(gh<_i851.FamilyManagementRepository>()),
    );
    gh.factory<_i201.GetFamilyMemberUseCase>(
      () =>
          _i201.GetFamilyMemberUseCase(gh<_i851.FamilyManagementRepository>()),
    );
    gh.factory<_i897.GetFamilyMembersUseCase>(
      () =>
          _i897.GetFamilyMembersUseCase(gh<_i851.FamilyManagementRepository>()),
    );
    gh.factory<_i977.ManageFamilyMemberAccessUseCase>(
      () => _i977.ManageFamilyMemberAccessUseCase(
        gh<_i851.FamilyManagementRepository>(),
      ),
    );
    gh.factory<_i671.ManageFamilyMemberPermissionsUseCase>(
      () => _i671.ManageFamilyMemberPermissionsUseCase(
        gh<_i851.FamilyManagementRepository>(),
      ),
    );
    gh.factory<_i141.RenewFamilyMemberSubscriptionUseCase>(
      () => _i141.RenewFamilyMemberSubscriptionUseCase(
        gh<_i851.FamilyManagementRepository>(),
      ),
    );
    gh.factory<_i978.SubscriptionPackagesRemoteDataSource>(
      () => _i461.SubscriptionPackagesRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i887.InfluencerAnalyticsRemoteDataSource>(
      () => _i467.InfluencerAnalyticsRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i173.NotificationsRemoteDataSource>(
      () => _i2.NotificationsRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i62.FoodPreferencesRepository>(
      () => _i1070.FoodPreferencesRepositoryImpl(
        gh<_i961.FoodPreferencesRemoteDataSource>(),
      ),
    );
    gh.factory<_i573.SubscriptionProgramsRemoteDataSource>(
      () => _i829.SubscriptionProgramsRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i583.FamilyPackagesRepository>(
      () => _i533.FamilyPackagesRepositoryImpl(
        gh<_i986.FamilyPackagesRemoteDataSource>(),
      ),
    );
    gh.factory<_i223.InfluencerWalletViewModel>(
      () => _i223.InfluencerWalletViewModel(
        gh<_i882.GetInfluencerWalletUseCase>(),
        gh<_i411.GetInfluencerWithdrawalsUseCase>(),
        gh<_i82.CreateInfluencerWithdrawalUseCase>(),
        gh<_i864.CancelInfluencerWithdrawalUseCase>(),
      ),
    );
    gh.factory<_i845.ChangeCustomerPasswordUseCase>(
      () => _i845.ChangeCustomerPasswordUseCase(
        gh<_i229.ChangePasswordRepository>(),
      ),
    );
    gh.factory<_i809.GetSubscriptionDurationsUseCase>(
      () => _i809.GetSubscriptionDurationsUseCase(
        gh<_i395.SubscriptionDurationRepository>(),
      ),
    );
    gh.factory<_i69.FamilyManagementViewModel>(
      () => _i69.FamilyManagementViewModel(
        gh<_i576.GetFamilyHomeUseCase>(),
        gh<_i897.GetFamilyMembersUseCase>(),
        gh<_i201.GetFamilyMemberUseCase>(),
        gh<_i977.ManageFamilyMemberAccessUseCase>(),
        gh<_i671.ManageFamilyMemberPermissionsUseCase>(),
        gh<_i141.RenewFamilyMemberSubscriptionUseCase>(),
      ),
    );
    gh.factory<_i462.GetSubscriptionReadinessUseCase>(
      () => _i462.GetSubscriptionReadinessUseCase(
        gh<_i1060.SubscriptionSummaryRepository>(),
      ),
    );
    gh.factory<_i926.GetSubscriptionSummaryUseCase>(
      () => _i926.GetSubscriptionSummaryUseCase(
        gh<_i1060.SubscriptionSummaryRepository>(),
      ),
    );
    gh.factory<_i895.CheckoutSubscriptionUseCase>(
      () => _i895.CheckoutSubscriptionUseCase(gh<_i996.PaymentRepository>()),
    );
    gh.factory<_i365.GetPaymentMethodsUseCase>(
      () => _i365.GetPaymentMethodsUseCase(gh<_i996.PaymentRepository>()),
    );
    gh.factory<_i182.GetSubscriptionCalendarUseCase>(
      () => _i182.GetSubscriptionCalendarUseCase(gh<_i996.PaymentRepository>()),
    );
    gh.factory<_i173.GetSubscriptionPaymentStatusUseCase>(
      () => _i173.GetSubscriptionPaymentStatusUseCase(
        gh<_i996.PaymentRepository>(),
      ),
    );
    gh.factory<_i32.GetFoodPreferencesCatalogUseCase>(
      () => _i32.GetFoodPreferencesCatalogUseCase(
        gh<_i62.FoodPreferencesRepository>(),
      ),
    );
    gh.factory<_i608.GetFoodPreferencesUseCase>(
      () =>
          _i608.GetFoodPreferencesUseCase(gh<_i62.FoodPreferencesRepository>()),
    );
    gh.factory<_i400.UpdateFoodPreferencesAllergiesUseCase>(
      () => _i400.UpdateFoodPreferencesAllergiesUseCase(
        gh<_i62.FoodPreferencesRepository>(),
      ),
    );
    gh.factory<_i635.UpdateFoodPreferencesUseCase>(
      () => _i635.UpdateFoodPreferencesUseCase(
        gh<_i62.FoodPreferencesRepository>(),
      ),
    );
    gh.factory<_i311.ProfileRepository>(
      () => _i1015.ProfileRepositoryImpl(gh<_i998.ProfileRemoteDataSource>()),
    );
    gh.factory<_i801.GetFamilySizePackagesUseCase>(
      () => _i801.GetFamilySizePackagesUseCase(
        gh<_i583.FamilyPackagesRepository>(),
      ),
    );
    gh.factory<_i1047.SubscriptionProgramsRepository>(
      () => _i995.SubscriptionProgramsRepositoryImpl(
        gh<_i573.SubscriptionProgramsRemoteDataSource>(),
      ),
    );
    gh.factory<_i62.MealDetailsRepository>(
      () => _i49.MealDetailsRepositoryImpl(
        gh<_i557.MealDetailsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i925.FamilySubscriptionSetupRepository>(
      () => _i922.FamilySubscriptionSetupRepositoryImpl(
        gh<_i379.FamilySubscriptionSetupRemoteDataSource>(),
        gh<_i41.FamilyFlowSnapshotStore>(),
      ),
    );
    gh.factory<_i5.DeleteInfluencerBankAccountUseCase>(
      () => _i5.DeleteInfluencerBankAccountUseCase(
        gh<_i577.InfluencerBankAccountRepository>(),
      ),
    );
    gh.factory<_i327.GetInfluencerBankAccountUseCase>(
      () => _i327.GetInfluencerBankAccountUseCase(
        gh<_i577.InfluencerBankAccountRepository>(),
      ),
    );
    gh.factory<_i937.GetInfluencerBanksUseCase>(
      () => _i937.GetInfluencerBanksUseCase(
        gh<_i577.InfluencerBankAccountRepository>(),
      ),
    );
    gh.factory<_i602.SaveInfluencerBankAccountUseCase>(
      () => _i602.SaveInfluencerBankAccountUseCase(
        gh<_i577.InfluencerBankAccountRepository>(),
      ),
    );
    gh.factory<_i914.ProfileUncompletedSubscriptionRepository>(
      () => _i983.ProfileUncompletedSubscriptionRepositoryImpl(
        gh<_i998.ProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i422.UploadFileRepository>(
      () =>
          _i818.UploadFileRepositoryImpl(gh<_i99.UploadFileRemoteDataSource>()),
    );
    gh.factory<_i603.RestaurantTierUpgradeRepository>(
      () => _i859.RestaurantTierUpgradeRepositoryImpl(
        gh<_i549.RestaurantTierUpgradeRemoteDataSource>(),
      ),
    );
    gh.factory<_i655.SubscriptionTypesRepository>(
      () => _i555.SubscriptionTypesRepositoryImpl(
        gh<_i735.SubscriptionTypesRemoteDataSource>(),
      ),
    );
    gh.factory<_i127.GetInfluencerSocialProfileUseCase>(
      () => _i127.GetInfluencerSocialProfileUseCase(
        gh<_i897.InfluencerSocialLinksRepository>(),
      ),
    );
    gh.factory<_i320.UpdateInfluencerSocialLinksUseCase>(
      () => _i320.UpdateInfluencerSocialLinksUseCase(
        gh<_i897.InfluencerSocialLinksRepository>(),
      ),
    );
    gh.factory<_i420.FoodPreferencesViewModel>(
      () => _i420.FoodPreferencesViewModel(
        gh<_i608.GetFoodPreferencesUseCase>(),
        gh<_i32.GetFoodPreferencesCatalogUseCase>(),
        gh<_i635.UpdateFoodPreferencesUseCase>(),
        gh<_i400.UpdateFoodPreferencesAllergiesUseCase>(),
      ),
    );
    gh.factory<_i341.NotificationsRepository>(
      () => _i166.NotificationsRepositoryImpl(
        gh<_i173.NotificationsRemoteDataSource>(),
      ),
    );
    gh.factory<_i982.FamilyAddressesRepository>(
      () => _i52.FamilyAddressesRepositoryImpl(
        gh<_i1040.FamilyAddressesRemoteDataSource>(),
        gh<_i41.FamilyFlowSnapshotStore>(),
      ),
    );
    gh.factory<_i718.GetSubscriptionProgramBundlesUseCase>(
      () => _i718.GetSubscriptionProgramBundlesUseCase(
        gh<_i650.SubscriptionProgramsRepository>(),
      ),
    );
    gh.factory<_i178.GetSubscriptionProgramsUseCase>(
      () => _i178.GetSubscriptionProgramsUseCase(
        gh<_i650.SubscriptionProgramsRepository>(),
      ),
    );
    gh.factory<_i377.GetSubscriptionConversionOptionsUseCase>(
      () => _i377.GetSubscriptionConversionOptionsUseCase(
        gh<_i655.SubscriptionTypesRepository>(),
      ),
    );
    gh.factory<_i999.GetSubscriptionTypesUseCase>(
      () => _i999.GetSubscriptionTypesUseCase(
        gh<_i655.SubscriptionTypesRepository>(),
      ),
    );
    gh.factory<_i995.UploadFileUseCase>(
      () => _i995.UploadFileUseCase(gh<_i422.UploadFileRepository>()),
    );
    gh.factory<_i333.CalendarRepository>(
      () => _i787.CalendarRepositoryImpl(gh<_i583.CalendarRemoteDataSource>()),
    );
    gh.factory<_i986.SubscriptionPlanRepository>(
      () => _i738.SubscriptionPlanRepositoryImpl(
        gh<_i755.SubscriptionPlanRemoteDataSource>(),
      ),
    );
    gh.factory<_i356.SubscriptionSummaryViewModel>(
      () => _i356.SubscriptionSummaryViewModel(
        gh<_i926.GetSubscriptionSummaryUseCase>(),
      ),
    );
    gh.factory<_i324.DeleteUncompletedSubscriptionUseCase>(
      () => _i324.DeleteUncompletedSubscriptionUseCase(
        gh<_i914.ProfileUncompletedSubscriptionRepository>(),
      ),
    );
    gh.factory<_i600.GetSubscriptionResumePreviewUseCase>(
      () => _i600.GetSubscriptionResumePreviewUseCase(
        gh<_i914.ProfileUncompletedSubscriptionRepository>(),
      ),
    );
    gh.factory<_i974.ResumeSubscriptionUseCase>(
      () => _i974.ResumeSubscriptionUseCase(
        gh<_i914.ProfileUncompletedSubscriptionRepository>(),
      ),
    );
    gh.factory<_i678.SubscriptionPackagesRepository>(
      () => _i384.SubscriptionPackagesRepositoryImpl(
        gh<_i978.SubscriptionPackagesRemoteDataSource>(),
      ),
    );
    gh.factory<_i261.CreateSubscriptionUpgradeRequestUseCase>(
      () => _i261.CreateSubscriptionUpgradeRequestUseCase(
        gh<_i603.RestaurantTierUpgradeRepository>(),
      ),
    );
    gh.factory<_i990.GetSubscriptionUpgradeOptionsUseCase>(
      () => _i990.GetSubscriptionUpgradeOptionsUseCase(
        gh<_i603.RestaurantTierUpgradeRepository>(),
      ),
    );
    gh.factory<_i934.GetSubscriptionUpgradeStatusUseCase>(
      () => _i934.GetSubscriptionUpgradeStatusUseCase(
        gh<_i603.RestaurantTierUpgradeRepository>(),
      ),
    );
    gh.factory<_i279.GetSubscriptionUpgradeSummaryUseCase>(
      () => _i279.GetSubscriptionUpgradeSummaryUseCase(
        gh<_i603.RestaurantTierUpgradeRepository>(),
      ),
    );
    gh.factory<_i964.FamilyProgramsRepository>(
      () => _i377.FamilyProgramsRepositoryImpl(
        gh<_i603.FamilyProgramsRemoteDataSource>(),
      ),
    );
    gh.factory<_i899.GetInfluencerActivitiesUseCase>(
      () => _i899.GetInfluencerActivitiesUseCase(
        gh<_i601.InfluencerDashboardRepository>(),
      ),
    );
    gh.factory<_i493.GetInfluencerHomeUseCase>(
      () => _i493.GetInfluencerHomeUseCase(
        gh<_i601.InfluencerDashboardRepository>(),
      ),
    );
    gh.factory<_i460.GetInfluencerLinksUseCase>(
      () => _i460.GetInfluencerLinksUseCase(
        gh<_i601.InfluencerDashboardRepository>(),
      ),
    );
    gh.factory<_i907.InfluencerBankAccountViewModel>(
      () => _i907.InfluencerBankAccountViewModel(
        gh<_i937.GetInfluencerBanksUseCase>(),
        gh<_i327.GetInfluencerBankAccountUseCase>(),
        gh<_i602.SaveInfluencerBankAccountUseCase>(),
        gh<_i5.DeleteInfluencerBankAccountUseCase>(),
      ),
    );
    gh.factory<_i556.AddressesRepository>(
      () =>
          _i376.AddressesRepositoryImpl(gh<_i737.AddressesRemoteDataSource>()),
    );
    gh.factory<_i626.InfluencerSocialLinksViewModel>(
      () => _i626.InfluencerSocialLinksViewModel(
        gh<_i127.GetInfluencerSocialProfileUseCase>(),
        gh<_i320.UpdateInfluencerSocialLinksUseCase>(),
      ),
    );
    gh.factory<_i588.InfluencerAnalyticsRepository>(
      () => _i166.InfluencerAnalyticsRepositoryImpl(
        gh<_i887.InfluencerAnalyticsRemoteDataSource>(),
      ),
    );
    gh.factory<_i420.SubscriptionProgramsViewModel>(
      () => _i420.SubscriptionProgramsViewModel(
        gh<_i178.GetSubscriptionProgramsUseCase>(),
        gh<_i718.GetSubscriptionProgramBundlesUseCase>(),
        gh<_i623.CheckSubscriptionPrerequisitesUseCase>(),
      ),
    );
    gh.factory<_i873.AbandonFamilyDraftUseCase>(
      () => _i873.AbandonFamilyDraftUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i843.AddFamilyMemberUseCase>(
      () => _i843.AddFamilyMemberUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i880.DeleteFamilyMemberUseCase>(
      () => _i880.DeleteFamilyMemberUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i34.GetFamilyFlowCurrentUseCase>(
      () => _i34.GetFamilyFlowCurrentUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i804.GetFamilyRelationshipsUseCase>(
      () => _i804.GetFamilyRelationshipsUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i973.LookupFamilyMemberUseCase>(
      () => _i973.LookupFamilyMemberUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i482.UpdateFamilyGroupUseCase>(
      () => _i482.UpdateFamilyGroupUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i237.UpdateFamilyMemberUseCase>(
      () => _i237.UpdateFamilyMemberUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i427.ConvertFromIndividualUseCase>(
      () => _i427.ConvertFromIndividualUseCase(
        gh<_i925.FamilySubscriptionSetupRepository>(),
      ),
    );
    gh.factory<_i406.CreateSubscriptionCancellationRequestUseCase>(
      () => _i406.CreateSubscriptionCancellationRequestUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i335.CreateSubscriptionFreezeRequestUseCase>(
      () => _i335.CreateSubscriptionFreezeRequestUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i995.CreateSubscriptionRenewalRequestUseCase>(
      () => _i995.CreateSubscriptionRenewalRequestUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i186.DeleteCustomerProfileImageUseCase>(
      () => _i186.DeleteCustomerProfileImageUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i750.GetCurrentCustomerSubscriptionUseCase>(
      () => _i750.GetCurrentCustomerSubscriptionUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i994.GetCustomerProfileUseCase>(
      () => _i994.GetCustomerProfileUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i768.GetProfileBillingUseCase>(
      () => _i768.GetProfileBillingUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i701.GetSubscriptionCancellationQuoteUseCase>(
      () => _i701.GetSubscriptionCancellationQuoteUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i999.GetSubscriptionFreezeDetailsUseCase>(
      () => _i999.GetSubscriptionFreezeDetailsUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i399.UpdateCustomerProfileImageUseCase>(
      () => _i399.UpdateCustomerProfileImageUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i857.UpdateCustomerProfileUseCase>(
      () => _i857.UpdateCustomerProfileUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i350.RegisterDeviceTokenUseCase>(
      () =>
          _i350.RegisterDeviceTokenUseCase(gh<_i341.NotificationsRepository>()),
    );
    gh.factory<_i546.UnregisterDeviceTokenUseCase>(
      () => _i546.UnregisterDeviceTokenUseCase(
        gh<_i341.NotificationsRepository>(),
      ),
    );
    gh.factory<_i832.GetSubscriptionMealDetailsUseCase>(
      () => _i832.GetSubscriptionMealDetailsUseCase(
        gh<_i62.MealDetailsRepository>(),
      ),
    );
    gh.factory<_i527.SubscriptionPlanViewModel>(
      () => _i527.SubscriptionPlanViewModel(
        gh<_i809.GetSubscriptionDurationsUseCase>(),
        gh<_i766.GetSubscriptionTiersUseCase>(),
        gh<_i726.GetSubscriptionTierRestaurantsUseCase>(),
        gh<_i462.GetSubscriptionReadinessUseCase>(),
      ),
    );
    gh.factory<_i275.GetSubscriptionDurationsUseCase>(
      () => _i275.GetSubscriptionDurationsUseCase(
        gh<_i986.SubscriptionPlanRepository>(),
      ),
    );
    gh.factory<_i837.GetSubscriptionRestaurantDetailsUseCase>(
      () => _i837.GetSubscriptionRestaurantDetailsUseCase(
        gh<_i986.SubscriptionPlanRepository>(),
      ),
    );
    gh.factory<_i314.GetSubscriptionProgramsUseCase>(
      () => _i314.GetSubscriptionProgramsUseCase(
        gh<_i1047.SubscriptionProgramsRepository>(),
      ),
    );
    gh.factory<_i668.FamilyPackagesViewModel>(
      () => _i668.FamilyPackagesViewModel(
        gh<_i801.GetFamilySizePackagesUseCase>(),
      ),
    );
    gh.factory<_i537.GetSubscriptionPackagesUseCase>(
      () => _i537.GetSubscriptionPackagesUseCase(
        gh<_i678.SubscriptionPackagesRepository>(),
      ),
    );
    gh.factory<_i898.AddCustomerAddressUseCase>(
      () => _i898.AddCustomerAddressUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i267.ConfirmSetDefaultAddressUseCase>(
      () => _i267.ConfirmSetDefaultAddressUseCase(
        gh<_i556.AddressesRepository>(),
      ),
    );
    gh.factory<_i624.DeleteCustomerAddressUseCase>(
      () => _i624.DeleteCustomerAddressUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i563.GeocodeAddressUseCase>(
      () => _i563.GeocodeAddressUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i945.GetCustomerAddressesUseCase>(
      () => _i945.GetCustomerAddressesUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i2.GetLocationsCatalogUseCase>(
      () => _i2.GetLocationsCatalogUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i577.PreviewExistingAddressCoverageUseCase>(
      () => _i577.PreviewExistingAddressCoverageUseCase(
        gh<_i556.AddressesRepository>(),
      ),
    );
    gh.factory<_i1022.PreviewNewAddressCoverageUseCase>(
      () => _i1022.PreviewNewAddressCoverageUseCase(
        gh<_i556.AddressesRepository>(),
      ),
    );
    gh.factory<_i1019.ReverseGeocodeLocationUseCase>(
      () =>
          _i1019.ReverseGeocodeLocationUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i241.UpdateCustomerAddressUseCase>(
      () => _i241.UpdateCustomerAddressUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i643.GetFamilyMemberAddressesUseCase>(
      () => _i643.GetFamilyMemberAddressesUseCase(
        gh<_i982.FamilyAddressesRepository>(),
      ),
    );
    gh.factory<_i643.AddFamilyMemberAddressUseCase>(
      () => _i643.AddFamilyMemberAddressUseCase(
        gh<_i982.FamilyAddressesRepository>(),
      ),
    );
    gh.factory<_i643.PreviewFamilyMemberAddressUseCase>(
      () => _i643.PreviewFamilyMemberAddressUseCase(
        gh<_i982.FamilyAddressesRepository>(),
      ),
    );
    gh.factory<_i643.PreviewExistingFamilyMemberAddressUseCase>(
      () => _i643.PreviewExistingFamilyMemberAddressUseCase(
        gh<_i982.FamilyAddressesRepository>(),
      ),
    );
    gh.factory<_i643.SetDefaultFamilyMemberAddressUseCase>(
      () => _i643.SetDefaultFamilyMemberAddressUseCase(
        gh<_i982.FamilyAddressesRepository>(),
      ),
    );
    gh.factory<_i448.GetFamilyProgramBundlesUseCase>(
      () => _i448.GetFamilyProgramBundlesUseCase(
        gh<_i964.FamilyProgramsRepository>(),
      ),
    );
    gh.factory<_i577.GetFamilyProgramsUseCase>(
      () =>
          _i577.GetFamilyProgramsUseCase(gh<_i964.FamilyProgramsRepository>()),
    );
    gh.factory<_i62.SubscriptionTypesViewModel>(
      () => _i62.SubscriptionTypesViewModel(
        gh<_i999.GetSubscriptionTypesUseCase>(),
        gh<_i377.GetSubscriptionConversionOptionsUseCase>(),
        gh<_i427.ConvertFromIndividualUseCase>(),
      ),
    );
    gh.factory<_i502.PaymentViewModel>(
      () => _i502.PaymentViewModel(
        gh<_i365.GetPaymentMethodsUseCase>(),
        gh<_i895.CheckoutSubscriptionUseCase>(),
        gh<_i173.GetSubscriptionPaymentStatusUseCase>(),
        gh<_i182.GetSubscriptionCalendarUseCase>(),
        gh<_i750.GetCurrentCustomerSubscriptionUseCase>(),
        gh<_i42.SharedPrefHelper>(),
      ),
    );
    gh.factory<_i446.ProfileViewModel>(
      () => _i446.ProfileViewModel(
        gh<_i994.GetCustomerProfileUseCase>(),
        gh<_i768.GetProfileBillingUseCase>(),
        gh<_i995.CreateSubscriptionRenewalRequestUseCase>(),
        gh<_i335.CreateSubscriptionFreezeRequestUseCase>(),
        gh<_i701.GetSubscriptionCancellationQuoteUseCase>(),
        gh<_i406.CreateSubscriptionCancellationRequestUseCase>(),
        gh<_i857.UpdateCustomerProfileUseCase>(),
        gh<_i995.UploadFileUseCase>(),
        gh<_i399.UpdateCustomerProfileImageUseCase>(),
        gh<_i186.DeleteCustomerProfileImageUseCase>(),
        gh<_i324.DeleteUncompletedSubscriptionUseCase>(),
        gh<_i600.GetSubscriptionResumePreviewUseCase>(),
        gh<_i974.ResumeSubscriptionUseCase>(),
      ),
    );
    gh.factory<_i147.AutoSelectCalendarDayUseCase>(
      () => _i147.AutoSelectCalendarDayUseCase(gh<_i333.CalendarRepository>()),
    );
    gh.factory<_i389.GetCalendarAvailableMealsUseCase>(
      () => _i389.GetCalendarAvailableMealsUseCase(
        gh<_i333.CalendarRepository>(),
      ),
    );
    gh.factory<_i705.GetCalendarDayUseCase>(
      () => _i705.GetCalendarDayUseCase(gh<_i333.CalendarRepository>()),
    );
    gh.factory<_i389.GetCalendarRestaurantsUseCase>(
      () => _i389.GetCalendarRestaurantsUseCase(gh<_i333.CalendarRepository>()),
    );
    gh.factory<_i200.GetCalendarUseCase>(
      () => _i200.GetCalendarUseCase(gh<_i333.CalendarRepository>()),
    );
    gh.factory<_i896.SaveCalendarDayMealsUseCase>(
      () => _i896.SaveCalendarDayMealsUseCase(gh<_i333.CalendarRepository>()),
    );
    gh.factory<_i133.SetCalendarDayRestaurantUseCase>(
      () =>
          _i133.SetCalendarDayRestaurantUseCase(gh<_i333.CalendarRepository>()),
    );
    gh.factory<_i597.FamilyPackageDaysViewModel>(
      () => _i597.FamilyPackageDaysViewModel(
        gh<_i34.GetFamilyFlowCurrentUseCase>(),
        gh<_i577.GetFamilyProgramsUseCase>(),
        gh<_i448.GetFamilyProgramBundlesUseCase>(),
        gh<_i570.GetFamilyPlanDurationsUseCase>(),
        gh<_i870.GetFamilyPlanTiersUseCase>(),
        gh<_i726.GetSubscriptionTierRestaurantsUseCase>(),
        gh<_i600.SaveFamilyMemberPlanUseCase>(),
      ),
    );
    gh.factory<_i528.RestaurantTierUpgradeViewModel>(
      () => _i528.RestaurantTierUpgradeViewModel(
        gh<_i990.GetSubscriptionUpgradeOptionsUseCase>(),
        gh<_i279.GetSubscriptionUpgradeSummaryUseCase>(),
        gh<_i261.CreateSubscriptionUpgradeRequestUseCase>(),
        gh<_i934.GetSubscriptionUpgradeStatusUseCase>(),
        gh<_i750.GetCurrentCustomerSubscriptionUseCase>(),
      ),
    );
    gh.factory<_i665.FamilyCheckoutViewModel>(
      () => _i665.FamilyCheckoutViewModel(
        gh<_i34.GetFamilyFlowCurrentUseCase>(),
        gh<_i408.GetFamilySummaryUseCase>(),
        gh<_i605.GetFamilyPaymentMethodsUseCase>(),
        gh<_i856.CheckoutFamilySubscriptionUseCase>(),
      ),
    );
    gh.factory<_i502.GetInfluencerAnalyticsUseCase>(
      () => _i502.GetInfluencerAnalyticsUseCase(
        gh<_i588.InfluencerAnalyticsRepository>(),
      ),
    );
    gh.factory<_i760.InfluencerDashboardViewModel>(
      () => _i760.InfluencerDashboardViewModel(
        gh<_i493.GetInfluencerHomeUseCase>(),
        gh<_i460.GetInfluencerLinksUseCase>(),
      ),
    );
    gh.lazySingleton<_i63.PushNotificationService>(
      () => _i63.PushNotificationService(
        gh<_i892.FirebaseMessaging>(),
        gh<_i163.FlutterLocalNotificationsPlugin>(),
        gh<_i179.AppNavigatorService>(),
        gh<_i227.TokenService>(),
        gh<_i148.DeviceIdService>(),
        gh<_i350.RegisterDeviceTokenUseCase>(),
        gh<_i546.UnregisterDeviceTokenUseCase>(),
      ),
    );
    gh.factory<_i2.AuthRepository>(
      () => _i607.AuthRepositoryImpl(
        gh<_i182.AuthRemoteDataSource>(),
        gh<_i227.TokenService>(),
        gh<_i42.SharedPrefHelper>(),
        gh<_i63.PushNotificationService>(),
        gh<_i41.FamilyFlowSnapshotStore>(),
      ),
    );
    gh.factory<_i603.FamilyAddressesViewModel>(
      () => _i603.FamilyAddressesViewModel(
        gh<_i34.GetFamilyFlowCurrentUseCase>(),
      ),
    );
    gh.factory<_i911.FamilyAllergiesViewModel>(
      () => _i911.FamilyAllergiesViewModel(
        gh<_i34.GetFamilyFlowCurrentUseCase>(),
        gh<_i32.GetFoodPreferencesCatalogUseCase>(),
        gh<_i515.SaveFamilyMemberAllergiesUseCase>(),
      ),
    );
    gh.factory<_i693.FamilySubscriptionSetupViewModel>(
      () => _i693.FamilySubscriptionSetupViewModel(
        gh<_i34.GetFamilyFlowCurrentUseCase>(),
        gh<_i482.UpdateFamilyGroupUseCase>(),
        gh<_i804.GetFamilyRelationshipsUseCase>(),
        gh<_i843.AddFamilyMemberUseCase>(),
        gh<_i237.UpdateFamilyMemberUseCase>(),
        gh<_i880.DeleteFamilyMemberUseCase>(),
        gh<_i873.AbandonFamilyDraftUseCase>(),
        gh<_i945.GetCustomerAddressesUseCase>(),
        gh<_i973.LookupFamilyMemberUseCase>(),
      ),
    );
    gh.factory<_i749.ForgotPasswordUseCase>(
      () => _i749.ForgotPasswordUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i171.GetCallingCodesUseCase>(
      () => _i171.GetCallingCodesUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i911.LoginUseCase>(
      () => _i911.LoginUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i757.LogoutUseCase>(
      () => _i757.LogoutUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i501.RefreshTokenUseCase>(
      () => _i501.RefreshTokenUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i769.RegisterUseCase>(
      () => _i769.RegisterUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i610.ResendPasswordOtpUseCase>(
      () => _i610.ResendPasswordOtpUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i621.ResendPhoneOtpUseCase>(
      () => _i621.ResendPhoneOtpUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i1029.ResetPasswordUseCase>(
      () => _i1029.ResetPasswordUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i918.VerifyPhoneUseCase>(
      () => _i918.VerifyPhoneUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i293.MealDetailsViewModel>(
      () => _i293.MealDetailsViewModel(
        gh<_i832.GetSubscriptionMealDetailsUseCase>(),
      ),
    );
    gh.factory<_i731.FamilyProgramsViewModel>(
      () => _i731.FamilyProgramsViewModel(
        gh<_i34.GetFamilyFlowCurrentUseCase>(),
        gh<_i577.GetFamilyProgramsUseCase>(),
        gh<_i600.SaveFamilyMemberPlanUseCase>(),
      ),
    );
    gh.factory<_i524.AddressesViewModel>(
      () => _i524.AddressesViewModel(
        gh<_i945.GetCustomerAddressesUseCase>(),
        gh<_i2.GetLocationsCatalogUseCase>(),
        gh<_i898.AddCustomerAddressUseCase>(),
        gh<_i241.UpdateCustomerAddressUseCase>(),
        gh<_i624.DeleteCustomerAddressUseCase>(),
        gh<_i563.GeocodeAddressUseCase>(),
        gh<_i1019.ReverseGeocodeLocationUseCase>(),
        gh<_i1022.PreviewNewAddressCoverageUseCase>(),
        gh<_i577.PreviewExistingAddressCoverageUseCase>(),
        gh<_i267.ConfirmSetDefaultAddressUseCase>(),
      ),
    );
    gh.factory<_i851.SubscriptionRestaurantDetailsViewModel>(
      () => _i851.SubscriptionRestaurantDetailsViewModel(
        gh<_i837.GetSubscriptionRestaurantDetailsUseCase>(),
      ),
    );
    gh.factory<_i127.CalendarViewModel>(
      () => _i127.CalendarViewModel(
        gh<_i200.GetCalendarUseCase>(),
        gh<_i705.GetCalendarDayUseCase>(),
        gh<_i389.GetCalendarRestaurantsUseCase>(),
        gh<_i133.SetCalendarDayRestaurantUseCase>(),
        gh<_i389.GetCalendarAvailableMealsUseCase>(),
        gh<_i896.SaveCalendarDayMealsUseCase>(),
        gh<_i147.AutoSelectCalendarDayUseCase>(),
        gh<_i750.GetCurrentCustomerSubscriptionUseCase>(),
        gh<_i42.SharedPrefHelper>(),
      ),
    );
    gh.factory<_i776.InfluencerAnalyticsViewModel>(
      () => _i776.InfluencerAnalyticsViewModel(
        gh<_i502.GetInfluencerAnalyticsUseCase>(),
      ),
    );
    gh.factory<_i892.AuthViewModel>(
      () => _i892.AuthViewModel(
        gh<_i911.LoginUseCase>(),
        gh<_i769.RegisterUseCase>(),
        gh<_i171.GetCallingCodesUseCase>(),
        gh<_i918.VerifyPhoneUseCase>(),
        gh<_i621.ResendPhoneOtpUseCase>(),
        gh<_i749.ForgotPasswordUseCase>(),
        gh<_i1029.ResetPasswordUseCase>(),
        gh<_i610.ResendPasswordOtpUseCase>(),
        gh<_i501.RefreshTokenUseCase>(),
        gh<_i757.LogoutUseCase>(),
        gh<_i750.GetCurrentCustomerSubscriptionUseCase>(),
        gh<_i42.SharedPrefHelper>(),
      ),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
