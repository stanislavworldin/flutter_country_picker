import 'dart:convert';
import 'dart:io';

/// Represents a continent
enum Continent {
  europe,
  asia,
  africa,
  northAmerica,
  southAmerica,
  oceania,
  antarctica,
}

/// Extension to get localized continent names
extension ContinentExtension on Continent {
  String get localizedName {
    switch (this) {
      case Continent.europe:
        return 'Europe';
      case Continent.asia:
        return 'Asia';
      case Continent.africa:
        return 'Africa';
      case Continent.northAmerica:
        return 'North America';
      case Continent.southAmerica:
        return 'South America';
      case Continent.oceania:
        return 'Oceania';
      case Continent.antarctica:
        return 'Antarctica';
    }
  }
}

/// Represents a country with its ISO code, flag emoji, phone code, and continent
class Country {
  /// ISO country code (e.g., 'US', 'RU', 'GB')
  final String code;

  /// Country flag emoji (e.g., '🇺🇸', '🇷🇺', '🇬🇧')
  final String flag;

  /// Phone dialing code (e.g., '+1', '+7', '+44')
  final String phoneCode;

  /// Continent where the country is located
  final Continent? continent;

  const Country({
    required this.code,
    required this.flag,
    required this.phoneCode,
    this.continent,
  });

  @override
  String toString() =>
      '$flag $code ($phoneCode)${continent != null ? ' - ${continent!.name}' : ''}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          flag == other.flag &&
          phoneCode == other.phoneCode &&
          continent == other.continent;

  @override
  int get hashCode =>
      code.hashCode ^ flag.hashCode ^ phoneCode.hashCode ^ continent.hashCode;
}

/// Utility class for managing country data and operations
class CountryData {
  /// List of popular countries (most commonly used)
  static const List<String> popularCountryCodes = [
    'US', // United States
    'GB', // United Kingdom
    'DE', // Germany
    'FR', // France
    'CA', // Canada
    'AU', // Australia
    'JP', // Japan
    'CN', // China
  ];

  // Cached data for performance optimization
  static List<Country>? _cachedCountries;
  static Map<String, Country>? _countryByCodeCache;
  static Map<String, List<Country>>? _countriesByContinentCache;
  static Map<String, List<Country>>? _searchIndexCache;

