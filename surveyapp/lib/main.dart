// firebase emulators:start --import ./emulators_data --export-on-exit

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:surveyapp/providers.dart';

import 'answers.dart';
import 'firebase_login.dart';
import 'firebase_options.dart';
import 'firebase_providers.dart';
import 'questions.dart';

bool loggedin = false;

final log = Logger('MainLogger');

// List<AnswerBlock> answers = [];
Map<String, AnswerBlock> answers = {};

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

  runApp(const ProviderScope(child: SurveyApp()));
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

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key}) : questions = Document().getBlocks();
  final Document document = Document();
  // final List<Block> questions;
  final Map<String, QuestionBlock> questions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final (title, :modified) = document.metadata;
    final (title, modified: _) = document.metadata;
    final authstatechanges = ref.watch(authStateChangesProvider);
    final userinstance = ref.watch(firebaseAuthProvider);

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
                child: const Text('check questions'),
              ),
              MenuItemButton(
                onPressed: () {
                  answers.forEach((key, value) {
                    var answerType = value.runtimeType;
                    switch (answerType) {
                      case const (AnswerType10) ||
                            const (AnswerType60) ||
                            const (AnswerType70):
                      case const (AnswerType20) || const (AnswerType21):
                      case const (AnswerType30) || const (AnswerType31):
                      case const (AnswerType40):
                      case const (AnswerType50):
                    }
                  });
                },
                child: const Text('answer check'),
              ),
              MenuItemButton(
                onPressed: () {
                  questions.forEach((key, value) {
                    var questionType = value.runtimeType;
                    switch (questionType) {
                      case const (Type10) || const (Type60) || const (Type70):
                        FirebaseFirestore.instance
                            .collection(value.questionid)
                            .doc("answers")
                            .collection("yes")
                            .count()
                            .get()
                            .then(
                              (res) => log.info(
                                  'Q(T10/60/70) questionid:${value.questionid} yes count:${res.count}'),
                              onError: (e) => log.info(
                                  "Q(T10/60/70) Error query questions item: $e"),
                            );
                        FirebaseFirestore.instance
                            .collection(value.questionid)
                            .doc("answers")
                            .collection("no")
                            .count()
                            .get()
                            .then(
                              (res) => log.info(
                                  'Q(T10/60/70) questionid:${value.questionid} no  count:${res.count}'),
                              onError: (e) => log.info(
                                  "Q(T10/60/70) Error query questions item: $e"),
                            );

                      case const (Type20) || const (Type21):
                        final int num = value.choices.length;
                        for (int i = 0; i < num; i++) {
                          log.info(
                              'Q(T20/21) questionid:${value.questionid} $i');
                          FirebaseFirestore.instance
                              .collection(value.questionid)
                              .doc("answers")
                              .collection(i.toString())
                              .count()
                              .get()
                              .then(
                                (res) => log.info(
                                    'Q(T20/21) questionid:${value.questionid} answer:$i  count:${res.count}'),
                                onError: (e) => log.info(
                                    "Q(T20/21)  Error query questions item: $e"),
                              );
                        }

                      case const (Type30) || const (Type31):
                        final int num = value.choices.length;
                        for (int i = 0; i < num; i++) {
                          log.info(
                              'Q(T30/31) questionid:${value.questionid} $i');
                          FirebaseFirestore.instance
                              .collection(value.questionid)
                              .doc("answers")
                              .collection(i.toString())
                              .count()
                              .get()
                              .then(
                                (res) => log.info(
                                    'Q(T30/31) questionid:${value.questionid} answer:$i  count:${res.count}'),
                                onError: (e) => log.info(
                                    "Q(T30/31)  Error query questions item: $e"),
                              );
                        }
                        FirebaseFirestore.instance
                            .collection(value.questionid)
                            .doc("answers")
                            .collection("others")
                            .get()
                            .then(
                          (querySnapshot) {
                            log.info(
                                "--> Q(T30/31) Successfully completed ${value.questionid} ${querySnapshot.docs}");
                            for (var docSnapshot in querySnapshot.docs) {
                              log.info(
                                  '--> Q(T30/31) ${docSnapshot.id} => ${docSnapshot.data()}');
                            }
                            log.info(
                                "--> Q(T30/31) Successfully completed ${value.questionid}");
                          },
                          onError: (e) =>
                              log.info("--> Q(T30/31) Error completing: $e"),
                        );

                      case const (Type40):
                      case const (Type50):
                    }
                  });
                },
                child: const Text('query questions item'),
              ),
              MenuItemButton(
                onPressed: () {
                  questions.forEach((key, value) {
                    var questionType = value.runtimeType;
                    switch (questionType) {
                      case const (Type10) || const (Type60) || const (Type70):
                      case const (Type20) || const (Type21):
                      case const (Type30) || const (Type31):
                      case const (Type40):
                      case const (Type50):
                    }
                  });
                },
                child: const Text('query questions item 2'),
              ),
              MenuItemButton(
                child: const Text('check if existing after login'),
                onPressed: () {
                  checkAnswered(userinstance, context);
                },
              ),
              MenuItemButton(
                child: const Text('Query data'),
                onPressed: () {
                  log.info('query data');
                  FirebaseFirestore.instance
                      .collection("10")
                      .doc("answers")
                      .collection("yes")
                      .where("email",
                          isEqualTo: userinstance.currentUser!.email)
                      .get()
                      .then(
                    (querySnapshot) {
                      log.info("query data --> Successfully completed");
                      for (var docSnapshot in querySnapshot.docs) {
                        log.info(
                            'query data --> ${docSnapshot.id} => ${docSnapshot.data()}');
                      }
                    },
                    onError: (e) => print("Error completing: $e"),
                  );
                },
              ),
              MenuItemButton(
                child: const Text('delete data'),
                onPressed: () {
                  log.info('delete data');

                  log.info('keys : ${questions.keys}');
                  for (var k in questions.keys) {
                    log.info('delete --> ${questions[k].runtimeType}');
                    switch (questions[k].runtimeType) {
                      case const (Type10) || const (Type60) || const (Type70):
                        log.info('delete --> AnswerType10/60/70 ');
                      case const (Type50):
                        log.info('delete --> AnswerType50 ');
                      case const (Type30) || const (Type31):
                        log.info(
                            'delete --> AnswerType30/31 ${userinstance.currentUser!.email}');

                        FirebaseFirestore.instance
                            .collection("30")
                            .doc("answers")
                            .collection("2")
                            .doc(userinstance.currentUser!.email)
                            .delete()
                            .then(
                              (doc) => log.info(
                                  "Document deleted 30/answers/2/${userinstance.currentUser!.email}"),
                              onError: (e) => log.info(
                                  "Error delete a document 30/answers/2/${userinstance.currentUser!.email} $e"),
                            );
                      case const (Type20) || const (Type21) || const (Type40):
                        // log.info(
                        //     'delete --> AnswerType20/21/40 ${questions[k]!.choices.length}');
                        log.info('delete --> AnswerType20/21/40');
                    }
                  }

                  // deleteFireStoreType2021
                  //
                  // String List<dynamic> choices
                  // AnswerType20
                  // AnswerType21
                  ///////////////////////
                  // 30: Instance of 'Type20',
                  // 20: Instance of 'Type21',
                  // 21: Instance of 'Type21',

                  // deleteFireStoreType40
                  //
                  // String List<dynamic> values
                  // AnswerType40
                  ///////////////////////
                  // 41: Instance of 'Type40',

                  // deleteFireStoreType3031 calls delete202140
                  //
                  // String List<dynamic> String
                  // AnswerType30
                  // AnswerType31
                  ///////////////////////
                  // 42: Instance of 'Type31',

                  // deleteFireStoreType50
                  //
                  // String String
                  // AnswerType50
                  ///////////////////////
                  // 50: Instance of 'Type50',

                  // deleteFireStoreType106070
                  //
                  // String and bool
                  // AnswerType60
                  // AnswerType70
                  // AnswerType10
                  ///////////////////////
                  // 11: Instance of 'Type60',
                  // 60: Instance of 'Type70'}
                  // 10: Instance of 'Type10',
                  // 40: Instance of 'Type10',
                  // deleteFireStoreType106070(userinstance, "11", "yes");
                  // deleteFireStoreType106070(userinstance, "11", "no");
                  // deleteFireStoreType106070(userinstance, "60", "yes");
                  // deleteFireStoreType106070(userinstance, "60", "no");
                  // deleteFireStoreType106070(userinstance, "10", "yes");
                  // deleteFireStoreType106070(userinstance, "10", "no");
                  // deleteFireStoreType106070(userinstance, "40", "yes");
                  // deleteFireStoreType106070(userinstance, "40", "no");
                },
              ),
              MenuItemButton(
                child: const Text('Query Count'),
                onPressed: () async {
                  log.info('Query Count');
                  FirebaseFirestore.instance
                      .collection("30")
                      .doc('answers')
                      .collection('2')
                      .count()
                      .get()
                      .then(
                        (res) => log.info('Query Count : ${res.count}'),
                        onError: (e) => log.info("Query Count Error: $e"),
                      );

                  log.info('Query all');
                  QuerySnapshot snapshot = await FirebaseFirestore.instance
                      .collectionGroup("yes")
                      .get();

                  for (int i = 0; i < snapshot.docs.length; i++) {
                    log.info('Query all : ${snapshot.docs[i].data()}');
                  }

                  for (var doc in snapshot.docs) {
                    Map<String, dynamic>? data =
                        doc.data() as Map<String, dynamic>;
                    log.info('Query all : ${data["email"]}');
                  }
                },
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
            Visibility(
              visible: authstatechanges.value == null ? true : false,
              child: ElevatedButton(
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
            ),
            Visibility(
              visible: authstatechanges.value == null ? false : true,
              child: ElevatedButton(
                onPressed: authstatechanges.value == null
                    ? null
                    : () {
                        // userinstance.signOut();
                        checkAnswered(userinstance, context);
                        QuestionMeta qm = QuestionMeta(title, "10", questions);
                        context.goNamed("questionmeta", extra: qm);
                      },
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text('始める'),
              ),
            ),
            Visibility(
              visible: authstatechanges.value == null ? false : true,
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }

  void deleteFireStoreType106070(
      FirebaseAuth userinstance, String questionid, String val) {
    FirebaseFirestore.instance
        .collection(questionid)
        .doc("answers")
        .collection(val)
        .doc(userinstance.currentUser!.email)
        .delete()
        .then(
          (doc) => log.info(
              "Document deleted $questionid $val ${userinstance.currentUser!.email}"),
          onError: (e) => log.info(
              "Error delete document  $questionid $val ${userinstance.currentUser!.email} $e"),
        );
  }

  void checkAnswered(FirebaseAuth userinstance, BuildContext context) {
    log.info(
        'check if existing after login : ${userinstance.currentUser!.email}');

    FirebaseFirestore.instance
        .collection("USERS")
        .doc(userinstance.currentUser!.email)
        .get()
        .then(
      (doc) {
        if (!doc.exists) {
          FirebaseFirestore.instance
              .collection("USERS")
              .doc(userinstance.currentUser!.email)
              .set({
            "email": userinstance.currentUser!.email,
          }).catchError((_) {
            log.info("user check not successful!");
          });
        } else {
          log.info('already answered');

          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('ご回答済み'),
              content:
                  const Text('既にご回答済みです。ご回答を削除しますか？\n\n削除しない場合このまま終了してください'),
              actions: <Widget>[
                // const TextButton(
                //   // onPressed: () => Navigator.pop(context, 'Cancel'),
                //   onPressed: null,
                //   // onPressed: () => Navigator.pop(context, 'Cancel'),
                //   child: Text('削除せず終わる'),
                // ),
                TextButton(
                  // TODO: データ削除処理
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("USERS")
                        .doc(userinstance.currentUser!.email)
                        .delete()
                        .then(
                          (doc) => log.info(
                              "Document deleted USERS ${userinstance.currentUser!.email}"),
                          onError: (e) => log.info(
                              "Error delete document USERS ${userinstance.currentUser!.email} $e"),
                        );
                    GoRouter.of(context).pop();
                  },
                  child: const Text('削除する'),
                ),
              ],
            ),
          );
        }
      },
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

class QuestionBottom extends StatefulWidget {
  final QuestionMeta qm;
  const QuestionBottom({
    super.key,
    required this.qm,
  });

  @override
  State<QuestionBottom> createState() => _QuestionBottomState();
}

class _QuestionBottomState extends State<QuestionBottom> {
  double _currentSliderValue = 50;
  @override
  Widget build(BuildContext context) {
    log.info('runtimeType:${widget.qm.qmap[widget.qm.questionid].runtimeType}');
    return switch (widget.qm.qmap[widget.qm.questionid].runtimeType) {
      const (Type10) => type10Widget(context),
      const (Type20) => Type2x3xWidget(qm: widget.qm),
      const (Type21) => Type2x3xWidget(qm: widget.qm),
      const (Type31) => Type2x3xWidget(qm: widget.qm),
      const (Type40) => (Column(
          children: [
            // Text('Type40'),
            const SizedBox(height: 30),
            Slider(
              value: _currentSliderValue,
              min: double.parse(
                  widget.qm.qmap[widget.qm.questionid]!.values[0].toString()),
              max: double.parse(
                  widget.qm.qmap[widget.qm.questionid]!.values[1].toString()),
              divisions: widget.qm.qmap[widget.qm.questionid]?.values[2],
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(
                  () {
                    _currentSliderValue = value;
                  },
                );
                log.info('_QuestionBottomState --> $_currentSliderValue');
              },
            ),
            Text('薦める度 : $_currentSliderValue'),
            const Text(
              '(全く勧めない:0 〜 強く勧める:100)',
              style: TextStyle(color: Colors.grey),
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
                AnswerType40 at40 = AnswerType40(
                    widget.qm.questionid, [_currentSliderValue.toInt()]);
                answers[widget.qm.questionid] = at40;
                log.info('AnswerType40 : ${at40.questionid} ${at40.value}');
                log.info('answers : $answers');
                QuestionMeta qmnext = QuestionMeta(
                    widget.qm.title,
                    // TODO: now always selext the first choice
                    // widget.qm.qmap[widget.qm.questionid]!.nexts[0],
                    widget.qm.qmap[widget.qm.questionid]!.nexts[0],
                    widget.qm.qmap);
                log.info('qmnext title:${qmnext.title}');
                log.info(
                    '       next:${qmnext.qmap[widget.qm.questionid]!.nexts[0]}');
                log.info('       qmap:${qmnext.qmap}');
                context.goNamed("questionmeta", extra: qmnext);
              },
              child: const Text('次へ'),
            ),
          ],
        )),
      const (Type50) => Type50Widget(qm: widget.qm),
      const (Type60) => const Type60Widget(),
      const (Type70) => const Type70Widget(),
      Type() => throw UnimplementedError(
          widget.qm.qmap[widget.qm.questionid].runtimeType.toString()),
    };
  }

  Column type10Widget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // const Expanded(child: SizedBox()),
        const SizedBox(height: 20),
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
    log.info('${widget.qm.qmap[widget.qm.questionid]!.nexts}');
    QuestionMeta qmnext = QuestionMeta(widget.qm.title,
        widget.qm.qmap[widget.qm.questionid]!.nexts[i], widget.qm.qmap);
    context.goNamed("questionmeta", extra: qmnext);
    AnswerBlock ab = AnswerType10(widget.qm.questionid, i == 0 ? true : false);
    // answers.add(ab);
    answers[widget.qm.questionid] = ab;
    log.info('two choices ${ab.questionid} ${ab.yesno} $answers');
  }
}

