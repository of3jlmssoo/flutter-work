import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:riverpodtest/expences.dart';
import 'package:uuid/uuid.dart';

import 'enums.dart';
import 'expence.dart';
import 'expenceproviders.dart';
import 'firebase_providers.dart';
import 'firestore_calc_totalprice.dart';
import 'report.dart';

// DONE: typo修正 expencesscrees to expencesscreens
// DONE: 申請済みであることが分かるようにする
// DONE: disableされたfloatingactionbuttonとレポート申請の背景色が違うので揃える
// TODO:firebase/firestore見直し

final log = Logger('ExpencesScreenFs');
// final _currentExpence = Provider<Expence>((ref) => throw UnimplementedError());
var uuid = const Uuid();

class ExpencesScreenFs extends ConsumerWidget {
  const ExpencesScreenFs({
    super.key,
    required this.reportID,
    required this.userID,
    required this.reportName,
    required this.reportStatus,
  });
  final String reportID;
  final String userID;
  final String reportName;
  final String reportStatus;

  void addNewExpence(
      WidgetRef ref, FirebaseAuth userinstance, BuildContext context) {
    log.info('addNewExpence() : reportStatus is $reportStatus');
    ref
        .read(currentExpenceTypeProvider.notifier)
        .expenceType(ExpenceType.transportation.id!);

    ref.read(currentTaxTypeProvider.notifier).taxType(TaxType.invoice.id);

    ref.read(currentPriceProvider.notifier).price(null);
    context.goNamed(
      "expenceinputfs",
      queryParameters: {
        'reportID': reportID,
        'userID': userinstance.currentUser!.uid,
        'id': uuid.v7(),
        'createdDateStr': DateTime.now().toString(),
        'expenceDateStr': DateTime.now().toString(),
        'expenceTypeName': ExpenceType.transportation.index.toString(),
        'taxTypeName': TaxType.invoice.index.toString(),
        // 'priceStr': '',
        'col1': '',
        'col2': '',
        'col3': '',
        'invoicenumber': '',
        'reportName': reportName,
        'priceStr': '',
        'status': Status.making.en,
      },
    );
  }

