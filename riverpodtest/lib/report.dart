// dart run build_runner build
import 'dart:core';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

enum Status {
  making(en: 'making', jp: '作成中'),
  submitted(en: 'submitted', jp: '申請済み'),
  other(en: 'other(paying)', jp: 'その他(支払い手続き中)');

  const Status({
    required this.en,
    required this.jp,
  });
  final String en;
  final String jp;
}

@freezed
class Report with _$Report {
  factory Report({
    required String userID,
    required String reportID,
    required String name,
    required DateTime createdDate,
    // required String Expence,
    required String col1,
    required int totalPrice,
    String? totalPriceStr,
    required Status status,
  }) = _Report;

  /// Convert a JSON object into an [Expence] instance.
  /// This enables type-safe reading of the API response.
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  // factory Report.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  //   SnapshotOptions? options,
  // ) {
  //   final data = snapshot.data();
  //   return Report(
  //     userID: data?['userID'],
  //     reportID: data?['reportID'],
  //     name: data?['name'],
  //     createdDate: data?['createdDate'],
  //     col1: data?['col1'],
  //     totalPrice: int.parse(data?['totalPriceStr']),
  //   );
  // }
  //
  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (userID != null) "userID": userID,
  //     if (reportID != null) "reportID": reportID,
  //     if (name != null) "name": name,
  //     if (createdDate != null) "createdDate": createdDate,
  //     if (col1 != null) "col1": col1,
  //     if (totalPrice != null) "totalPriceStr": totalPrice.toString(),
  //   };
  // }
}
