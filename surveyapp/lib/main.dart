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
  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     home: SurveyMenu(),
  //   );
  // }
}

// class SurveyMenu extends StatefulWidget {
//   const SurveyMenu({super.key});
//
//   @override
//   State<SurveyMenu> createState() => _SurveyMenuState();
// }
//
// class _SurveyMenuState extends State<SurveyMenu> with TickerProviderStateMixin {
//   late AnimationController controller;
//
//   final Document document = Document();
//
//   var i = 0.0;
//
//   @override
//   void initState() {
//     controller = AnimationController(
//       /// [AnimationController]s can be created with `vsync: this` because of
//       /// [TickerProviderStateMixin].
//       vsync: this,
//       duration: const Duration(seconds: 120),
//     )..addListener(() {
//         setState(() {});
//       });
//     controller.repeat(reverse: true);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           MenuAnchor(
//             builder: (BuildContext context, MenuController controller,
//                 Widget? child) {
//               return IconButton(
//                 onPressed: () {
//                   if (controller.isOpen) {
//                     controller.close();
//                   } else {
//                     controller.open();
//                   }
//                 },
//                 icon: const Icon(Icons.density_medium),
//                 tooltip: 'Show menu',
//               );
//             },
//             menuChildren: [
//               MenuItemButton(
//                 onPressed: null,
//                 child: Text('text'),
//               ),
//               MenuItemButton(
//                 child: const Text('main'),
//                 onPressed: () {
//                   log.info('main pressed');
//                 },
//               )
//             ],
//           ),
//         ],
//         title: const Text('投資に関するアンケート'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(1.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             LinearProgressIndicator(
//               // value: controller.value,
//               value: i,
//               semanticsLabel: 'Linear progress indicator',
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   i = i + 0.1;
//                   // log.info('document : ${document.getBlocks()}');
//                   document.getBlocks();
//                 },
//                 child: const Text('Forward')),
//             ElevatedButton(
//                 onPressed: () {
//                   i = i - 0.1;
//                 },
//                 child: const Text('Backward')),
//             Text('${i.toString()}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  HomeScreen({super.key});
  final Document document = Document();
  late List<Block> questions;

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
                  for (var q in questions) {
                    log.info('--------------------------------------------');
                    BlockWidget(block: q);
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
          onPressed: () {},
          child: const Text('Go to the Details screen'),
        ),
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({
    required this.block,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: switch (block) {
        Type70(:final comment, :final questionid, :final text) =>
          Text('type 70'),
        Type50(:final comment, :final questionid, :final text, :final nexts) =>
          Text('type 50'),
        Type31(
          :final comment,
          :final questionid,
          :final text,
          :final choices,
          :final nexts
        ) =>
          Text('type 31'),
        Type40(
          :final comment,
          :final questionid,
          :final text,
          :final values,
          :final nexts
        ) =>
          Text('type 40'),
        Type30(
          :final comment,
          :final questionid,
          :final text,
          :final choices,
          :final nexts
        ) =>
          Text('type 30'),
        Type20(
          :final comment,
          :final questionid,
          :final text,
          :final choices,
          :final nexts
        ) =>
          Text('type 20'),
        Type21(
          :final comment,
          :final questionid,
          :final text,
          :final choices,
          :final nexts
        ) =>
          Text('type 21'),
        Type60(:final comment, :final questionid, :final text, :final nexts) =>
          Text('type 60'),
        Type10(:final comment, :final questionid, :final text, :final nexts) =>
          Text('type 10'),

        // HeaderBlock(:final text) => Text(
        //   text,
        //   style: Theme.of(context).textTheme.displayMedium,
        // ),
        // ParagraphBlock(:final text) => Text(text),
        // CheckboxBlock(:final text, :final isChecked) => Row(
        //   children: [
        //     Checkbox(value: isChecked, onChanged: (_) {}),
        //     Text(text),
        //   ],
        // ),
        // TODO: Handle this case.
        Type31() => null,
        // TODO: Handle this case.
        Type40() => null,
      },
    );
  }
}
