import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'weather_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService =
  WeatherService('fd5e193d79df29654005788089747d5d');
  String? _errorMessage;

  void _searchCity() async {
    if (_controller.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
    } else {
      try {
        final cityName = _controller.text;
        // Try to fetch weather for the entered city to check if it exists
        await _weatherService.getWeather(cityName);
        // Navigate to the weather page if this is successful
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherPage(cityName: cityName),
          ),
        );
        //In case that gibberish is being put into the search input field, the error will
        //be shown
      } catch (e) {
        setState(() {
          _errorMessage = 'City not found. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchCity,
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
