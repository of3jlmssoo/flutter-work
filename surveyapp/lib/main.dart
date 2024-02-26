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

import 'answers.dart';
import 'questions.dart';

final log = Logger('MainLogger');

List<AnswerBlock> answers = [];

class QuestionMeta {
  final String title;
  final String questionid;
  final Map<String, QuestionBlock> qmap;
  QuestionMeta(this.title, this.questionid, this.qmap);
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      name: 'questionmeta',
      path: '/questionmeta',
      builder: (context, state) {
        QuestionMeta sample = state.extra as QuestionMeta;
        return QuestionMain(qm: sample);
      },
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
  final Map<String, QuestionBlock> questions;

  @override
  Widget build(BuildContext context) {
    final (title, :modified) = document.metadata;

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
                child: const Text('getBlocks()'),
              ),
              MenuItemButton(
                onPressed: () {
                  for (var b in questions.values) {
                    log.info('${b.questionid} ${b.text}');
                  }
                },
                child: const Text('document'),
              ),
              MenuItemButton(
                onPressed: () {
                  AnswerBlock ab1 = AnswerType10("10", true);
                  log.info('${ab1.runtimeType} ${ab1.toJson()}');
                  AnswerBlock ab2 = AnswerType40("41", ["10"]);
                  log.info('${ab2.runtimeType} ${ab2.toJson()}');
                  log.info('${this.runtimeType.toString()}');
                  log.info('${title}');
                  log.info('answer checked');
                },
                child: const Text('answer check'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                QuestionMeta qm = QuestionMeta(title, "10", questions);
                context.goNamed("questionmeta", extra: qm);
              },
              child: const Text('始める'),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionMain extends StatelessWidget {
  final QuestionMeta qm;
  const QuestionMain({
    super.key,
    required this.qm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(qm.title)),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Text(qm.qmap[qm.questionid]!.text,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Flexible(flex: 2, child: QuestionBottom(qm: qm)),
          ],
        ),
      ),
    );
  }
}

class QuestionBottom extends StatelessWidget {
  final QuestionMeta qm;
  const QuestionBottom({
    super.key,
    required this.qm,
  });

  @override
  Widget build(BuildContext context) {
    return switch (qm.qmap[qm.questionid].runtimeType) {
      Type10 => type10Widget(context),
      Type21 => type21Widget(qm: qm),
      Type60 => type60Widget(),
      Type() =>
        throw UnimplementedError(qm.qmap[qm.questionid].runtimeType.toString()),
    };
  }

  Column type10Widget(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: SizedBox()),
        Row(
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
              onPressed: () {
                twoChoices(context, 1);
              },
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
              onPressed: () {
                twoChoices(context, 0);
              },
              child: const Text('はい'),
            ),
          ],
        ),
      ],
    );
  }

  void twoChoices(BuildContext context, int i) {
    log.info('${qm.qmap[qm.questionid]!.nexts}');
    QuestionMeta qmnext =
        QuestionMeta(qm.title, qm.qmap[qm.questionid]!.nexts[i], qm.qmap);
    context.goNamed("questionmeta", extra: qmnext);
    AnswerBlock ab = AnswerType10(qm.questionid, i == 0 ? true : false);
    answers.add(ab);
    log.info('two choices ${ab.questionid} ${ab.yesno}');
  }
}

class type60Widget extends StatelessWidget {
  const type60Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Expanded(child: SizedBox()), Text('アプリを終了させてください')],
    );
  }
}

class type21Widget extends StatelessWidget {
  const type21Widget({
    super.key,
    required this.qm,
  });

  final QuestionMeta qm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 4,
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 10,
            radius: const Radius.circular(10),
            scrollbarOrientation: ScrollbarOrientation.right,
            child: ListView(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              // itemExtent: 20,
              children: [
                for (var i = 0; i < qm.qmap[qm.questionid]!.choices.length; i++)
                  CheckboxListTile(
                    title: Text('${qm.qmap[qm.questionid]!.choices[i]}'),
                    value: false, //_isChecked[i],
                    onChanged: (bool? value) {
                      // setState(() {
                      //   _isChecked[i] = value!;
                      // });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  )
              ],
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
        Flexible(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              side: const BorderSide(),
            ),
            onPressed: () {
              log.info('${qm.qmap[qm.questionid]!.nexts}');
              QuestionMeta qmnext = QuestionMeta(
                  qm.title, qm.qmap[qm.questionid]!.nexts[0], qm.qmap);
              context.goNamed("questionmeta", extra: qmnext);
            },
            child: const Text('はい'),
          ),
        )
      ],
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final QuestionBlock questionblock;

  const QuestionWidget({
    required this.questionblock,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Text('abc'),
    );
  }
}
