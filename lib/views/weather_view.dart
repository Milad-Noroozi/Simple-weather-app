import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:simple_weather_app/controllers/weather_controller.dart';
import 'package:simple_weather_app/Model/current_city_data_model.dart'; 

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  late final WeatherController _controller;
  final TextEditingController _cityTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = WeatherController(onStateChanged: () {
      setState(() {});
    });
    _controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text("Weather App"),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'edit', child: Text('ویرایش')),
              PopupMenuItem(value: 'delete', child: Text('حذف')),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/pic_bg.jpg"),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: _controller.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : SingleChildScrollView(
                    child: Column(
                      children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 8, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _cityTextController,
                                    decoration: InputDecoration(
                                      hintText: "Enter a city name",
                                      hintStyle: TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                        borderSide: BorderSide(color: Colors.white70),
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty) {
                                        _controller.fetchWeatherForCity(value);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_cityTextController.text.isNotEmpty) {
                                      _controller.fetchWeatherForCity(_cityTextController.text);
                                    }
                                  },
                                  child: Text("Find"),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                            child: Text(
                              _controller.currentWeather!.cityname.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            _controller.currentWeather!.description,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Image.network(
                            "https://openweathermap.org/img/wn/${_controller.currentWeather!.icon}@2x.png",
                          ),
                          Text(
                            "${_controller.currentWeather!.temp.round()}\u00b0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // MAX Temp
                              Column(
                                children: [
                                  Text("MAX", style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 6),
                                  Text(
                                    "${_controller.currentWeather!.tempMax.round()}\u00b0",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20, height: 40, child: VerticalDivider(color: Colors.white30, thickness: 1)),
                              // MIN Temp
                              Column(
                                children: [
                                  Text("MIN", style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 6),
                                  Text(
                                    "${_controller.currentWeather!.tempMin.round()}\u00b0",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Divider(color: Colors.white30),
                          SizedBox(height: 10),
                          // Daily Forecast List
                          SizedBox(
                            height: 105,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _controller.dailyForecast.length,
                              itemBuilder: (context, index) {
                                final dayData = _controller.dailyForecast[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat.E().format(
                                          DateTime.fromMillisecondsSinceEpoch(dayData.dateTime * 1000),
                                        ),
                                        style: TextStyle(color: Colors.grey, fontSize: 13),
                                      ),
                                      Image.network(
                                        "https://openweathermap.org/img/wn/${dayData.icon}@2x.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                      Text(
                                        "${dayData.temp.round()}\u00b0",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(color: Colors.white30),
                          SizedBox(height: 10),
                          // Extra Details
                           Padding(
                             padding: const EdgeInsets.symmetric(vertical: 10.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 // Wind Speed
                                 Column(
                                   children: [
                                     Text("Wind Speed", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                     SizedBox(height: 6),
                                     Text("${_controller.currentWeather!.windspeed} m/s", style: TextStyle(color: Colors.white, fontSize: 15)),
                                   ],
                                 ),
                                 // Sunrise
                                 Column(
                                   children: [
                                     Text("Sunrise", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                     SizedBox(height: 6),
                                     Text(DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(_controller.currentWeather!.sunrise * 1000)), style: TextStyle(color: Colors.white, fontSize: 15)),
                                   ],
                                 ),
                                 // Sunset
                                 Column(
                                   children: [
                                     Text("Sunset", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                     SizedBox(height: 6),
                                     Text(DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(_controller.currentWeather!.sunset * 1000)), style: TextStyle(color: Colors.white, fontSize: 15)),
                                   ],
                                 ),
                                 // Humidity
                                 Column(
                                   children: [
                                     Text("Humidity", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                     SizedBox(height: 6),
                                     Text("${_controller.currentWeather!.humidity}%", style: TextStyle(color: Colors.white, fontSize: 15)),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                        ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}