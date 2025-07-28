import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'country_localizations_en.dart';
import 'country_localizations_es.dart';
import 'country_localizations_fr.dart';
import 'country_localizations_de.dart';
import 'country_localizations_zh.dart';
import 'country_localizations_ru.dart';
import 'country_localizations_pt.dart';
import 'country_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized country names with an instance of CountryLocalizations
/// returned by `CountryLocalizations.of(context)`.
abstract class CountryLocalizations {
  /// Creates a new CountryLocalizations instance for the specified locale
  /// 
  /// [locale] - The locale string (e.g., 'en', 'es', 'fr')
  CountryLocalizations(String locale);

  // Removed unused localeName field

  /// Get the CountryLocalizations instance for the current context
  static CountryLocalizations of(BuildContext context) {
    return Localizations.of<CountryLocalizations>(
        context, CountryLocalizations)!;
  }

  /// Localizations delegate for CountryLocalizations
  static const LocalizationsDelegate<CountryLocalizations> delegate =
      _CountryLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('zh'),
    Locale('ru'),
    Locale('pt'),
    Locale('ar'),
  ];

  /// Get country name by country code
  ///
  /// Returns the localized name for the given country code
  /// If the country code is not found, returns the code itself
  String getCountryName(String countryCode);

  /// Get all country names as a map
  ///
  /// Returns a map where keys are country codes and values are localized names
  Map<String, String> get allCountryNames;

  /// Get the localized text for "Select Country"
  String get selectCountry;

  /// Get the localized text for "Search country..."
  String get searchCountry;

  /// Get the localized text for "Select your country"
  String get selectYourCountry;

  /// Get continent name by continent enum
  ///
  /// Returns the localized name for the given continent
  String getContinentName(dynamic continent);

  /// Get the localized text for "Popular"
  String get popular;
}

class _CountryLocalizationsDelegate
    extends LocalizationsDelegate<CountryLocalizations> {
  const _CountryLocalizationsDelegate();

  @override
  Future<CountryLocalizations> load(Locale locale) {
    return SynchronousFuture<CountryLocalizations>(
        lookupCountryLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'es',
        'fr',
        'de',
        'zh',
        'ru',
        'pt',
        'ar'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_CountryLocalizationsDelegate old) => false;
}

/// Lookup function to get the appropriate CountryLocalizations instance
///
/// Returns the correct localization class based on the provided locale
/// Falls back to English if the locale is not supported
CountryLocalizations lookupCountryLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return CountryLocalizationsEn();
    case 'es':
      return CountryLocalizationsEs();
    case 'fr':
      return CountryLocalizationsFr();
    case 'de':
      return CountryLocalizationsDe();
    case 'zh':
      return CountryLocalizationsZh();
    case 'ru':
      return CountryLocalizationsRu();
    case 'pt':
      return CountryLocalizationsPt();
    case 'ar':
      return CountryLocalizationsAr();
  }

  // Fallback to English for unsupported locales
  return CountryLocalizationsEn();
}
