import 'package:country_search/country_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountrySearch Tests', () {
    testWidgets('CountryPicker displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            CountryLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
          ],
          home: Scaffold(
            body: CountryPicker(
              selectedCountry: null,
              onCountrySelected: _emptyCallback,
            ),
          ),
        ),
      );
      expect(find.byType(CountryPicker), findsOneWidget);
    });

    testWidgets('CountryPicker shows selected country',
        (WidgetTester tester) async {
      const testCountry = Country(
          code: 'US',
          flag: '🇺🇸',
          phoneCode: '+1',
          continent: Continent.northAmerica);
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            CountryLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
          ],
          home: Scaffold(
            body: CountryPicker(
              selectedCountry: testCountry,
              onCountrySelected: _emptyCallback,
            ),
          ),
        ),
      );
      expect(find.text('🇺🇸'), findsOneWidget);
    });

    test('CountryData contains countries', () {
      const countries = CountryData.countries;
      expect(countries, isNotEmpty);
      expect(countries.length, greaterThan(190)); // Should have 200+ countries
    });

    test('CountryData can find country by code', () {
      final country = CountryData.getCountryByCode('US');
      expect(country, isNotNull);
      expect(country!.code, equals('US'));
      expect(country.flag, equals('🇺🇸'));
      expect(country.phoneCode, equals('+1'));
    });

    test('CountryData returns null for invalid code', () {
      final country = CountryData.getCountryByCode('INVALID');
      expect(country, isNull);
    });

    test('CountryData can find country by phone code', () {
      final country = CountryData.getCountryByPhoneCode('+1');
      expect(country, isNotNull);
      expect(country!.phoneCode, equals('+1'));
      // +1 can be US or CA, so we check that it's one of them
      expect(['US', 'CA'], contains(country.code));
    });

    test('CountryData returns null for invalid phone code', () {
      final country = CountryData.getCountryByPhoneCode('+999999');
      expect(country, isNull);
    });

    test('CountryData search works', () {
      final results = CountryData.searchCountries('russia', (code) => 'Russia');
      expect(results, isNotEmpty);
      expect(results.any((country) => country.code == 'RU'), isTrue);
    });

    test('CountryData search is case insensitive', () {
      final results = CountryData.searchCountries('RUSSIA', (code) => 'Russia');
      expect(results, isNotEmpty);
      expect(results.any((country) => country.code == 'RU'), isTrue);
    });

    test('CountryData search by phone code works', () {
      final results = CountryData.searchByPhoneCode('+1');
      expect(results, isNotEmpty);
      expect(results.any((country) => country.code == 'US'), isTrue);
      expect(results.any((country) => country.code == 'CA'), isTrue);
    });

    test('CountryData can get countries by continent', () {
      final europeanCountries =
          CountryData.getCountriesByContinent(Continent.europe);
      expect(europeanCountries, isNotEmpty);
      expect(
          europeanCountries
              .every((country) => country.continent == Continent.europe),
          isTrue);
    });

    test('CountryData can search by continent', () {
      final results = CountryData.searchByContinent('europe');
      expect(results, isNotEmpty);
      expect(
          results.every(
              (country) => country.continent?.name.contains('europe') == true),
          isTrue);
    });

    test('CountryData can get available continents', () {
      final continents = CountryData.getAvailableContinents();
      expect(continents, isNotEmpty);
      expect(continents.contains(Continent.europe), isTrue);
      expect(continents.contains(Continent.asia), isTrue);
      expect(continents.contains(Continent.africa), isTrue);
      expect(continents.contains(Continent.northAmerica), isTrue);
      expect(continents.contains(Continent.southAmerica), isTrue);
      expect(continents.contains(Continent.oceania), isTrue);
    });

    test('CountryData search includes phone codes', () {
      final results = CountryData.searchCountries('+7', (code) => 'Russia');
      expect(results, isNotEmpty);
      expect(results.any((country) => country.code == 'RU'), isTrue);
    });
  });
}

void _emptyCallback(Country _) {}
