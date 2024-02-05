import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        // backgroundColor: Colors.teal,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.blue,
              backgroundImage: AssetImage('images/myChecked.png'),
            ),
            Text(
              '姓名氏名',
              style: TextStyle(
                  fontFamily: 'ZenKurento',
                  fontSize: 40.0,
                  color: Colors.grey,
                  letterSpacing: 5,
                  fontWeight: FontWeight.bold),
            ),
            // Text(
            //   'FLUTTER LEARNER1',
            //   style: TextStyle(
            //       fontFamily: 'ZenKurento',
            //       fontSize: 40.0,
            //       color: Colors.grey,
            //       fontWeight: FontWeight.bold),
            // ),
            // Text(
            //   'FLUTTER LEARNER2',
            //   style: TextStyle(
            //       fontFamily: 'SourceCodePro',
            //       fontSize: 40.0,
            //       color: Colors.grey,
            //       fontWeight: FontWeight.bold),
            // ),
            Text(
              'FLUTTER LEARNER3',
              style: TextStyle(
                  fontFamily: 'SourceCodeProItalic',
                  fontSize: 20.0,
                  color: Colors.teal.shade900,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 70.0,
              child: Divider(
                color: Colors.teal.shade100,
                thickness: 2.0,
              ),
            ),
            Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
                // padding: EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone,
                        // size: 100.0,
                        color: Colors.teal.shade900,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '(Card)123-456-7890',
                        style: TextStyle(
                          // fontFamily: 'SourceCodePro',
                          color: Colors.teal.shade900,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                )),

            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  // size: 100.0,
                  color: Colors.teal.shade900,
                ),
                title: Text(
                  '(ListTile in Card)123-45',
                  style: TextStyle(
                    // fontFamily: 'SourceCodePro',
                    color: Colors.teal.shade900,
                    fontSize: 20.0,
                  ),
                ),
                subtitle: Text('call me if you need'),
                dense: false,
                enabled: true,
                hoverColor: Colors.red,
              ),
            ),
            Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
                // padding: EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.outgoing_mail,
                        // size: 100.0,
                        color: Colors.teal.shade900,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '(Card)mailaddress@gmail.com',
                        style: TextStyle(
                          // fontFamily: 'SourceCodePro',
                          color: Colors.teal.shade900,
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                ))
            // Text(
            //   'small letters with toUpper()'.toUpperCase(),
            //   style: TextStyle(
            //       fontFamily: 'SourceCodePro',
            //       fontSize: 22.0,
            //       color: Colors.teal.shade50,
            //       fontWeight: FontWeight.bold),
            // ),
            // source sans pro
          ],
        )),
      ),
    );
  }
}