  /// Complete list of all supported countries with phone codes and continents
  static const List<Country> countries = [
    Country(
        code: 'AC',
        flag: '🇦🇨',
        phoneCode: '+247',
        continent: Continent.africa),
    Country(
        code: 'AD',
        flag: '🇦🇩',
        phoneCode: '+376',
        continent: Continent.europe),
    Country(
        code: 'AE', flag: '🇦🇪', phoneCode: '+971', continent: Continent.asia),
    Country(
        code: 'AF', flag: '🇦🇫', phoneCode: '+93', continent: Continent.asia),
    Country(
        code: 'AG',
        flag: '🇦🇬',
        phoneCode: '+1268',
        continent: Continent.northAmerica),
    Country(
        code: 'AI',
        flag: '🇦🇮',
        phoneCode: '+1264',
        continent: Continent.northAmerica),
    Country(
        code: 'AL',
        flag: '🇦🇱',
        phoneCode: '+355',
        continent: Continent.europe),
    Country(
        code: 'AM', flag: '🇦🇲', phoneCode: '+374', continent: Continent.asia),
    Country(
        code: 'AO',
        flag: '🇦🇴',
        phoneCode: '+244',
        continent: Continent.africa),
    Country(
        code: 'AQ',
        flag: '🇦🇶',
        phoneCode: '+672',
        continent: Continent.antarctica),
    Country(
        code: 'AR',
        flag: '🇦🇷',
        phoneCode: '+54',
        continent: Continent.southAmerica),
    Country(
        code: 'AS',
        flag: '🇦🇸',
        phoneCode: '+1684',
        continent: Continent.oceania),
    Country(
        code: 'AT',
        flag: '🇦🇹',
        phoneCode: '+43',
        continent: Continent.europe),
    Country(
        code: 'AU',
        flag: '🇦🇺',
        phoneCode: '+61',
        continent: Continent.oceania),
    Country(
        code: 'AW',
        flag: '🇦🇼',
        phoneCode: '+297',
        continent: Continent.northAmerica),
    Country(
        code: 'AX',
        flag: '🇦🇽',
        phoneCode: '+358',
        continent: Continent.europe),
    Country(
        code: 'AZ', flag: '🇦🇿', phoneCode: '+994', continent: Continent.asia),
    Country(
        code: 'BA',
        flag: '🇧🇦',
        phoneCode: '+387',
        continent: Continent.europe),
    Country(
        code: 'BB',
        flag: '🇧🇧',
        phoneCode: '+1246',
        continent: Continent.northAmerica),
    Country(
        code: 'BD', flag: '🇧🇩', phoneCode: '+880', continent: Continent.asia),
    Country(
        code: 'BE',
        flag: '🇧🇪',
        phoneCode: '+32',
        continent: Continent.europe),
    Country(
        code: 'BG',
        flag: '🇧🇬',
        phoneCode: '+359',
        continent: Continent.europe),
    Country(
        code: 'BF',
        flag: '🇧🇫',
        phoneCode: '+226',
        continent: Continent.africa),
    Country(
        code: 'BH', flag: '🇧🇭', phoneCode: '+973', continent: Continent.asia),
    Country(
        code: 'BI',
        flag: '🇧🇮',
        phoneCode: '+257',
        continent: Continent.africa),
    Country(
        code: 'BJ',
        flag: '🇧🇯',
        phoneCode: '+229',
        continent: Continent.africa),
    Country(
        code: 'BL',
        flag: '🇧🇱',
        phoneCode: '+590',
        continent: Continent.northAmerica),
    Country(
        code: 'BM',
        flag: '🇧🇲',
        phoneCode: '+1441',
        continent: Continent.northAmerica),
    Country(
        code: 'BN', flag: '🇧🇳', phoneCode: '+673', continent: Continent.asia),
    Country(
        code: 'BO',
        flag: '🇧🇴',
        phoneCode: '+591',
        continent: Continent.southAmerica),
    Country(
        code: 'BR',
        flag: '🇧🇷',
        phoneCode: '+55',
        continent: Continent.southAmerica),
    Country(
        code: 'BS',
        flag: '🇧🇸',
        phoneCode: '+1242',
        continent: Continent.northAmerica),
    Country(
        code: 'BT', flag: '🇧🇹', phoneCode: '+975', continent: Continent.asia),
    Country(
        code: 'BW',
        flag: '🇧🇼',
        phoneCode: '+267',
        continent: Continent.africa),
    Country(
        code: 'BY',
        flag: '🇧🇾',
        phoneCode: '+375',
        continent: Continent.europe),
    Country(
        code: 'BZ',
        flag: '🇧🇿',
        phoneCode: '+501',
        continent: Continent.northAmerica),
    Country(
        code: 'CA',
        flag: '🇨🇦',
        phoneCode: '+1',
        continent: Continent.northAmerica),
    Country(
        code: 'CC', flag: '🇨🇨', phoneCode: '+61', continent: Continent.asia),
    Country(
        code: 'CD',
        flag: '🇨🇩',
        phoneCode: '+243',
        continent: Continent.africa),
    Country(
        code: 'CF',
        flag: '🇨🇫',
        phoneCode: '+236',
        continent: Continent.africa),
    Country(
        code: 'CG',
        flag: '🇨🇬',
        phoneCode: '+242',
        continent: Continent.africa),
    Country(
        code: 'CH',
        flag: '🇨🇭',
        phoneCode: '+41',
        continent: Continent.europe),
    Country(
        code: 'CI',
        flag: '🇨🇮',
        phoneCode: '+225',
        continent: Continent.africa),
    Country(
        code: 'CK',
        flag: '🇨🇰',
        phoneCode: '+682',
        continent: Continent.oceania),
    Country(
        code: 'CL',
        flag: '🇨🇱',
        phoneCode: '+56',
        continent: Continent.southAmerica),
    Country(
        code: 'CM',
        flag: '🇨🇲',
        phoneCode: '+237',
        continent: Continent.africa),
    Country(
        code: 'CN', flag: '🇨🇳', phoneCode: '+86', continent: Continent.asia),
    Country(
        code: 'CO',
        flag: '🇨🇴',
        phoneCode: '+57',
        continent: Continent.southAmerica),
    Country(
        code: 'CR',
        flag: '🇨🇷',
        phoneCode: '+506',
        continent: Continent.northAmerica),
    Country(
        code: 'CU',
        flag: '🇨🇺',
        phoneCode: '+53',
        continent: Continent.northAmerica),
    Country(
        code: 'CV',
        flag: '🇨🇻',
        phoneCode: '+238',
        continent: Continent.africa),
    Country(
        code: 'CW',
        flag: '🇨🇼',
        phoneCode: '+599',
        continent: Continent.northAmerica),
    Country(
        code: 'CX', flag: '🇨🇽', phoneCode: '+61', continent: Continent.asia),
    Country(
        code: 'CY', flag: '🇨🇾', phoneCode: '+357', continent: Continent.asia),
    Country(
        code: 'CZ',
        flag: '🇨🇿',
        phoneCode: '+420',
        continent: Continent.europe),
    Country(
        code: 'DE',
        flag: '🇩🇪',
        phoneCode: '+49',
        continent: Continent.europe),
    Country(
        code: 'DJ',
        flag: '🇩🇯',
        phoneCode: '+253',
        continent: Continent.africa),
    Country(
        code: 'DK',
        flag: '🇩🇰',
        phoneCode: '+45',
        continent: Continent.europe),
    Country(
        code: 'DM',
        flag: '🇩🇲',
        phoneCode: '+1767',
        continent: Continent.northAmerica),
    Country(
        code: 'DO',
        flag: '🇩🇴',
        phoneCode: '+1809',
        continent: Continent.northAmerica),
    Country(
        code: 'EC',
        flag: '🇪🇨',
        phoneCode: '+593',
        continent: Continent.southAmerica),
    Country(
        code: 'EE',
        flag: '🇪🇪',
        phoneCode: '+372',
        continent: Continent.europe),
    Country(
        code: 'EG',
        flag: '🇪🇬',
        phoneCode: '+20',
        continent: Continent.africa),
    Country(
        code: 'EH',
        flag: '🇪🇭',
        phoneCode: '+212',
        continent: Continent.africa),
    Country(
        code: 'ER',
        flag: '🇪🇷',
        phoneCode: '+291',
        continent: Continent.africa),
    Country(
        code: 'ES',
        flag: '🇪🇸',
        phoneCode: '+34',
        continent: Continent.europe),
    Country(
        code: 'ET',
        flag: '🇪🇹',
        phoneCode: '+251',
        continent: Continent.africa),
    Country(
        code: 'FI',
        flag: '🇫🇮',
        phoneCode: '+358',
        continent: Continent.europe),
    Country(
        code: 'FK',
        flag: '🇫🇰',
        phoneCode: '+500',
        continent: Continent.southAmerica),
    Country(
        code: 'FJ',
        flag: '🇫🇯',
        phoneCode: '+679',
        continent: Continent.oceania),
    Country(
        code: 'FM',
        flag: '🇫🇲',
        phoneCode: '+691',
        continent: Continent.oceania),
    Country(
        code: 'FO',
        flag: '🇫🇴',
        phoneCode: '+298',
        continent: Continent.europe),
    Country(
        code: 'FR',
        flag: '🇫🇷',
        phoneCode: '+33',
        continent: Continent.europe),
    Country(
        code: 'GA',
        flag: '🇬🇦',
        phoneCode: '+241',
        continent: Continent.africa),
    Country(
        code: 'GB',
        flag: '🇬🇧',
        phoneCode: '+44',
        continent: Continent.europe),
    Country(
        code: 'GD',
        flag: '🇬🇩',
        phoneCode: '+1473',
        continent: Continent.northAmerica),
    Country(
        code: 'GE', flag: '🇬🇪', phoneCode: '+995', continent: Continent.asia),
    Country(
        code: 'GF',
        flag: '🇬🇫',
        phoneCode: '+594',
        continent: Continent.southAmerica),
    Country(
        code: 'GG',
        flag: '🇬🇬',
        phoneCode: '+44',
        continent: Continent.europe),
    Country(
        code: 'GH',
        flag: '🇬🇭',
        phoneCode: '+233',
        continent: Continent.africa),
    Country(
        code: 'GI',
        flag: '🇬🇮',
        phoneCode: '+350',
        continent: Continent.europe),
    Country(
        code: 'GL',
        flag: '🇬🇱',
        phoneCode: '+299',
        continent: Continent.northAmerica),
    Country(
        code: 'GM',
        flag: '🇬🇲',
        phoneCode: '+220',
        continent: Continent.africa),
    Country(
        code: 'GN',
        flag: '🇬🇳',
        phoneCode: '+224',
        continent: Continent.africa),
    Country(
        code: 'GP',
        flag: '🇬🇵',
        phoneCode: '+590',
        continent: Continent.northAmerica),
    Country(
        code: 'GQ',
        flag: '🇬🇶',
        phoneCode: '+240',
        continent: Continent.africa),
    Country(
        code: 'GR',
        flag: '🇬🇷',
        phoneCode: '+30',
        continent: Continent.europe),
    Country(
        code: 'GS',
        flag: '🇬🇸',
        phoneCode: '+500',
        continent: Continent.antarctica),
    Country(
        code: 'GT',
        flag: '🇬🇹',
        phoneCode: '+502',
        continent: Continent.northAmerica),
    Country(
        code: 'GU',
        flag: '🇬🇺',
        phoneCode: '+1671',
        continent: Continent.oceania),
    Country(
        code: 'GW',
        flag: '🇬🇼',
        phoneCode: '+245',
        continent: Continent.africa),
    Country(
        code: 'GY',
        flag: '🇬🇾',
        phoneCode: '+592',
        continent: Continent.southAmerica),
    Country(
        code: 'HK', flag: '🇭🇰', phoneCode: '+852', continent: Continent.asia),
    Country(
        code: 'HM',
        flag: '🇭🇲',
        phoneCode: '+672',
        continent: Continent.antarctica),
    Country(
        code: 'HN',
        flag: '🇭🇳',
        phoneCode: '+504',
        continent: Continent.northAmerica),
    Country(
        code: 'HR',
        flag: '🇭🇷',
        phoneCode: '+385',
        continent: Continent.europe),
    Country(
        code: 'HT',
        flag: '🇭🇹',
        phoneCode: '+509',
        continent: Continent.northAmerica),
    Country(
        code: 'HU',
        flag: '🇭🇺',
        phoneCode: '+36',
        continent: Continent.europe),
    Country(
        code: 'ID', flag: '🇮🇩', phoneCode: '+62', continent: Continent.asia),
    Country(
        code: 'IE',
        flag: '🇮🇪',
        phoneCode: '+353',
        continent: Continent.europe),
    Country(
        code: 'IL', flag: '🇮🇱', phoneCode: '+972', continent: Continent.asia),
    Country(
        code: 'IM',
        flag: '🇮🇲',
        phoneCode: '+44',
        continent: Continent.europe),
    Country(
        code: 'IN', flag: '🇮🇳', phoneCode: '+91', continent: Continent.asia),
    Country(
        code: 'IO', flag: '🇮🇴', phoneCode: '+672', continent: Continent.asia),
    Country(
        code: 'IQ', flag: '🇮🇶', phoneCode: '+964', continent: Continent.asia),
    Country(
        code: 'IR', flag: '🇮🇷', phoneCode: '+98', continent: Continent.asia),
    Country(
        code: 'IS',
        flag: '🇮🇸',
        phoneCode: '+354',
        continent: Continent.europe),
    Country(
        code: 'IT',
        flag: '🇮🇹',
        phoneCode: '+39',
        continent: Continent.europe),
    Country(
        code: 'JE',
        flag: '🇯🇪',
        phoneCode: '+44',
        continent: Continent.europe),
    Country(
        code: 'JM',
        flag: '🇯🇲',
        phoneCode: '+1876',
        continent: Continent.northAmerica),
    Country(
        code: 'JO', flag: '🇯🇴', phoneCode: '+962', continent: Continent.asia),
    Country(
        code: 'JP', flag: '🇯🇵', phoneCode: '+81', continent: Continent.asia),
    Country(
        code: 'KE',
        flag: '🇰🇪',
        phoneCode: '+254',
        continent: Continent.africa),
    Country(
        code: 'KG', flag: '🇰🇬', phoneCode: '+996', continent: Continent.asia),
    Country(
        code: 'KH', flag: '🇰🇭', phoneCode: '+855', continent: Continent.asia),
    Country(
        code: 'KI',
        flag: '🇰🇮',
        phoneCode: '+686',
        continent: Continent.oceania),
    Country(
        code: 'KM',
        flag: '🇰🇲',
        phoneCode: '+269',
        continent: Continent.africa),
    Country(
        code: 'KN',
        flag: '🇰🇳',
        phoneCode: '+1869',
        continent: Continent.northAmerica),
    Country(
        code: 'KP', flag: '🇰🇵', phoneCode: '+850', continent: Continent.asia),
    Country(
        code: 'KR', flag: '🇰🇷', phoneCode: '+82', continent: Continent.asia),
    Country(
        code: 'KW', flag: '🇰🇼', phoneCode: '+965', continent: Continent.asia),
    Country(
        code: 'KY',
        flag: '🇰🇾',
        phoneCode: '+1345',
        continent: Continent.northAmerica),
    Country(
        code: 'KZ', flag: '🇰🇿', phoneCode: '+7', continent: Continent.asia),
    Country(
        code: 'LA', flag: '🇱🇦', phoneCode: '+856', continent: Continent.asia),
    Country(
        code: 'LB', flag: '🇱🇧', phoneCode: '+961', continent: Continent.asia),
    Country(
        code: 'LC',
        flag: '🇱🇨',
        phoneCode: '+1758',
        continent: Continent.northAmerica),
    Country(
        code: 'LI',
        flag: '🇱🇮',
        phoneCode: '+423',
        continent: Continent.europe),
    Country(
        code: 'LK', flag: '🇱🇰', phoneCode: '+94', continent: Continent.asia),
    Country(
        code: 'LR',
        flag: '🇱🇷',
        phoneCode: '+231',
        continent: Continent.africa),
    Country(
        code: 'LS',
        flag: '🇱🇸',
        phoneCode: '+266',
        continent: Continent.africa),
    Country(
        code: 'LT',
        flag: '🇱🇹',
        phoneCode: '+370',
        continent: Continent.europe),
    Country(
        code: 'LU',
        flag: '🇱🇺',
        phoneCode: '+352',
        continent: Continent.europe),
    Country(
        code: 'LV',
        flag: '🇱🇻',
        phoneCode: '+371',
        continent: Continent.europe),
    Country(
        code: 'LY',
        flag: '🇱🇾',
        phoneCode: '+218',
        continent: Continent.africa),
    Country(
        code: 'MA',
        flag: '🇲🇦',
        phoneCode: '+212',
        continent: Continent.africa),
    Country(
        code: 'MC',
        flag: '🇲🇨',
        phoneCode: '+377',
        continent: Continent.europe),
    Country(
        code: 'MD',
        flag: '🇲🇩',
        phoneCode: '+373',
        continent: Continent.europe),
    Country(
        code: 'ME',
        flag: '🇲🇪',
        phoneCode: '+382',
        continent: Continent.europe),
    Country(
        code: 'MG',
        flag: '🇲🇬',
        phoneCode: '+261',
        continent: Continent.africa),
    Country(
        code: 'MH',
        flag: '🇲🇭',
        phoneCode: '+692',
        continent: Continent.oceania),
    Country(
        code: 'MK',
        flag: '🇲🇰',
        phoneCode: '+389',
        continent: Continent.europe),
    Country(
        code: 'ML',
        flag: '🇲🇱',
        phoneCode: '+223',
        continent: Continent.africa),
    Country(
        code: 'MM', flag: '🇲🇲', phoneCode: '+95', continent: Continent.asia),
    Country(
        code: 'MN', flag: '🇲🇳', phoneCode: '+976', continent: Continent.asia),
    Country(
        code: 'MO', flag: '🇲🇴', phoneCode: '+853', continent: Continent.asia),
    Country(
        code: 'MP',
        flag: '🇲🇵',
        phoneCode: '+1670',
        continent: Continent.oceania),
    Country(
        code: 'MR',
        flag: '🇲🇷',
        phoneCode: '+222',
        continent: Continent.africa),
    Country(
        code: 'MS',
        flag: '🇲🇸',
        phoneCode: '+1664',
        continent: Continent.northAmerica),
    Country(
        code: 'MT',
        flag: '🇲🇹',
        phoneCode: '+356',
        continent: Continent.europe),
    Country(
        code: 'MV', flag: '🇲🇻', phoneCode: '+960', continent: Continent.asia),
    Country(
        code: 'MW',
        flag: '🇲🇼',
        phoneCode: '+265',
        continent: Continent.africa),
    Country(
        code: 'MX',
        flag: '🇲🇽',
        phoneCode: '+52',
        continent: Continent.northAmerica),
    Country(
        code: 'MY', flag: '🇲🇾', phoneCode: '+60', continent: Continent.asia),
    Country(
        code: 'MZ',
        flag: '🇲🇿',
        phoneCode: '+258',
        continent: Continent.africa),
    Country(
        code: 'NA',
        flag: '🇳🇦',
        phoneCode: '+264',
        continent: Continent.africa),
    Country(
        code: 'NC',
        flag: '🇳🇨',
        phoneCode: '+687',
        continent: Continent.oceania),
    Country(
        code: 'NE',
        flag: '🇳🇪',
        phoneCode: '+227',
        continent: Continent.africa),
    Country(
        code: 'NF',
        flag: '🇳🇫',
        phoneCode: '+672',
        continent: Continent.oceania),
    Country(
        code: 'NG',
        flag: '🇳🇬',
        phoneCode: '+234',
        continent: Continent.africa),
    Country(
        code: 'NI',
        flag: '🇳🇮',
        phoneCode: '+505',
        continent: Continent.northAmerica),
    Country(
        code: 'NL',
        flag: '🇳🇱',
        phoneCode: '+31',
        continent: Continent.europe),
    Country(
        code: 'NO',
        flag: '🇳🇴',
        phoneCode: '+47',
        continent: Continent.europe),
    Country(
        code: 'NP', flag: '🇳🇵', phoneCode: '+977', continent: Continent.asia),
    Country(
        code: 'NR',
        flag: '🇳🇷',
        phoneCode: '+674',
        continent: Continent.oceania),
    Country(
        code: 'NU',
        flag: '🇳🇺',
        phoneCode: '+683',
        continent: Continent.oceania),
    Country(
        code: 'NZ',
        flag: '🇳🇿',
        phoneCode: '+64',
        continent: Continent.oceania),
    Country(
        code: 'OM', flag: '🇴🇲', phoneCode: '+968', continent: Continent.asia),
    Country(
        code: 'PA',
        flag: '🇵🇦',
        phoneCode: '+507',
        continent: Continent.northAmerica),
    Country(
        code: 'PE',
        flag: '🇵🇪',
        phoneCode: '+51',
        continent: Continent.southAmerica),
    Country(
        code: 'PF',
        flag: '🇵🇫',
        phoneCode: '+689',
        continent: Continent.oceania),
    Country(
        code: 'PG',
        flag: '🇵🇬',
        phoneCode: '+675',
        continent: Continent.oceania),
    Country(
        code: 'PH', flag: '🇵🇭', phoneCode: '+63', continent: Continent.asia),
    Country(
        code: 'PK', flag: '🇵🇰', phoneCode: '+92', continent: Continent.asia),
    Country(
        code: 'PL',
        flag: '🇵🇱',
        phoneCode: '+48',
        continent: Continent.europe),
    Country(
        code: 'PM',
        flag: '🇵🇲',
        phoneCode: '+508',
        continent: Continent.northAmerica),
    Country(
        code: 'PN',
        flag: '🇵🇳',
        phoneCode: '+64',
        continent: Continent.oceania),
    Country(
        code: 'PR',
        flag: '🇵🇷',
        phoneCode: '+1787',
        continent: Continent.northAmerica),
    Country(
        code: 'PS', flag: '🇵🇸', phoneCode: '+970', continent: Continent.asia),
    Country(
        code: 'PT',
        flag: '🇵🇹',
        phoneCode: '+351',
        continent: Continent.europe),
    Country(
        code: 'PW',
        flag: '🇵🇼',
        phoneCode: '+680',
        continent: Continent.oceania),
    Country(
        code: 'PY',
        flag: '🇵🇾',
        phoneCode: '+595',
        continent: Continent.southAmerica),
    Country(
        code: 'QA', flag: '🇶🇦', phoneCode: '+974', continent: Continent.asia),
    Country(
        code: 'RE',
        flag: '🇷🇪',
        phoneCode: '+262',
        continent: Continent.africa),
    Country(
        code: 'RO',
        flag: '🇷🇴',
        phoneCode: '+40',
        continent: Continent.europe),
    Country(
        code: 'RS',
        flag: '🇷🇸',
        phoneCode: '+381',
        continent: Continent.europe),
    Country(
        code: 'RU', flag: '🇷🇺', phoneCode: '+7', continent: Continent.europe),
    Country(
        code: 'RW',
        flag: '🇷🇼',
        phoneCode: '+250',
        continent: Continent.africa),
    Country(
        code: 'SA', flag: '🇸🇦', phoneCode: '+966', continent: Continent.asia),
    Country(
        code: 'SB',
        flag: '🇸🇧',
        phoneCode: '+677',
        continent: Continent.oceania),
    Country(
        code: 'SC',
        flag: '🇸🇨',
        phoneCode: '+248',
        continent: Continent.africa),
    Country(
        code: 'SD',
        flag: '🇸🇩',
        phoneCode: '+249',
        continent: Continent.africa),
    Country(
        code: 'SE',
        flag: '🇸🇪',
        phoneCode: '+46',
        continent: Continent.europe),
    Country(
        code: 'SG', flag: '🇸🇬', phoneCode: '+65', continent: Continent.asia),
    Country(
        code: 'SH',
        flag: '🇸🇭',
        phoneCode: '+290',
        continent: Continent.africa),
    Country(
        code: 'SI',
        flag: '🇸🇮',
        phoneCode: '+386',
        continent: Continent.europe),
    Country(
        code: 'SJ',
        flag: '🇸🇯',
        phoneCode: '+47',
        continent: Continent.europe),
    Country(
        code: 'SK',
        flag: '🇸🇰',
        phoneCode: '+421',
        continent: Continent.europe),
    Country(
        code: 'SL',
        flag: '🇸🇱',
        phoneCode: '+232',
        continent: Continent.africa),
    Country(
        code: 'SM',
        flag: '🇸🇲',
        phoneCode: '+378',
        continent: Continent.europe),
    Country(
        code: 'SO',
        flag: '🇸🇴',
        phoneCode: '+252',
        continent: Continent.africa),
    Country(
        code: 'SR',
        flag: '🇸🇷',
        phoneCode: '+597',
        continent: Continent.southAmerica),
    Country(
        code: 'SS',
        flag: '🇸🇸',
        phoneCode: '+211',
        continent: Continent.africa),
    Country(
        code: 'ST',
        flag: '🇸🇹',
        phoneCode: '+239',
        continent: Continent.africa),
    Country(
        code: 'SV',
        flag: '🇸🇻',
        phoneCode: '+503',
        continent: Continent.northAmerica),
    Country(
        code: 'SX',
        flag: '🇸🇽',
        phoneCode: '+1721',
        continent: Continent.northAmerica),
    Country(
        code: 'SY', flag: '🇸🇾', phoneCode: '+963', continent: Continent.asia),
    Country(
        code: 'SZ',
        flag: '🇸🇿',
        phoneCode: '+268',
        continent: Continent.africa),
    Country(
        code: 'TA',
        flag: '🇹🇦',
        phoneCode: '+290',
        continent: Continent.antarctica),
    Country(
        code: 'TC',
        flag: '🇹🇨',
        phoneCode: '+1649',
        continent: Continent.northAmerica),
    Country(
        code: 'TD',
        flag: '🇹🇩',
        phoneCode: '+235',
        continent: Continent.africa),
    Country(
        code: 'TF',
        flag: '🇹🇫',
        phoneCode: '+262',
        continent: Continent.antarctica),
    Country(
        code: 'TG',
        flag: '🇹🇬',
        phoneCode: '+228',
        continent: Continent.africa),
    Country(
        code: 'TH', flag: '🇹🇭', phoneCode: '+66', continent: Continent.asia),
    Country(
        code: 'TJ', flag: '🇹🇯', phoneCode: '+992', continent: Continent.asia),
    Country(
        code: 'TK',
        flag: '🇹🇰',
        phoneCode: '+690',
        continent: Continent.oceania),
    Country(
        code: 'TL', flag: '🇹🇱', phoneCode: '+670', continent: Continent.asia),
    Country(
        code: 'TM', flag: '🇹🇲', phoneCode: '+993', continent: Continent.asia),
    Country(
        code: 'TN',
        flag: '🇹🇳',
        phoneCode: '+216',
        continent: Continent.africa),
    Country(
        code: 'TO',
        flag: '🇹🇴',
        phoneCode: '+676',
        continent: Continent.oceania),
    Country(
        code: 'TR', flag: '🇹🇷', phoneCode: '+90', continent: Continent.asia),
    Country(
        code: 'TT',
        flag: '🇹🇹',
        phoneCode: '+1868',
        continent: Continent.northAmerica),
    Country(
        code: 'TV',
        flag: '🇹🇻',
        phoneCode: '+688',
        continent: Continent.oceania),
    Country(
        code: 'TW', flag: '🇹🇼', phoneCode: '+886', continent: Continent.asia),
    Country(
        code: 'TZ',
        flag: '🇹🇿',
        phoneCode: '+255',
        continent: Continent.africa),
    Country(
        code: 'UA',
        flag: '🇺🇦',
        phoneCode: '+380',
        continent: Continent.europe),
    Country(
        code: 'UG',
        flag: '🇺🇬',
        phoneCode: '+256',
        continent: Continent.africa),
    Country(
        code: 'UM',
        flag: '🇺🇲',
        phoneCode: '+1',
        continent: Continent.oceania),
    Country(
        code: 'US',
        flag: '🇺🇸',
        phoneCode: '+1',
        continent: Continent.northAmerica),
    Country(
        code: 'UY',
        flag: '🇺🇾',
        phoneCode: '+598',
        continent: Continent.southAmerica),
    Country(
        code: 'UZ', flag: '🇺🇿', phoneCode: '+998', continent: Continent.asia),
    Country(
        code: 'VA',
        flag: '🇻🇦',
        phoneCode: '+379',
        continent: Continent.europe),
    Country(
        code: 'VC',
        flag: '🇻🇨',
        phoneCode: '+1784',
        continent: Continent.northAmerica),
    Country(
        code: 'VE',
        flag: '🇻🇪',
        phoneCode: '+58',
        continent: Continent.southAmerica),
    Country(
        code: 'VG',
        flag: '🇻🇬',
        phoneCode: '+1284',
        continent: Continent.northAmerica),
    Country(
        code: 'VI',
        flag: '🇻🇮',
        phoneCode: '+1340',
        continent: Continent.northAmerica),
    Country(
        code: 'VN', flag: '🇻🇳', phoneCode: '+84', continent: Continent.asia),
    Country(
        code: 'VU',
        flag: '🇻🇺',
        phoneCode: '+678',
        continent: Continent.oceania),
    Country(
        code: 'WS',
        flag: '🇼🇸',
        phoneCode: '+685',
        continent: Continent.oceania),
    Country(
        code: 'WF',
        flag: '🇼🇫',
        phoneCode: '+681',
        continent: Continent.oceania),
    Country(
        code: 'YE', flag: '🇾🇪', phoneCode: '+967', continent: Continent.asia),
    Country(
        code: 'YT',
        flag: '🇾🇹',
        phoneCode: '+262',
        continent: Continent.africa),
    Country(
        code: 'ZA',
        flag: '🇿🇦',
        phoneCode: '+27',
        continent: Continent.africa),
    Country(
        code: 'ZM',
        flag: '🇿🇲',
        phoneCode: '+260',
        continent: Continent.africa),
    Country(
        code: 'ZW',
        flag: '🇿🇾',
        phoneCode: '+263',
        continent: Continent.africa),
    Country(
        code: 'XK',
        flag: '🇽🇰',
        phoneCode: '+383',
        continent: Continent.europe),
  ];