class Type70Widget extends ConsumerWidget {
  const Type70Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userinstance = ref.watch(firebaseAuthProvider);
    final sendResult = ref.watch(sendProvider);
    return Column(
      children: [
        const SizedBox(height: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            side: const BorderSide(),
          ),
          onPressed: sendResult
              ? null
              : () {
                  log.info('Type70 answers:$answers');
                  answers.forEach(
                    (key, value) {
                      log.info(
                          'key $key and value $value and ${value.runtimeType}');
                      var answerType = value.runtimeType;
                      switch (answerType) {
                        case const (AnswerType10):
                          log.info(
                              '$answerType ${value.questionid} ${value.yesno}');
                          addDocumentType10(
                              answerType.toString(),
                              userinstance,
                              value.questionid,
                              value.yesno == true ? "yes" : "no");

                        case const (AnswerType20) || const (AnswerType21):
                          log.info(
                              '$answerType ${value.questionid} ${value.choices}');
                          addDocumentType2x3x(answerType.toString(),
                              userinstance, value.questionid, value.choices);

                        case const (AnswerType30) || const (AnswerType31):
                          log.info(
                              '$answerType ${value.questionid} add${value.choices}  ${value.answerinput}');
                          addDocumentType2x3x(
                              answerType.toString(),
                              userinstance,
                              value.questionid,
                              value.choices,
                              value.answerinput);

                        // Todo: addDocumentType40
                        case const (AnswerType40):
                          log.info(
                              '$answerType ${value.questionid} ${value.value}');
                          addDocumentType40(answerType.toString(), userinstance,
                              value.questionid, value.value[0]);

                        // Todo: addDocumentType50
                        case const (AnswerType50):
                          log.info(
                              '$answerType ${value.questionid} ${value.answerinput}');
                          addDocumentType50(answerType.toString(), userinstance,
                              value.questionid, value.answerinput);
                        // case const (AnswerType70):
                        //   log.info('${value.questionid} ${value.done}');

                        // Todo: addDocumentType6070
                        case const (AnswerType60) || const (AnswerType70):
                          log.info(
                              '$answerType ${value.questionid} ${value.done}');

                        default:
                          throw const FormatException(
                              'Invalid when sending data to firestore');
                      }
                    },
                  );
                  ref.read(sendProvider.notifier).sent();
                },
          child: const Text('送信'),
        ),
      ],
    );
  }

  // Todo: process for type30 and type31
  void addDocumentType2x3x(String answerType, FirebaseAuth userinstance,
      String questionid, List<dynamic> values,
      [String answerinput = '']) {
    for (var v in values) {
      FirebaseFirestore.instance
          .collection(questionid)
          .doc("answers")
          .collection(v.toString())
          .doc(userinstance.currentUser!.email)
          .set({
        "email": userinstance.currentUser!.email,
      }).onError((e, _) => log.info(
              "Error writing document: $answerType $questionid $values $e"));
    }

    log.info(
        'addDocumentType2x3x--> $questionid / answers / $answerinput / ${userinstance.currentUser!.email}');
    if ((answerType == "AnswerType30" || answerType == "AnswerType31") &&
        answerinput.isNotEmpty) {
      FirebaseFirestore.instance
          .collection(questionid)
          .doc("answers")
          .collection("others")
          .doc(answerinput)
          .set({
        "ticker": answerinput,
      }).onError((e, _) => log.info(
              "Error writing document: $answerType $questionid $values $e"));
      FirebaseFirestore.instance
          .collection(questionid)
          .doc("answers")
          .collection("others")
          .doc(answerinput)
          .collection("ids")
          .doc(userinstance.currentUser!.email)
          .set({
        "email": userinstance.currentUser!.email,
      }).onError((e, _) => log.info(
              "Error writing document: $answerType $questionid $values $e"));
    }
  }

  void addDocumentType40(String answerType, FirebaseAuth userinstance,
      String questionid, int value) {
    FirebaseFirestore.instance
        .collection(questionid)
        .doc("answers")
        .collection(value.toString())
        .doc(userinstance.currentUser!.email)
        .set({
      "email": userinstance.currentUser!.email,
    }).onError((e, _) => log
            .info("Error writing document: $answerType $questionid $value $e"));
  }

  void addDocumentType50(String answerType, FirebaseAuth userinstance,
      String questionid, String answerinput) {
    FirebaseFirestore.instance
        .collection(questionid)
        .doc("answers")
        .collection(userinstance.currentUser!.email as String)
        .doc(userinstance.currentUser!.email)
        .set({
      "email": userinstance.currentUser!.email,
      "answerinput": answerinput,
    }).onError((e, _) => log.info(
            "Error writing document: $answerType $questionid $answerinput $e"));
  }

  void addDocumentType10(String answerType, FirebaseAuth userinstance,
      String questionid, String yesno) {
    FirebaseFirestore.instance
        .collection(questionid)
        .doc("answers")
        .collection(yesno)
        .doc(userinstance.currentUser!.email)
        .set({
      "email": userinstance.currentUser!.email,
    }).onError((e, _) => log
            .info("Error writing document: $answerType $questionid $yesno $e"));
  }
}

