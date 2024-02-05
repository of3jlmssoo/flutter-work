import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../navbar.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';

  final formKey = GlobalKey<FormState>();

  final Map data = {'name': String, 'email': String, 'age': int};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(),
      appBar: AppBar(title: Text('Change Account Details')),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (input) => data['name'] = input,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onSaved: (input) => data['email'] = input,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  onSaved: (input) => data['age'] = input,
                ),
                // TextButton(
                //   onPressed: () => formKey.currentState!.save(),
                //   child: Text('Submit'),
                //   style: TextButton.styleFrom(
                //     // primary: Colors.black,
                //     backgroundColor: Colors.blue,
                //   ),
                // ),
                TextButton(
                  onPressed: () {
                    formKey.currentState!.save();
                    Provider.of<Data>(context, listen: false)
                        .updateAccount(data);
                    formKey.currentState?.reset();

                    // child: Text('Submit',
                    // style: TextButton.styleFrom(
                    //   // primary: Colors.black,
                    //   backgroundColor: Colors.blue,
                    // ),
                  },
                  child: Text(
                    'submit',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
