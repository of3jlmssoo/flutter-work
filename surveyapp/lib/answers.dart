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
      const (AnswerType10) => {"questionid": questionid, "yesno": yesno},
      const (AnswerType20) => {"questionid": questionid, "choices": choices},
      const (AnswerType21) => {"questionid": questionid, "choices": choices},
      const (AnswerType30) => {
          "questionid": questionid,
          "choices": choices,
          "answerinput": answerinput
        },
      const (AnswerType31) => {
          "questionid": questionid,
          "choices": choices,
          "answerinput": answerinput
        },
      const (AnswerType40) => {"questionid": questionid, "value": value},
      const (AnswerType50) => {
          "questionid": questionid,
          "answerinput": answerinput
        },
      const (AnswerType60) => {"questionid": questionid, "done": done},
      const (AnswerType70) => {"questionid": questionid, "done": done},
      _ => {"questionid": questionid},
    };
  }

  String get questionid => questionid;
  String get type => type;
  List<dynamic> get value => value;
  List<dynamic> get choices => choices;
  String get answerinput => answerinput;
  bool get done => done;
  bool get yesno => yesno;
}

class AnswerType10 extends AnswerBlock {
  final String questionid;
  final bool yesno; // true for yes, balse for no
  AnswerType10(this.questionid, this.yesno);
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
  final List<int> value;
  AnswerType40(this.questionid, this.value);
}

class AnswerType50 extends AnswerBlock {
  final String questionid;
  final String answerinput;
  AnswerType50(this.questionid, this.answerinput);
}

class AnswerType60 extends AnswerBlock {
  final String questionid;
  final bool done;
  AnswerType60(this.questionid, this.done);
}

class AnswerType70 extends AnswerBlock {
  final String questionid;
  final bool done;
  AnswerType70(this.questionid, this.done);
}
