import 'package:flutter/material.dart';
import 'package:simple_weather_app/views/weather_view.dart'; // وارد کردن View از پوشه جدید

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: WeatherView(),
    );
  }
}