# Changelog

## [2.5.0] - 2025-01-28

### Added
- **Arabic Language Support**: Added complete Arabic localization
- **Arabic Translations**: All country names, UI text, and continent names translated to Arabic
- **Arabic Locale**: Added `Locale('ar')` support for Arabic language
- **Arabic UI**: Interface displays in Arabic when locale is set to Arabic

### Features
- Complete Arabic localization with 246 country names translated
- Arabic UI text: "اختر البلد", "البحث عن بلد...", "اختر بلدك"
- Arabic continent names: "أفريقيا", "آسيا", "أوروبا", "أمريكا", "أوقيانوسيا", "أنتاركتيكا"
- Seamless integration with existing localization system
- Maintains all existing functionality in Arabic

### Technical Details
- Added `CountryLocalizationsAr` class for Arabic translations
- Updated `CountryLocalizations` to support Arabic locale
- Added Arabic to supported locales list
- All translations follow Arabic language conventions

## [2.4.0] - 2025-01-28

### Added
- **Chinese Language Support**: Added complete Chinese (Simplified) localization
- **Chinese Translations**: All country names, UI text, and continent names translated to Chinese
- **Chinese Locale**: Added `Locale('zh')` support for Chinese language
- **Chinese UI**: Interface displays in Chinese when locale is set to Chinese

### Features
- Complete Chinese localization with 246 country names translated
- Chinese UI text: "选择国家", "搜索国家...", "选择您的国家"
- Chinese continent names: "亚洲", "欧洲", "非洲", "美洲", "大洋洲", "南极洲"
- Seamless integration with existing localization system
- Maintains all existing functionality in Chinese

### Technical Details
- Added `CountryLocalizationsZh` class for Chinese translations
- Updated `CountryLocalizations` to support Chinese locale
- Added Chinese to supported locales list
- All translations follow Chinese language conventions

## [2.3.1] - 2025-01-28

### Fixed
- **Debug Messages**: Removed all debug print statements from production code for cleaner pub.dev release
- **Screenshot Links**: Fixed README screenshot URLs to use correct GitHub branch paths
- **Code Quality**: Removed unused imports and improved code cleanliness
- **Production Ready**: Code is now fully production-ready without debug information

### Technical Improvements
- Removed 49 debug print statements from core library files
- Fixed screenshot links in README.md to prevent 404 errors
- Removed unused `foundation.dart` import
- Improved error handling with silent fails instead of debug prints

## [2.3.0] - 2025-01-28

### Added
- **Auto Country Detection**: Added automatic country detection functionality
- **IP Geolocation**: Detect country by IP address using free geolocation service
- **Locale Detection**: Detect country by device locale and language preferences
- **Smart Fallback**: Multiple detection methods with intelligent fallback
- **Auto-Detection Parameter**: Added `autoDetectCountry` parameter to CountryPicker

### Features
- Automatic country detection on widget initialization
- IP-based geolocation using ip-api.com service
- Locale-based detection with language-to-country mapping
- Comprehensive language support (100+ languages mapped to countries)
- Debug logging for detection process
- Graceful fallback when detection fails

### API Changes
- Added `autoDetectCountry` parameter to CountryPicker (default: false)
- Added `CountryData.getCountryByIP()` method for IP-based detection
- Added `CountryData.getCountryByLocale()` method for locale-based detection
- Added `CountryData.autoDetectCountry()` method for combined detection
- Auto-detection only triggers when no country is already selected

### Technical Details
- Uses free IP geolocation service (ip-api.com)
- Supports 100+ language-to-country mappings
- Handles network errors gracefully
- Provides detailed debug logging
- Maintains backward compatibility

## [2.2.0] - 2025-01-28

### Added
- **Feature Customization**: Added comprehensive feature control parameters to CountryPicker
- **Search Control**: Added `enableSearch` parameter to disable search functionality
- **Phone Code Control**: Added `showPhoneCodes` parameter to hide phone codes
- **Flag Control**: Added `showFlags` parameter to hide country flags
- **Unified Control**: All features can now be disabled via widget parameters

### Features
- Disable search field completely with `enableSearch: false`
- Hide phone codes in list and selection with `showPhoneCodes: false`
- Hide country flags with `showFlags: false`
- Consistent parameter-based feature control
- Maintains all existing functionality when parameters are true (default)

### API Changes
- Added `enableSearch` parameter to CountryPicker (default: true)
- Added `showPhoneCodes` parameter to CountryPicker (default: true)
- Added `showFlags` parameter to CountryPicker (default: true)
- Search algorithm respects `showPhoneCodes` and `enableContinentFilter` settings
- UI elements conditionally rendered based on parameter values

## [2.1.0] - 2025-01-28

### Added
- **Continent Filtering**: Added continent-based country filtering with population-based sorting
- **Continent Enum**: Added Continent enum with all 6 continents (Europe, Asia, Africa, Americas, Oceania, Antarctica)
- **Continent Data**: All 246 countries now include continent information
- **Localized Continent Names**: Continent names are translated to all supported languages
- **Continent UI**: Added continent filter chips in the country picker interface
- **Continent UI**: Added continent filter chips in the country picker interface
- **Population-based Sorting**: Continents sorted by population (Asia → Africa → Americas → Europe → Oceania → Antarctica)

### Features
- Filter countries by continent with intuitive UI
- Continent names displayed in user's language
- Smooth UI updates when switching continents
- Customizable continent filtering (can be disabled)
- Continent filtering can be disabled
- Population-based continent ordering for better UX

