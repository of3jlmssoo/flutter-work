import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final log = Logger('questions');

class Document {
  final Map<String, Object?> _json;
  Document() : _json = jsonDecode(documentJson);

  (String, {DateTime modified}) get metadata {
    if (_json
        case {
          'metadata': {
            'title': String title,
            'modified': String localModified,
          }
        }) {
      return (title, modified: DateTime.parse(localModified));
    } else {
      throw const FormatException('Unexpected JSON');
    }
  }

  Map<String, QuestionBlock> getBlocks() {
    List<QuestionBlock> qlist = [];
    Map<String, QuestionBlock> result = {};

    log.info('getBlocks called');
    if (_json case {'questions': List blocksJson}) {
      // return [for (final blockJson in blocksJson) Block.fromJson(blockJson)];
      qlist = [
        for (final blockJson in blocksJson) QuestionBlock.fromJson(blockJson)
      ];
      for (QuestionBlock b in qlist) {
        log.info('--> $b');
        result[b.questionid] = b;
      }
      log.info('before return $result');
      return result;
    } else {
      throw const FormatException('Unexpected JSON format');
    }
  }
  // List<Block> getBlocks() {
  //   if (_json case {'questions': List blocksJson}) {
  //     return [for (final blockJson in blocksJson) Block.fromJson(blockJson)];
  //   } else {
  //     throw const FormatException('Unexpected JSON format');
  //   }
  // }
}

const documentJson = """
{
  "metadata": {
    "title": "投資に関するアンケート",
    "modified": "2024-01-01"
  },
  "questions" : [
    {
      "comment" : "10. 文書 + はい/いいえ nextsははい、いいえの順",
      "questionid" : "10",
      "type" : "10",
      "text" : "今後の情報提供に役立てるため、このアンケートは、皆様の投資に関する知識、認識を把握させていただきます。ご協力をお願いいたします。\\n\\n勝手ながら、ご回答者は20歳以上の方に限定させていただきます。\\n\\n２０歳以上の方ですか？",
      "nexts" : ["20" , "11"]
    },
    {
      "comment" : "60. 文書 + 戻る",
      "questionid" : "11",
      "type" : "60",
      "text" : "勝手ながらご回答者を20歳以上の方に限定させていただきます。" ,
      "nexts" : ["10"]
    },
    {
      "comment" : "21. 文書 + 選択肢 (複数)",
      "questionid" : "20",
      "type" : "21",
      "text" : "普段ご利用の銀行をお応えください。" ,
      "choices" : [
        "紅樺色の銀行 bb5548",
       "藤黄色の銀行 f7c114",
        "千草色の銀行 92b5a9",
        "漆黒色の銀行 0d0015",
        "その他の銀行 0d0015"
      ],
      "nexts" : ["21"]
    },
    {
      "comment" : "21. 文書 + 選択肢 (複数)",
      "questionid" : "21",
      "type" : "21",
      "text" : "普段ご利用の証券会社をお応えください。" ,
      "choices" : [
        "ホームページに人の顔写真がやたらと掲載されてうざい証券会社",
        "ホームページに稀に人の顔写真が掲載されて残念に思うことがある証券会社",
        "口座開設し幾つか買ったのに追加で買えなくなった証券会社"
      ],
      "nexts" : [ "30" ]
    },
    {
      "comment" : "20. 文書 + 選択肢 (一択)",
      "questionid" : "30",
      "type" : "20",
      "text" : "金融資産額はどれくらいでしょうか？",
      "choices" : [ 
        "500万円未満",
        "500〜1,000万円未満",
        "1,000〜3,000万円未満",
        "3,000万円以上",
        "無い" 
      ],
      "nexts" : ["40", "41", "42", "42", "40"]
    },
    {
      "comment" : "10. 文書 + はい/いいえ",
      "questionid" : "40",
      "type" : "10",
      "text" : "新NISAがんばりますか？",
      "nexts" : [ "50", "50" ]
    }, 
       {
      "comment" : "40. 文書 + スライダー(値)",
      "questionid" : "41",
      "type" : "40",
      "text" : "新NISAを知人に勧めますか？" ,
      "values" : [ 0, 100, 10],
      "nexts" : [ "50" ]
    },
    {
      "comment" : "31. 文書 + 選択肢 (複数) + 入力",
      "questionid" : "42",
      "type" : "31",
      "text" : "どの銘柄がお好きですか？" ,
      "choices" : [
        "CVR",
        "GROW",
        "NNY",
        "その他"
      ],
      "nexts" :  ["50"]
    },
    {
      "comment" : "50. 文書 + 入力欄",
      "questionid" : "50",
      "type" : "50",
      "text" : "できるだけ具体的に記載してください。" ,
      "nexts" : [ "60" ]
    },


    {
      "comment" : "70. 文書 + 送信",
      "questionid" : "60",
      "type" : "70",
      "text" : "ご回答いただきありがとうございました。回答送信ボタンを押してください。",
      "nexts" : [ "0" ]
    }
  ]

}
""";