  /// Initialize cache for better performance
  ///
  /// This method should be called once to initialize all caches
  static void _initializeCache() {
    if (_cachedCountries != null) return; // Already initialized

    _cachedCountries = countries;
    _countryByCodeCache = <String, Country>{};
    _countriesByContinentCache = <String, List<Country>>{};
    _searchIndexCache = <String, List<Country>>{};

    // Build country by code cache
    for (final country in countries) {
      _countryByCodeCache![country.code] = country;
    }

    // Build countries by continent cache
    for (final country in countries) {
      if (country.continent != null) {
        final continentKey = country.continent!.name;
        _countriesByContinentCache!
            .putIfAbsent(continentKey, () => [])
            .add(country);
      }
    }
  }

  /// Get cached countries list
  ///
  /// Returns cached list of all countries
  static List<Country> get cachedCountries {
    _initializeCache();
    return _cachedCountries!;
  }

  /// Get a country by its ISO code
  ///
  /// Returns null if the country code is not found
  static Country? getCountryByCode(String code) {
    _initializeCache();
    return _countryByCodeCache![code.toUpperCase()];
  }

  /// Get a country by its phone code
  ///
  /// Returns null if the phone code is not found
  static Country? getCountryByPhoneCode(String phoneCode) {
    try {
      return countries.firstWhere((country) => country.phoneCode == phoneCode);
    } catch (e) {
      return null;
    }
  }

