import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

final log = Logger('firestore_calc_totalprice');

Future<int> calcTotalPrice(String userID, String reportID) async {
  int result = 0;
  var expencesRef = FirebaseFirestore.instance
      .collection("users")
      .doc(userID)
      .collection('reports')
      .doc(reportID)
      .collection('expences');
  var allExpences = await expencesRef.get();
  for (var doc in allExpences.docs) {
    result += doc.data()['price'] as int;
  }

  log.info('total price is $result');

  final reportRef = FirebaseFirestore.instance
      .collection("users")
      .doc(userID)
      .collection("reports")
      .doc(reportID);
  reportRef.update({"totalPriceStr": result.toString()}).then(
      (value) => log.info(
          "firestore_calc_totalprice : DocumentSnapshot successfully updated!"),
      onError: (e) =>
          log.info("firestore_calc_totalprice : Error updating document $e"));

  return result;
}
