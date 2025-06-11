import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:simple_weather_app/Model/current_city_data_model.dart';
import 'package:simple_weather_app/Model/dailyForecastDataModel.dart';

class WeatherController {
  final String _apiKey = "33199fbedb3ae7c66ce44cc662bca1ac";

  // State of the app
  Currentcitydatamodel? currentWeather;
  List<DailyForecastDataModel> dailyForecast = [];
  bool isLoading = true;

  // Callback to notify the View to rebuild
  final Function() onStateChanged;

  WeatherController({required this.onStateChanged});

  Future<void> init() async {
    await fetchWeatherForCity("tehran");
  }

  Future<void> fetchWeatherForCity(String cityName) async {
    isLoading = true;
    onStateChanged(); // Notify view to show loading indicator

    try {
      var response = await Dio().get(
        "https://api.openweathermap.org/data/2.5/weather",
        queryParameters: {"q": cityName, "appid": _apiKey, "units": "metric"},
      );

      final lat = response.data['coord']['lat'];
      final lon = response.data['coord']['lon'];

      currentWeather = Currentcitydatamodel(
        cityname: response.data["name"],
        main: response.data["weather"][0]["main"],
        description: response.data["weather"][0]["description"],
        country: response.data["sys"]["country"],
        icon: response.data["weather"][0]["icon"],
        lat: lat, // Corrected order
        lon: lon, // Corrected order
        temp: response.data["main"]["temp"],
        tempMin: response.data["main"]["temp_min"],
        tempMax: response.data["main"]["temp_max"],
        pressure: response.data["main"]["pressure"],
        humidity: response.data["main"]["humidity"],
        windspeed: response.data["wind"]["speed"],
        dateTime: response.data["dt"],
        sunrise: response.data["sys"]["sunrise"],
        sunset: response.data["sys"]["sunset"],
      );

      await _fetchDailyForecast(lat, lon);

    } catch (e) {
      print("Error fetching current weather: $e");
      // Optionally, handle error state here
    }

    isLoading = false;
    onStateChanged(); // Notify view to show data
  }

  Future<void> _fetchDailyForecast(num lat, num lon) async {
    try {
      var response = await Dio().get(
        "https://api.openweathermap.org/data/2.5/forecast",
        queryParameters: {
          "lat": lat,
          "lon": lon,
          "appid": _apiKey,
          "units": "metric",
        },
      );

      final List<dynamic> hourlyForecasts = response.data['list'];
      final Map<String, List<dynamic>> dailyGroupedForecasts = {};

      for (var forecast in hourlyForecasts) {
        final String day = DateFormat('yyyy-MM-dd').format(
            DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000));
        
        if (dailyGroupedForecasts[day] == null) {
          dailyGroupedForecasts[day] = [];
        }
        dailyGroupedForecasts[day]!.add(forecast);
      }

      List<DailyForecastDataModel> processedDailyForecast = [];
      dailyGroupedForecasts.forEach((day, forecastsForDay) {
        num maxTemp = forecastsForDay
            .map((item) => item['main']['temp'])
            .reduce((a, b) => a > b ? a : b);
        
        String icon = forecastsForDay[forecastsForDay.length ~/ 2]['weather'][0]['icon'];

        processedDailyForecast.add(
          DailyForecastDataModel(
            dateTime: forecastsForDay[0]['dt'],
            temp: maxTemp,
            icon: icon,
          ),
        );
      });

      dailyForecast = processedDailyForecast.take(5).toList();

    } catch (e) {
      print("Error fetching daily forecast: $e");
    }
  }
}