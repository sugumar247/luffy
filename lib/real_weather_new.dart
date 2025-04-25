import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = 'London';
  String _temperature = '';
  String _weatherDescription = '';
  String _feelsLike = '';
  bool _loading = false;

  final String apiKey = 'f8a674cf89e35a475daf8cee2c196ee0';
  //bf36644c7af8fdf8799bafae5922f7da
  //19ba1577c72fc8ce8e42b21108a9552d

  Future<void> _getWeather() async {
    setState(() {
      _loading = true;
    });

    final String url = 'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = '${data['main']['temp']} °C';
          _weatherDescription = data['weather'][0]['description'];
          _feelsLike = 'Feels like: ${data['main']['feels_like']} °C';
        });
      } else {
        setState(() {
          _temperature = 'Error fetching data';
        });
      }
    } catch (e) {
      setState(() {
        _temperature = 'Error fetching data';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  _city = value;
                });
              },
              decoration: InputDecoration(labelText: 'Enter city name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : Column(
              children: [
                Text('City: $_city'),
                Text('Temperature: $_temperature'),
                Text('Weather: $_weatherDescription'),
                Text(_feelsLike),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
