import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:logging/logging.dart';

final log = Logger('ExpenceInputLoginLogger');

class ExpenceInput extends StatefulWidget {
  @override
  State<ExpenceInput> createState() => _ExpenceInputState();
}

class _ExpenceInputState extends State<ExpenceInput> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;

  DateTime _date = new DateTime.now();

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(
            days: 360))); // if (picked != null) setState(() => _date = picked);
    if (picked != null)
      return picked;
    else
      return DateTime.now();
  }

  static const List<String> expenceTypeList = <String>[
    '交通費直',
    'その他',
    '直',
    'Four'
  ];
  static const List<String> taxTypeList = <String>['one', 'two', 'Three', '直'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style: TextStyle(
            fontFamily: 'MPLUSRounded',
          ),
          'Sample Code',
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
                      const Text(
                        '経費種別',
                        // style: Theme.of(context).textTheme.bodyLarge,
                        style: TextStyle(
                          fontFamily: 'MPLUSRounded',
                        ),
                      ),

                      DropdownMenu<String>(
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
                            fontSize: 12, fontFamily: 'MPLUSRounded'),
                        initialSelection: expenceTypeList.first,
                        onSelected: (String? value) {
                          setState(() {
                            log.info('selected :$value');
                          });
                        },
                        dropdownMenuEntries: expenceTypeList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            style: ButtonStyle(textStyle: MaterialStateTextStyle.resolveWith((states) => TextStyle(fontSize: 10,fontFamily: 'MPLUSRounded') )),
                              value: value, label: value);
                        }).toList(),
                      ),
                      // ),
                      const SizedBox(height: 20),
                      const Text(
                        '日付',
                        // style: Theme.of(context).textTheme.bodyLarge,
                        style: TextStyle(
                          fontFamily: 'MPLUSRounded',
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(
                                intl.DateFormat.yMd().format(date),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),

                          //   ],
                          // ),
                          TextButton(
                            child: const Text(
                              '日付指定',
                              style: TextStyle(
                                fontFamily: 'MPLUSRounded',
                              ),
                            ),
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  date = selectedDate;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // InputDetails(inputType: InputType.transportation),
                      InputDetails(inputType: InputType.other),
                      const SizedBox(height: 20),
                      const Text(
                        '金額',
                        style: TextStyle(fontFamily: 'MPLUSRounded'),
                        // style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextFormField(
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          // filled: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          log.info('input: value:$value');
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'メモ',
                        style: TextStyle(fontFamily: 'MPLUSRounded'),
                        // style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // filled: true,
                          // hintText: 'Enter a description...',
                          // labelText: 'Description',
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                        maxLines: 5,
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        '税タイプ',
                        style: TextStyle(fontFamily: 'MPLUSRounded'),
                        // style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      DropdownMenu<String>(
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
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'MPLUSRounded',
                        ),
                        initialSelection: taxTypeList.first,
                        onSelected: (String? value) {
                          setState(() {
                            log.info('selected :$value');
                          });
                        },
                        dropdownMenuEntries: taxTypeList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            style: ButtonStyle(textStyle: MaterialStateTextStyle.resolveWith((states) => TextStyle(fontSize: 10,fontFamily: 'MPLUSRounded') )),
                              value: value, label: value);
                        }).toList(),
                      ),
                      //
                      //
                      //
                      const SizedBox(height: 20),

                      TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter a title...',
                          labelText: 'Title',
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          hintText: 'Enter a description...',
                          labelText: 'Description',
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                        maxLines: 5,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimated value',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          Text(
                            intl.NumberFormat.currency(
                                    symbol: "\$", decimalDigits: 0)
                                .format(maxValue),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Slider(
                            min: 0,
                            max: 500,
                            divisions: 500,
                            value: maxValue,
                            onChanged: (value) {
                              setState(() {
                                maxValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: brushedTeeth,
                            onChanged: (checked) {
                              setState(() {
                                brushedTeeth = checked;
                              });
                            },
                          ),
                          Text('Brushed Teeth',
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Enable feature',
                              style: Theme.of(context).textTheme.bodyLarge),
                          Switch(
                            value: enableFeature,
                            onChanged: (enabled) {
                              setState(() {
                                enableFeature = enabled;
                              });
                            },
                          ),
                        ],
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

enum InputType { transportation, other }

class InputDetails extends StatelessWidget {
  InputDetails({required this.inputType});
  final InputType inputType;
  @override
  Widget build(BuildContext context) {
    if (inputType == InputType.transportation) {
      return Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '乗車地',
                  style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('input: value:$value');
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
                  style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('input: value:$value');
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
                  style: TextStyle(fontFamily: 'MPLUSRounded'),
                  // style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    // filled: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    log.info('input: value:$value');
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
