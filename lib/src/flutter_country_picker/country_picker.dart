import 'package:flutter/material.dart';
import 'country_data.dart';
import 'localizations/country_localizations.dart';

/// A beautiful and customizable country picker widget
///
/// This widget displays a list of countries with flags and localized names.
/// It supports search functionality, multi-language support, and continent filtering.
class CountryPicker extends StatefulWidget {
  /// Currently selected country
  final Country? selectedCountry;

  /// Callback function called when a country is selected
  final Function(Country) onCountrySelected;

  /// Whether to enable continent filtering functionality
  /// Default is true
  final bool enableContinentFilter;

  /// Whether to enable search functionality
  /// Default is true
  final bool enableSearch;

  /// Whether to show phone codes in country list and selected country
  /// Default is true
  final bool showPhoneCodes;

  /// Whether to show country flags
  /// Default is true
  final bool showFlags;

  /// Whether to auto-detect user's country on initialization
  /// Default is true
  final bool autoDetectCountry;

  const CountryPicker({
    super.key,
    this.selectedCountry,
    required this.onCountrySelected,
    this.enableContinentFilter = true,
    this.enableSearch = true,
    this.showPhoneCodes = true,
    this.showFlags = true,
    this.autoDetectCountry = true,
  });

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  bool _isSearching = false;
  int _updateCounter = 0;
  Continent? _selectedContinent;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _allCountries = CountryData.cachedCountries;
    _filteredCountries = _allCountries;

