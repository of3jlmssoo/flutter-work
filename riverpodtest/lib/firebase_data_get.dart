import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';
import 'package:riverpodtest/firestore_calc_totalprice.dart';
import 'package:riverpodtest/reports.dart';

import 'firebase_providers.dart';
import 'report.dart';

// DONE: hambuger menuを作成しテストデータ作成を移動
// DONE: 新規レポートはfloatingactionbuttonへ
// TODO: firebase/firestore見直し
// TODO: 新規レポートの入力チェック

final log = Logger('firebase_data_get');

void fireStoreSetData(
    {required String userID,
    required String name,
    required DateTime createdDate,
    required String col1,
    required int totalPrice,
    required String reportID,
    required Status status}) {
  var db = FirebaseFirestore.instance;

  final docData = {
    "userID": userID,
    "reportID": reportID,
    "name": name,
    "createdDate": createdDate,
    "col1": col1,
    "totalPriceStr": totalPrice.toString(),
    "status": status.en,
  };

  db
      .collection("users")
      .doc(userID)
      .collection("reports")
      .doc(reportID)
      .set(docData)
      .onError((e, _) =>
          log.info("fireStoreSetData() : Error writing document: $e"));
}

class GetSampleData extends ConsumerStatefulWidget {
  const GetSampleData({super.key});

  @override
  GetSampleDataState createState() => GetSampleDataState();
}

class GetSampleDataState extends ConsumerState<GetSampleData> {
  void addTestReports() {
    fireStoreSetData(
      userID: FirebaseAuth.instance.currentUser!.uid,
      name: '2024年1月',
      createdDate: DateTime.now(),
      col1: "",
      totalPrice: 0,
      reportID: uuid.v7(),
      status: Status.making,
    );
    fireStoreSetData(
      userID: FirebaseAuth.instance.currentUser!.uid,
      name: '2024年2月',
      createdDate: DateTime.now(),
      col1: "",
      totalPrice: 0,
      reportID: uuid.v7(),
      status: Status.making,
    );
  }

  void addNewReport() {
    String reportName = '';
    log.info('addNewReport() : addNewReport');
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext cotext) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: 200,
              color: Colors.blue[200],
              child: Center(
                  child: Padding(addNewReport
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5.0),
                    const Text('レポート名称'),
                    TextFormField(
                      onChanged: (value) {
                        log.info(
                            'report name input(TextFormField) : input: value:$value');
                        reportName = value;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          fireStoreSetData(
                            userID: FirebaseAuth.instance.currentUser!.uid,
                            name: reportName,
                            createdDate: DateTime.now(),
                            col1: "",
                            totalPrice: 0,
                            reportID: uuid.v7(),
                            status: Status.making,
                          );

                          Navigator.pop(context);
                        },
                        child: const Text('OK')),
                  ],
                ),
              )),
            ),
          );
        });
    log.info('end of addNewReport');
  }

  @override
  Widget build(BuildContext context) {
    final userinstance = ref.watch(firebaseAuthProvider);
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userinstance.currentUser!.uid)
        .collection('reports')
        .snapshots();

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
                child: const Text('テストデータ追加'),
                onPressed: () {
                  log.info('menuitembutton : テストデータ追加');
                  addTestReports();
                  // addTestData(ref, userinstance);
                },
              ),
              MenuItemButton(
                child: const Text('firebase_data_get'),
                onPressed: () {
                  log.info('menuitembutton : firebase_data_get pressed');
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
        title: const Text('経費レポート一覧'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else {
                  log.info('StreamBuilder : StreamBuilder has no error');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("StreamBuilder : Waiting");
                } else {
                  log.info('StreamBuilder : Not waiting');
                }
                // log.info(
                //     'StreamBuilder : snapshot.error ${FirebaseFirestore.instance.settings} $snapshot');
                // log.info(
                //     'irebase_data_get : FirebaseAuth.instance ${FirebaseAuth.instance.currentUser}');

                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Dismissible(
                          direction: data["status"] == Status.making.en
                              ? DismissDirection.horizontal
                              : DismissDirection.none,
                          key: ValueKey(data["reportID"]),
                          onDismissed: (_) async {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(data["userID"])
                                .collection("reports")
                                .doc(data["reportID"])
                                .delete()
                                .then(
                                  (doc) => log
                                      .info("Dismissible : Document deleted"),
                                  onError: (e) => log.info(
                                      "Dismissible : Error updating document $e"),
                                );
                            int result = await calcTotalPrice(
                                data["userID"], data["reportID"]);
                            log.info('Dismissible : total price is $result');
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(data['name']),
                              subtitle: Text(
                                  '作成日 : ${intl.DateFormat('yyyy年MM月dd日').format(data['createdDate'].toDate())} '
                                  '${data['status'] == 'submitted' ? "申請済み" : data['status'] == 'making' ? '作成中' : 'その他'}'),
                              onTap: () async {
                                int result = await calcTotalPrice(
                                    data["userID"], data["reportID"]);
                                log.info(
                                    'Card onTap() : total price is $result');

                                log.info(
                                    'Card onTap() : reportID is ${data['reportID']}');
                                log.info(
                                    'Card onTap() : status is ${data['status']}');
                                if (!context.mounted) {
                                  return;
                                } else {
                                  context.goNamed(
                                    "expencescreenfs",
                                    queryParameters: {
                                      'reportID': data['reportID'],
                                      'userID': data['userID'],
                                      'reportName': data['name'],
                                      'reportStatus': data['status'],
                                    },
                                  );
                                }
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue.shade200,
        onPressed: () {
          addNewReport();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
