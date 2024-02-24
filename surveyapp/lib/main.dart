// TODO : プログレスバーの処理 計算で処理する
// DONE : JSON decode処理 metadata(サンプルそのまま)
// DONE : JSON decode処理 questionsパート
// TODO : JSONをインプットにしたUI (初期画面)
// TODO : JSONをインプットにしたUI (2つ目以降。gorouter組み込み)
// TODO : firestore collection/doc構成決定
// TODO : firebase/firestore emulator構成
// TODO : firestoreへ送付
// TODO : graphic package

// MEMO : DateTimeはエンコードする時にtoIso8601String()でISO8601形式の文字列に変換する

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import 'questions.dart';

final log = Logger('MainLogger');

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            return HomeScreen();
          },
        ),
      ],
    ),
  ],
);

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
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) : questions = Document().getBlocks();
  final Document document = Document();
  // final List<Block> questions;
  final Map<String, Block> questions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Home Screen')

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
                onPressed: () {
                  document.getBlocks();
                },
                child: Text('getBlocks()'),
              ),
              MenuItemButton(
                onPressed: () {
                  // final List<Block> questions = document.getBlocks();
                  // var qkeys = questions.keys;
                  // for (int i = 0; i < uestions.length; i++) {
                  log.info('--------------------------------------------');
                  for (var b in questions.values) {
                    log.info('${b.values} ${b.text}');
                    //   log.info(questions[i].runtimeType == Type21
                    //       ? questions[i].choices
                    //       : 'not Type21');
                    //   QuestionWidget(questionblock: questions[i]);
                    log.info('============================================');
                  }
                },
                child: Text('document'),
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
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: QuestionMain(
          questions: questions,
        ),
        // questions: questions.values.toList(), type: questions["10"]!.type),
      ),
    );
  }
}

class QuestionMain extends StatelessWidget {
  const QuestionMain({
    super.key,
    required this.questions,
    // required this.type,
  });

  // final List<Block> questions;
  final Map<String, Block> questions;
  // final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // SizedBox(
        //   height: 250,
        // ),
        Flexible(
          child: Text(questions["10"]!.text,
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        Flexible(child: QuestionBottom()),
      ],
    );
  }
}

class QuestionBottom extends StatelessWidget {
  const QuestionBottom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            side: const BorderSide(),
          ),
          onPressed: () {},
          child: const Text('いいえ'),
        ),
        const SizedBox(
          width: 30,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            side: const BorderSide(),
          ),
          onPressed: () {},
          child: const Text('はい'),
        ),
      ],
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final Block questionblock;

  const QuestionWidget({
    required this.questionblock,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Text('abc'),
      // child: switch (questionblockblock) {
      //   HeaderBlock(:final text) => Text(
      //       text,
      //       style: Theme.of(context).textTheme.displayMedium,
      //     ),
      //   ParagraphBlock(:final text) => Text(text),
      //   CheckboxBlock(:final text, :final isChecked) => Row(
      //       children: [
      //         Checkbox(value: isChecked, onChanged: (_) {}),
      //         Text(text),
      //       ],
      //     ),
      // },
    );
  }
}
