class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final DateTime dateTime;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.dateTime,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      dateTime: DateTime.now(),  // assuming 'dt' is a UNIX timestamp
    );
  }

  factory Weather.fromForecastJson(Map<String, dynamic> json) {
    return Weather(
      cityName: '',  // forecast data doesn't contain city name for each entry
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      dateTime: DateTime.parse(json['dt_txt']),  // 'dt_txt' is for forecast datetime
    );
  }
}
