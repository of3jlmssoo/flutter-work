// dart run build_runner watch

// @riverpod
// class ReportList extends _$ReportList {
//   @override
//   Future<List<Todo>> build() async => [/* ... */];

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

// import 'firebase_providers.dart';
import 'report.dart';

part 'reports.g.dart';

var uuid = const Uuid();

@Riverpod(keepAlive: true)
class ReportList extends _$ReportList {
  // final userID = uuid.v7();
  @override
  List<Report> build() => [
        Report(
          userID: FirebaseAuth.instance.currentUser!.uid,
          name: "2023年10月国内交通費精算",
          createdDate: DateTime.now(),
          col1: "col1",
          totalPrice: 1,
          reportID: uuid.v7(),
          status: Status.making,
        ),
        Report(
          userID: FirebaseAuth.instance.currentUser!.uid,
          name: "2023年11月国内交通費精算",
          createdDate: DateTime.now(),
          col1: "col2",
          totalPrice: 2,
          reportID: uuid.v7(),
          status: Status.making,
        )
      ];

  void addReport(Report report) {
    state = [
      ...state,
      report,
    ];
  }

  void removeReport(Report target) {
    state =
        state.where((report) => report.reportID != target.reportID).toList();
  }
}