class Type50Widget extends StatelessWidget {
  final QuestionMeta qm;
  const Type50Widget({super.key, required this.qm});

  @override
  Widget build(BuildContext context) {
    late String userinput = '';
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
        const SizedBox(height: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            side: const BorderSide(),
          ),
          onPressed: () {
            // ignore: unnecessary_null_comparison
            if (userinput.isNotEmpty) {
              AnswerType50 at50 = AnswerType50(qm.questionid, userinput);
              // answers.add(at50);
              answers[qm.questionid] = at50;
              log.info('AnswerType50 : ${at50.questionid} ${at50.answerinput}');
              log.info('answers : $answers');

              QuestionMeta qmnext = QuestionMeta(
                  qm.title, qm.qmap[qm.questionid]!.nexts[0], qm.qmap);
              log.info('qmnext title:${qmnext.title}');
              log.info('       next:${qmnext.qmap[qm.questionid]!.nexts[0]}');
              log.info('       qmap:${qmnext.qmap}');
              context.goNamed("questionmeta", extra: qmnext);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('入力をお願いします'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('次へ'),
        ),
      ],
    );
  }
}

class Type60Widget extends StatelessWidget {
  const Type60Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [SizedBox(), Text('アプリを終了させてください')],
    );
  }
}

class Type2x3xWidget extends ConsumerStatefulWidget {
  const Type2x3xWidget({
    super.key,
    required this.qm,
  });

