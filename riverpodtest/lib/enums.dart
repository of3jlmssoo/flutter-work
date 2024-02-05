enum TaxType {
  invoice,
  standardNoReceipt,
  others,
}

extension TaxTypeExt on TaxType {
  String get name {
    switch (this) {
      case TaxType.invoice:
        return 'インボイス対象';
      case TaxType.standardNoReceipt:
        return 'レシート無し対象';
      case TaxType.others:
        return 'その他';
    }
  }

  int get id {
    switch (this) {
      case TaxType.invoice:
        return TaxType.invoice.index;
      case TaxType.standardNoReceipt:
        return TaxType.standardNoReceipt.index;
      case TaxType.others:
        return TaxType.others.index;
    }
  }
}

enum ExpenceType {
  transportation,
  others,
  test,
}

extension ExpenceTypeExt on ExpenceType {
  String get name {
    switch (this) {
      case ExpenceType.transportation:
        return '交通費';
      case ExpenceType.others:
        return 'その他';
      case ExpenceType.test:
        return 'テスト(直)';
    }
  }

  static final ids = {
    ExpenceType.transportation: ExpenceType.transportation.index,
    ExpenceType.others: ExpenceType.others.index,
    ExpenceType.test: ExpenceType.test.index,
  };

  int? get id => ids[this];
}

String getExpenceType(int i) {
  switch (i) {
    case 1:
      return ExpenceType.others.name;
    case 2:
      return ExpenceType.test.name;
    default:
      return ExpenceType.transportation.name;
  }
}