  /// Get a sorted list of countries based on localized names
  ///
  /// [getCountryName] should be a function that returns the localized name for a country code
  static List<Country> getSortedCountries(
      String Function(String) getCountryName) {
    final sortedCountries = List<Country>.from(cachedCountries);

    sortedCountries.sort((a, b) {
      final nameA = getCountryName(a.code).toLowerCase();
      final nameB = getCountryName(b.code).toLowerCase();
      return nameA.compareTo(nameB);
    });

    return sortedCountries;
  }

  /// Search countries by name, code, or phone code
  ///
  /// [query] is the search term
  /// [getCountryName] should be a function that returns the localized name for a country code
  static List<Country> searchCountries(
      String query, String Function(String) getCountryName) {
    if (query.isEmpty) return cachedCountries;

    final lowercaseQuery = query.toLowerCase().trim();

    // Check cache for this query and language
    final languageCode = _getLanguageCode(getCountryName);
    final cacheKey = '${languageCode}_$lowercaseQuery';

    if (_searchIndexCache!.containsKey(cacheKey)) {
      return _searchIndexCache![cacheKey]!;
    }

    final results = <Country>[];
    final exactMatches = <Country>[];
    final startsWithMatches = <Country>[];
    final containsMatches = <Country>[];

    for (final country in cachedCountries) {
      final countryName = getCountryName(country.code).toLowerCase();
      final countryCode = country.code.toLowerCase();
      final countryPhoneCode = country.phoneCode.toLowerCase();

      // Exact match
      if (countryName == lowercaseQuery ||
          countryCode == lowercaseQuery ||
          countryPhoneCode == lowercaseQuery) {
        exactMatches.add(country);
      }
      // Starts with query
      else if (countryName.startsWith(lowercaseQuery) ||
          countryCode.startsWith(lowercaseQuery) ||
          countryPhoneCode.startsWith(lowercaseQuery)) {
        startsWithMatches.add(country);
      }
      // Contains query
      else if (countryName.contains(lowercaseQuery) ||
          countryCode.contains(lowercaseQuery) ||
          countryPhoneCode.contains(lowercaseQuery)) {
        containsMatches.add(country);
      }
    }

    // Combine results in priority order
    results.addAll(exactMatches);
    results.addAll(startsWithMatches);
    results.addAll(containsMatches);

    // Cache the result
    _searchIndexCache![cacheKey] = results;

    return results;
  }

