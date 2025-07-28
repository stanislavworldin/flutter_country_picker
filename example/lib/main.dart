import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_picker_enterprise/country_picker_enterprise.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _currentLocale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
    debugPrint('Language changed to: ${locale.languageCode}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Picker Demo',
      theme: ThemeData.dark(),
      locale: _currentLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        CountryLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('pt'),
        Locale('ru'),
        Locale('zh'),
      ],
      home: MyHomePage(
        onLanguageChanged: _changeLanguage,
        currentLocale: _currentLocale,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  final Locale currentLocale;

  const MyHomePage({
    super.key,
    required this.onLanguageChanged,
    required this.currentLocale,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Country? selectedCountry;

  String _getLanguageName(String code) {
    switch (code) {
      case 'ar':
        return '🇸🇦 العربية';
      case 'de':
        return '🇩🇪 Deutsch';
      case 'en':
        return '🇺🇸 English';
      case 'es':
        return '🇪🇸 Español';
      case 'fr':
        return '🇫🇷 Français';
      case 'pt':
        return '🇵🇹 Português';
      case 'ru':
        return '🇷🇺 Русский';
      case 'zh':
        return '🇨🇳 中文';
      default:
        return '🇺🇸 English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Picker Demo'),
        actions: [
          PopupMenuButton<Locale>(
            onSelected: widget.onLanguageChanged,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: Locale('ar'),
                child: Text('🇸🇦 العربية'),
              ),
              const PopupMenuItem(
                value: Locale('de'),
                child: Text('🇩🇪 Deutsch'),
              ),
              const PopupMenuItem(
                value: Locale('en'),
                child: Text('🇺🇸 English'),
              ),
              const PopupMenuItem(
                value: Locale('es'),
                child: Text('🇪🇸 Español'),
              ),
              const PopupMenuItem(
                value: Locale('fr'),
                child: Text('🇫🇷 Français'),
              ),
              const PopupMenuItem(
                value: Locale('pt'),
                child: Text('🇵🇹 Português'),
              ),
              const PopupMenuItem(
                value: Locale('ru'),
                child: Text('🇷🇺 Русский'),
              ),
              const PopupMenuItem(
                value: Locale('zh'),
                child: Text('🇨🇳 中文'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language),
                  const SizedBox(width: 4),
                  Text(_getLanguageName(widget.currentLocale.languageCode)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    'Current Language: ${_getLanguageName(widget.currentLocale.languageCode)}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Country picker section
            const Text(
              'Select your country:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CountryPicker(
              selectedCountry: selectedCountry,
              onCountrySelected: (Country country) {
                setState(() {
                  selectedCountry = country;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Selected: ${country.flag} ${country.code} (${country.phoneCode})'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              // Customization options (all enabled by default)
              enableSearch: true,
              showPhoneCodes: true,
              showFlags: true,
              enableContinentFilter: true,
              // Auto-detect user's country on initialization
              autoDetectCountry: true,
            ),
            const SizedBox(height: 32),

            // Selected country display
            if (selectedCountry != null) ...[
              const Text(
                'Selected Country:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    Text(
                      selectedCountry!.flag,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedCountry!.code,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            CountryLocalizations.of(context)
                                .getCountryName(selectedCountry!.code),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            'Phone: ${selectedCountry!.phoneCode}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),

            // Features section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.05 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Features:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('• 246 countries with flags and phone codes'),
                  const Text('• Multi-language support (8 languages)'),
                  const Text('• Smart search by name, code, or phone number'),
                  const Text(
                      '• Continent filtering with population-based sorting'),
                  const Text('• Popular countries section for quick access'),
                  const Text(
                      '• Feature customization (disable unwanted features)'),
                  const Text('• Auto country detection (IP + locale)'),
                  const Text('• RTL support for Arabic language'),
                  const Text('• Cross-platform support'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
