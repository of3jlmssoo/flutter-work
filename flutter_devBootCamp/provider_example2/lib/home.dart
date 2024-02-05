import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_example2/model/item_data.dart';
import 'package:provider_example2/model/item_list.dart';
import 'package:provider_example2/model/item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userInput = '';
  Item newitem = Item(completed: false, item: 'zyx');
  final _inputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      key: _formKey,
      body: Column(
        children: [
          TextFormField(
            validator: (input) {
              if (input == null) {
                return "please enter your input";
              }
            },
            controller: _inputController,
            decoration: const InputDecoration(labelText: 'your input'),
            onSaved: (input) {
              newitem.item = input!;
              newitem.completed = false;
              String s = newitem.item;
              bool b = newitem.completed;
              debugPrint('=============== $s ==============');
              debugPrint('=============== $b ==============');
              setState(() {});
            },
            // onChanged: (input) {
            //   //   debugPrint('onChanged --> $input');
            //   newitem.item = input;
            //   newitem.completed = true;
            //   setState(() {});
            // },
          ),
          TextButton(
            onPressed: () {
              debugPrint('1 --> pressed!');

              if (_formKey.currentState == null) {
                print("_formKey.currentState is null!");
              } else if (_formKey.currentState!.validate()) {
                print("Form input is valid");
              }
              _formKey.currentState!.save();
              debugPrint('2 --> pressed!');
              setState(() {});
              ItemData().addItem(newitem);
              debugPrint('3 --> pressed!');
              ;
            },
            child: const Text(
              'submit',
            ),
          ),
          // Consumer<ItemData>(
          //   builder: (context, cart, child) {
          //     debugPrint('------- Consumer!');
          //     return ItemList();
          //   },

          // ),
          ItemList(),
        ],
      ),
    );
  }
}
