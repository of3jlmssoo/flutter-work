// dart run build_runner build
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// import 'enums.dart';

part 'expence.freezed.dart';
part 'expence.g.dart';

@freezed
class Expence with _$Expence {
  const Expence._();
  factory Expence({
    required String userID,
    required String reportID,
    required String id,
    required DateTime createdDate,
    // ExpenceType? expenceType,
    int? expenceType,
    DateTime? expenceDate,
    String? col1,
    String? col2,
    String? col3,
    int? price,
    // TaxType? taxType,
    int? taxType,
    String? invoiceNumber,
  }) = _Expence;

  factory Expence.fromJson(Map<String, dynamic> json) =>
      _$ExpenceFromJson(json);

  factory Expence.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Expence(
      userID: data?['userID'],
      reportID: data?['reportID'],
      id: data?['id'],
      createdDate: data?['createdDate'],
      expenceType: data?['expenceType'],
      expenceDate: data?['expenceDate'],
      col1: data?['col1'],
      col2: data?['col2'],
      col3: data?['col3'],
      price: data?['price'],
      taxType: data?['taxType'],
      invoiceNumber: data?['invoiceNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userID": userID,
      "reportID": reportID,
      "id": id,
      "createdDate": createdDate,
      if (expenceType != null) "expenceType": expenceType,
      if (expenceDate != null) "expenceDate": expenceDate,
      if (col1 != null) "col1": col1,
      if (col2 != null) "col2": col2,
      if (col3 != null) "col3": col3,
      if (price != null) "price": price,
      if (taxType != null) "taxType": taxType,
      if (invoiceNumber != null) "invoiceNumber": invoiceNumber,
    };
  }
}
