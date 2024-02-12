// TODO : プログレスバーの処理 計算で処理する
// TODO : JSON処理 metadata(サンプルそのまま)
// TODO : JSON処理 questionsパート
// TODO : JSONをインプットにしたUI
// TODO : firestoreへ送付

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('MainLogger');

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  runApp(const SurveyApp());
}

class SurveyApp extends StatelessWidget {
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SurveyMenu(),
    );
  }
}

class SurveyMenu extends StatefulWidget {
  const SurveyMenu({super.key});

  @override
  State<SurveyMenu> createState() => _SurveyMenuState();
}

class _SurveyMenuState extends State<SurveyMenu> with TickerProviderStateMixin {
  late AnimationController controller;

  var i = 0.0;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 120),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: Text('text'),
              ),
              MenuItemButton(
                child: const Text('main'),
                onPressed: () {
                  log.info('main pressed');
                },
              )
            ],
          ),
        ],
        title: const Text('投資に関するアンケート'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LinearProgressIndicator(
              // value: controller.value,
              value: i,
              semanticsLabel: 'Linear progress indicator',
            ),
            ElevatedButton(
                onPressed: () {
                  i = i + 0.1;
                },
                child: const Text('Forward')),
            ElevatedButton(
                onPressed: () {
                  i = i - 0.1;
                },
                child: const Text('Backward')),
            Text('${i.toString()}'),
          ],
        ),
      ),
    );
  }
}
