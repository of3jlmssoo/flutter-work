import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';
import 'package:riverpodtest/expences.dart';
import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'expence.dart';
import 'expenceproviders.dart';
import 'firestore_calc_totalprice.dart';
import 'report.dart';

// TODO:firebase/firestore見直し

var uuid = const Uuid();
final log = Logger('ExpenceInputLogger');

Expence expence = Expence(
  userID: 'dummyuserid',
  reportID: 'dummyreportid',
  id: 'dumyyid',
  createdDate: DateTime.now(),
  expenceDate: DateTime.now(),
  expenceType: ExpenceType.transportation.id,
  taxType: TaxType.invoice.id,
);

class ExpenceInputFs extends ConsumerStatefulWidget {
  // go_routerでの受け渡しのため日付、金額もStringで定義
  final String reportID;
  final String userID;
  final String id;
  final String? expenceTypeName;
  final String? taxTypeName;
  // DateTime? createdDate;
  // DateTime? expenceDate;
  final String col1;
  final String col2;
  final String col3;
  // final int? price;
  final String invoiceNumber;
  final String reportName;
  final String reportStatus;

  final String createdDateStr;
  final String expenceDateStr;
  final String priceStr;

  const ExpenceInputFs({
    super.key,
    required this.reportID,
    required this.userID,
    required this.id,
    required this.createdDateStr,
    this.expenceTypeName,
    this.taxTypeName,
    this.expenceDateStr = "",
    this.col1 = "",
    this.col2 = "",
    this.col3 = "",
    this.priceStr = "",
    this.invoiceNumber = "",
    required this.reportName,
    required this.reportStatus,
  });

  @override
  ExpenceInputState createState() => ExpenceInputState();
}

class ExpenceInputState extends ConsumerState<ExpenceInputFs> {
  final _priceFieldController = TextEditingController(
      text: expence.price != null ? expence.price.toString() : '');

  int initialPrice = 0;

  @override
  void initState() {
    super.initState();

    log.info('initState() : widget.expenceTypeName ${widget.expenceTypeName}');
    log.info('initState() : widget.taxTypeName ${widget.taxTypeName}');

    log.info('initState() : ${widget.createdDateStr} ${widget.expenceDateStr}');

    expence = expence.copyWith(
      userID: widget.userID,
      reportID: widget.reportID,
      id: widget.id,
      createdDate: DateTime.parse(widget.createdDateStr),
      expenceType: int.tryParse(widget.expenceTypeName!),
      expenceDate: DateTime.parse(widget.expenceDateStr),
      taxType: int.tryParse(widget.taxTypeName!),
    );
    // if (widget.priceStr != null) {
    log.info('initState() : widget.priceStr : ${widget.priceStr}');

    if (widget.priceStr != "") {
      expence = expence.copyWith(price: int.parse(widget.priceStr));
      initialPrice = expence.price!;
    } else {
      expence = expence.copyWith(
          price: null); // to make the field blank in case of new record
    }

    log.info('initState() : expence.price : ${expence.price}');

    expence = expence.copyWith(col1: widget.col1);

    expence = expence.copyWith(col2: widget.col2);

    expence = expence.copyWith(col3: widget.col3);

    expence = expence.copyWith(invoiceNumber: widget.invoiceNumber);

    log.info('initState() : ${expence.toString()}');
  }

  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  DateTime expenceDate = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;

  final DateTime _date = DateTime.now();

  static const List<String> taxTypeList = <String>['one', 'two', 'Three', '直'];

  var expenceTypeDefault =
      <String?>[ExpenceType.values.map((e) => e.name).toList().first].first;
  var taxTypeDefault =
      <String?>[TaxType.values.map((e) => e.name).toList().first].first;

