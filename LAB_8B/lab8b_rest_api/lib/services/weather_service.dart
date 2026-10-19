import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/city_location.dart';
import '../models/weather_data.dart';

class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _weatherBaseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Default preset cities for quick access
  static final List<CityLocation> defaultCities = [
    CityLocation(
      name: 'Hanoi',
      latitude: 21.0285,
      longitude: 105.8542,
      country: 'Vietnam',
    ),
    CityLocation(
      name: 'Ho Chi Minh City',
      latitude: 10.8231,
      longitude: 106.6297,
      country: 'Vietnam',
    ),
    CityLocation(
      name: 'Da Nang',
      latitude: 16.0544,
      longitude: 108.2022,
      country: 'Vietnam',
    ),
    CityLocation(
      name: 'Tokyo',
      latitude: 35.6762,
      longitude: 139.6503,
      country: 'Japan',
    ),
    CityLocation(
      name: 'London',
      latitude: 51.5074,
      longitude: -0.1278,
      country: 'United Kingdom',
    ),
    CityLocation(
      name: 'New York',
      latitude: 40.7128,
      longitude: -74.0060,
      country: 'United States',
    ),
  ];

  /// Search cities by name using Open-Meteo Geocoding REST API
  Future<List<CityLocation>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse('$_geocodingBaseUrl?name=${Uri.encodeComponent(query)}&count=5&language=en&format=json');

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          final List results = data['results'];
          return results.map((item) => CityLocation.fromJson(item)).toList();
        }
        return [];
      } else {
        throw HttpException('Geocoding API server error (${response.statusCode})');
      }
    } on SocketException {
      throw Exception('No Internet connection. Please check your network and try again.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to search city: $e');
    }
  }

  /// Fetch weather forecast for specific coordinates
  Future<WeatherData> fetchWeather(CityLocation city) async {
    final uri = Uri.parse(
      '$_weatherBaseUrl?latitude=${city.latitude}&longitude=${city.longitude}'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max'
      '&timezone=auto',
    );

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherData.fromJson(data, city.name, city.country);
      } else {
        throw HttpException('Weather API server returned code ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Network request timed out. Please try again.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load weather data: $e');
    }
  }
}
