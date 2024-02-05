import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future getData() async {
    final uri = Uri.parse(
        'https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22');

    // final uri = Uri.parse(
    //     'https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=$apiKey');

    var response = await http.get(uri);
    debugPrint(
        'status and body --> ${response.statusCode} \n ${response.body}');
    if (response.statusCode == 200) {
      String data = response.body;
      debugPrint('NetworkHelper getData() --> $data');
      return jsonDecode(data);
    } else {
      debugPrint('--> Error status code is ${response.statusCode}');
    }
  }
}
