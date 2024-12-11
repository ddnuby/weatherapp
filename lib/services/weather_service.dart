import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapppractice/models/weather_mode.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  static const FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load the weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // Get the location permission from the user (asking for either to be used always, or deny it.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // The error in case of the permission being denied
    if (permission == LocationPermission.denied) {
      throw Exception('No sunspotting can be done');};
    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Converting the location into a list of placemark objects
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    // Extracting the name of the city from the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }

  Future<List<Weather>> getWeeklyForecast(String cityName) async {
    final response = await http.get(
        Uri.parse('$FORECAST_URL?q=$cityName&appid=$apiKey&units=metric'));

    //If and else statement, for loading the weekly forecast data
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['list'];
      List<Weather> forecast = data.map((json) => Weather.fromForecastJson(json)).toList();
      return forecast;
    } else {
      throw Exception('Failed to load the weekly forecast data');
    }
  }
}
