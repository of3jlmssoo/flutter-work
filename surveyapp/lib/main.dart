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
  final List<Block> questions;
  // final List<Block> questions = document.getBlocks();

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
                  final List<Block> questions = document.getBlocks();
                  for (int i = 0; i < questions.length; i++) {
                    log.info('--------------------------------------------');
                    log.info(questions[i].runtimeType == Type21
                        ? questions[i].choices
                        : 'not Type21');
                    QuestionWidget(questionblock: questions[i]);
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
      body: Center(
        child: ElevatedButton(
          // onPressed: () => context.go('/details'),
          onPressed: () {
            // final List<Block> questions = document.getBlocks();
            // QuestionWidget(questionblock: questions[0]);
          },
          child: Text('${questions[0].text}'),
        ),
      ),
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
