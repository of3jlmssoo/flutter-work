import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

final log = Logger('ListViewsLoginLogger');

class ListViews extends StatelessWidget {
  Widget _showFirstListView() {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Text("First ListView$index");
      },
    );
  }

  Widget _showSecondListView() {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Text("Second ListView$index");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Code'),
      ),
      // body: Center(child: const Text('You have pressed the button x times.')),
      // backgroundColor: Colors.blueGrey.shade200,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.go('/');
      //   },
      //   tooltip: 'Increment Counter',
      //   child: const Icon(Icons.keyboard_return),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text('申請レポート'),
          const SizedBox(height: 10),
          Container(
              decoration: BoxDecoration(border: Border.all()),
              margin: const EdgeInsets.only(left: 10),
              height: 100,
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: _showFirstListView())),
          const Divider(),
          const Text('お知らせ'),
          Container(
              decoration: BoxDecoration(border: Border.all()),
              margin: const EdgeInsets.only(left: 10),
              height: 100,
              child: _showSecondListView()),
          const SizedBox(height: 10),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              context.go('/');
              var uuid = Uuid();
              var v7 = uuid.v7();
              log.info('${v7}');
            },
            child: const Icon(
              Icons.keyboard_return,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
