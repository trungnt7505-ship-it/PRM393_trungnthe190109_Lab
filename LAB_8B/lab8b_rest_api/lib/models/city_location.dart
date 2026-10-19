class CityLocation {
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? admin1;

  CityLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.admin1,
  });

  factory CityLocation.fromJson(Map<String, dynamic> json) {
    return CityLocation(
      name: json['name'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String? ?? '',
      admin1: json['admin1'] as String?,
    );
  }

  String get displayName {
    if (admin1 != null && admin1!.isNotEmpty) {
      return '$name, $admin1, $country';
    }
    return country.isNotEmpty ? '$name, $country' : name;
  }
}
