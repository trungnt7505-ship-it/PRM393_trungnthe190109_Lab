import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab8b_rest_api/models/city_location.dart';
import 'package:lab8b_rest_api/models/weather_data.dart';
import 'package:lab8b_rest_api/services/weather_service.dart';

void main() {
  group('CityLocation Model Test', () {
    test('CityLocation.fromJson creates correct instance', () {
      final jsonMap = {
        'name': 'Hanoi',
        'latitude': 21.0285,
        'longitude': 105.8542,
        'country': 'Vietnam',
        'admin1': 'Hanoi Capital City'
      };

      final city = CityLocation.fromJson(jsonMap);

      expect(city.name, equals('Hanoi'));
      expect(city.latitude, equals(21.0285));
      expect(city.longitude, equals(105.8542));
      expect(city.country, equals('Vietnam'));
      expect(city.displayName, equals('Hanoi, Hanoi Capital City, Vietnam'));
    });
  });

  group('WeatherData Model Test', () {
    test('WeatherData parses rain and generates correct umbrella advice', () {
      final mockJson = {
        'current': {
          'temperature_2m': 24.5,
          'apparent_temperature': 26.0,
          'relative_humidity_2m': 85,
          'wind_speed_10m': 12.0,
          'precipitation': 2.5,
          'weather_code': 61, // Rain
          'is_day': 1,
        },
        'daily': {
          'time': ['2026-10-12'],
          'weather_code': [61],
          'temperature_2m_max': [28.0],
          'temperature_2m_min': [22.0],
          'precipitation_probability_max': [80],
        }
      };

      final weather = WeatherData.fromJson(mockJson, 'Hanoi', 'Vietnam');

      expect(weather.temperature, equals(24.5));
      expect(weather.conditionText, equals('Rain'));
      expect(weather.needsUmbrella, isTrue);
      expect(weather.umbrellaAdvice, contains('Take an umbrella'));
    });

    test('WeatherData parses clear weather and generates no umbrella advice', () {
      final mockJson = {
        'current': {
          'temperature_2m': 28.0,
          'apparent_temperature': 29.0,
          'relative_humidity_2m': 60,
          'wind_speed_10m': 8.0,
          'precipitation': 0.0,
          'weather_code': 0, // Clear sky
          'is_day': 1,
        },
        'daily': {
          'time': ['2026-10-12'],
          'weather_code': [0],
          'temperature_2m_max': [30.0],
          'temperature_2m_min': [23.0],
          'precipitation_probability_max': [5],
        }
      };

      final weather = WeatherData.fromJson(mockJson, 'Hanoi', 'Vietnam');

      expect(weather.conditionText, equals('Clear Sky'));
      expect(weather.needsUmbrella, isFalse);
      expect(weather.umbrellaAdvice, contains('No umbrella needed'));
    });
  });

  group('WeatherService API Test', () {
    test('fetchWeather handles successful 200 response', () async {
      final mockClient = MockClient((request) async {
        final responseBody = jsonEncode({
          'current': {
            'temperature_2m': 25.0,
            'apparent_temperature': 26.0,
            'relative_humidity_2m': 70,
            'wind_speed_10m': 10.0,
            'precipitation': 0.0,
            'weather_code': 1,
            'is_day': 1,
          },
          'daily': {
            'time': ['2026-10-12'],
            'weather_code': [1],
            'temperature_2m_max': [29.0],
            'temperature_2m_min': [21.0],
            'precipitation_probability_max': [10],
          }
        });
        return http.Response(responseBody, 200);
      });

      final service = WeatherService(client: mockClient);
      final city = WeatherService.defaultCities.first;
      final weather = await service.fetchWeather(city);

      expect(weather.cityName, equals('Hanoi'));
      expect(weather.temperature, equals(25.0));
    });

    test('fetchWeather handles server error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = WeatherService(client: mockClient);
      final city = WeatherService.defaultCities.first;

      expect(() => service.fetchWeather(city), throwsA(isA<Exception>()));
    });
  });
}
