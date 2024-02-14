import 'dart:convert';

import 'package:logging/logging.dart';

final log = Logger('Data');

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

  List<Block> getBlocks() {
    if (_json case {'questions': List blocksJson}) {
      return [for (final blockJson in blocksJson) Block.fromJson(blockJson)];
    } else {
      throw const FormatException('Unexpected JSON format');
    }
  }
}

const documentJson = '''
{
  "metadata": {
    "title": "投資に関するアンケート",
    "modified": "2024-01-01"
  },


  "questions" : [
    {
      "comment" : "10. 文書 + はい/いいえ",
      "questionid" : "10",
      "type" : "10",
      "text" : "今後の情報提供に役立てるため、このアンケートは、皆様の投資に関する知識、認識を把握させていただきます。ご協力をお願いいたします。勝手ながら、ご回答者は20歳以上の方に限定させていただきます。２０歳以上の方ですか？",
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
        "漆黒色の銀行 0d0015"
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
      "nexts" : [ "30"]
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
      "nexts" : [ "50"]
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
      "text" : "ご回答いただきありがとうございました。回答送信ボタンを押してください。" 
    }
  ]

}
''';

sealed class Block {
  Block();

  factory Block.fromJson(Map<String, Object?> json) {
    log.info('--- $json ---');
    for (var e in json.keys) {
      log.info('$e ${json[e].runtimeType}');
    }

    // log.info('--- ${json["comment"].runtimeType}');
    // log.info('--- ${json["questionid"].runtimeType}');
    // log.info('--- ${json["type"].runtimeType}');
    // log.info('--- ${json["text"].runtimeType}');
    // log.info('--- ${json["nexts"].runtimeType}');
    log.info('-------------');
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
        Type21(comment, questionid, text, choices, nexts),
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
        'choices': String choices,
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
      } =>
        Type70(comment, questionid, text),
      _ => throw FormatException('Unexpected JSON format $json'),
    };
  }
}

class Type70 extends Block {
  final String comment;
  final String questionid;
  final String text;
  Type70(this.comment, this.questionid, this.text);
}

class Type50 extends Block {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> nexts;
  Type50(this.comment, this.questionid, this.text, this.nexts);
}

class Type31 extends Block {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> choices;
  final List<dynamic> nexts;
  Type31(this.comment, this.questionid, this.text, this.choices, this.nexts);
}

class Type40 extends Block {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> values;
  final List<dynamic> nexts;
  Type40(this.comment, this.questionid, this.text, this.values, this.nexts);
}

class Type30 extends Block {
  final String comment;
  final String questionid;
  final String text;
  // final List<dynamic> choices;
  final String choices;
  final List<dynamic> nexts;
  Type30(this.comment, this.questionid, this.text, this.choices, this.nexts);
}

class Type20 extends Block {
  final String comment;
  final String questionid;
  final String text;
  final String choices;
  final List<dynamic> nexts;
  Type20(this.comment, this.questionid, this.text, this.choices, this.nexts);
}

class Type21 extends Block {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> choices;
  final List<dynamic> nexts;
  Type21(this.comment, this.questionid, this.text, this.choices, this.nexts);
}

class Type60 extends Block {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> nexts;
  Type60(this.comment, this.questionid, this.text, this.nexts);
}

class Type10 extends Block {
  final String comment;
  final String questionid;
  final String text;
  final List<dynamic> nexts;
  Type10(this.comment, this.questionid, this.text, this.nexts);
}

class HeaderBlock extends Block {
  final String text;
  HeaderBlock(this.text);
}

class ParagraphBlock extends Block {
  final String text;
  ParagraphBlock(this.text);
}

class CheckboxBlock extends Block {
  final String text;
  final bool isChecked;
  CheckboxBlock(this.text, this.isChecked);
}
