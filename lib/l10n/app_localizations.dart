import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
    Locale('en')
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
  /// **'Enter an address, neighborhood, city, or ZIP code'**
  String get search_hint_enter_address_neighborhood;

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
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