  final QuestionMeta qm;

  @override
  ConsumerState<Type2x3xWidget> createState() => _Type2x3xWidgetState();
}

class _Type2x3xWidgetState extends ConsumerState<Type2x3xWidget> {
  final ScrollController _firstController = ScrollController();
  @override
  Widget build(BuildContext context) {
    String userinputTicker = '';
    var isChecked =
        List.filled(widget.qm.qmap[widget.qm.questionid]!.choices.length, 0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        log.info('_isChecked : $isChecked');
                      });
                      log.info('-------> ${isChecked.last}');
                      // isChecked.last == 1
                      //     ? ref.read(type31InputProvider.notifier).toTrue()
                      //     : ref.read(type31InputProvider.notifier).toFalse();
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Type3xの場合、銘柄入力欄を表示する
        Visibility(
          visible: (widget.qm.qmap[widget.qm.questionid].runtimeType ==
                      Type30) ||
                  (widget.qm.qmap[widget.qm.questionid].runtimeType == Type31)
              ? true
              : false,
          child: Container(
            // width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    width: 1, color: Colors.black, style: BorderStyle.solid)),
            child: TextField(
              minLines: 1,
              maxLines: 1,
              decoration: const InputDecoration(
                  hintText: '一番好きな銘柄をここに入力してください',
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none),
              onChanged: (value) {
                log.info('type50 -- $value');
                userinputTicker = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        // const Expanded(child: SizedBox()),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            side: const BorderSide(),
          ),

          // 次へボタンが押された場合、次の画面へ遷移する
          onPressed: () {
            List<int> selected = [];
            for (int i = 0; i < isChecked.length; i++) {
              if (isChecked[i] == 1) selected.add(i);
            }

            if (widget.qm.qmap[widget.qm.questionid].runtimeType == Type20) {
              AnswerType20 at20 = AnswerType20(widget.qm.questionid, selected);
              answers[widget.qm.questionid] = at20;
              log.info('AnswerType20 : ${at20.questionid} ${at20.choices}');
              log.info('answers : $answers');
            }
            if (widget.qm.qmap[widget.qm.questionid].runtimeType == Type21) {
              AnswerType21 at21 = AnswerType21(widget.qm.questionid, selected);
              answers[widget.qm.questionid] = at21;
              log.info('AnswerType20 : ${at21.questionid} ${at21.choices}');
              log.info('answers : $answers');
            }
            if (widget.qm.qmap[widget.qm.questionid].runtimeType == Type30) {
              AnswerType30 at30 =
                  AnswerType30(widget.qm.questionid, selected, userinputTicker);
              answers[widget.qm.questionid] = at30;
              log.info(
                  'AnswerType30 : ${at30.questionid} ${at30.choices} ${at30.answerinput}');
              log.info('answers : $answers');
            }
            if (widget.qm.qmap[widget.qm.questionid].runtimeType == Type31) {
              AnswerType31 at31 =
                  AnswerType31(widget.qm.questionid, selected, userinputTicker);
              answers[widget.qm.questionid] = at31;
              log.info(
                  'AnswerType31 : ${at31.questionid} ${at31.choices} ${at31.answerinput}');
              log.info('answers : $answers');
            }
            var questionType = widget.qm.qmap[widget.qm.questionid].runtimeType;

            if ((questionType == Type21 &&
                    isChecked.fold(0, (e, t) => e + t) > 0) ||
                (questionType == Type20 &&
                    isChecked.fold(0, (e, t) => e + t) == 1) ||
                (questionType == Type31 &&
                    isChecked.fold(0, (e, t) => e + t) > 0 &&
                    (isChecked.last == 1
                        ? userinputTicker.length > 0
                        : true)) ||
                (questionType == Type30 &&
                    isChecked.fold(0, (e, t) => e + t) == 1 &&
                    (isChecked.last == 1
                        ? userinputTicker.length > 0
                        : true))) {
              log.info(
                  'nexts          : ${widget.qm.qmap[widget.qm.questionid]!.nexts}');
              log.info('isChecked : $isChecked');

              final int next =
                  widget.qm.qmap[widget.qm.questionid]!.nexts.length == 1
                      ? 0
                      : isChecked.indexOf(1);

              QuestionMeta qmnext = QuestionMeta(
                  widget.qm.title,
                  // TODO: now always selext the first choice
                  // widget.qm.qmap[widget.qm.questionid]!.nexts[0],
                  widget.qm.qmap[widget.qm.questionid]!.nexts[next],
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
      child: const Text('abc'),
    );
  }
}
