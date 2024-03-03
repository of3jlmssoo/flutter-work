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
          TextButton(
            onPressed: () {
              QuestionMeta qm = QuestionMeta(title, "10", questions);
              context.goNamed("questionmeta", extra: qm);
            },
            child: const Text('始める'),
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
    log.info('answers:$answers');
    return Scaffold(
      appBar: AppBar(title: Text(qm.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('${qm.qmap[qm.questionid]}'),
              Text(qm.qmap[qm.questionid]!.text,
                  style: Theme.of(context).textTheme.bodyLarge),
              QuestionBottom(qm: qm),
            ],
          ),
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
    log.info('runtimeType:${qm.qmap[qm.questionid].runtimeType}');
    return switch (qm.qmap[qm.questionid].runtimeType) {
      Type10 => type10Widget(context),
      Type20 => type2xWidget(qm: qm),
      Type21 => type2xWidget(qm: qm),
      Type50 => Type50Widget(qm: qm),
      Type60 => type60Widget(),
      Type70 => Column(
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
                log.info('Type70 answers:$answers');
              },
              child: const Text('送信'),
            ),
          ],
        ),
      Type() =>
        throw UnimplementedError(qm.qmap[qm.questionid].runtimeType.toString()),
    };
  }

  Column type10Widget(BuildContext context) {
    return Column(
      children: [
        // const Expanded(child: SizedBox()),
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
    log.info('two choices ${ab.questionid} ${ab.yesno} ${answers}');
  }
}

class Type50Widget extends StatelessWidget {
  final QuestionMeta qm;
  const Type50Widget({super.key, required this.qm});

  @override
  Widget build(BuildContext context) {
    late String userinput;
    return Column(
      children: [
        // Expanded(child: SizedBox()),
        Container(
          // width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  width: 1, color: Colors.black, style: BorderStyle.solid)),
          child: TextField(
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(
                hintText: 'ここに入力してください',
                contentPadding: EdgeInsets.all(15),
                border: InputBorder.none),
            onChanged: (value) {
              log.info('type50 -- $value');
              userinput = value;
            },
          ),
        ),
        // Expanded(child: SizedBox()),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            side: const BorderSide(),
          ),
          onPressed: () {
            AnswerType50 at50 = AnswerType50(qm.questionid, userinput);
            answers.add(at50);
            log.info('AnswerType50 : ${at50.questionid} ${at50.answerinput}');
            log.info('answers : $answers');

            QuestionMeta qmnext = QuestionMeta(
                qm.title, qm.qmap[qm.questionid]!.nexts[0], qm.qmap);
            log.info('qmnext title:${qmnext.title}');
            log.info('       next:${qmnext.qmap[qm.questionid]!.nexts[0]}');
            log.info('       qmap:${qmnext.qmap}');
            context.goNamed("questionmeta", extra: qmnext);
          },
          child: const Text('次へ'),
        ),
      ],
    );
  }
}

class type60Widget extends StatelessWidget {
  const type60Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [SizedBox(), Text('アプリを終了させてください')],
    );
  }
}

class type2xWidget extends StatefulWidget {
  const type2xWidget({
    super.key,
    required this.qm,
  });

  final QuestionMeta qm;

  @override
  State<type2xWidget> createState() => _type2xWidgetState();
}

class _type2xWidgetState extends State<type2xWidget> {
  final ScrollController _firstController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var isChecked =
        List.filled(widget.qm.qmap[widget.qm.questionid]!.choices.length, 0);

    return Column(
      children: [
        // const Expanded(child: SizedBox()),
        Scrollbar(
          thumbVisibility: true,
          controller: _firstController,
          thickness: 10,
          radius: const Radius.circular(10),
          scrollbarOrientation: ScrollbarOrientation.right,
          child: ListView(
            controller: _firstController,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            // itemExtent: 20,
            children: [
              for (var i = 0;
                  i < widget.qm.qmap[widget.qm.questionid]!.choices.length;
                  i++)
                StatefulBuilder(
                  builder: (context, _setState) => CheckboxListTile(
                    title: Text(
                        '${widget.qm.qmap[widget.qm.questionid]!.choices[i]}'),
                    value: isChecked[i] == 1 ? true : false,
                    onChanged: (bool? v) {
                      _setState(() {
                        // _isChecked[i] = value!;
                        log.info('value $v   ${isChecked[i]}');
                        isChecked[i] = v == true ? 1 : 0;
                        log.info('_isChecked : ${isChecked}');
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                )
            ],
          ),
        ),
        // const Expanded(child: SizedBox()),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            side: const BorderSide(),
          ),
          onPressed: () {
            List<int> selected = [];
            for (int i = 0; i < isChecked.length; i++) {
              if (isChecked[i] == 1) selected.add(i);
            }

            if (widget.qm.qmap[widget.qm.questionid].runtimeType == Type20) {
              AnswerType20 at20 = AnswerType20(widget.qm.questionid, selected);
              answers.add(at20);
              log.info('AnswerType20 : ${at20.questionid} ${at20.choices}');
              log.info('answers : $answers');
            }
            if (widget.qm.qmap[widget.qm.questionid].runtimeType == Type21) {
              AnswerType21 at21 = AnswerType21(widget.qm.questionid, selected);
              answers.add(at21);
              log.info('AnswerType20 : ${at21.questionid} ${at21.choices}');
              log.info('answers : $answers');
            }
            var questionType = widget.qm.qmap[widget.qm.questionid].runtimeType;
            if ((questionType == Type21 &&
                    isChecked.fold(0, (e, t) => e + t) > 0) ||
                (questionType == Type20 &&
                    isChecked.fold(0, (e, t) => e + t) == 1)) {
              log.info('${widget.qm.qmap[widget.qm.questionid]!.nexts}');
              QuestionMeta qmnext = QuestionMeta(
                  widget.qm.title,
                  widget.qm.qmap[widget.qm.questionid]!.nexts[0],
                  widget.qm.qmap);
              log.info('qmnext title:${qmnext.title}');
              log.info(
                  '       next:${qmnext.qmap[widget.qm.questionid]!.nexts[0]}');
              log.info('       qmap:${qmnext.qmap}');
              context.goNamed("questionmeta", extra: qmnext);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: questionType == Type20
                      ? const Text('1つだけご選択ください')
                      : const Text('少なくとも1つご選択ください'),
                  duration: const Duration(seconds: 2),
                ),
              );
              log.info('please select at least one');
            }
          },
          child: const Text('次へ'),
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