### API Changes
- Added `enableContinentFilter` parameter to CountryPicker (default: true)

- Added `continent` field to Country model
- Added `Continent` enum with 6 continents
- Added `getCountriesByContinent()` method to CountryData
- Added `searchByContinent()` method to CountryData
- Added `getAvailableContinents()` method to CountryData
- Added `getContinentName()` method to all localizations

## [2.0.4] - 2025-01-28

### Added
- **Screenshots Assets**: Added screenshots as assets in pubspec.yaml for proper README display
- **Image Support**: Improved image handling for pub.dev documentation

## [2.0.3] - 2025-01-28

### Changed
- **Topic Update**: Changed topic from `phone-codes` to `codes` for better discoverability

## [2.0.2] - 2025-01-28

### Fixed
- **Screenshots Display**: Fixed screenshot URLs in README to use GitHub raw links for proper display on pub.dev
- **README Images**: Updated image paths from relative to absolute URLs

## [2.0.1] - 2025-01-28

### Added
- **Updated CHANGELOG**: Added comprehensive changelog for version 2.0.0 features
- **Better Documentation**: Improved changelog structure and readability

## [2.0.0] - 2025-01-28

### Added
- **Phone Codes**: Added phone codes for all 245+ countries
- **Enhanced Search**: Smart search now includes phone code matching
- **UI Improvements**: Phone codes displayed in country list and selection
- **Updated Topics**: Added phone-codes topic for better discoverability
- **Improved Description**: Updated package description to highlight new features

### Changed
- **Major Version Bump**: Version 2.0.0 due to significant new functionality
- **Country Model**: Added phoneCode field to Country class
- **Search Algorithm**: Enhanced to search by country name, code, and phone code
- **UI Display**: Country picker now shows phone codes in subtitle and selection

### Features
- Search by phone code (e.g., "+1" for US/Canada, "+44" for UK)
- Phone codes displayed in country list: "US (+1)", "GB (+44)"
- Phone code shown when country is selected
- Maintains backward compatibility with existing API

## [1.1.0] - 2025-01-28

### Added
- Added Portuguese language support with complete translations
- Added 22 missing countries to match UN member states and territories
- Added new countries: AL, AX, BA, BN, BT, FO, GG, GI, IM, JE, KY, LK, ME, MK, MN, MV, NP, RS, SJ, TL, UM, XK
- Total countries increased from 224 to 246

### Fixed
- Updated all language files with translations for new countries
- Improved country coverage to match international standards

## [1.0.8] - 2025-01-28

### Added
- Added German language support with complete translations
- Added German country names for all 224 countries
- Added German UI text translations (select, search, labels)

### Fixed
- Removed deprecated 'authors' field from pubspec.yaml
- Fixed const declaration in localization tests
- All static analysis issues resolved - 100% clean code

## [1.0.7] - 2025-01-28

### Added
- Added fallback to English for unsupported locales
- Added comprehensive testing documentation to README
- Added optimization guide for removing unused languages

### Fixed
- Fixed locale handling - now gracefully falls back to English instead of crashing

### Improved
- Better error handling for unsupported languages
- More detailed README with testing and optimization sections

## [1.0.6] - 2025-01-28

### Added
- Added 7 missing important countries: MX, DK, BG, BY, EE, MT, TJ
- Total countries increased from 217 to 224

### Fixed
- Fixed pubspec.yaml structure for screenshots
- Removed unused intl dependency

## [1.0.5] - 2025-01-28

### Added
- Added screenshots support for pub.dev
- Added beautiful screenshots showing search and multi-language functionality

## [1.0.4] - 2025-01-28

### Added
- Added comprehensive test coverage for widget and localization functionality
- Added analysis_options.yaml for better code quality
- Added topics to pubspec.yaml for better discoverability
- Improved package documentation and examples

### Fixed
- Fixed all static analysis issues - now 100% clean code
- Improved test coverage with proper const usage
- Fixed formatting issues in all source files
- Resolved all linter warnings and info messages

## [1.0.3] - 2025-01-28

### Fixed
- Fixed all static analysis issues - now 100% clean code
- Improved test coverage with proper const usage
- Fixed formatting issues in all source files
- Resolved all linter warnings and info messages

### Added
- Comprehensive test coverage for widget and localization functionality
- Added analysis_options.yaml for better code quality
- Added topics to pubspec.yaml for better discoverability
- Improved package documentation and examples

## [1.0.2] - 2025-01-28

### Added
- Comprehensive test coverage for widget and localization functionality
- Added analysis_options.yaml for better code quality
- Added topics to pubspec.yaml for better discoverability
- Improved package documentation and examples

### Fixed
- Fixed library name to match package name (country_search.dart)
- Updated all import paths in documentation and examples
- Resolved package validation warnings

## [1.0.1] - 2025-01-28

### Fixed
- Fixed library name to match package name (country_search.dart)
- Updated all import paths in documentation and examples
- Resolved package validation warnings

## [1.0.0] - 2024-01-XX

### Added
- Initial release of Flutter Country Picker
- Beautiful and customizable country picker widget
- Support for 200+ countries with flags and ISO codes
- Multi-language support (English, Spanish, French, Russian)
- Smart search functionality
- Dark theme with modern design
- Responsive design for all screen sizes
- Comprehensive API documentation
- MIT License

### Features
- Country selection with flag emojis
- Localized country names
- Search by country name or code
- Customizable labels and hints
- Modal bottom sheet picker
- Keyboard navigation support
- Accessibility support 