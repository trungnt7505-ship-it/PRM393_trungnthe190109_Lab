// ============================================================================
// LAB 8B - STEP 4 & STEP 7: DEFINE MODEL CLASSES & PURPOSE-DRIVEN ELEMENTS
// ============================================================================
import 'package:flutter/material.dart';

class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final int precipitationProbability;

  DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitationProbability,
  });

  factory DailyForecast.fromJson(
    String dateStr,
    int code,
    double maxT,
    double minT,
    int precipProb,
  ) {
    return DailyForecast(
      date: DateTime.tryParse(dateStr) ?? DateTime.now(),
      weatherCode: code,
      maxTemp: maxT,
      minTemp: minT,
      precipitationProbability: precipProb,
    );
  }

  String get conditionText => WeatherData.getConditionText(weatherCode);
  IconData get iconData => WeatherData.getWeatherIcon(weatherCode, true);
}

class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final bool isDay;
  final List<DailyForecast> dailyForecasts;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
    required this.dailyForecasts,
  });

  factory WeatherData.fromJson(
    Map<String, dynamic> json,
    String cityName,
    String country,
  ) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final daily = json['daily'] as Map<String, dynamic>? ?? {};

    final dailyList = <DailyForecast>[];
    if (daily.containsKey('time') && daily['time'] is List) {
      final times = daily['time'] as List;
      final codes = (daily['weather_code'] as List?) ?? [];
      final maxTemps = (daily['temperature_2m_max'] as List?) ?? [];
      final minTemps = (daily['temperature_2m_min'] as List?) ?? [];
      final precipProbs = (daily['precipitation_probability_max'] as List?) ?? [];

      for (int i = 0; i < times.length; i++) {
        dailyList.add(
          DailyForecast.fromJson(
            times[i].toString(),
            i < codes.length ? (codes[i] as num).toInt() : 0,
            i < maxTemps.length ? (maxTemps[i] as num).toDouble() : 0.0,
            i < minTemps.length ? (minTemps[i] as num).toDouble() : 0.0,
            i < precipProbs.length ? (precipProbs[i] as num).toInt() : 0,
          ),
        );
      }
    }

    return WeatherData(
      cityName: cityName,
      country: country,
      temperature: (current['temperature_2m'] as num? ?? 0).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num? ?? 0).toDouble(),
      relativeHumidity: (current['relative_humidity_2m'] as num? ?? 0).toInt(),
      windSpeed: (current['wind_speed_10m'] as num? ?? 0).toDouble(),
      precipitation: (current['precipitation'] as num? ?? 0).toDouble(),
      weatherCode: (current['weather_code'] as num? ?? 0).toInt(),
      isDay: (current['is_day'] as num? ?? 1) == 1,
      dailyForecasts: dailyList,
    );
  }

  String get conditionText => getConditionText(weatherCode);

  IconData get iconData => getWeatherIcon(weatherCode, isDay);

  // Scenario A - Purpose-Driven Decision 1: Do I need an umbrella today?
  bool get needsUmbrella => precipitation > 0.1 || weatherCode >= 51;

  String get umbrellaAdvice {
    if (needsUmbrella) {
      return "Take an umbrella! Rain or precipitation is expected today.";
    }
    return "No umbrella needed today. Dry conditions expected.";
  }

  // Scenario A - Purpose-Driven Decision 2: Is it a good day for outdoor activities?
  String get activityAdvice {
    if (weatherCode >= 95) {
      return "Stay indoors due to severe thunderstorm risk";
    } else if (precipitation > 1.0) {
      return "Indoor activities recommended due to rainy weather";
    } else if (temperature > 32.0) {
      return "Too hot for outdoor sports";
    } else if (temperature < 10.0) {
      return "Too cold for outdoor sports";
    } else {
      return "Nice weather for a walk";
    }
  }

  // Scenario A - Purpose-Driven Decision 3: How hot/cold will it be this afternoon?
  String get afternoonTempAdvice {
    if (dailyForecasts.isNotEmpty) {
      final maxT = dailyForecasts.first.maxTemp.round();
      final minT = dailyForecasts.first.minTemp.round();
      if (maxT > 32) {
        return "Hot afternoon expected around $maxT°C (Min $minT°C). Stay hydrated!";
      } else if (maxT < 18) {
        return "Cold afternoon expected around $maxT°C (Min $minT°C). Wear warm clothes!";
      } else {
        return "Pleasant temperature around $maxT°C (Min $minT°C) this afternoon.";
      }
    }
    return "Expected peak temperature around ${temperature.round()}°C this afternoon.";
  }

  // Outfit Recommendation
  String get clothingAdvice {
    if (temperature < 12.0) {
      return "Wear a heavy jacket or coat and warm layer.";
    } else if (temperature < 22.0) {
      return "A sweater or light jacket is recommended.";
    } else if (temperature < 30.0) {
      return "Comfortable clothing like t-shirts and jeans.";
    } else {
      return "Light, breathable summer clothing is recommended.";
    }
  }

  static String getConditionText(int code) {
    switch (code) {
      case 0:
        return "Clear Sky";
      case 1:
        return "Mainly Clear";
      case 2:
        return "Partly Cloudy";
      case 3:
        return "Overcast";
      case 45:
      case 48:
        return "Foggy";
      case 51:
      case 53:
      case 55:
        return "Drizzle";
      case 61:
      case 63:
      case 65:
        return "Rain";
      case 66:
      case 67:
        return "Freezing Rain";
      case 71:
      case 73:
      case 75:
      case 77:
        return "Snowfall";
      case 80:
      case 81:
      case 82:
        return "Rain Showers";
      case 85:
      case 86:
        return "Snow Showers";
      case 95:
      case 96:
      case 99:
        return "Thunderstorm";
      default:
        return "Unknown";
    }
  }

  static IconData getWeatherIcon(int code, bool isDay) {
    switch (code) {
      case 0:
        return isDay ? Icons.wb_sunny : Icons.nights_stay;
      case 1:
      case 2:
        return isDay ? Icons.wb_cloudy : Icons.cloud_queue;
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.blur_on;
      case 51:
      case 53:
      case 55:
        return Icons.water_drop;
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Icons.umbrella;
      case 66:
      case 67:
        return Icons.ac_unit;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Icons.ac_unit;
      case 95:
      case 96:
      case 99:
        return Icons.flash_on;
      default:
        return Icons.thermostat;
    }
  }
}
