import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('FirebaseDataLogger');

late User loggedInUser;

class FirestoreData extends StatefulWidget {
  static const String id = 'chat_screen';

  const FirestoreData({super.key});

  @override
  _FirestoreDataState createState() => _FirestoreDataState();
}

class _FirestoreDataState extends State<FirestoreData> {
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
        log.info('_FireStoreDataState : not logged in yet');
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
    return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  log.info('close icon!');
                  messagesGet();
                }),
          ],
          title: const Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Material(
            color: Colors.white,
            child: Column(
              children: [
                ElevatedButton(
                  child: const Text('add data 1'),
                  onPressed: () {
                    _firestore.collection('records').add({
                      'name': 'name1',
                      'number': 1,
                      'timestamp': DateTime.now(),
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('add data 2'),
                  onPressed: () {
                    _firestore.collection('records').add({
                      'name': 'name2',
                      'number': 2,
                      'timestamp': DateTime.now(),
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('add data 3'),
                  onPressed: () {
                    _firestore.collection('records').add({
                      'name': 'name3',
                      'number': 3,
                      'timestamp': DateTime.now(),
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('timestamp')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        List<MessageBubble> messageBubbles = [];
        for (var document in snapshot.data!.docs.reversed) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          final messageText = data['text'];
          final messageSender = data['sender'];
          final currentUser = loggedInUser;
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isME: currentUser.email == messageSender,
          );
          print('$currentUser --- $messageSender');
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isME});
  final String sender;
  final String text;
  final bool isME;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Material(
            borderRadius: isME
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            elevation: 10.0,
            color: isME ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                style: TextStyle(
                  color: isME ? Colors.white : Colors.black54,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
