import 'package:flutter/material.dart';
import '../models/weather_mode.dart';
import '../services/weather_service.dart';
import 'weekly_forecast_page.dart';
import 'search_page.dart';
import 'package:url_launcher/url_launcher.dart';

class WeatherPage extends StatefulWidget {
  final String? cityName;

  const WeatherPage({Key? key, this.cityName}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}
//My api key from openweather
class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService =
  WeatherService('fd5e193d79df29654005788089747d5d');
  Weather? _weather;
  String? _errorMessage;

  // Fetch the weather
  _fetchWeather() async {
    try {
      // Get the current city
      String cityName = widget.cityName ?? await _weatherService.getCurrentCity();
      // Get the weather for the city
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _errorMessage = null;
      });
    } catch (e) {
      print(e);
      setState(() {
        _errorMessage = 'Failed to load weather for ${widget.cityName ?? 'current location'}';
      });
    }
  }

  // Init state
  @override
  void initState() {
    super.initState();
    // Fetch weather on startup
    _fetchWeather();
  }

  void _navigateToSearchPage() {
    // Navigating on push to the search page (to search for any city)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
  }

  void _navigateToWeeklyForecastPage() {
    // Navigating on push to the weekly forecast page
    if (_weather != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeeklyForecastPage(cityName: _weather!.cityName),
        ),
      );
    }
  }

  //Assets (background images) changing depending on the weather condition
  String _getBackgroundImage(String mainCondition) {
    switch (mainCondition) {
      case 'Clear':
        return 'assets/sunny.jpg';
      case 'Clouds':
        return 'assets/cloudy.jpg';
      case 'Rain':
        return 'assets/rain.jpg';
      case 'Snow':
        return 'assets/snow.jpg';
      default:
        return 'assets/cloudy.jpg';
    }
  }

  //Icons changing depending on the weather condition
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
  void _openWebsite() {
    // Open the website using a URL launcher

    final Uri url = Uri.parse('https://verdant-platypus-7c9eb5.netlify.app');
    if (canLaunch(url.toString()) != null) {
      launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sunspotter'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _navigateToSearchPage,
          ),
        ],
      ),
      body: Stack(
        children: [
          _weather == null
              ? Container(color: Colors.blue) // Default background color while loading
              : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_getBackgroundImage(_weather!.mainCondition)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: _weather == null
                ? Center(
              child: Text(
                _errorMessage ?? 'Sunspotting...Hmmm...',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _weather!.cityName,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _weather!.mainCondition == 'Clear' ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        _getWeatherIcon(_weather!.mainCondition),
                        color: _weather!.mainCondition == 'Clear' ? Colors.black : Colors.white,
                        size: 48,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _weather!.mainCondition,
                          style: TextStyle(
                            fontSize: 24,
                            color: _weather!.mainCondition == 'Clear' ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: _navigateToWeeklyForecastPage,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.cloud,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _openWebsite,
                  child: Center(
                    child: Text(
                      'Visit Our Website ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        decoration: TextDecoration.underline, // Underline the text to indicate it's a link
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_weather!.temperature.round()}°C',
                        style: TextStyle(
                          fontSize: 125,
                          fontWeight: FontWeight.bold,
                          color: _weather!.mainCondition == 'Clear' ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}