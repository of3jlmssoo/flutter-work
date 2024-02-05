import 'package:flutter/material.dart';
import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const apiKey = 'b6907d289e10d714a6e88b30761fae22';
const openWeatherMapURL = 'https://samples.openweathermap.org/data/2.5/weather';
const realOpenWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    // real API access
    // NetworkHelper networkHelper = NetworkHelper(
    //     '$realOpenWeatherMapURL?q=$cityName&appid=$apiKey&unit=metric');
    // sample API
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?q=lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22');
    var weatheData = networkHelper.getData();
    return weatheData;
  }

  Future<dynamic> getLocationWeather() async {
    Location loc = Location();
    await loc.getCurrentLocation();
    debugPrint('--> ${loc.latitude} and ${loc.longitude}');
    double latitude = loc.latitude;
    double longitude = loc.longitude;

    longitude = 139.01;
    latitude = 35.02;

    // NetworkHelper networkHelper = NetworkHelper('https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22')
    NetworkHelper networkHelper = NetworkHelper(
        '${openWeatherMapURL}?lat=${latitude}&lon=${longitude}&appid=$apiKey');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
