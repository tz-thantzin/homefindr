import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_my.dart';
import 'app_localizations_th.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('my'),
    Locale('th'),
    Locale('zh')
  ];

  /// No description provided for @the_best_way_to.
  ///
  /// In en, this message translates to:
  /// **'THE BEST WAY TO'**
  String get the_best_way_to;

  /// No description provided for @find_dream_home.
  ///
  /// In en, this message translates to:
  /// **'Find Your Dream Home'**
  String get find_dream_home;

  /// No description provided for @more_than_apartments.
  ///
  /// In en, this message translates to:
  /// **'We\'ve more than 745,000 apartments, place & plot.'**
  String get more_than_apartments;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get nav_buy;

  /// No description provided for @nav_rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get nav_rent;

  /// No description provided for @nav_sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get nav_sell;

  /// No description provided for @nav_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get nav_contact;

  /// No description provided for @nav_login_register.
  ///
  /// In en, this message translates to:
  /// **'Login / Register'**
  String get nav_login_register;

  /// No description provided for @nav_contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get nav_contact_us;

  /// No description provided for @nav_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get nav_language;

  /// No description provided for @nav_browse_by_type.
  ///
  /// In en, this message translates to:
  /// **'Browse by type'**
  String get nav_browse_by_type;

  /// No description provided for @nav_view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get nav_view_all;

  /// No description provided for @nav_menu_apartments.
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get nav_menu_apartments;

  /// No description provided for @nav_menu_apartments_sub.
  ///
  /// In en, this message translates to:
  /// **'City living redefined'**
  String get nav_menu_apartments_sub;

  /// No description provided for @nav_menu_villas.
  ///
  /// In en, this message translates to:
  /// **'Villas'**
  String get nav_menu_villas;

  /// No description provided for @nav_menu_villas_sub.
  ///
  /// In en, this message translates to:
  /// **'Luxury & space'**
  String get nav_menu_villas_sub;

  /// No description provided for @nav_menu_studios.
  ///
  /// In en, this message translates to:
  /// **'Studios'**
  String get nav_menu_studios;

  /// No description provided for @nav_menu_studios_sub.
  ///
  /// In en, this message translates to:
  /// **'Compact & smart'**
  String get nav_menu_studios_sub;

  /// No description provided for @nav_menu_offices.
  ///
  /// In en, this message translates to:
  /// **'Offices'**
  String get nav_menu_offices;

  /// No description provided for @nav_menu_offices_sub.
  ///
  /// In en, this message translates to:
  /// **'Work in style'**
  String get nav_menu_offices_sub;

  /// No description provided for @nav_menu_townhouses.
  ///
  /// In en, this message translates to:
  /// **'Townhouses'**
  String get nav_menu_townhouses;

  /// No description provided for @nav_menu_townhouses_sub.
  ///
  /// In en, this message translates to:
  /// **'Best of both worlds'**
  String get nav_menu_townhouses_sub;

  /// No description provided for @nav_menu_rent_apartments.
  ///
  /// In en, this message translates to:
  /// **'Rent Apartments'**
  String get nav_menu_rent_apartments;

  /// No description provided for @nav_menu_rent_apartments_sub.
  ///
  /// In en, this message translates to:
  /// **'Short & long term'**
  String get nav_menu_rent_apartments_sub;

  /// No description provided for @nav_menu_rent_villas.
  ///
  /// In en, this message translates to:
  /// **'Rent Villas'**
  String get nav_menu_rent_villas;

  /// No description provided for @nav_menu_rent_villas_sub.
  ///
  /// In en, this message translates to:
  /// **'Premium rentals'**
  String get nav_menu_rent_villas_sub;

  /// No description provided for @nav_menu_rent_studios.
  ///
  /// In en, this message translates to:
  /// **'Rent Studios'**
  String get nav_menu_rent_studios;

  /// No description provided for @nav_menu_rent_studios_sub.
  ///
  /// In en, this message translates to:
  /// **'Affordable options'**
  String get nav_menu_rent_studios_sub;

  /// No description provided for @nav_menu_rent_offices.
  ///
  /// In en, this message translates to:
  /// **'Rent Offices'**
  String get nav_menu_rent_offices;

  /// No description provided for @nav_menu_rent_offices_sub.
  ///
  /// In en, this message translates to:
  /// **'Flexible workspaces'**
  String get nav_menu_rent_offices_sub;

  /// No description provided for @nav_menu_rent_townhouses.
  ///
  /// In en, this message translates to:
  /// **'Rent Townhouses'**
  String get nav_menu_rent_townhouses;

  /// No description provided for @nav_menu_rent_townhouses_sub.
  ///
  /// In en, this message translates to:
  /// **'Family-friendly'**
  String get nav_menu_rent_townhouses_sub;

  /// No description provided for @search_tab_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get search_tab_all;

  /// No description provided for @search_tab_for_sale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get search_tab_for_sale;

  /// No description provided for @search_tab_for_rent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get search_tab_for_rent;

  /// No description provided for @search_hint_enter_address_neighborhood.
  ///
  /// In en, this message translates to:
  /// **'Enter address, neighborhood, city, or ZIP code'**
  String get search_hint_enter_address_neighborhood;

  /// No description provided for @search_any_type.
  ///
  /// In en, this message translates to:
  /// **'Any Type'**
  String get search_any_type;

  /// No description provided for @search_hint_refine.
  ///
  /// In en, this message translates to:
  /// **'Refine search...'**
  String get search_hint_refine;

  /// No description provided for @search_hint_properties.
  ///
  /// In en, this message translates to:
  /// **'Search properties...'**
  String get search_hint_properties;

  /// No description provided for @search_results_all_properties.
  ///
  /// In en, this message translates to:
  /// **'All Properties'**
  String get search_results_all_properties;

  /// No description provided for @search_results_for_query.
  ///
  /// In en, this message translates to:
  /// **'Results for \"{query}\"'**
  String search_results_for_query(String query);

  /// No description provided for @search_results_found_single.
  ///
  /// In en, this message translates to:
  /// **'1 property found'**
  String get search_results_found_single;

  /// No description provided for @search_results_found_plural.
  ///
  /// In en, this message translates to:
  /// **'{count} properties found'**
  String search_results_found_plural(int count);

  /// No description provided for @search_no_results.
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get search_no_results;

  /// No description provided for @search_no_results_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search filters'**
  String get search_no_results_subtitle;

  /// No description provided for @search_no_results_filters.
  ///
  /// In en, this message translates to:
  /// **'No properties match your filters'**
  String get search_no_results_filters;

  /// No description provided for @search_filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get search_filter_title;

  /// No description provided for @search_filter_reset_all.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get search_filter_reset_all;

  /// No description provided for @search_filter_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get search_filter_reset;

  /// No description provided for @search_filter_sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get search_filter_sort_by;

  /// No description provided for @search_filter_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get search_filter_status;

  /// No description provided for @search_filter_type.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get search_filter_type;

  /// No description provided for @search_filter_min_beds.
  ///
  /// In en, this message translates to:
  /// **'Min. Bedrooms'**
  String get search_filter_min_beds;

  /// No description provided for @search_filter_beds.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get search_filter_beds;

  /// No description provided for @search_filter_all_status.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get search_filter_all_status;

  /// No description provided for @search_filter_sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get search_filter_sold;

  /// No description provided for @search_filter_any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get search_filter_any;

  /// No description provided for @search_filter_sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get search_filter_sort;

  /// No description provided for @search_filter_all_types.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get search_filter_all_types;

  /// No description provided for @search_sort_newest.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get search_sort_newest;

  /// No description provided for @search_sort_price_low.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get search_sort_price_low;

  /// No description provided for @search_sort_price_high.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get search_sort_price_high;

  /// No description provided for @search_sort_newest_short.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get search_sort_newest_short;

  /// No description provided for @search_sort_price_low_short.
  ///
  /// In en, this message translates to:
  /// **'Price ↑'**
  String get search_sort_price_low_short;

  /// No description provided for @search_sort_price_high_short.
  ///
  /// In en, this message translates to:
  /// **'Price ↓'**
  String get search_sort_price_high_short;

  /// No description provided for @search_advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced Search →'**
  String get search_advanced;

  /// No description provided for @search_properties_count.
  ///
  /// In en, this message translates to:
  /// **'{count} properties'**
  String search_properties_count(int count);

  /// No description provided for @property_discover_our_latest.
  ///
  /// In en, this message translates to:
  /// **'Discover Our Latest Properties'**
  String get property_discover_our_latest;

  /// No description provided for @property_explore_newest_listing.
  ///
  /// In en, this message translates to:
  /// **'Explore the newest listings in your favorite neighborhoods.'**
  String get property_explore_newest_listing;

  /// No description provided for @property_view_all_properties_btn.
  ///
  /// In en, this message translates to:
  /// **'View All Properties'**
  String get property_view_all_properties_btn;

  /// No description provided for @property_type_section_title.
  ///
  /// In en, this message translates to:
  /// **'Explore Property Types'**
  String get property_type_section_title;

  /// No description provided for @property_type_section_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your dream home by browsing through various categories.'**
  String get property_type_section_subtitle;

  /// No description provided for @property_type_section_apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get property_type_section_apartment;

  /// No description provided for @property_type_section_villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get property_type_section_villa;

  /// No description provided for @property_type_section_studio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get property_type_section_studio;

  /// No description provided for @property_type_section_office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get property_type_section_office;

  /// No description provided for @property_type_section_townhouse.
  ///
  /// In en, this message translates to:
  /// **'Townhouse'**
  String get property_type_section_townhouse;

  /// No description provided for @property_type_section_properties_suffix.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get property_type_section_properties_suffix;

  /// No description provided for @property_card_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get property_card_featured;

  /// No description provided for @property_detail_about.
  ///
  /// In en, this message translates to:
  /// **'About this property'**
  String get property_detail_about;

  /// No description provided for @property_detail_features_amenities.
  ///
  /// In en, this message translates to:
  /// **'Features & Amenities'**
  String get property_detail_features_amenities;

  /// No description provided for @property_detail_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get property_detail_location;

  /// No description provided for @property_detail_similar.
  ///
  /// In en, this message translates to:
  /// **'Similar Properties'**
  String get property_detail_similar;

  /// No description provided for @property_detail_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading property...'**
  String get property_detail_loading;

  /// No description provided for @property_detail_listed_price.
  ///
  /// In en, this message translates to:
  /// **'Listed Price'**
  String get property_detail_listed_price;

  /// No description provided for @property_detail_send_message.
  ///
  /// In en, this message translates to:
  /// **'Send a Message'**
  String get property_detail_send_message;

  /// No description provided for @property_detail_interested_in.
  ///
  /// In en, this message translates to:
  /// **'Interested in \"{title}\"'**
  String property_detail_interested_in(String title);

  /// No description provided for @property_detail_call_agent.
  ///
  /// In en, this message translates to:
  /// **'Call Agent'**
  String get property_detail_call_agent;

  /// No description provided for @property_detail_agent_name.
  ///
  /// In en, this message translates to:
  /// **'Sarah Johnson'**
  String get property_detail_agent_name;

  /// No description provided for @property_detail_agent_title.
  ///
  /// In en, this message translates to:
  /// **'Licensed Agent'**
  String get property_detail_agent_title;

  /// No description provided for @property_detail_agent_online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get property_detail_agent_online;

  /// No description provided for @property_detail_description_body.
  ///
  /// In en, this message translates to:
  /// **'This stunning {type} is located in the heart of {location}. Featuring {beds} bedrooms and {baths} bathrooms across {sqft} sq ft of thoughtfully designed living space. The property boasts modern finishes, open-plan living areas, and premium fixtures throughout. Natural light floods every room, and the layout has been designed for both comfort and style. Close to top schools, shopping, dining, and excellent transport links. A rare opportunity not to be missed.'**
  String property_detail_description_body(String type, String location, int beds, int baths, int sqft);

  /// No description provided for @property_detail_feature_ac.
  ///
  /// In en, this message translates to:
  /// **'Air Conditioning'**
  String get property_detail_feature_ac;

  /// No description provided for @property_detail_feature_parking.
  ///
  /// In en, this message translates to:
  /// **'Private Parking'**
  String get property_detail_feature_parking;

  /// No description provided for @property_detail_feature_pool.
  ///
  /// In en, this message translates to:
  /// **'Swimming Pool'**
  String get property_detail_feature_pool;

  /// No description provided for @property_detail_feature_security.
  ///
  /// In en, this message translates to:
  /// **'24/7 Security'**
  String get property_detail_feature_security;

  /// No description provided for @property_detail_feature_gym.
  ///
  /// In en, this message translates to:
  /// **'Gym Access'**
  String get property_detail_feature_gym;

  /// No description provided for @property_detail_feature_wifi.
  ///
  /// In en, this message translates to:
  /// **'High-Speed WiFi'**
  String get property_detail_feature_wifi;

  /// No description provided for @property_detail_feature_elevator.
  ///
  /// In en, this message translates to:
  /// **'Elevator'**
  String get property_detail_feature_elevator;

  /// No description provided for @property_detail_feature_balcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get property_detail_feature_balcony;

  /// No description provided for @property_detail_feature_laundry.
  ///
  /// In en, this message translates to:
  /// **'In-unit Laundry'**
  String get property_detail_feature_laundry;

  /// No description provided for @property_detail_feature_pets.
  ///
  /// In en, this message translates to:
  /// **'Pet Friendly'**
  String get property_detail_feature_pets;

  /// No description provided for @property_detail_hint_name.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get property_detail_hint_name;

  /// No description provided for @property_detail_hint_email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get property_detail_hint_email;

  /// No description provided for @property_detail_hint_message.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get property_detail_hint_message;

  /// No description provided for @property_detail_beds.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get property_detail_beds;

  /// No description provided for @property_detail_baths.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get property_detail_baths;

  /// No description provided for @property_detail_sqft.
  ///
  /// In en, this message translates to:
  /// **'sq ft'**
  String get property_detail_sqft;

  /// No description provided for @property_detail_send_btn.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get property_detail_send_btn;

  /// No description provided for @buy_screen_status.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get buy_screen_status;

  /// No description provided for @buy_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Find Your Dream Home'**
  String get buy_hero_title;

  /// No description provided for @buy_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore hundreds of properties for sale across prime locations.'**
  String get buy_hero_subtitle;

  /// No description provided for @rent_screen_status.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get rent_screen_status;

  /// No description provided for @rent_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Your Perfect Rental'**
  String get rent_hero_title;

  /// No description provided for @rent_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover flexible rental options in the best neighborhoods.'**
  String get rent_hero_subtitle;

  /// No description provided for @listing_stat_properties_label.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get listing_stat_properties_label;

  /// No description provided for @listing_stat_cities_label.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get listing_stat_cities_label;

  /// No description provided for @listing_stat_clients_label.
  ///
  /// In en, this message translates to:
  /// **'Happy Clients'**
  String get listing_stat_clients_label;

  /// No description provided for @listing_stat_properties_value.
  ///
  /// In en, this message translates to:
  /// **'300+'**
  String get listing_stat_properties_value;

  /// No description provided for @listing_stat_cities_value.
  ///
  /// In en, this message translates to:
  /// **'5'**
  String get listing_stat_cities_value;

  /// No description provided for @listing_stat_clients_value.
  ///
  /// In en, this message translates to:
  /// **'10K+'**
  String get listing_stat_clients_value;

  /// No description provided for @contact_breadcrumb_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get contact_breadcrumb_home;

  /// No description provided for @contact_breadcrumb_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_breadcrumb_contact;

  /// No description provided for @contact_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Get In Touch'**
  String get contact_hero_title;

  /// No description provided for @contact_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Our team of experts is here to help you find the perfect property.\nReach out and we\'ll get back to you within 24 hours.'**
  String get contact_hero_subtitle;

  /// No description provided for @contact_form_title.
  ///
  /// In en, this message translates to:
  /// **'Send Us a Message'**
  String get contact_form_title;

  /// No description provided for @contact_form_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the form and we\'ll be in touch shortly.'**
  String get contact_form_subtitle;

  /// No description provided for @contact_form_interested_in.
  ///
  /// In en, this message translates to:
  /// **'I\'m interested in:'**
  String get contact_form_interested_in;

  /// No description provided for @contact_inquiry_buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get contact_inquiry_buy;

  /// No description provided for @contact_inquiry_rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get contact_inquiry_rent;

  /// No description provided for @contact_inquiry_sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get contact_inquiry_sell;

  /// No description provided for @contact_inquiry_general.
  ///
  /// In en, this message translates to:
  /// **'General Inquiry'**
  String get contact_inquiry_general;

  /// No description provided for @contact_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get contact_name;

  /// No description provided for @contact_name_hint.
  ///
  /// In en, this message translates to:
  /// **'John Smith'**
  String get contact_name_hint;

  /// No description provided for @contact_email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get contact_email;

  /// No description provided for @contact_email_hint.
  ///
  /// In en, this message translates to:
  /// **'john@example.com'**
  String get contact_email_hint;

  /// No description provided for @contact_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get contact_phone;

  /// No description provided for @contact_phone_hint.
  ///
  /// In en, this message translates to:
  /// **'+66 123 456 789'**
  String get contact_phone_hint;

  /// No description provided for @contact_subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contact_subject;

  /// No description provided for @contact_subject_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3-bedroom apartment'**
  String get contact_subject_hint;

  /// No description provided for @contact_message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contact_message;

  /// No description provided for @contact_message_hint.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about what you\'re looking for...'**
  String get contact_message_hint;

  /// No description provided for @contact_send.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get contact_send;

  /// No description provided for @contact_success_title.
  ///
  /// In en, this message translates to:
  /// **'Message Sent!'**
  String get contact_success_title;

  /// No description provided for @contact_success_subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll get back to you within 24 hours.'**
  String get contact_success_subtitle;

  /// No description provided for @contact_validation_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get contact_validation_required;

  /// No description provided for @contact_validation_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get contact_validation_email_required;

  /// No description provided for @contact_validation_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get contact_validation_email_invalid;

  /// No description provided for @contact_info_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_info_title;

  /// No description provided for @contact_address.
  ///
  /// In en, this message translates to:
  /// **'Bangkok, Thailand'**
  String get contact_address;

  /// No description provided for @contact_phone_number.
  ///
  /// In en, this message translates to:
  /// **'+95 123-123-123'**
  String get contact_phone_number;

  /// No description provided for @contact_email_address.
  ///
  /// In en, this message translates to:
  /// **'support@homez.com'**
  String get contact_email_address;

  /// No description provided for @contact_office_hours.
  ///
  /// In en, this message translates to:
  /// **'Mon–Sat: 9:00 AM – 6:00 PM'**
  String get contact_office_hours;

  /// No description provided for @contact_info_address_label.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get contact_info_address_label;

  /// No description provided for @contact_info_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contact_info_phone_label;

  /// No description provided for @contact_info_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contact_info_email_label;

  /// No description provided for @contact_info_hours_label.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get contact_info_hours_label;

  /// No description provided for @contact_agent_title.
  ///
  /// In en, this message translates to:
  /// **'Talk to an Agent'**
  String get contact_agent_title;

  /// No description provided for @contact_agent_available.
  ///
  /// In en, this message translates to:
  /// **'Available now'**
  String get contact_agent_available;

  /// No description provided for @contact_card_response_title.
  ///
  /// In en, this message translates to:
  /// **'Fast Response'**
  String get contact_card_response_title;

  /// No description provided for @contact_card_response_desc.
  ///
  /// In en, this message translates to:
  /// **'We reply within 24 hours on business days'**
  String get contact_card_response_desc;

  /// No description provided for @contact_card_licensed_title.
  ///
  /// In en, this message translates to:
  /// **'Licensed Agents'**
  String get contact_card_licensed_title;

  /// No description provided for @contact_card_licensed_desc.
  ///
  /// In en, this message translates to:
  /// **'All our agents are fully certified'**
  String get contact_card_licensed_desc;

  /// No description provided for @contact_card_fees_title.
  ///
  /// In en, this message translates to:
  /// **'No Hidden Fees'**
  String get contact_card_fees_title;

  /// No description provided for @contact_card_fees_desc.
  ///
  /// In en, this message translates to:
  /// **'Transparent pricing, always'**
  String get contact_card_fees_desc;

  /// No description provided for @contact_card_support_title.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get contact_card_support_title;

  /// No description provided for @contact_card_support_desc.
  ///
  /// In en, this message translates to:
  /// **'Round-the-clock assistance available'**
  String get contact_card_support_desc;

  /// No description provided for @contact_faq_title.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get contact_faq_title;

  /// No description provided for @contact_faq_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick answers to common questions.'**
  String get contact_faq_subtitle;

  /// No description provided for @contact_faq_q1.
  ///
  /// In en, this message translates to:
  /// **'How do I schedule a property viewing?'**
  String get contact_faq_q1;

  /// No description provided for @contact_faq_a1.
  ///
  /// In en, this message translates to:
  /// **'You can schedule a viewing by contacting us via the form above or by calling our office. We\'ll arrange a time that works for you.'**
  String get contact_faq_a1;

  /// No description provided for @contact_faq_q2.
  ///
  /// In en, this message translates to:
  /// **'What documents do I need to buy a property?'**
  String get contact_faq_q2;

  /// No description provided for @contact_faq_a2.
  ///
  /// In en, this message translates to:
  /// **'Typically you\'ll need proof of identity, proof of funds or mortgage agreement, and a signed offer letter. Our agents will guide you through the full process.'**
  String get contact_faq_a2;

  /// No description provided for @contact_faq_q3.
  ///
  /// In en, this message translates to:
  /// **'Do you charge a fee for rental inquiries?'**
  String get contact_faq_q3;

  /// No description provided for @contact_faq_a3.
  ///
  /// In en, this message translates to:
  /// **'No. Our rental search service is completely free for tenants. Fees are charged to landlords only.'**
  String get contact_faq_a3;

  /// No description provided for @contact_faq_q4.
  ///
  /// In en, this message translates to:
  /// **'How long does the buying process take?'**
  String get contact_faq_q4;

  /// No description provided for @contact_faq_a4.
  ///
  /// In en, this message translates to:
  /// **'The timeline varies, but from offer acceptance to key handover typically takes 4–8 weeks, depending on financing and legal checks.'**
  String get contact_faq_a4;

  /// No description provided for @contact_faq_q5.
  ///
  /// In en, this message translates to:
  /// **'Can I list my property with Homez?'**
  String get contact_faq_q5;

  /// No description provided for @contact_faq_a5.
  ///
  /// In en, this message translates to:
  /// **'Absolutely. Contact us to discuss listing options. We offer professional photography, pricing advice, and a wide buyer/renter network.'**
  String get contact_faq_a5;

  /// No description provided for @subscription_section_title.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get subscription_section_title;

  /// No description provided for @subscription_section_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Flexible plans for every stage of your business growth.'**
  String get subscription_section_subtitle;

  /// No description provided for @subscription_section_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subscription_section_monthly;

  /// No description provided for @subscription_section_yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get subscription_section_yearly;

  /// No description provided for @subscription_section_most_popular.
  ///
  /// In en, this message translates to:
  /// **'MOST POPULAR'**
  String get subscription_section_most_popular;

  /// No description provided for @subscription_section_per_month.
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get subscription_section_per_month;

  /// No description provided for @subscription_section_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get subscription_section_get_started;

  /// No description provided for @subscription_section_basic_title.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get subscription_section_basic_title;

  /// No description provided for @subscription_section_basic_feature_1.
  ///
  /// In en, this message translates to:
  /// **'5 Projects'**
  String get subscription_section_basic_feature_1;

  /// No description provided for @subscription_section_basic_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Basic Analytics'**
  String get subscription_section_basic_feature_2;

  /// No description provided for @subscription_section_basic_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Community Support'**
  String get subscription_section_basic_feature_3;

  /// No description provided for @subscription_section_business_title.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get subscription_section_business_title;

  /// No description provided for @subscription_section_business_feature_1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Projects'**
  String get subscription_section_business_feature_1;

  /// No description provided for @subscription_section_business_feature_2.
  ///
  /// In en, this message translates to:
  /// **'Advanced AI'**
  String get subscription_section_business_feature_2;

  /// No description provided for @subscription_section_business_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get subscription_section_business_feature_3;

  /// No description provided for @subscription_section_business_feature_4.
  ///
  /// In en, this message translates to:
  /// **'Custom Branding'**
  String get subscription_section_business_feature_4;

  /// No description provided for @subscription_section_pro_title.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get subscription_section_pro_title;

  /// No description provided for @subscription_section_pro_feature_1.
  ///
  /// In en, this message translates to:
  /// **'White Label'**
  String get subscription_section_pro_feature_1;

  /// No description provided for @subscription_section_pro_feature_2.
  ///
  /// In en, this message translates to:
  /// **'API Access'**
  String get subscription_section_pro_feature_2;

  /// No description provided for @subscription_section_pro_feature_3.
  ///
  /// In en, this message translates to:
  /// **'Dedicated Manager'**
  String get subscription_section_pro_feature_3;

  /// No description provided for @subscription_section_pro_feature_4.
  ///
  /// In en, this message translates to:
  /// **'SLA Guarantee'**
  String get subscription_section_pro_feature_4;

  /// No description provided for @footer_description.
  ///
  /// In en, this message translates to:
  /// **'We are a leading real estate agency helping thousands of people find their dream homes. Our expertise spans across major cities globally.'**
  String get footer_description;

  /// No description provided for @footer_newsletter_title.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to our newsletter'**
  String get footer_newsletter_title;

  /// No description provided for @footer_newsletter_hint.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get footer_newsletter_hint;

  /// No description provided for @footer_quick_links.
  ///
  /// In en, this message translates to:
  /// **'Quick Links'**
  String get footer_quick_links;

  /// No description provided for @footer_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get footer_support;

  /// No description provided for @footer_contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get footer_contact_us;

  /// No description provided for @footer_rights_reserved.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Homez. All rights reserved.'**
  String get footer_rights_reserved;

  /// No description provided for @footer_help_center.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get footer_help_center;

  /// No description provided for @footer_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get footer_privacy_policy;

  /// No description provided for @footer_terms_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get footer_terms_service;

  /// No description provided for @footer_faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get footer_faq;

  /// No description provided for @footer_monday_friday.
  ///
  /// In en, this message translates to:
  /// **'Mon - Sat: 9:00 AM - 6:00 PM'**
  String get footer_monday_friday;

  /// No description provided for @page_not_found.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get page_not_found;

  /// No description provided for @the_page_you_are_looking_for_does_not_exist.
  ///
  /// In en, this message translates to:
  /// **'The page you\'re looking for doesn\'t exist or has been moved.'**
  String get the_page_you_are_looking_for_does_not_exist;

  /// No description provided for @go_back_home.
  ///
  /// In en, this message translates to:
  /// **'Go Back Home'**
  String get go_back_home;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'my', 'th', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'my': return AppLocalizationsMy();
    case 'th': return AppLocalizationsTh();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
