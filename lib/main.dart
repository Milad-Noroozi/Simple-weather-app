import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:simple_weather_app/Model/currentCityDataModel.dart';

void main() {
  runApp(StartApp());
}

class StartApp extends StatefulWidget {
  const StartApp({super.key});

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  Currentcitydatamodel? _currentWeather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SendRequestCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text("Weather App"),
          actions: [
            PopupMenuButton<String>(
              itemBuilder:
                  (BuildContext context) => [
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
              child:
                  _currentWeather == null
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text("Find"),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'City name',
                                      labelStyle: TextStyle(
                                        color: const Color.fromARGB(
                                          169,
                                          221,
                                          221,
                                          221,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                            169,
                                            180,
                                            180,
                                            180,
                                          ),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          25.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                            108,
                                            0,
                                            0,
                                            0,
                                          ),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          25.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      hintText: "Pleas enter a city name",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                            child: Text(
                              _currentWeather!.cityname.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            _currentWeather!.description,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Icon(
                              Icons.sunny_snowing,
                              color: Colors.white,
                              size: 70,
                            ),
                          ),
                          Text(
                            "${_currentWeather!.temp}\u00b0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "MAX",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "${_currentWeather!.tempMax}\u00b0",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  color: const Color.fromARGB(120, 51, 51, 51),
                                  thickness: 2,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "MIN",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "${_currentWeather!.tempMain}\u00b0",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Divider(
                            // height: 10,
                            color: const Color.fromARGB(120, 51, 51, 51),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 100,
                            // color: Colors.white,
                            // color: Colors.white,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Fri, 8pm",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Icon(
                                        Icons.cloud_queue_sharp,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "12"
                                        "\u00b0",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 5),
                          Divider(
                            // height: 10,
                            color: const Color.fromARGB(120, 51, 51, 51),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Wind Speed",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "${_currentWeather!.windspeed} m/s",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  color: const Color.fromARGB(120, 51, 51, 51),
                                  thickness: 2,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "sunrise",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('h:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        _currentWeather!.sunrise * 1000,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  color: const Color.fromARGB(120, 51, 51, 51),
                                  thickness: 2,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "sunset",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('h:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        _currentWeather!.sunset * 1000,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: VerticalDivider(
                                  color: const Color.fromARGB(120, 51, 51, 51),
                                  thickness: 2,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "humidity",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "${_currentWeather!.humidity}%",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }

  void SendRequestCurrentWeather() async {
    print("1. Starting the request..."); // 1. آیا متد اصلاً شروع می‌شود؟

    var apikey = "33199fbedb3ae7c66ce44cc662bca1ac";
    var cityname = "tehran";

    try {
      var response = await Dio().get(
        "https://api.openweathermap.org/data/2.5/weather",
        queryParameters: {"q": cityname, "appid": apikey, "units": "metric"},
      );

      print(
        "2. Request successful. Response received.",
      ); // 2. آیا درخواست موفق بود؟

      var datamodel = Currentcitydatamodel(
        response.data["name"],
        response.data["weather"][0]["main"],
        response.data["weather"][0]["description"],
        response.data["sys"]["country"],
        response.data["coord"]["lon"],
        response.data["coord"]["lat"],
        response.data["main"]["temp"],
        response.data["main"]["temp_min"],
        response.data["main"]["temp_max"],
        response.data["main"]["pressure"],
        response.data["main"]["humidity"],
        response.data["wind"]["speed"],
        response.data["dt"],
        response.data["sys"]["sunrise"],
        response.data["sys"]["sunset"],
      );

      print("3. Data model created successfully."); // 3. آیا مدل ساخته شد؟

      setState(() {
        print(
          "4. Inside setState. Updating the state.",
        ); // 4. آیا وارد setState می‌شویم؟
        _currentWeather = datamodel;
      });

      print("5. setState has been called."); // 5. آیا setState تمام شد؟
    } catch (e) {
      print("---!!! AN ERROR OCCURRED !!!---");
      print("The error is: $e");
      print("---------------------------------");
    }
  }
}