    // Auto-detect country if enabled and no country is selected
    if (widget.autoDetectCountry && widget.selectedCountry == null) {
      _autoDetectCountry();
    }
  }

  /// Auto-detect user's country and call onCountrySelected
  Future<void> _autoDetectCountry() async {
    try {
      final detectedCountry = await CountryData.autoDetectCountry();

      if (detectedCountry != null && mounted) {
        widget.onCountrySelected(detectedCountry);
      }
    } catch (e) {
      // Silent fail
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update sorting when language changes
    _updateCountriesForLanguage();
  }

  void _updateCountriesForLanguage() {
    final countryLocalizations = CountryLocalizations.of(context);

    // Clear search cache when language changes
    CountryData.clearSearchCache();

    _allCountries =
        CountryData.getSortedCountries(countryLocalizations.getCountryName);
    _filteredCountries = _allCountries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    _filterAndSortCountries(query);
    setState(() {
      _isSearching = query.isNotEmpty;
      _updateCounter++;
    });
  }

  void _filterAndSortCountries(String query) {
    // Apply continent filter first
    List<Country> baseCountries = _allCountries;
    if (widget.enableContinentFilter && _selectedContinent != null) {
      baseCountries = CountryData.getCountriesByContinent(_selectedContinent);
    }

    if (query.isEmpty) {
      _filteredCountries = baseCountries;
      return;
    }

    final countryLocalizations = CountryLocalizations.of(context);
    final results = <Country>[];
    final exactMatches = <Country>[];
    final startsWithMatches = <Country>[];
    final containsMatches = <Country>[];

    for (final country in baseCountries) {
      final countryName =
          countryLocalizations.getCountryName(country.code).toLowerCase();
      final countryCode = country.code.toLowerCase();
      final countryPhoneCode = country.phoneCode.toLowerCase();
      final countryContinent = country.continent?.name.toLowerCase() ?? '';

      // Exact match
      if (countryName == query ||
          countryCode == query ||
          (widget.showPhoneCodes && countryPhoneCode == query) ||
          (widget.enableContinentFilter && countryContinent == query)) {
        exactMatches.add(country);
      }
      // Starts with query
      else if (countryName.startsWith(query) ||
          countryCode.startsWith(query) ||
          (widget.showPhoneCodes && countryPhoneCode.startsWith(query)) ||
          (widget.enableContinentFilter &&
              countryContinent.startsWith(query))) {
        startsWithMatches.add(country);
      }
      // Contains query
      else if (countryName.contains(query) ||
          countryCode.contains(query) ||
          (widget.showPhoneCodes && countryPhoneCode.contains(query)) ||
          (widget.enableContinentFilter && countryContinent.contains(query))) {
        containsMatches.add(country);
      }
    }

    // Combine results in priority order
    results.addAll(exactMatches);
    results.addAll(startsWithMatches);
    results.addAll(containsMatches);

    _filteredCountries = results;
  }

  void _onContinentChanged(
      Continent? continent, void Function(VoidCallback) setModalState) {
    _selectedContinent = continent;
    _filterAndSortCountries(_searchController.text.toLowerCase().trim());
    setModalState(() {
      _updateCounter++;
    });
  }

  Widget _buildCountryList(ScrollController scrollController,
      CountryLocalizations countryLocalizations) {
    // If continent is selected or search is active, show regular list
    if (_selectedContinent != null || _searchController.text.isNotEmpty) {
      return ListView.builder(
        key: ValueKey(
            'country_list_${_filteredCountries.length}_$_updateCounter'),
        controller: scrollController,
        itemCount: _filteredCountries.length,
        // Performance optimizations
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        addSemanticIndexes: false,
        itemBuilder: (context, index) =>
            _buildCountryTile(_filteredCountries[index], countryLocalizations),
      );
    }

    // If "All" is selected and no search, show Popular section + all countries
    final popularCountries = CountryData.getPopularCountries();

    return ListView.builder(
      key: ValueKey(
          'country_list_with_popular_${_filteredCountries.length}_$_updateCounter'),
      controller: scrollController,
      itemCount: popularCountries.length +
          1 +
          1 +
          _filteredCountries.length, // +1 for Popular header, +1 for divider
      // Performance optimizations
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      addSemanticIndexes: false,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Popular header
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              countryLocalizations.popular,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        } else if (index <= popularCountries.length) {
          // Popular countries
          final country = popularCountries[index - 1];
          return _buildCountryTile(country, countryLocalizations);
        } else if (index == popularCountries.length + 1) {
          // Divider
          return const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Divider(color: Colors.white24, height: 1),
          );
        } else {
          // All other countries
          final country =
              _filteredCountries[index - popularCountries.length - 2];
          return _buildCountryTile(country, countryLocalizations);
        }
      },
    );
  }

  Widget _buildCountryTile(
      Country country, CountryLocalizations countryLocalizations) {
    final isSelected = widget.selectedCountry?.code == country.code;
    final countryName = countryLocalizations.getCountryName(country.code);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onCountrySelected(country);
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF699B4B).withAlpha(25) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (widget.showFlags)
                Text(
                  country.flag,
                  style: const TextStyle(fontSize: 24),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      countryName,
                      style: TextStyle(
                        color:
                            isSelected ? const Color(0xFF699B4B) : Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                    ),
                    Text(
                      '${country.code}${widget.showPhoneCodes ? ' (${country.phoneCode})' : ''}',
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF699B4B).withAlpha(180)
                            : Colors.white54,
                      ),
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF699B4B),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinentFilter(void Function(VoidCallback) setModalState) {
    final continents = CountryData.getAvailableContinents();
    final countryLocalizations = CountryLocalizations.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "All" option
          _buildContinentChip(
              null, countryLocalizations.getContinentName(null), setModalState),
          const SizedBox(width: 8),
          // Continent options
          ...continents.map((continent) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildContinentChip(
                    continent,
                    countryLocalizations.getContinentName(continent),
                    setModalState),
              )),
        ],
      ),
    );
  }

  Widget _buildContinentChip(Continent? continent, String label,
      void Function(VoidCallback) setModalState) {
    final isSelected = _selectedContinent == continent;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _onContinentChanged(continent, setModalState);
        }
      },
      backgroundColor: Colors.white.withAlpha((0.05 * 255).toInt()),
      selectedColor: const Color(0xFF699B4B),
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? const Color(0xFF699B4B) : Colors.white24,
      ),
    );
  }

  void _showCountryPicker() {
    final countryLocalizations = CountryLocalizations.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF302E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) => Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3C3A38),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        countryLocalizations.selectCountry,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Search field
                      if (widget.enableSearch) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          onChanged: (value) {
                            final query = value.toLowerCase().trim();
                            _filterAndSortCountries(query);
                            setModalState(() {
                              _isSearching = query.isNotEmpty;
                              _updateCounter++;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: countryLocalizations.searchCountry,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: isRTL
                                ? null
                                : const Icon(Icons.search,
                                    color: Colors.white54),
                            suffixIcon: _isSearching
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.white54),
                                    onPressed: () {
                                      _searchController.clear();
                                      // Reset continent selection when clearing search
                                      if (widget.enableContinentFilter) {
                                        _selectedContinent = null;
                                      }
                                      setModalState(() {
                                        _isSearching = false;
                                        _updateCounter++;
                                        _filteredCountries = _allCountries;
                                      });
                                    },
                                  )
                                : (isRTL
                                    ? const Icon(Icons.search,
                                        color: Colors.white54)
                                    : null),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.white24),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.white54),
                            ),
                            filled: true,
                            fillColor:
                                Colors.white.withAlpha((0.07 * 255).toInt()),
                          ),
                        ),
                      ],
                      // Continent filter
                      if (widget.enableContinentFilter) ...[
                        const SizedBox(height: 16),
                        _buildContinentFilter(setModalState),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child:
                      _buildCountryList(scrollController, countryLocalizations),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final countryLocalizations = CountryLocalizations.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: ValueKey('country_picker_$_updateCounter'),
        onTap: _showCountryPicker,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withAlpha((0.07 * 255).toInt()),
          ),
          child: Row(
            children: [
              if (widget.selectedCountry != null) ...[
                if (widget.showFlags) ...[
                  Text(
                    widget.selectedCountry!.flag,
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: isRTL ? 0 : 12),
                  if (isRTL) const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: isRTL
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        countryLocalizations
                            .getCountryName(widget.selectedCountry!.code),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.selectedCountry!.code,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      if (widget.showPhoneCodes)
                        Text(
                          widget.selectedCountry!.phoneCode,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ] else ...[
                if (widget.showFlags)
                  const Icon(Icons.flag, color: Colors.white54)
                else
                  const Icon(Icons.location_on, color: Colors.white54),
                SizedBox(width: isRTL ? 0 : 12),
                if (isRTL) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    countryLocalizations.selectYourCountry,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  ),
                ),
              ],
              Icon(
                isRTL ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
