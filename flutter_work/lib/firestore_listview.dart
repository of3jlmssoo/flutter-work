import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('FirebaseListViewLogger');
List<Container> cotainers = [
  Container(
    height: 200,
    width: double.infinity,
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF846AFF),
          Color(0xFF755EE8),
          Colors.purpleAccent,
          Colors.amber,
        ],
      ),
      borderRadius: BorderRadius.circular(16),
    ), // radius( 16)), // Adds a gradient background and rounded corners to the container
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Family Card',
                  // style: MyTextSample.headline(context)!
                  //     .copyWith(color: Colors.white, fontFamily: "monospace"),
                ), // Adds a title to the card
                const Spacer(),
                Stack(
                  children: List.generate(
                    2,
                    (index) => Container(
                      margin: EdgeInsets.only(left: (15 * index).toDouble()),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              100)), // radius(100), color: Colors.white54),
                    ),
                  ),
                ) // Adds a stack of two circular containers to the right of the title
              ],
            ),
            Text(
              '4111 7679 8689 9700',
              // style: MyTextSample.subhead(context)!
              //     .copyWith(color: Colors.white, fontFamily: "monospace"),
            ) // Adds a subtitle to the card
          ],
        ),
        const Text('\$3,000',
            style: TextStyle(
                fontSize: 24,
                color: Colors.white)) // Adds a price to the bottom of the card
      ],
    ),
  ),
];
List<Card> cards = [
  Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const ListTile(
          leading: Icon(Icons.album),
          title: Text('2023/11/03'),
          subtitle: Text('電車'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              child: const Text('BUY TICKETS'),
              onPressed: () {/* ... */},
            ),
            const SizedBox(width: 8),
            TextButton(
              child: const Text('LISTEN'),
              onPressed: () {/* ... */},
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  ),
  // Card(
  //   child: Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: <Widget>[
  //       const ListTile(
  //         leading: Icon(Icons.album),
  //         title: Text('The Enchanted Nightingale'),
  //         subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: <Widget>[
  //           TextButton(
  //             child: const Text('BUY TICKETS'),
  //             onPressed: () {/* ... */},
  //           ),
  //           const SizedBox(width: 8),
  //           TextButton(
  //             child: const Text('LISTEN'),
  //             onPressed: () {/* ... */},
  //           ),
  //           const SizedBox(width: 8),
  //         ],
  //       ),
  //     ],
  //   ),
  // ),
];

late User loggedInUser;

class FirestoreListView extends StatefulWidget {
  static const String id = 'chat_screen';

  const FirestoreListView({super.key});

  @override
  _FirestoreListViewState createState() => _FirestoreListViewState();
}

class _FirestoreListViewState extends State<FirestoreListView> {
  final messageTextController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String messageText;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        log.info('getCurrentUser() --> loggedInUser $loggedInUser');
        log.info('getCurrentUser() --> _firestore $_firestore');
      } else {
        log.info('_FirestoreListViewState : not logged in yet');
      }
    } catch (e) {
      log.info(e);
    }
  }

  void messagesStream() async {
    log.info('messagesStream()');
    await _firestore
        .collection('records')
        .orderBy('timestamp')
        .snapshots()
        .forEach((snapshot) {
      for (var message in snapshot.docs) {
        log.info('messagesStream() ${message.data()}');
      }
    });
  }

  void messagesGet() async {
    await _firestore.collection("records").get().then(
      (querySnapshot) {
        log.info("messagesGet() Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          log.info(' => ${docSnapshot.data()}');
        }
      },
      onError: (e) => log.info("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: cotainers.length,
      itemBuilder: (BuildContext context, int index) {
        return cotainers[index];
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