  /// Get language code from getCountryName function for caching
  static String _getLanguageCode(String Function(String) getCountryName) {
    // Try to detect language by testing a known country
    final testName = getCountryName('US');
    if (testName == 'United States') return 'en';
    if (testName == 'Estados Unidos') return 'es';
    if (testName == 'États-Unis') return 'fr';
    if (testName == 'Vereinigte Staaten') return 'de';
    if (testName == '中国') return 'zh';
    if (testName == 'США') return 'ru';
    if (testName == 'Estados Unidos') return 'pt';
    if (testName == 'الولايات المتحدة') return 'ar';
    return 'en'; // Default fallback
  }

  /// Clear search cache when language changes
  ///
  /// Call this method when the app language changes
  static void clearSearchCache() {
    _searchIndexCache?.clear();
  }

  /// Search countries by phone code only
  ///
  /// [phoneCode] is the phone code to search for (e.g., '+1', '+7')
  static List<Country> searchByPhoneCode(String phoneCode) {
    if (phoneCode.isEmpty) return countries;

    final results = countries
        .where((country) => country.phoneCode.contains(phoneCode))
        .toList();

    return results;
  }

  /// Get countries by continent
  ///
  /// [continent] is the continent to filter by
  /// Returns empty list if continent is null
  static List<Country> getCountriesByContinent(Continent? continent) {
    if (continent == null) return [];

    _initializeCache();
    return _countriesByContinentCache![continent.name] ?? [];
  }

