// dart run build_runner build --delete-conflicting-outputs

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class Type31Input extends _$Type31Input {
  @override
  bool build() => false;

  void toTrue() => state = true;
  void toFalse() => state = false;
}

@riverpod
class Send extends _$Send {
  @override
  bool build() {
    return false;
  }

  void sent() => state = true;

  // Add methods to mutate the state
}
