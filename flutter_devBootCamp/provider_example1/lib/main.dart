import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/account.dart';
import './screens/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Provider Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Map data = {'name': 'Sammy Shark', 'email': 'example@example.com', 'age': 42};
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: AccountScreen(),
    //   routes: {
    //     'account_screen': (context) => AccountScreen(),
    //     'settings_screen': (context) => SettingsScreen(),
    //   },
    // );
    //
    return ChangeNotifierProvider<Data>(
      // create: (context) => data,
      create: (context) => Data(),
      child: MaterialApp(home: AccountScreen(), routes: {
        'account_screen': (context) => AccountScreen(),
        'settings_screen': (context) => SettingsScreen(),
      }),
    );
  }
}

class Data extends ChangeNotifier {
  Map data = {'name': 'Sammy Shark', 'email': 'example@example.com', 'age': 42};

  void updateAccount(input) {
    data = input;
    notifyListeners();
  }
}
