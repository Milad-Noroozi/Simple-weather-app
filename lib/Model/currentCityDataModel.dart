class Currentcitydatamodel {
  String _cityname;
  String _main;
  String _description;
  String _country;
  var _lon;
  var _lat;
  var _temp;
  var _temp_min;
  var _temp_max;
  var _pressure;
  var _humidity;
  var _windspeed;
  var _dateTime;
  var _sunrise;
  var _sunset;

  Currentcitydatamodel(
    this._cityname,
    this._main,
    this._description,
    this._country,
    this._lon,
    this._lat,
    this._temp,
    this._temp_min,
    this._temp_max,
    this._pressure,
    this._humidity,
    this._windspeed,
    this._dateTime,
    this._sunrise,
    this._sunset,
  );

  // Getters
  String get cityname => _cityname;
  String get main => _main;
  String get description => _description;
  String get country => _country;
  get lon => _lon;
  get lat => _lat;
  get temp => _temp;
  get tempMain => _temp_min;
  get tempMax => _temp_max;
  get pressure => _pressure;
  get humidity => _humidity;
  get windspeed => _windspeed;
  get dateTime => _dateTime;
  get sunrise => _sunrise;
  get sunset => _sunset;
}
