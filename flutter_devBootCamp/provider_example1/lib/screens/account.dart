import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_example1/screens/settings.dart';
import '../main.dart';
import '../navbar.dart';

class AccountScreen extends StatelessWidget {
  static const String id = 'account_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(),
      appBar: AppBar(
        title: Text('Account Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SettingsScreen(),
            ),
            // Text('Name: '),
            // Text('Email: '),
            // Text('Age: '),
            // Text('Name: ' + Provider.of<Map>(context)['name'].toString()),
            // Text('Email: ' + Provider.of<Map>(context)['email'].toString()),
            // Text('Age: ' + Provider.of<Map>(context)['age'].toString()),
            Text('Name: ' + Provider.of<Data>(context).data['name'].toString()),
            Text('Email: ' +
                Provider.of<Data>(context).data['email'].toString()),
            Text('Age: ' + Provider.of<Data>(context).data['age'].toString()),
          ],
        ),
      ),
    );
  }
}
