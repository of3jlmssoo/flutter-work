// dart run build_runner watch

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';

import 'expence.dart';
import 'package:collection/collection.dart';
part 'expences.g.dart';

final log = Logger('Expences');

const uuid = Uuid();

@Riverpod(keepAlive: true)
class ExpenceList extends _$ExpenceList {
  @override
  List<Expence> build() => [];

  void addExpence(Expence expence) {
    state = state.where((report) => report.id != expence.id).toList();

    log.info('addExpence1 : $state');
    log.info('addExpence2 : ${expence.reportID}');

    state = [
      ...state,
      expence,
    ];
    state = state.sorted((a, b) => a.expenceDate!.compareTo(b.expenceDate!));
  }

  void removeReport(Expence expence) {
    state = state.where((report) => report.id != expence.id).toList();
  }
}
