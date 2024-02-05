import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

final log = Logger('CSV2Logger');

class StrListStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/entries.csv');
  }

  Future<File> writeCSV(String str, FileMode mode) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(str, mode: mode);
    // return file.writeAsString('$counter',mode: FileMode.append);
  }

  Future<List<List<dynamic>>> readCSV() async {
    try {
      final file = await _localFile;

      Stream<List<int>> inputStream = file.openRead();

      List<List> importList = [];

      // Read lines one by one, and split each ','
      await inputStream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (String line) {
          importList.add(line.split(','));
        },
      ).asFuture();

      return importList;
      // Read the file
      // final contents = await file.readAsString();
      // List<String> result = contents.split('\n');
      // log.info('readCSV() $result');

      // return result;
    } catch (e) {
      // if file does not exist, catched here
      log.info('readCounter() error ${e.toString()}');
      return <List>[];
    }
  }

  void deleteFile() async {
    final file = await _localFile;
    if (file.existsSync()) {
      file.deleteSync();
      log.info('file deleted. $file');
    } else {
      log.info('file does not exist');
    }
  }
}

class CSV2 extends StatefulWidget {
  const CSV2({super.key, required this.storage});

  final StrListStorage storage;

  @override
  State<CSV2> createState() => _CSV2State();
}

class _CSV2State extends State<CSV2> {
  // final Future<Directory> appDocumentsDir = getApplicationDocumentsDirectory();
  // Future<Directory?>? _appDocumentsDirectory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV String List'),
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  log.info('write ab,12,cd (FileMode.write)');
                  String str0 = 'ab';
                  String str1 = '12';
                  String str2 = 'cd';
                  widget.storage
                      .writeCSV('$str0,$str1,$str2\n', FileMode.write);
                },
                child: const Text('write ab,12,cd (FileMode.write)')),
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  log.info('write ab,12,cd (FileMode.append)');
                  String str0 = 'ab';
                  String str1 = '12';
                  String str2 = 'cd';
                  widget.storage
                      .writeCSV('$str0,$str1,$str2\n', FileMode.append);
                },
                child: const Text('write ab,12,cd (FileMode.append)')),
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  log.info('write bc,23,de (FileMode.append)');
                  String str0 = 'bc';
                  String str1 = '23';
                  String str2 = 'de';
                  widget.storage
                      .writeCSV('$str0,$str1,$str2\n', FileMode.append);
                },
                child: const Text('write bc,23,de (FileMode.append)')),
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  log.info('write cd,34,ef (FileMode.append)');
                  String str0 = 'cd';
                  String str1 = '34';
                  String str2 = 'ef';
                  widget.storage
                      .writeCSV('$str0,$str1,$str2\n', FileMode.append);
                },
                child: const Text('write cd,34,ef (FileMode.append)')),
            const SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  widget.storage
                      .readCSV()
                      .then((value) => log.info('read() $value'));
                },
                child: const Text('read')),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                log.info('delete the file');
                widget.storage.deleteFile();
              },
              child: const Text('delete'),
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
