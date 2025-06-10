import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:simple_weather_app/Model/currentCityDataModel.dart';
import 'package:simple_weather_app/Model/dailyForecastDataModel.dart';

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
  List<DailyForecastDataModel> _dailyForecast = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendRequestCurrentWeather();
  }

void sendRequestCurrentWeather() async {
  var apikey = "33199fbedb3ae7c66ce44cc662bca1ac";
  var cityname = "tehran";

  try {
    var response = await Dio().get(
      "https://api.openweathermap.org/data/2.5/weather",
      queryParameters: {"q": cityname, "appid": apikey, "units": "metric"},
    );

    // --- این بخش کلیدی و اصلاح شده است ---

    // 1. مقادیر lat و lon را مستقیماً از پاسخ API در متغیرهای محلی و امن ذخیره کن
    final lat = response.data['coord']['lat'];
    final lon = response.data['coord']['lon'];

    // 2. حالا setState را برای آب و هوای فعلی صدا بزن
    setState(() {
      _currentWeather = Currentcitydatamodel(
        response.data["name"],
        response.data["weather"][0]["main"],
        response.data["weather"][0]["description"],
        response.data["sys"]["country"],
        response.data["weather"][0]["icon"],
        lat, // از متغیر محلی استفاده کن
        lon, // از متغیر محلی استفاده کن
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
    });

    // 3. تابع بعدی را با متغیرهای محلی و امن فراخوانی کن
    sendRequestDailyForecast(lat, lon);

  } catch (e) {
    // اگر خطایی رخ دهد، اینجا چاپ می‌شود
    print("Error fetching current weather: $e");
  }
}

void sendRequestDailyForecast(num lat, num lon) async {
  var apikey = "33199fbedb3ae7c66ce44cc662bca1ac";

  try {
    // مرحله ۱: درخواست به API جدید (/forecast)
    var response = await Dio().get(
      "https://api.openweathermap.org/data/2.5/forecast", // <-- API رایگان پیش‌بینی
      queryParameters: {
        "lat": lat,
        "lon": lon,
        "appid": apikey,
        "units": "metric",
      },
    );

    // مرحله ۲: پردازش و گروه‌بندی اطلاعات ۳ ساعته بر اساس روز
    final List<dynamic> hourlyForecasts = response.data['list'];
    final Map<String, List<dynamic>> dailyGroupedForecasts = {};

    for (var forecast in hourlyForecasts) {
      // تاریخ هر آیتم را به صورت "سال-ماه-روز" استخراج می‌کنیم
      final String day = DateFormat('yyyy-MM-dd').format(
          DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000));
      
      // اگر این روز در مپ ما وجود نداشت، یک لیست خالی برایش بساز
      if (dailyGroupedForecasts[day] == null) {
        dailyGroupedForecasts[day] = [];
      }
      // آیتم فعلی را به لیست آن روز اضافه کن
      dailyGroupedForecasts[day]!.add(forecast);
    }

    // مرحله ۳: ساختن لیست نهایی اطلاعات روزانه
    List<DailyForecastDataModel> processedDailyForecast = [];
    dailyGroupedForecasts.forEach((day, forecastsForDay) {
      // برای هر روز، بیشینه دما را پیدا می‌کنیم
      num maxTemp = forecastsForDay
          .map((item) => item['main']['temp'])
          .reduce((a, b) => a > b ? a : b);
      
      // آیکون همان روز را از آیتم وسط روز (حدود ظهر) انتخاب می‌کنیم تا نماینده بهتری باشد
      String icon = forecastsForDay[forecastsForDay.length ~/ 2]['weather'][0]['icon'];

      processedDailyForecast.add(
        DailyForecastDataModel(
          // از تایم‌استمپ اولین آیتم آن روز برای نمایش تاریخ استفاده می‌کنیم
          dateTime: forecastsForDay[0]['dt'],
          temp: maxTemp,
          icon: icon,
        ),
      );
    });

    // مرحله ۴: آپدیت کردن وضعیت (State) با لیست پردازش شده
    setState(() {
      // ما فقط ۵ روز آینده را می‌خواهیم
      _dailyForecast = processedDailyForecast.take(5).toList();
    });

  } catch (e) {
    print("Error fetching daily forecast: $e");
  }
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
                          Image.network(
                            "https://openweathermap.org/img/wn/${_currentWeather!.icon}@2x.png",
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
                            height: 105,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  _dailyForecast.isEmpty
                                      ? 7
                                      : _dailyForecast.length,
                              itemBuilder: (context, index) {
                                if (_dailyForecast.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 15,
                                          color: Colors.white24,
                                          margin: EdgeInsets.only(bottom: 8),
                                        ),
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white24,
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          width: 40,
                                          height: 15,
                                          color: Colors.white24,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                final dayData = _dailyForecast[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        DateFormat.EEEE().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            dayData.dateTime * 1000,
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
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
}
