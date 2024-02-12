import 'dart:convert';

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
    if (_json case {'blocks': List blocksJson}) {
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
      "type" : 10,
      "text" : "今後の情報提供に役立てるため、このアンケートは、皆様の投資に関する知識、認識を把握させていただきます。ご協力をお願いいたします。
                \\n
                勝手ながら、ご回答者は20歳以上の方に限定させていただきます。
                \\n
                ２０歳以上の方ですか？",
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
      "type" : 21,
      "text" : "普段ご利用の銀行をお応えください。" ,
      "choices" : [
        "紅樺色の銀行 bb5548",
        "藤黄色の銀行 f7c114",
        "千草色の銀行 92b5a9"
        "漆黒色の銀行 0d0015"
      ],
      "nexts" : [ "21"]
    },
    
    {
      "comment" : "21. 文書 + 選択肢 (複数)",
      "questionid" : "21",
      "type" : 21,
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
      "type" : 20,
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
      "type" : 10,
      "text" : "新NISAがんばりますか？",
      "nexts" : [ "50"]
    }, 
       {
      "comment" : "40. 文書 + スライダー(値)",
      "questionid" : "41",
      "type" : 40,
      "text" : "新NISAを知人に勧めますか？" ,
      "values" : [ 0, 100, 10],
      "nexts" : [ "50" ]
    },
    {
      "comment" : "31. 文書 + 選択肢 (複数) + 入力",
      "questionid" : "42",
      "type" : 31,
      "text" : "どの銘柄がお好きですか？" ,
      "choices" : [
        "CVR",
        "GROW",
        "NNY"
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
      "text" : "ご回答いただきありがとうございました。
                \\n
                回答送信ボタンを押してください。" 
    }
  ]

}
''';

sealed class Block {
  Block();

  factory Block.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {'type': 'h1', 'text': String text} => HeaderBlock(text),
      {'type': 'p', 'text': String text} => ParagraphBlock(text),
      {'type': 'checkbox', 'text': String text, 'checked': bool checked} =>
        CheckboxBlock(text, checked),
      _ => throw const FormatException('Unexpected JSON format'),
    };
  }
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
