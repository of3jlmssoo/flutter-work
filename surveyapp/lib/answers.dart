import 'package:logging/logging.dart';

final log = Logger('answers');

const answersJson = '''
{
    {
        "questionid" : "10",
        "type" : "10",
        "answer" : "0",
        "commnet" : "see the type10 definition",
    },

{
    "questionid" : "20",
    "type" : "21",
    "answer" : "0",

},

{
    "questionid" : "21",
    "type" : "21",
    "answer" : "0",

},

{
    "questionid" : "30",
    "type" : "20",
    "answer" : "0",

},
{
    "questionid" : "40",
    "type" : "10",
    "answer" : "0",
    "commnet" : "0 for yes 1 for no",
},
{
    "questionid" : "41",
    "type" : "40",
    "answer" : "77",
},
{
    "questionid" : "42",
    "type" : "31",
    "answer" : "0",
    "input" : "VGR",
},
{
    "questionid" : "50",
    "type" : "50",
    "input" : "入力"
}
}
''';

sealed class AnswerBlock {
  AnswerBlock();

  // Map<String, dynamic> toJson(AnswerBlock b) {
  Map<String, dynamic> toJson() {
    return switch (runtimeType) {
      AnswerType10 => {"questionid": questionid, "yesno": yesno},
      AnswerType20 => {"questionid": questionid, "choices": choices},
      AnswerType21 => {"questionid": questionid, "choices": choices},
      AnswerType30 => {
          "questionid": questionid,
          "choices": choices,
          "answerinput": answerinput
        },
      AnswerType31 => {
          "questionid": questionid,
          "choices": choices,
          "answerinput": answerinput
        },
      AnswerType40 => {"questionid": questionid, "value": value},
      AnswerType50 => {"questionid": questionid, "answerinput": answerinput},
      AnswerType60 => {"questionid": questionid, "done": done},
      AnswerType70 => {"questionid": questionid, "done": done},
      _ => {"questionid": questionid},
    };
  }

  // factory AnswerBlock.fromJson(Map<String, Object?> json) {
  //   log.info('--- $json ---');
  //   for (var e in json.keys) {
  //     log.info('$e ${json[e].runtimeType} ${json[e]}');
  //   }

  //   log.info('\n');
  //   return switch (json) {
  //     {
  //       'comment': String comment,
  //       'questionid': String questionid,
  //       'type': '10',
  //       'text': String text,
  //       'nexts': List<dynamic> nexts
  //     } =>
  //       AnswerType10(questionid, text, nexts),
  //     {
  //       'comment': String comment,
  //       'questionid': String questionid,
  //       'type': '60',
  //       'text': String text,
  //       'nexts': List<dynamic> nexts
  //     } =>
  //       AnswerType60( questionid, text, nexts),
  //     {
  //       'comment': String comment,
  //       'questionid': String questionid,
  //       'type': '20',
  //       'text': String text,
  //       'choices': List<dynamic> choices,
  //       'nexts': List<dynamic> nexts
  //     } =>
  //       AnswerType21( questionid, text, choices, nexts),
  //     {
  //       'comment': String comment,
  //       'questionid': String questionid,
  //       'type': '21',
  //       'text': String text,
  //       'choices': List<dynamic> choices,
  //       'nexts': List<dynamic> nexts
  //     } =>
  //       AnswerType21( questionid, text, choices, nexts),
  //     {
  //       'comment': String comment,
  //       'questionid': String questionid,
  //       'type': '30',
  //       'text': String text,
  //       'choices': List<dynamic> choices,
  //       'nexts': List<dynamic> nexts
  //     } =>
  //       AnswerType30( questionid, text, choices, nexts),
  //     {
  //       'comment': String comment,
  //       'questionid': String questionid,
  //       'type': '40',
  //       'text': String text,
  //       'values': List<dynamic> values,
  //       'nexts': List<dynamic> nexts
  //     } =>
  //       AnswerType40( questionid, text, values, nexts),
  //     {
  //       'comment': String comment,
  //       'questionid': String questionid,
  //       'type': '31',
  //       'text': String text,
  //       'choices': List<dynamic> choices,
  //       'nexts': List<dynamic> nexts
  //     } =>
  //       AnswerType31( questionid, text, choices, nexts),
  //     {
  //       'questionid': String questionid,
  //       'text': String answerinput,
  //     } =>
  //       AnswerType50( questionid, answer, nexts),
  //     {
  //       'questionid': String questionid,
  //       'done': bool done,
  //     } =>
  //       AnswerType70(questionid, done),
  //     _ => throw FormatException('Unexpected JSON format $json'),
  //   };
  // }

  String get questionid => questionid;
  String get type => type;
  List<dynamic> get value => value;
  List<dynamic> get choices => choices;
  String get answerinput => answerinput;
  bool get done => done;
  bool get yesno => yesno;
}

class AnswerType70 extends AnswerBlock {
  final String questionid;
  final bool done;
  AnswerType70(this.questionid, this.done);
}

class AnswerType50 extends AnswerBlock {
  final String questionid;
  final String answerinput;
  AnswerType50(this.questionid, this.answerinput);
}

class AnswerType30 extends AnswerBlock {
  final String questionid;
  final List<dynamic> choices;
  final String answerinput;
  AnswerType30(this.questionid, this.choices, this.answerinput);
}

class AnswerType31 extends AnswerBlock {
  final String questionid;
  final List<dynamic> choices;
  final String answerinput;
  AnswerType31(this.questionid, this.choices, this.answerinput);
}

class AnswerType40 extends AnswerBlock {
  final String questionid;
  final List<dynamic> value;
  AnswerType40(this.questionid, this.value);
}

class AnswerType20 extends AnswerBlock {
  final String questionid;
  final List<dynamic> choices;
  AnswerType20(this.questionid, this.choices);
}

class AnswerType21 extends AnswerBlock {
  final String questionid;
  final List<dynamic> choices;
  AnswerType21(this.questionid, this.choices);
}

class AnswerType60 extends AnswerBlock {
  final String questionid;
  final bool done;
  AnswerType60(this.questionid, this.done);
}

class AnswerType10 extends AnswerBlock {
  final String questionid;
  final bool yesno; // true for yes, balse for no
  AnswerType10(this.questionid, this.yesno);
}
