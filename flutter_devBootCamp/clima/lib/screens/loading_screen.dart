import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';
// import 'package:clima/services/location.dart';
// import 'package:clima/services/networking.dart';

import 'package:clima/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clima/services/weather.dart';
// const apiKey = 'b6907d289e10d714a6e88b30761fae22';
// Future<Position> _determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled don't continue
//     // accessing the position and request users of the
//     // App to enable the location services.
//     return Future.error('Location services are disabled.');
//   }
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied, next time you could try
//       // requesting permissions again (this is also where
//       // Android's shouldShowRequestPermissionRationale
//       // returned true. According to Android guidelines
//       // your App should show an explanatory UI now.
//       return Future.error('Location permissions are denied');
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately.
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }
//
//   // When we reach here, permissions are granted and we can
//   // continue accessing the position of the device.
//   return await Geolocator.getCurrentPosition();
// }

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // void getLocation() async {
  //   // Future<Position> postion = _determinePosition();
  //
  //   try {
  //     // somethingThatExpectsLessThan10(12);
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.low);
  //     debugPrint('-->' + position.toString());
  //   } catch (e) {
  //     debugPrint(e as String?);
  //   }
  // }

  // void somethingThatExpectsLessThan10(int n) {
  //   if (n > 10) {
  //     throw 'n is greater than 10.';
  //   }
  // }

  late double latitude;
  late double longitude;

  void getLocationData() async {
    // Location loc = Location();
    // await loc.getCurrentLocation();
    // debugPrint('--> ${loc.latitude} and ${loc.longitude}');
    // latitude = loc.latitude;
    // longitude = loc.longitude;
    //
    // longitude = 139.01;
    // latitude = 35.02;
    //
    // // NetworkHelper networkHelper = NetworkHelper('https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22')
    // NetworkHelper networkHelper = NetworkHelper(
    //     'https://samples.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=$apiKey');
    //
    // var weatherData = await networkHelper.getData();
    // debugPrint('getLocationdata() --> $weatherData');

    // WeatherModel weatherModel = WeatherModel();
    // var weatherData = weatherModel.getLocationWeather();
    var weatherData = await WeatherModel().getLocationWeather();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(locationWeather: weatherData);
    }));

    // var weatherDescription = decodedData['weather'][0]['description'];
    // var weathertemp = decodedData['main']['temp'];
    // var weatherID = decodedData['weather'][0]['id'];
    // var weatherCity = decodedData['name'];
    // debugPrint('--> $weathertemp $weatherID $weatherCity');
    //temp 285.514
    //id in weather 800
    //city name tawarano
    // print('--> description is $weatherDescription');
    // getData();
  }

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // getData();
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
      //   body: Center(
      //     child: ElevatedButton(
      //       onPressed: () {
      //         //Get the current location
      //         getLocation();
      //       },
      //       child: Text('Get Location'),
      //     ),
      //   ),
    );
  }
}

// null aware operator
// a = b ?? c
