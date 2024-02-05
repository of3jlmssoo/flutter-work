import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:work/csv2.dart';

final log = Logger('CSVLogger');

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
    // return file.writeAsString('$counter',mode: FileMode.append);
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // if file does not exist, catched here
      log.info('readCounter() error ${e.toString()}');
      return 0;
    }
  }

  void deleteCounter() async {
    final file = await _localFile;
    if (file.existsSync()) {
      file.deleteSync();
      log.info('file deleted. $file');
    } else {
      log.info('file does not exist');
    }
  }
}

class CSV extends StatefulWidget {
  const CSV({super.key, required this.storage});

  final CounterStorage storage;

  @override
  State<CSV> createState() => _CSVState();
}

class _CSVState extends State<CSV> {
  // final Future<Directory> appDocumentsDir = getApplicationDocumentsDirectory();
  // Future<Directory?>? _appDocumentsDirectory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('simple CSV read and write int'),
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  widget.storage.readCounter().then((value) {
                    log.info('read $value');
                  });
                },
                child: const Text('read')),
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  widget.storage.writeCounter(3);
                },
                child: const Text('write 3')),
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  widget.storage.writeCounter(7);
                },
                child: const Text('write 7')),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                widget.storage.deleteCounter();
              },
              child: const Text('delete'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              child: const Text('CSV2'),
              onPressed: () {
                context.go('/csvSecond', extra: StrListStorage());
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => CSV2(storage: StrListStorage())),
                // );
              },
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                context.go('/');
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
