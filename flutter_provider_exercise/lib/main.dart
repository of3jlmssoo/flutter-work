import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Data>(
          create: (context) => Data(),
        ),
      ],
      child: MaterialApp(
        home: AccountScreen(),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('プロバイダーお試し'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(flex: 1, child: MyInputItem()),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _MyListItem(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyInputItem extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  String userinput = '';
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Form(
          key: formKey,
          child: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: '入力エリア'),
                  onSaved: (input) => userinput = input!,
                ),
                TextButton(
                  onPressed: () {
                    formKey.currentState!.save();
                    Provider.of<Data>(context, listen: false)
                        .addItem(userinput);
                    formKey.currentState?.reset();
                  },
                  child: const Text('確定'),
                ),
              ],
            ),
          ),
        ));
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(Provider.of<Data>(context).entries[index]),
            ),
            const SizedBox(width: 24),
            _AddButton(index),
          ],
        ),
      ),
    );
  }
}

class Data extends ChangeNotifier {
  final List<String> _entries = [
    'A',
    'B',
  ];

  void addItem(String newitem) {
    _entries.add(newitem);
    notifyListeners();
  }

  void removeItem(int index) {
    debugPrint('Data removeAt at $index');
    _entries.removeAt(index);
    notifyListeners();
    debugPrint('Data removeAt at $index');
  }

  int get length => _entries.length;

  List<String> get entries => _entries;

  String getItem(int index) {
    return _entries[index];
  }
}

class _AddButton extends StatelessWidget {
  final int positionIndex;
  const _AddButton(this.positionIndex);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        debugPrint('_AddButton index is $positionIndex');
        var data = context.read<Data>();
        data.removeItem(positionIndex);
      },
      child: const Icon(
        Icons.check,
      ),
    );
  }
}