sealed class QuestionBlock {
  QuestionBlock();

  factory QuestionBlock.fromJson(Map<String, Object?> json) {
    log.info('--- $json ---');
    for (var e in json.keys) {
      log.info('$e ${json[e].runtimeType} ${json[e]}');
    }

    log.info('\n');
    return switch (json) {
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '10',
        'text': String text,
        'nexts': List<dynamic> nexts
      } =>
        Type10(comment, questionid, text, nexts),
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '60',
        'text': String text,
        'nexts': List<dynamic> nexts
      } =>
        Type60(comment, questionid, text, nexts),
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '20',
        'text': String text,
        'choices': List<dynamic> choices,
        'nexts': List<dynamic> nexts
      } =>
        Type20(comment, questionid, text, choices, nexts),
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '21',
        'text': String text,
        'choices': List<dynamic> choices,
        'nexts': List<dynamic> nexts
      } =>
        Type21(comment, questionid, text, choices, nexts),
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '30',
        'text': String text,
        'choices': List<dynamic> choices,
        'nexts': List<dynamic> nexts
      } =>
        Type30(comment, questionid, text, choices, nexts),
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '40',
        'text': String text,
        'values': List<dynamic> values,
        'nexts': List<dynamic> nexts
      } =>
        Type40(comment, questionid, text, values, nexts),
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '31',
        'text': String text,
        'choices': List<dynamic> choices,
        'nexts': List<dynamic> nexts
      } =>
        Type31(comment, questionid, text, choices, nexts),
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '50',
        'text': String text,
        'nexts': List<dynamic> nexts
      } =>
        Type50(comment, questionid, text, nexts),
      {
        'comment': String comment,
        'questionid': String questionid,
        'type': '70',
        'text': String text,
        'nexts': List<dynamic> nexts
      } =>
        Type70(comment, questionid, text, nexts),
      _ => throw FormatException('Unexpected JSON format $json'),
    };
  }

  String get questionid => questionid;
  String get type => type;
  String get text => text;
  List<dynamic> get nexts => nexts;
  List<dynamic> get values => values;

  List<dynamic> get choices => choices;
}

class Type10 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> nexts;
  Type10(this.comment, this.questionid, this.text, this.nexts);
}

class Type20 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  @override
  final List<dynamic> choices;
  final List<dynamic> nexts;
  Type20(this.comment, this.questionid, this.text, this.choices, this.nexts);
}

class Type21 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  @override
  final List<dynamic> choices;
  final List<dynamic> nexts;
  Type21(this.comment, this.questionid, this.text, this.choices, this.nexts);
}

class Type30 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  // final List<dynamic> choices;
  @override
  final List<dynamic> choices;
  final List<dynamic> nexts;
  Type30(this.comment, this.questionid, this.text, this.choices, this.nexts);
}

class Type31 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  @override
  final List<dynamic> choices;
  final List<dynamic> nexts;
  Type31(this.comment, this.questionid, this.text, this.choices, this.nexts);
}

class Type40 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> values;
  final List<dynamic> nexts;
  Type40(this.comment, this.questionid, this.text, this.values, this.nexts);
}

class Type50 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> nexts;
  Type50(this.comment, this.questionid, this.text, this.nexts);
}

class Type60 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> nexts;
  Type60(this.comment, this.questionid, this.text, this.nexts);
}

class Type70 extends QuestionBlock {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> nexts;
  Type70(this.comment, this.questionid, this.text, this.nexts);
}

class BlockWidget extends StatelessWidget {
  final QuestionBlock block;

  const BlockWidget({
    required this.block,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: switch (block) {
        Type70(:final comment, :final questionid, :final text) =>
          const Text('type 70'),
        Type50(:final comment, :final questionid, :final text, :final nexts) =>
          const Text('type 50'),
        Type31(
          :final comment,
          :final questionid,
          :final text,
          :final choices,
          :final nexts
        ) =>
          const Text('type 31'),
        Type40(
          :final comment,
          :final questionid,
          :final text,
          :final values,
          :final nexts
        ) =>
          const Text('type 40'),
        Type30(
          :final comment,
          :final questionid,
          :final text,
          :final choices,
          :final nexts
        ) =>
          const Text('type 30'),
        Type20(
          :final comment,
          :final questionid,
          :final text,
          :final choices,
          :final nexts
        ) =>
          const Text('type 20'),
        Type21(
          :final comment,
          :final questionid,
          :final text,
          :final choices,
          :final nexts
        ) =>
          const Text('type 21'),
        Type60(:final comment, :final questionid, :final text, :final nexts) =>
          const Text('type 60'),
        Type10(:final comment, :final questionid, :final text, :final nexts) =>
          const Text('type 10'),

        // TODO: Handle this case.
        Type31() => null,
        // TODO: Handle this case.
        Type40() => null,
      },
    );
  }
}
