### read line by line

#### learn dart

https://dart-tutorial.com/file-handling-in-dart/read-file-in-dart/

```dart
https://stackoverflow.com/questions/21813401/reading-file-line-by-line-in-dart

import 'dart:async';
import 'dart:io';
import 'dart:convert';

main() {
  var path = ...;
  File(path)
    .openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter())
    .forEach((l) => print('line: $l'));
}

or
https://stackoverflow.com/questions/20815913/how-to-read-a-file-line-by-line-in-dart

I think this code is useful:

import 'dart:io';
import 'dart:convert';
import 'dart:async';

main() {
  final file = new File('file.txt');
  Stream<List<int>> inputStream = file.openRead();

  inputStream
    .transform(utf8.decoder)       // Decode bytes to UTF-8.
    .transform(new LineSplitter()) // Convert stream to individual lines.
    .listen((String line) {        // Process results.
        print('$line: ${line.length} bytes');
      },
      onDone: () { print('File is now closed.'); },
      onError: (e) { print(e.toString()); });
}
```

```dart
  File file = File('test.txt');
  // check if file exists
  if (file.existsSync()) {
    // delete file
    file.deleteSync();
    print('File deleted.');
  } else {
    print('File does not exist.');
  }
```
