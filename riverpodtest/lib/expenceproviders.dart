import 'package:intl/intl.dart' as intl;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpodtest/enums.dart';

part 'expenceproviders.g.dart';

@riverpod
class CurrentTaxType extends _$CurrentTaxType {
  @override
  int? build() {
    return TaxType.invoice.id;
  }

  void taxType(int tt) {
    state = tt;
  }

  String? name(int i) {
    switch (i) {
      case 0:
        return TaxType.invoice.name;
      case 1:
        return TaxType.standardNoReceipt.name;
      case 2:
        return TaxType.others.name;
      default:
        return 'default value';
    }
  }
}

@riverpod
class CurrentExpenceType extends _$CurrentExpenceType {
  @override
  int? build() {
    return ExpenceType.transportation.id;
  }

  void expenceType(int et) {
    state = et;
  }
}

@riverpod
// @Riverpod(keepAlive: true)
class CurrentExpenceDate extends _$CurrentExpenceDate {
  @override
  String build() {
    return intl.DateFormat.yMd().format(DateTime.now());
  }

  void expenceDate(DateTime dt) {
    state = intl.DateFormat.yMd().format(dt);
  }
}

@riverpod
class CurrentPrice extends _$CurrentPrice {
  @override
  int? build() {
    return null;
  }

  void price(int? price) {
    state = price;
  }
}
