import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Animation Demo',
      theme: ThemeData.dark(),
      home: WeatherAnimationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherAnimationScreen extends StatefulWidget {
  @override
  _WeatherAnimationScreenState createState() => _WeatherAnimationScreenState();
}

class _WeatherAnimationScreenState extends State<WeatherAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimationStarted = false;
  String _currentWeather = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Reset animation state when completed
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimationStarted = false;
        });
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation(String weather) {
    setState(() {
      _currentWeather = weather;
      _isAnimationStarted = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather Animation Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weather buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: !_isAnimationStarted ? () => _startAnimation('Sunny') : null,
                  child: Text('Sunny'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: !_isAnimationStarted ? () => _startAnimation('Rainy') : null,
                  child: Text('Rainy'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: !_isAnimationStarted ? () => _startAnimation('Cloudy') : null,
                  child: Text('Cloudy'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: !_isAnimationStarted ? () => _startAnimation('Snowy') : null,
                  child: Text('Snowy'),
                ),
              ],
            ),

            // Animation display
            SizedBox(height: 20),
            if (_isAnimationStarted)
              Column(
                children: [
                  if (_currentWeather == 'Sunny')
                    ScaleTransition(
                      scale: _animation,
                      child: FadeTransition(
                        opacity: _animation,
                        child: Icon(Icons.wb_sunny, size: 120, color: Colors.yellow),
                      ),
                    ),
                  if (_currentWeather == 'Rainy')
                    ScaleTransition(
                      scale: _animation,
                      child: FadeTransition(
                        opacity: _animation,
                        child: Icon(Icons.beach_access, size: 120, color: Colors.blue),
                      ),
                    ),
                  if (_currentWeather == 'Cloudy')
                    ScaleTransition(
                      scale: _animation,
                      child: FadeTransition(
                        opacity: _animation,
                        child: Icon(Icons.cloud, size: 120, color: Colors.grey),
                      ),
                    ),
                  if (_currentWeather == 'Snowy')
                    ScaleTransition(
                      scale: _animation,
                      child: FadeTransition(
                        opacity: _animation,
                        child: Icon(Icons.ac_unit, size: 120, color: Colors.lightBlue),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
