import 'package:bmicalculator/screens/result_page.dart';
import 'package:flutter/material.dart';
import 'screens/input_page.dart';

void main() => runApp(BMICalculator());

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(color: Color(0xFF0A0E21)),
        // canvasColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      // theme: ThemeData(
      //   appBarTheme: AppBarTheme(color: Color(0xFF0A0E21)),
      //   // canvasColor: Color(0xFF0A0E21),
      //   scaffoldBackgroundColor: Color(0xFF0A0E21),
      //
      //   textTheme: TextTheme(
      //     bodyMedium: TextStyle(
      //       color: Colors.white,
      //       // fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //
      //   colorScheme: // accentcolor
      //       ColorScheme.fromSwatch().copyWith(secondary: Colors.purple),
      // ),
      // home: InputPage(),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => InputPage(),
        ResultPage.routeName: (context) => ResultPage(
              bmiResult: 'dummy',
              resultText: 'dummy',
              interpretation: 'dummy',
            ),
        // '/result': (BuildContext context) => ResultPage(
        //       bmiResult: 'xx',
        //       resultText: '',
        //       interpretation: '',
        //     ),
      },
    );
  }
}
