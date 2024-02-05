//  firebase emulators:start --import=./dir --export-on-exit
//
//
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:work/csv2.dart';

import 'csv.dart';
import 'expinput.dart';
import 'firebase_login.dart';
import 'firestore_data.dart';
import 'firestore_listview.dart';
import 'listviews.dart';
import 'textfielddropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

final log = Logger('MainLogger');

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => FirstRoute(),
    ),
    GoRoute(
      path: '/textdropdown',
      builder: (context, state) => const TextFieldAndDrowDown(),
    ),
    GoRoute(
      path: '/csv',
      builder: (context, state) {
        final CounterStorage param =
            GoRouterState.of(context).extra as CounterStorage;
        return CSV(storage: param);
      },
    ),
    GoRoute(
      path: '/csvSecond',
      builder: (context, state) {
        final StrListStorage param =
            GoRouterState.of(context).extra as StrListStorage;
        return CSV2(storage: param);
      },
    ),
    GoRoute(
      path: '/listViews',
      builder: (context, state) => ListViews(),
    ),
    GoRoute(
      path: '/expinput',
      builder: (context, state) => ExpenceInput(),
    ),
  ],
);

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: Locale('ja'),
      theme: ThemeData(
        fontFamily: 'MPLUSRounded',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'MPLUSRounded'),
          bodyMedium: TextStyle(fontFamily: 'MPLUSRounded'),
          headlineMedium: TextStyle(fontFamily: 'MPLUSRounded'),
          headlineSmall: TextStyle(fontFamily: 'MPLUSRounded'),
          titleLarge: TextStyle(fontFamily: 'MPLUSRounded'),
          titleMedium: TextStyle(fontFamily: 'MPLUSRounded'),
          titleSmall: TextStyle(fontFamily: 'MPLUSRounded'),
          bodySmall: TextStyle(fontFamily: 'MPLUSRounded'),
          labelLarge: TextStyle(fontFamily: 'MPLUSRounded'),
          labelSmall: TextStyle(fontFamily: 'MPLUSRounded'),
        ),
      ),
      home: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}

class FirstRoute extends StatefulWidget {
  const FirstRoute({super.key});

  @override
  State<FirstRoute> createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
  bool loggedin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choices'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            ElevatedButton(
              child: const Text('Text and DropDown'),
              onPressed: () {
                context.go('/textdropdown');
              },
            ),
            const SizedBox(height: 5),
            // path_provider package required
            ElevatedButton(
              child: const Text('CSV'),
              onPressed: () {
                context.go('/csv', extra: CounterStorage());
              },
            ),
            const SizedBox(height: 5),
            // path_provider package required
            ElevatedButton(
              child: const Text('Firebase login'),
              onPressed: () async {
                log.info('Firebase login Button Pressed');
                loggedin = await firebaseLoginController(context);
                if (!loggedin) {
                  log.info('loggedin == null $loggedin');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: const Text('Please login again'),
                      action: SnackBarAction(label: 'Close', onPressed: () {}),
                    ),
                  );
                } else {
                  log.info('loggedin != null $loggedin');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: const Text('You are logged in!'),
                      action: SnackBarAction(label: 'Close', onPressed: () {}),
                    ),
                  );
                }
              },
            ),
            ElevatedButton(
              child: const Text('Firebase data'),
              onPressed: () {
                if (loggedin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirestoreData()),
                  );
                } else {
                  log.severe('please login first');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: const Text('Please login first'),
                      action: SnackBarAction(label: 'Close', onPressed: () {}),
                    ),
                  );
                }
              },
            ),
            ElevatedButton(
              child: const Text('Firebase ListView'),
              onPressed: () {
                if (loggedin) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FirestoreListView()),
                  );
                } else {
                  log.severe('please login first');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: const Text('Please login first'),
                      action: SnackBarAction(label: 'Close', onPressed: () {}),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              child: const Text('ListViews'),
              onPressed: () {
                context.go('/listviews');
              },
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              child: const Text('Input'),
              onPressed: () {
                context.go('/expinput');
              },
            ),
            const SizedBox(height: 5),
            const Text(
              "直感的",
              style: TextStyle(
                fontFamily: 'MPLUSRounded',
                fontSize: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
