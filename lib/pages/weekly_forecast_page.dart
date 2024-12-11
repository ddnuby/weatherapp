import 'package:flutter/material.dart';
import '../models/weather_mode.dart';
import '../services/weather_service.dart';

class WeeklyForecastPage extends StatefulWidget {
  final String? cityName; // Optional city name passed from another page

  const WeeklyForecastPage({Key? key, this.cityName}) : super(key: key);

  @override
  _WeeklyForecastPageState createState() => _WeeklyForecastPageState();
}

class _WeeklyForecastPageState extends State<WeeklyForecastPage> {
  final _weatherService = WeatherService('fd5e193d79df29654005788089747d5d');
  List<Weather>? _weeklyForecast;
  bool _isLoading = true;
  String? _errorMessage;

  // Fetch the weekly forecast
  _fetchWeeklyForecast() async {
    try {
      String cityName = widget.cityName ?? await _weatherService.getCurrentCity();
      final weeklyForecast = await _weatherService.getWeeklyForecast(cityName);
      setState(() {
        _weeklyForecast = weeklyForecast;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load weekly forecast';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeeklyForecast();
  }

  @override
  void didUpdateWidget(covariant WeeklyForecastPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cityName != oldWidget.cityName) {
      _fetchWeeklyForecast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Forecast'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _weeklyForecast == null
          ? Center(
        child: Text(
          _errorMessage ?? 'Failed to load weekly forecast',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _weeklyForecast!.length,
        itemBuilder: (context, index) {
          final weather = _weeklyForecast![index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              leading: Icon(
                _getWeatherIcon(weather.mainCondition),
                size: 48,
                color: Colors.blueAccent,
              ),
              title: Text(
                '${weather.dateTime.day}/${weather.dateTime.month}/${weather.dateTime.year}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                weather.mainCondition,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Text(
                '${weather.temperature.round()}°C',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getWeatherIcon(String mainCondition) {
    switch (mainCondition) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.beach_access;
      case 'Snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }
}
