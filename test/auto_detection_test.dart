import 'dart:io';
import 'package:country_search/country_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auto Detection Tests', () {
    testWidgets('Auto Detection работает при инициализации',
        (WidgetTester tester) async {
      debugPrint('🧪 Тестируем Auto Detection при инициализации');

      Country? selectedCountry;
      bool onCountrySelectedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            CountryLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          home: Scaffold(
            body: CountryPicker(
              selectedCountry: selectedCountry,
              onCountrySelected: (Country country) {
                debugPrint('🎯 Auto Detection: выбрана страна ${country.code}');
                selectedCountry = country;
                onCountrySelectedCalled = true;
              },
              autoDetectCountry: true,
            ),
          ),
        ),
      );

      // Ждем немного для асинхронной операции
      await tester.pumpAndSettle();

      // Проверяем, что callback был вызван (если страна была определена)
      expect(onCountrySelectedCalled, isTrue);
      expect(selectedCountry, isNotNull);

      debugPrint(
          '✅ Auto Detection: страна ${selectedCountry?.code} определена автоматически');
    });

    testWidgets('Auto Detection не работает когда страна уже выбрана',
        (WidgetTester tester) async {
      debugPrint('🧪 Тестируем Auto Detection когда страна уже выбрана');

      final initialCountry = CountryData.getCountryByCode('US')!;
      Country? selectedCountry = initialCountry;
      bool onCountrySelectedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            CountryLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          home: Scaffold(
            body: CountryPicker(
              selectedCountry: selectedCountry,
              onCountrySelected: (Country country) {
                debugPrint('🎯 Callback вызван: ${country.code}');
                selectedCountry = country;
                onCountrySelectedCalled = true;
              },
              autoDetectCountry: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем, что callback НЕ был вызван, так как страна уже была выбрана
      expect(onCountrySelectedCalled, isFalse);
      expect(selectedCountry?.code, equals('US'));

      debugPrint(
          '✅ Auto Detection: callback не вызван, так как страна уже была выбрана');
    });

    testWidgets('Auto Detection не работает когда отключен',
        (WidgetTester tester) async {
      debugPrint('🧪 Тестируем Auto Detection когда отключен');

      Country? selectedCountry;
      bool onCountrySelectedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            CountryLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          home: Scaffold(
            body: CountryPicker(
              selectedCountry: selectedCountry,
              onCountrySelected: (Country country) {
                debugPrint('🎯 Callback вызван: ${country.code}');
                selectedCountry = country;
                onCountrySelectedCalled = true;
              },
              autoDetectCountry: false, // Отключен
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем, что callback НЕ был вызван
      expect(onCountrySelectedCalled, isFalse);
      expect(selectedCountry, isNull);

      debugPrint(
          '✅ Auto Detection: callback не вызван, так как функция отключена');
    });

    test('getCountryByIP возвращает страну при успешном запросе', () async {
      debugPrint('🧪 Тестируем getCountryByIP');

      final country = await CountryData.getCountryByIP();

      // Может вернуть null если нет интернета или сервис недоступен
      if (country != null) {
        debugPrint('✅ getCountryByIP: определена страна ${country.code}');
        expect(country.code, isNotEmpty);
        expect(country.flag, isNotEmpty);
        expect(country.phoneCode, isNotEmpty);
      } else {
        debugPrint(
            'ℹ️ getCountryByIP: страна не определена (возможно нет интернета)');
      }
    });

    test('getCountryByLocale работает с различными локалями', () {
      debugPrint('🧪 Тестируем getCountryByLocale');

      // Тестируем различные локали
      final testCases = [
        'en_US', // Английский США
        'ru_RU', // Русский Россия
        'de_DE', // Немецкий Германия
        'fr_FR', // Французский Франция
        'es_ES', // Испанский Испания
        'zh_CN', // Китайский Китай
        'ja_JP', // Японский Япония
        'ko_KR', // Корейский Южная Корея
      ];

      for (final locale in testCases) {
        final country = CountryData.getCountryByLocale(locale);
        if (country != null) {
          debugPrint('✅ getCountryByLocale($locale): ${country.code}');
          expect(country.code, isNotEmpty);
          expect(country.flag, isNotEmpty);
          expect(country.phoneCode, isNotEmpty);
        } else {
          debugPrint('❌ getCountryByLocale($locale): страна не найдена');
        }
      }
    });

    test('getCountryByLocale работает с языковыми кодами', () {
      debugPrint('🧪 Тестируем getCountryByLocale с языковыми кодами');

      final testCases = [
        'en', // Английский -> США
        'ru', // Русский -> Россия
        'de', // Немецкий -> Германия
        'fr', // Французский -> Франция
        'es', // Испанский -> Испания
        'zh', // Китайский -> Китай
        'ja', // Японский -> Япония
        'ko', // Корейский -> Южная Корея
      ];

      for (final languageCode in testCases) {
        final country = CountryData.getCountryByLocale(languageCode);
        if (country != null) {
          debugPrint('✅ getCountryByLocale($languageCode): ${country.code}');
          expect(country.code, isNotEmpty);
          expect(country.flag, isNotEmpty);
          expect(country.phoneCode, isNotEmpty);
        } else {
          debugPrint('❌ getCountryByLocale($languageCode): страна не найдена');
        }
      }
    });

    test('autoDetectCountry использует IP и Locale', () async {
      debugPrint('🧪 Тестируем autoDetectCountry');

      final country = await CountryData.autoDetectCountry();

      if (country != null) {
        debugPrint('✅ autoDetectCountry: определена страна ${country.code}');
        expect(country.code, isNotEmpty);
        expect(country.flag, isNotEmpty);
        expect(country.phoneCode, isNotEmpty);
      } else {
        debugPrint('ℹ️ autoDetectCountry: страна не определена');
      }
    });

    test('Platform.localeName возвращает корректный формат', () {
      debugPrint('🧪 Тестируем Platform.localeName');

      final locale = Platform.localeName;
      debugPrint('✅ Platform.localeName: $locale');

      expect(locale, isNotEmpty);
      expect(locale, contains('_'));
    });
  });
}
