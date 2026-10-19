import 'package:flutter/material.dart';
import '../models/city_location.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();

  CityLocation _selectedCity = WeatherService.defaultCities.first; // Default Hanoi
  late Future<WeatherData> _weatherFuture;

  List<CityLocation> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(_selectedCity);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _searchError = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      final results = await _weatherService.searchCities(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
        if (results.isEmpty) {
          _searchError = 'No city found for "$query"';
        }
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _searchError = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _selectCity(CityLocation city) {
    setState(() {
      _selectedCity = city;
      _searchResults = [];
      _searchController.text = city.name;
    });
    FocusScope.of(context).unfocus();
    _loadWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wb_sunny_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              'Weather Companion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Weather',
            onPressed: _loadWeather,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadWeather();
            await _weatherFuture;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input Box
                _buildSearchSection(theme),
                const SizedBox(height: 12),

                // Quick City Preset Chips
                _buildQuickCityChips(),
                const SizedBox(height: 16),

                // Main API FutureBuilder Content
                FutureBuilder<WeatherData>(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    // Loading State
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingWidget();
                    }

                    // Error State
                    if (snapshot.hasError) {
                      return _buildErrorWidget(snapshot.error);
                    }

                    // Empty / Unexpected Response State
                    if (!snapshot.hasData) {
                      return _buildEmptyWidget();
                    }

                    // Success State
                    final weather = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Weather Hero Card
                        _buildCurrentWeatherCard(weather, theme),
                        const SizedBox(height: 20),

                        // Section Header: Purpose-Driven Recommendations
                        Text(
                          '💡 What should you do today?',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Decision Cards
                        _buildDecisionCards(weather, theme),
                        const SizedBox(height: 20),

                        // Key Metrics Section
                        _buildMetricsGrid(weather, theme),
                        const SizedBox(height: 20),

                        // Daily Forecast List
                        if (weather.dailyForecasts.isNotEmpty) ...[
                          Text(
                            '📅 7-Day Forecast',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDailyForecastList(weather.dailyForecasts, theme),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Search Bar Widget ---
  Widget _buildSearchSection(ThemeData theme) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search city (e.g., Tokyo, Paris, Hanoi)...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : null,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHigh,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (value) => _performSearch(value),
          onSubmitted: (value) => _performSearch(value),
        ),
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: LinearProgressIndicator(),
          ),
        if (_searchError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _searchError!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
        if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final city = _searchResults[index];
                return ListTile(
                  leading: const Icon(Icons.location_city_outlined),
                  title: Text(city.name),
                  subtitle: Text(city.displayName),
                  onTap: () => _selectCity(city),
                );
              },
            ),
          ),
      ],
    );
  }

  // --- Quick City Choice Chips ---
  Widget _buildQuickCityChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: WeatherService.defaultCities.map((city) {
          final isSelected = city.name == _selectedCity.name;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(city.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _selectCity(city);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Loading Widget State ---
  Widget _buildLoadingWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Fetching live weather data...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- Error Widget State ---
  Widget _buildErrorWidget(Object? error) {
    final errorMessage = error.toString().replaceAll('Exception: ', '');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, size: 56, color: Colors.red.shade600),
          const SizedBox(height: 12),
          const Text(
            'Unable to Fetch Weather',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade800, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _loadWeather,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  // --- Empty Response State ---
  Widget _buildEmptyWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('No weather data available'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadWeather,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // --- Current Weather Card ---
  Widget _buildCurrentWeatherCard(WeatherData weather, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: weather.isDay
              ? [Colors.blue.shade600, Colors.lightBlue.shade300]
              : [Colors.indigo.shade900, Colors.deepPurple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (weather.isDay ? Colors.blue : Colors.indigo).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 20),
              const SizedBox(width: 4),
              Text(
                '${weather.cityName}, ${weather.country}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(weather.iconData, size: 72, color: Colors.amberAccent),
              const SizedBox(width: 16),
              Text(
                '${weather.temperature.round()}°C',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              weather.conditionText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Feels like ${weather.apparentTemperature.round()}°C',
            style: const TextStyle(fontSize: 14, color: Colors.white80),
          ),
        ],
      ),
    );
  }

  // --- Purpose-Driven Decision Cards ---
  Widget _buildDecisionCards(WeatherData weather, ThemeData theme) {
    return Column(
      children: [
        // Umbrella Advice
        _buildDecisionTile(
          icon: weather.needsUmbrella ? Icons.umbrella : Icons.wb_sunny_outlined,
          iconColor: weather.needsUmbrella ? Colors.blue.shade700 : Colors.amber.shade700,
          backgroundColor: weather.needsUmbrella ? Colors.blue.shade50 : Colors.amber.shade50,
          title: 'Umbrella Needed?',
          subtitle: weather.umbrellaAdvice,
          badgeText: weather.needsUmbrella ? 'YES' : 'NO',
          badgeColor: weather.needsUmbrella ? Colors.blue : Colors.orange,
        ),
        const SizedBox(height: 10),

        // Activity Advice
        _buildDecisionTile(
          icon: Icons.directions_run_rounded,
          iconColor: Colors.green.shade700,
          backgroundColor: Colors.green.shade50,
          title: 'Outdoor Activities',
          subtitle: weather.activityAdvice,
        ),
        const SizedBox(height: 10),

        // Outfit Recommendation
        _buildDecisionTile(
          icon: Icons.checkroom_rounded,
          iconColor: Colors.purple.shade700,
          backgroundColor: Colors.purple.shade50,
          title: 'Outfit Recommendation',
          subtitle: weather.clothingAdvice,
        ),
      ],
    );
  }

  Widget _buildDecisionTile({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    String? badgeText,
    Color? badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    if (badgeText != null && badgeColor != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.black80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Metrics Grid ---
  Widget _buildMetricsGrid(WeatherData weather, ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildMetricItem(
          icon: Icons.water_drop_outlined,
          label: 'Humidity',
          value: '${weather.relativeHumidity}%',
          color: Colors.blue,
          theme: theme,
        ),
        _buildMetricItem(
          icon: Icons.air_rounded,
          label: 'Wind Speed',
          value: '${weather.windSpeed.round()} km/h',
          color: Colors.teal,
          theme: theme,
        ),
        _buildMetricItem(
          icon: Icons.grain_rounded,
          label: 'Precipitation',
          value: '${weather.precipitation} mm',
          color: Colors.indigo,
          theme: theme,
        ),
        _buildMetricItem(
          icon: Icons.device_thermostat,
          label: 'Apparent Temp',
          value: '${weather.apparentTemperature.round()}°C',
          color: Colors.orange,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Daily Forecast List ---
  Widget _buildDailyForecastList(List<DailyForecast> forecasts, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: forecasts.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant,
        ),
        itemBuilder: (context, index) {
          final day = forecasts[index];
          final dayName = index == 0 ? 'Today' : _getDayName(day.date);

          return ListTile(
            leading: Icon(
              day.iconData,
              color: day.precipitationProbability > 40 ? Colors.blue : Colors.orange,
            ),
            title: Text(
              dayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${day.conditionText} • 🌧️ ${day.precipitationProbability}%',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${day.maxTemp.round()}°',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 8),
                Text(
                  '${day.minTemp.round()}°',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}