  /// Search countries by continent name
  ///
  /// [query] is the continent name to search for (e.g., 'europe', 'asia')
  static List<Country> searchByContinent(String query) {
    if (query.isEmpty) return countries;

    final lowercaseQuery = query.toLowerCase().trim();
    final results = countries
        .where((country) =>
            country.continent != null &&
            country.continent!.name.contains(lowercaseQuery))
        .toList();

    return results;
  }

  /// Get popular countries
  ///
  /// Returns a list of popular countries sorted alphabetically
  static List<Country> getPopularCountries() {
    final popularCountries = <Country>[];

    for (final code in popularCountryCodes) {
      final country = getCountryByCode(code);
      if (country != null) {
        popularCountries.add(country);
      }
    }

    // Sort alphabetically by country name (will be sorted properly when localized)
    return popularCountries;
  }

  /// Get all available continents
  ///
  /// Returns a list of all continents that have countries, sorted by population (descending)
  static List<Continent> getAvailableContinents() {
    // Static list sorted by population (descending)
    const continents = [
      Continent.asia, // 4.6B
      Continent.africa, // 1.4B
      Continent.northAmerica, // 600M
      Continent.southAmerica, // 400M
      Continent.europe, // 750M
      Continent.oceania, // 45M
      Continent.antarctica, // 0M
    ];

    return continents;
  }