  void addTestData(WidgetRef ref, FirebaseAuth userinstance) async {
    log.info(
        'addTestData() : ref.watch(expenceListProvider) is ${ref.watch(expenceListProvider)}');
    log.info(
        'addTestData() : ExpenceType.others.id is ${ExpenceType.others.id}');

    var testExpence = Expence(
        userID: userinstance.currentUser!.uid,
        reportID: reportID,
        id: uuid.v7(),
        createdDate: DateTime.now(),
        expenceDate: DateTime.now().subtract(const Duration(days: 10)),
        expenceType: ExpenceType.others.id,
        price: 123,
        col1: '物品を購入したという申請',
        col3: 'しかし、それが何かについてどこに記載するのか',
        taxType: TaxType.invoice.id,
        invoiceNumber: '123');
    ref.read(expenceListProvider.notifier).addExpence(testExpence);

    var db = FirebaseFirestore.instance;

    log.info(
        'addTestData() : userID is ${testExpence.userID} and uid is ${userinstance.currentUser!.uid}');

    final expenceRef = db
        .collection('users')
        .doc(testExpence.userID)
        .collection('reports')
        .doc(testExpence.reportID)
        .collection('expences')
        .withConverter(
          fromFirestore: Expence.fromFirestore,
          toFirestore: (Expence expence, options) => expence.toFirestore(),
        )
        .doc(testExpence.id);
    await expenceRef.set(testExpence);

    testExpence = Expence(
      userID: userinstance.currentUser!.uid,
      reportID: reportID,
      id: uuid.v7(),
      createdDate: DateTime.now(),
      expenceDate: DateTime.now().subtract(const Duration(days: 20)),
      expenceType: ExpenceType.transportation.id,
      price: 456,
      col1: '東京の東京駅のそばの大手町',
      col2: '神奈川東京千葉埼玉',
      col3: 'なんのための交通費か。電車かバスかタクシーか',
      taxType: TaxType.standardNoReceipt.id,
    );
    ref.read(expenceListProvider.notifier).addExpence(testExpence);
    final expenceRef2 = db
        .collection('users')
        .doc(testExpence.userID)
        .collection('reports')
        .doc(testExpence.reportID)
        .collection('expences')
        .withConverter(
          fromFirestore: Expence.fromFirestore,
          toFirestore: (Expence expence, options) => expence.toFirestore(),
        )
        .doc(testExpence.id);
    await expenceRef2.set(testExpence);

    int result = await calcTotalPrice(testExpence.userID, testExpence.reportID);
    log.info('addTestData() : total price is $result');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userinstance = ref.watch(firebaseAuthProvider);

    final Stream<QuerySnapshot> expencesStream =
        // FirebaseFirestore.instance.collection('cities').snapshots();
        FirebaseFirestore.instance
            .collection('users')
            .doc(userinstance.currentUser!.uid)
            .collection('reports')
            .doc(reportID)
            .collection('expences')
            .snapshots();

    // int totalPrice = 0;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.density_medium),
                tooltip: 'Show menu',
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: reportStatus != Status.making.en
                    ? null
                    : () {
                        log.info('menuitembutton : テストデータ追加');
                        addTestData(ref, userinstance);
                      },
                child: const Text('テストデータ追加'),
              ),
              MenuItemButton(
                child: const Text('expencesscreens'),
                onPressed: () {
                  log.info('menuitembutton : expencesscrees pressed');
                },
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(//'${reportName.substring(start)}'),
                reportName.substring(
                    0, reportName.length > 14 ? 14 : reportName.length)),

            // Icon(Icons.add),
          ],
        ),
      ),
      body: Column(
        children: [
          // Text('$totalPrice'),
          ElevatedButton(
            onPressed: () => context.go('/fbdataget'),
            child: const Text('レポート一覧へ'),
          ),
          reportStatus != Status.making.en
              ? const Text('ステータス : 申請済み')
              : ElevatedButton(
                  onPressed: reportStatus != Status.making.en
                      ? null
                      : () {
                          final reportRef = FirebaseFirestore.instance
                              .collection("users")
                              .doc(userID)
                              .collection('reports')
                              .doc(reportID);
                          // reportRef.update({"status": Status.submitted.name}).then(
                          reportRef.update({
                            "status": Status.submitted.en
                          }).then(
                              (value) => log.info(
                                  "update Status : DocumentSnapshot successfully updated!"),
                              onError: (e) => log.info(
                                  "update Status : Error updating document $e"));
                          context.go('/fbdataget');
                        },
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text('レポート申請'),
                ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: expencesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('expencesStream Something went wrong');
                } else {
                  log.info('StreamBuilder : StreamBuilder has no error');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading (経費情報待ち)");
                } else {
                  log.info('StreamBuilder : Not waiting');
                }
                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Dismissible(
                          direction: reportStatus == Status.making.en
                              ? DismissDirection.horizontal
                              : DismissDirection.none,
                          key: ValueKey(data["id"]),
                          onDismissed: (_) async {
                            log.info(
                                "Dismissible : uuid $userID ${data["reportID"]} ${data["id"]}");
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(userID)
                                .collection("reports")
                                .doc(data["reportID"])
                                .collection("expences")
                                .doc(data["id"])
                                .delete()
                                .then(
                                  (doc) => log
                                      .info("Dismissible : Document deleted"),
                                  onError: (e) => log.info(
                                      "Dismissible : Error updating document $e"),
                                );
                            int result = await calcTotalPrice(
                                data["userID"], data["reportID"]);
                            log.info('Dismissible total price is $result');
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(
                                '${getExpenceType(data["expenceType"])} ${intl.DateFormat.yMMMd('ja').format(data["expenceDate"].toDate())} (${DateFormat.E('ja').format(data["expenceDate"].toDate())}) ${data["price"]}円',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  // '${data["col1"] != null ? data["col1"] : ''} ${data["col2"] != null ? data["col2"] : ''} ${sodata["col3"] != null ? data["col3"] : ''}'),
                                  '${data["col1"] ?? ''} ${data["col2"] ?? ''} ${data["col3"] ?? ''}'),
                              onTap: () {
                                log.info(
                                    'Card onTap() : data["price"].toString() : ${data["price"].toString()}');
                                log.info(
                                    'Card onTap() : data["expenceTyoe"].toString() : ${data["expenceType"].toString()}');
                                ref
                                    .read(currentPriceProvider.notifier)
                                    .price(int.parse(data["price"].toString()));
                                ref
                                    .read(currentTaxTypeProvider.notifier)
                                    .taxType(
                                        int.parse(data["taxType"].toString()));
                                log.info(
                                    "Card onTap() : currentExpenceTypeProvider ${ref.watch(currentExpenceTypeProvider)}");
                                ref
                                    .read(currentExpenceTypeProvider.notifier)
                                    .expenceType(int.parse(
                                        data["expenceType"].toString()));
                                log.info(
                                    "Card onTap() : currentExpenceTypeProvider ${ref.watch(currentExpenceTypeProvider)}");
                                log.info(
                                    "Card onTap() : reportStatus $reportStatus");
                                log.info("Card onTap() : data $data");
                                context.goNamed(
                                  "expenceinputfs",
                                  queryParameters: {
                                    'reportID': data["reportID"],
                                    'userID': data["userID"],
                                    'id': data["id"],
                                    'createdDateStr':
                                        data["createdDate"].toDate().toString(),
                                    'expenceDateStr':
                                        data["expenceDate"].toDate().toString(),
                                    'expenceTypeName':
                                        data["expenceType"].toString(),
                                    'priceStr': data["price"].toString(),
                                    'col1': data["col1"],
                                    'col2': data["col2"],
                                    'col3': data["col3"],
                                    'taxTypeName': data["taxType"].toString(),
                                    'invoiceNumber': data["invoiceNumber"],
                                    'reportName': reportName,
                                    'status': reportStatus,
                                    // 'reportStatus' :
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      })
                      .toList()
                      .cast(),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reportStatus == Status.making.en
            ? () {
                log.info('floatingActionButton : expencesscreenfs : 経費追加');
                addNewExpence(ref, userinstance, context);
              }
            : null,
        backgroundColor: reportStatus == Status.making.en
            ? Colors.lightBlue.shade200
            : Colors.grey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
