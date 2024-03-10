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
