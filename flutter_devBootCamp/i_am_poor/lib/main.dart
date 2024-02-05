import 'package:flutter/material.dart';
// rename shift f6

void main() {
  runApp(const poor_app());
}

class poor_app extends StatelessWidget {
  const poor_app({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppBarExample(),
    );
  }
}

class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});
  // debugShowCheckedModeBanner: false,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'I am poor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('This is a snackbar'),
                duration: Duration(seconds: 1),
              ));
            },
          ),
        ],
        backgroundColor: Colors.lightGreen[200],
      ),
      body: Center(
        child: Image.network(
            // 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            'https://img.icons8.com/?size=512&id=16alD-niWjYF&format=png'),
      ),
    );
  }
}