  @override
  Widget build(BuildContext context) {
    // final tt = ref.watch(currentTaxTypeProvider);
    // final ed = ref.watch(currentExpenceDateProvider);
    // final pr = ref.watch(currentPriceProvider);
    // final et = ref.watch(currentExpenceTypeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back, color: Colors.black),
          onTap: () => Router.neglect(context, () {
            context.goNamed(
              "expencescreenfs",
              queryParameters: {
                'reportID': widget.reportID,
                'userID': widget.userID,
                'reportName': widget.reportName,
                'reportStatus': widget.reportStatus.toString(),
              },
            );
          }),
        ),
        title: const Text(
          '経費入力(FS)',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('${widget.reportStatus}'),
                      const Text(
                        // '経費種別 ${expence.expenceType} ${ExpenceType.values.toList().elementAt(expence.expenceType).name}',
                        '経費種別',
                      ),

                      DropdownMenu<String>(
                        enabled: widget.reportStatus == Status.making.en
                            ? true
                            : false,
                        trailingIcon:
                            const Icon(Icons.arrow_drop_down, size: 10),
                        inputDecorationTheme: InputDecorationTheme(
                          isDense: true,
                          // contentPadding:
                          //     const EdgeInsets.symmetric(horizontal: 16),
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(45)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // textStyle: const TextStyle(fontSize: 14),
                        textStyle: const TextStyle(
                          fontSize: 12,
                        ),

                        // initialSelection: ExpenceType.values.toList().elementAt(expence.expenceType!),

                        initialSelection: ExpenceType.values
                            .toList()
                            .elementAt(expence.expenceType!)
                            .name,

                        onSelected: (String? value) {
                          log.info('DropdownMenu : 経費種別0 value:$value');
                          log.info(
                              'DropdownMenu : 経費種別1 ${expence.expenceType}');

                          late int epType;
                          for (var type in ExpenceType.values) {
                            if (value == type.name) {
                              epType = type.index;
                              break;
                            }
                          }
                          log.info('DropdownMenu : 経費種別2 $epType');
                          expence = expence.copyWith(expenceType: epType);
                          log.info('DropdownMenu : 経費種別2 --------');
                          ref
                              .read(currentExpenceTypeProvider.notifier)
                              .expenceType(epType);
                          log.info(
                              'DropdownMenu : 経費種別4 ${expence.expenceType}');
                          log.info(
                              'DropdownMenu : 経費種別5 ${expence.toString()}');
                        },
                        dropdownMenuEntries: ExpenceType.values
                            .map((e) => e.name)
                            .toList()
                            .map<DropdownMenuEntry<String>>((String? value) {
                          return DropdownMenuEntry<String>(
                              style: ButtonStyle(
                                  textStyle: MaterialStateTextStyle.resolveWith(
                                      (states) => const TextStyle(
                                            fontSize: 10,
                                          ))),
                              value: value!,
                              label: value);
                        }).toList(),
                      ),
                      // ),
                      const SizedBox(height: 20),
                      const Text(
                        '日付',
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(intl.DateFormat.yMd()
                                  .format(expence.expenceDate!)),
                            ],
                          ),
                          TextButton(
                            onPressed: widget.reportStatus != Status.making.en
                                ? null
                                : () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (selectedDate != null) {
                                      expence = expence.copyWith(
                                          expenceDate: selectedDate);
                                      ref
                                          .read(currentExpenceDateProvider
                                              .notifier)
                                          .expenceDate(selectedDate);
                                      log.info('日付指定 : ${expence.toString()}');
                                      log.info(
                                          '日付指定 : ${DateTime.now().toString()}');
                                      log.info(
                                          '日付指定 : ${DateTime.parse(DateTime.now().toString())}');
                                    }
                                  },
                            child: const Text(
                              '日付指定',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InputDetailsFs(reportStatus: widget.reportStatus),
                      const SizedBox(height: 20),
                      const Text(
                        '金額',
                      ),

                      TextFormField(
                        readOnly: widget.reportStatus == Status.making.en
                            ? false
                            : true,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              num.tryParse(value) == null) {
                            return '半角数字を入力してください';
                          }
                          return null;
                        },
                        initialValue: expence.price == null
                            ? ''
                            : expence.price.toString(),
                        // controller: _priceFieldController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          // filled: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          expence = expence.copyWith(price: int.parse(value));
                        },
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'メモ',
                      ),
                      TextFormField(
                        readOnly: widget.reportStatus == Status.making.en
                            ? false
                            : true,
                        initialValue: expence.col3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          expence = expence.copyWith(col3: value);
                          log.info('メモ : ${expence.toString()}');
                        },
                        maxLines: 5,
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        '税タイプ',
                      ),
                      DropdownMenu<String>(
                        enabled: widget.reportStatus == Status.making.en
                            ? true
                            : false,
                        trailingIcon:
                            const Icon(Icons.arrow_drop_down, size: 10),
                        inputDecorationTheme: InputDecorationTheme(
                          isDense: true,
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(45)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        initialSelection: TaxType.values
                            .toList()
                            .elementAt(expence.taxType!)
                            .name,
                        onSelected: (String? value) {
                          late TaxType tType;
                          for (var type in TaxType.values) {
                            if (value == type.name) {
                              tType = type;
                              log.info('TaxType = $tType');
                              break;
                            }
                          }
                          expence = expence.copyWith(taxType: tType.id);
                          ref
                              .read(currentTaxTypeProvider.notifier)
                              .taxType(tType.id);
                          log.info('TaxType : ${expence.toString()}');
                        },
                        dropdownMenuEntries: TaxType.values
                            .map((e) => e.name)
                            .toList()
                            .map<DropdownMenuEntry<String>>((String? value) {
                          return DropdownMenuEntry<String>(
                              style: ButtonStyle(
                                  textStyle: MaterialStateTextStyle.resolveWith(
                                      (states) => const TextStyle(
                                            fontSize: 10,
                                            // fontFamily: 'MPLUSRounded',
                                          ))),
                              value: value!,
                              label: value);
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      Visibility(
                        visible: expence.taxType == TaxType.invoice.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('インボイス番号'),
                            TextFormField(
                              readOnly: widget.reportStatus == Status.making.en
                                  ? false
                                  : true,
                              validator: (value) {
                                if (expence.taxType == TaxType.invoice.index &&
                                        (value == null || value.isEmpty) ||
                                    value?.length != 3 ||
                                    num.tryParse(value!) == null) {
                                  return 'インボイス番号(3桁)を入力してください';
                                }
                                return null;
                              },
                              initialValue: expence.invoiceNumber,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                expence =
                                    expence.copyWith(invoiceNumber: value);
                                log.info('InvoiceNum : ${expence.toString()}');
                              },
                              // maxLines: 5,
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: widget.reportStatus != Status.making.en
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(expenceListProvider.notifier)
                                      .addExpence(expence);

                                  log.info(
                                      'add/update :expence.expenceType:${expence.expenceType}');
                                  log.info(
                                      'add/update : expence.expenceType:${expence.expenceType}');

                                  var db = FirebaseFirestore.instance;
                                  log.info('expenceinput add/update1 : $db');
                                  log.info(
                                      'expenceinput add/update2 : ${widget.userID}');
                                  log.info(
                                      'expenceinput add/update3 : ${widget.reportID}');
                                  final expenceRef = db
                                      .collection('users')
                                      .doc(widget.userID)
                                      .collection('reports')
                                      .doc(widget.reportID)
                                      .collection('expences')
                                      .withConverter(
                                        fromFirestore: Expence.fromFirestore,
                                        toFirestore:
                                            (Expence expence, options) =>
                                                expence.toFirestore(),
                                      )
                                      .doc(widget.id);
                                  await expenceRef.set(expence);
                                  // if (initialPrice != expence.price) {
                                  //   final priceRef = db
                                  //       .collection("users")
                                  //       .doc(widget.userID)
                                  //       .collection('reports')
                                  //       .doc(widget.reportID)
                                  //       .collection('expences');
                                  //   washingtonRef.update({"capital": true}).then(
                                  //       (value) => print(
                                  //           "DocumentSnapshot successfully updated!"),
                                  //       onError: (e) =>
                                  //           print("Error updating document $e"));
                                  // }

                                  int result = await calcTotalPrice(
                                      widget.userID, widget.reportID);
                                  log.info('add/update total price is $result');

                                  log.info('expenceinputfs : before goNamed');
                                  if (!context.mounted) {
                                    return;
                                  } else {
                                    context.goNamed(
                                      "expencescreenfs",
                                      queryParameters: {
                                        'reportID': widget.reportID,
                                        'userID': widget.userID,
                                        'reportName': widget.reportName,
                                        'reportStatus':
                                            widget.reportStatus.toString(),
                                      },
                                    );
                                  }
                                  _priceFieldController.clear();
                                }
                              },
                        child: const Text('追加/更新'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          log.info('logExpence : ${expence.toString()}');
                        },
                        child: const Text('入力データ確認'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputDetailsFs extends ConsumerWidget {
  const InputDetailsFs({super.key, required this.reportStatus});
  final String reportStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etype = ref.watch(currentExpenceTypeProvider);
    // log.info('expenceinputfs : etype $etype');
    if (etype == ExpenceType.transportation.index) {
      return Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '乗車地',
                ),
                TextFormField(
                  readOnly: reportStatus == Status.making.en ? false : true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "乗車地を入力してください";
                    }
                    return null;
                  },
                  initialValue: expence.col1,
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('col1(then) : input: value:$value');
                    expence = expence.copyWith(col1: value);
                    log.info('col1(then) : ${expence.toString()}');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '降車地',
                ),
                TextFormField(
                  readOnly: reportStatus == Status.making.en ? false : true,
                  validator: (value) {
                    if (expence.expenceType ==
                            ExpenceType.transportation.index &&
                        (value == null || value.isEmpty)) {
                      return "降車地を入力してください";
                    }
                    return null;
                  },
                  initialValue: expence.col2,
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('col2 : input: value:$value');
                    expence = expence.copyWith(col2: value);
                    log.info('col2 : ${expence.toString()}');
                  },
                ),
              ],
            ),
          ),
          // SizedBox(width: 5),
          const SizedBox(width: 0),
          SizedBox(
            height: 60,
            width: 23,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    log.info("favorite pressed");
                  },
                  iconSize: 23,
                  icon: const Icon(Icons.favorite_border, size: 25),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '費用項目',
                ),
                TextFormField(
                  readOnly: reportStatus == Status.making.en ? false : true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "費用項目を入力してください";
                    }
                    return null;
                  },
                  initialValue: expence.col1,
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('input: 費用項目value:$value');
                    log.info('col1(else) : input: value:$value');
                    expence = expence.copyWith(col1: value);
                    log.info('col1(else) : ${expence.toString()}');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),
        ],
      );
    }
  }
}
