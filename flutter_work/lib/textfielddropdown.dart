import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

class TextFieldAndDrowDown extends StatefulWidget {
  const TextFieldAndDrowDown({super.key});

  @override
  State<TextFieldAndDrowDown> createState() => _TextFieldAndDrowDownState();
}

class _TextFieldAndDrowDownState extends State<TextFieldAndDrowDown> {
  final TextEditingController colorController = TextEditingController();
  ColorLabel? selectedColor;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<ColorLabel>> colorEntries =
        <DropdownMenuEntry<ColorLabel>>[];
    for (final ColorLabel color in ColorLabel.values) {
      colorEntries.add(
        DropdownMenuEntry<ColorLabel>(
            value: color, label: color.label, enabled: color.label != 'Grey'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text and DropDown'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 5),
            TextField(
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'your input',
              ),
              controller: _controller,
              onSubmitted: (String value) async {
                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Thanks!'),
                      content: Text(
                          'You typed "$value", which has length ${value.characters.length}.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 5),
            DropdownMenu<ColorLabel>(
              initialSelection: ColorLabel.green,
              controller: colorController,
              label: const Text('Color'),
              dropdownMenuEntries: colorEntries,
              onSelected: (ColorLabel? color) {
                setState(() {
                  selectedColor = color;
                  _controller.text = color!.label;
                });
              },
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                //   Navigator.pop(context);
                //
                context.go('/');
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
