import 'package:country_picker_enterprise/country_picker_enterprise.dart';
import 'package:country_picker_enterprise/src/flutter_country_picker/localizations/country_localizations_de.dart';
import 'package:country_picker_enterprise/src/flutter_country_picker/localizations/country_localizations_pt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Localizations Tests', () {
    test('English localizations work correctly', () {
      final localizations = CountryLocalizationsEn();

      expect(localizations.getCountryName('US'), equals('United States'));
      expect(localizations.getCountryName('RU'), equals('Russia'));
      expect(localizations.selectCountry, equals('Select Country'));
      expect(localizations.searchCountry, equals('Search country...'));
      expect(localizations.selectYourCountry, equals('Select your country'));
    });

    test('Spanish localizations work correctly', () {
      final localizations = CountryLocalizationsEs();

      expect(localizations.getCountryName('US'), equals('Estados Unidos'));
      expect(localizations.getCountryName('RU'), equals('Rusia'));
      expect(localizations.selectCountry, equals('Seleccionar país'));
      expect(localizations.searchCountry, equals('Buscar país...'));
      expect(localizations.selectYourCountry, equals('Selecciona tu país'));
    });

    test('French localizations work correctly', () {
      final localizations = CountryLocalizationsFr();

      expect(localizations.getCountryName('US'), equals('États-Unis'));
      expect(localizations.getCountryName('RU'), equals('Russie'));
      expect(localizations.selectCountry, equals('Sélectionner un pays'));
      expect(localizations.searchCountry, equals('Rechercher un pays...'));
      expect(
          localizations.selectYourCountry, equals('Sélectionnez votre pays'));
    });

    test('Russian localizations work correctly', () {
      final localizations = CountryLocalizationsRu();

      expect(localizations.getCountryName('US'), equals('США'));
      expect(localizations.getCountryName('RU'), equals('Россия'));
      expect(localizations.selectCountry, equals('Выберите страну'));
      expect(localizations.searchCountry, equals('Поиск страны...'));
      expect(localizations.selectYourCountry, equals('Выберите вашу страну'));
    });

    test('German localizations work correctly', () {
      final localizations = CountryLocalizationsDe();

      expect(localizations.getCountryName('US'), equals('Vereinigte Staaten'));
      expect(localizations.getCountryName('RU'), equals('Russland'));
      expect(localizations.getCountryName('DE'), equals('Deutschland'));
      expect(localizations.selectCountry, equals('Land auswählen'));
      expect(localizations.searchCountry, equals('Land suchen...'));
      expect(localizations.selectYourCountry, equals('Wählen Sie Ihr Land'));
    });

    test('Portuguese localizations work correctly', () {
      final localizations = CountryLocalizationsPt();

      expect(localizations.getCountryName('US'), equals('Estados Unidos'));
      expect(localizations.getCountryName('RU'), equals('Rússia'));
      expect(localizations.getCountryName('PT'), equals('Portugal'));
      expect(localizations.selectCountry, equals('Selecionar país'));
      expect(localizations.searchCountry, equals('Pesquisar país...'));
      expect(localizations.selectYourCountry, equals('Selecione seu país'));
    });

    test('All localizations have same country codes', () {
      final en = CountryLocalizationsEn();
      final es = CountryLocalizationsEs();
      final fr = CountryLocalizationsFr();
      final ru = CountryLocalizationsRu();
      final de = CountryLocalizationsDe();
      final pt = CountryLocalizationsPt();

      expect(en.allCountryNames.keys, equals(es.allCountryNames.keys));
      expect(en.allCountryNames.keys, equals(fr.allCountryNames.keys));
      expect(en.allCountryNames.keys, equals(ru.allCountryNames.keys));
      expect(en.allCountryNames.keys, equals(de.allCountryNames.keys));
      expect(en.allCountryNames.keys, equals(pt.allCountryNames.keys));
    });

    test('Localizations delegate works', () {
      expect(CountryLocalizations.delegate, isNotNull);
      expect(CountryLocalizations.supportedLocales, isNotEmpty);
      expect(CountryLocalizations.supportedLocales.length, equals(8));
    });

    test('Fallback to English for unsupported locale', () {
      // Test with unsupported locale (Japanese)
      const unsupportedLocale = Locale('ja');
      final localizations = lookupCountryLocalizations(unsupportedLocale);

      // Should fallback to English
      expect(localizations, isA<CountryLocalizationsEn>());
      expect(localizations.getCountryName('US'), equals('United States'));
      expect(localizations.selectCountry, equals('Select Country'));
    });
  });
}
