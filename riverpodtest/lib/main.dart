// cd projects/flutter-work/riverpodtest
//
// firebase emulators:start --import ./emulators_data --export-on-exit

// DONE: go_routerを別ファイルへ
// DONE: ホームを経費精算ホームへ
// DONE: hamburger menuでuidを移動
// DONE: user is workはユーザー名:workへ

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';

// import 'package:riverpodtest/expenceinputfs.dart';
// import 'package:riverpodtest/expencesscreenfs.dart';
// import 'package:riverpodtest/firebase_data_get.dart';
import 'package:riverpodtest/firebase_providers.dart';

import 'firebase_login.dart';
import 'firebase_options.dart';
import 'go_routers.dart';

final log = Logger('MainLogger');

// The route configuration.

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  initializeDateFormatting("ja");

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
      log.info(e);
    }
  }

  // Web.
  // await FirebaseFirestore.instance.enablePersistence();

  // All other platforms.
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// The main app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'MPLUSRounded',
      ),
      routerConfig: myRouter,
    );
  }
}

bool loggedin = false;

// The home screen
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userinstance = ref.watch(firebaseAuthProvider);
    // final authrepo = ref.watch(authRepositoryProvider);
    final authstatechanges = ref.watch(authStateChangesProvider);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.density_medium),
                tooltip: 'Show menu',
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: null,
                child: Text(
                    '${userinstance.currentUser != null ? userinstance.currentUser?.uid : "not login"}'),
              ),
              MenuItemButton(
                child: const Text('main'),
                onPressed: () {
                  log.info('main pressed');
                },
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
        title: const Text('経費精算ホーム'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              // 'user is ${ref.read(firebaseAuthProvider).authStateChanges()} '),
              authstatechanges.value == null
                  ? "ログインしてください"
                  : "ユーザー名 : ${userinstance.currentUser!.displayName!}",
            ),
            const SizedBox(
              height: 35,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
              ),
              onPressed: authstatechanges.value != null
                  ? null
                  : () async {
                      log.info('Firebase login Button Pressed');
                      loggedin = await firebaseLoginController(context);
                      if (!loggedin) {
                        log.info('loggedin == null $loggedin');
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 5),
                            content: const Text('Please login again'),
                            action: SnackBarAction(
                                label: 'Close', onPressed: () {}),
                          ),
                        );
                      } else {
                        log.info('loggedin != null $loggedin');
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 5),
                            content: const Text('You are logged in!'),
                            action: SnackBarAction(
                                label: 'Close', onPressed: () {}),
                          ),
                        );
                      }
                    },
              child: const Text('ログイン'),
            ),
            ElevatedButton(
              onPressed: authstatechanges.value == null
                  ? null
                  : () {
                      userinstance.signOut();
                    },
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
              ),
              child: const Text('ログアウト'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
              ),
              onPressed: authstatechanges.value == null
                  ? null
                  : () async {
                      if (userinstance.currentUser == null) {
                        loggedin = await firebaseLoginController(context);
                      } else {
                        context.go("/fbdataget");
                      }
                    },
              child: const Text('レポート一覧'),
            ),
          ],
        ),
      ),
    );
  }
}