  /// Get country by IP address (requires internet connection)
  ///
  /// This method uses a free IP geolocation service to determine the user's country
  /// Returns null if unable to determine country
  static Future<Country?> getCountryByIP() async {
    try {
      // Using a free IP geolocation service
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('http://ip-api.com/json'));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final data = jsonDecode(responseBody) as Map<String, dynamic>;

      final countryCode = data['countryCode'] as String?;
      if (countryCode != null) {
        final country = getCountryByCode(countryCode);
        return country;
      }
    } catch (e) {
      // Silent fail
    }
    return null;
  }

  /// Get country by device locale
  ///
  /// Uses the device's locale to determine the most likely country
  /// Returns null if unable to determine country
  static Country? getCountryByLocale(String locale) {
    try {
      // Extract country code from locale (e.g., "en_US" -> "US")
      final parts = locale.split('_');
      if (parts.length > 1) {
        final countryCode = parts[1].toUpperCase();
        final country = getCountryByCode(countryCode);
        if (country != null) {
          return country;
        }
      }

      // Fallback: try to match language to common countries
      final languageCode = locale.split('_')[0].toLowerCase();
      final languageToCountry = {
        'en': 'US', // English -> US
        'ru': 'RU', // Russian -> Russia
        'de': 'DE', // German -> Germany
        'fr': 'FR', // French -> France
        'es': 'ES', // Spanish -> Spain
        'pt': 'PT', // Portuguese -> Portugal
        'zh': 'CN', // Chinese -> China
        'ja': 'JP', // Japanese -> Japan
        'ko': 'KR', // Korean -> South Korea
        'ar': 'SA', // Arabic -> Saudi Arabia
        'hi': 'IN', // Hindi -> India
        'it': 'IT', // Italian -> Italy
        'nl': 'NL', // Dutch -> Netherlands
        'pl': 'PL', // Polish -> Poland
        'tr': 'TR', // Turkish -> Turkey
        'sv': 'SE', // Swedish -> Sweden
        'da': 'DK', // Danish -> Denmark
        'no': 'NO', // Norwegian -> Norway
        'fi': 'FI', // Finnish -> Finland
        'cs': 'CZ', // Czech -> Czech Republic
        'sk': 'SK', // Slovak -> Slovakia
        'hu': 'HU', // Hungarian -> Hungary
        'ro': 'RO', // Romanian -> Romania
        'bg': 'BG', // Bulgarian -> Bulgaria
        'hr': 'HR', // Croatian -> Croatia
        'sl': 'SI', // Slovenian -> Slovenia
        'et': 'EE', // Estonian -> Estonia
        'lv': 'LV', // Latvian -> Latvia
        'lt': 'LT', // Lithuanian -> Lithuania
        'mt': 'MT', // Maltese -> Malta
        'el': 'GR', // Greek -> Greece
        'he': 'IL', // Hebrew -> Israel
        'th': 'TH', // Thai -> Thailand
        'vi': 'VN', // Vietnamese -> Vietnam
        'id': 'ID', // Indonesian -> Indonesia
        'ms': 'MY', // Malay -> Malaysia
        'tl': 'PH', // Tagalog -> Philippines
        'bn': 'BD', // Bengali -> Bangladesh
        'ur': 'PK', // Urdu -> Pakistan
        'fa': 'IR', // Persian -> Iran
        'uk': 'UA', // Ukrainian -> Ukraine
        'be': 'BY', // Belarusian -> Belarus
        'kk': 'KZ', // Kazakh -> Kazakhstan
        'ky': 'KG', // Kyrgyz -> Kyrgyzstan
        'uz': 'UZ', // Uzbek -> Uzbekistan
        'tg': 'TJ', // Tajik -> Tajikistan
        'mn': 'MN', // Mongolian -> Mongolia
        'ka': 'GE', // Georgian -> Georgia
        'hy': 'AM', // Armenian -> Armenia
        'az': 'AZ', // Azerbaijani -> Azerbaijan
        'mk': 'MK', // Macedonian -> North Macedonia
        'sq': 'AL', // Albanian -> Albania
        'bs': 'BA', // Bosnian -> Bosnia and Herzegovina
        'sr': 'RS', // Serbian -> Serbia
        'me': 'ME', // Montenegrin -> Montenegro
        'is': 'IS', // Icelandic -> Iceland
        'ga': 'IE', // Irish -> Ireland
        'cy': 'GB', // Welsh -> United Kingdom
        'gd': 'GB', // Scottish Gaelic -> United Kingdom
        'br': 'FR', // Breton -> France
        'oc': 'FR', // Occitan -> France
        'ca': 'ES', // Catalan -> Spain
        'eu': 'ES', // Basque -> Spain
        'gl': 'ES', // Galician -> Spain
        'ast': 'ES', // Asturian -> Spain
        'an': 'ES', // Aragonese -> Spain
        'ext': 'ES', // Extremaduran -> Spain
        'fur': 'IT', // Friulian -> Italy
        'lld': 'IT', // Ladin -> Italy
        'vec': 'IT', // Venetian -> Italy
        'lmo': 'IT', // Lombard -> Italy
        'pms': 'IT', // Piedmontese -> Italy
        'sc': 'IT', // Sardinian -> Italy
        'scn': 'IT', // Sicilian -> Italy
        'rm': 'CH', // Romansh -> Switzerland
        'gsw': 'CH', // Swiss German -> Switzerland
        'wae': 'CH', // Walser -> Switzerland
        'bar': 'AT', // Bavarian -> Austria
        'cim': 'IT', // Cimbrian -> Italy
        'sma': 'SE', // Southern Sami -> Sweden
        'smj': 'SE', // Lule Sami -> Sweden
        'sme': 'NO', // Northern Sami -> Norway
        'smn': 'FI', // Inari Sami -> Finland
        'sms': 'FI', // Skolt Sami -> Finland
        'sju': 'SE', // Ume Sami -> Sweden
        'fit': 'FI', // Tornedalen Finnish -> Finland
        'vep': 'RU', // Veps -> Russia
        'vot': 'RU', // Votic -> Russia
        'izh': 'RU', // Ingrian -> Russia
        'krl': 'RU', // Karelian -> Russia
        'lud': 'RU', // Ludian -> Russia
        'vro': 'EE', // Võro -> Estonia
        'fkv': 'FI', // Kven Finnish -> Finland
        'liv': 'LV', // Livonian -> Latvia
      };

      final countryCode = languageToCountry[languageCode];
      if (countryCode != null) {
        final country = getCountryByCode(countryCode);
        if (country != null) {
          return country;
        }
      }
    } catch (e) {
      // Silent fail
    }
    return null;
  }

  /// Auto-detect country using multiple methods
  ///
  /// Tries IP detection first, then falls back to locale detection
  /// Returns null if unable to determine country
  static Future<Country?> autoDetectCountry() async {
    // Try IP detection first
    final countryByIP = await getCountryByIP();
    if (countryByIP != null) {
      return countryByIP;
    }

    // Fallback to locale detection
    final countryByLocale = getCountryByLocale(Platform.localeName);
    if (countryByLocale != null) {
      return countryByLocale;
    }

    return null;
  }
}
