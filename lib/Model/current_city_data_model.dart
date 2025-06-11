class Currentcitydatamodel {
  String cityname;
  String main;
  String description;
  String country;
  String icon;
  num lon;
  num lat;
  num temp;
  num tempMin;
  num tempMax;
  num pressure;
  num humidity;
  num windspeed;
  int dateTime;
  int sunrise;
  int sunset;

  Currentcitydatamodel({
    required this.cityname,
    required this.main,
    required this.description,
    required this.country,
    required this.icon,
    required this.lon,
    required this.lat,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windspeed,
    required this.dateTime,
    required this.sunrise,
    required this.sunset,
  });
}