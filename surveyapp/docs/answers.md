## answers json template
```json
{
    "questionid" : "10",
    "type" : "10",
    "answer" : "0",
    "commnet" : "0 for yes 1 for no",
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
},
```

## firestore
<!-- /answers/OvP5jpOxT8FCbP4b9dzB/10/KXRFpzLZjMassCns5OJN/yes/BMTcvlKDl9f882EzoFc8(field id:"mail2")
/answers/OvP5jpOxT8FCbP4b9dzB/10/KXRFpzLZjMassCns5OJN/yes/iplfWnpYCkgGn3g4O06N(filed id:"mail1")
/answers/OvP5jpOxT8FCbP4b9dzB/10/KXRFpzLZjMassCns5OJN/no/1Dund0q14aBPZmiZulq4(field id:"mail3")

/answers/OvP5jpOxT8FCbP4b9dzB/repondents/T9aqI1BnMsKPRWGHrCAA(field id:"mail2")
/answers/OvP5jpOxT8FCbP4b9dzB/repondents/KAw8oCbf7LOz2g4GmDsT(field id:"mail1") -->

/10/KXRFpzLZjMassCns5OJN/yes/BMTcvlKDl9f882EzoFc8(field id:"mail2")
/10/KXRFpzLZjMassCns5OJN/yes/iplfWnpYCkgGn3g4O06N(filed id:"mail1")
/10/KXRFpzLZjMassCns5OJN/no/1Dund0q14aBPZmiZulq4(field id:"mail3")

/repondents/T9aqI1BnMsKPRWGHrCAA(field id:"mail2")
/repondents/KAw8oCbf7LOz2g4GmDsT(field id:"mail1")


/survey/XzVjwRQP4mWPHiaZVGW8(field title="", modifiled=timestamp)


## usage
db = FirebaseFirestore.instance;


// 回答者のメールアドレス登録
final data = {"id": "mail1@mail.com"};

db.collection("respondents").add(data).then((documentSnapshot) =>
    print("Added Data with ID: ${documentSnapshot.id}"));

// idチェック
final respRef = db.collection("respondents");
String mailid = "mail1";
final query = respRef.where("id", isEqualTo: mailid);


// surveryデータ登録
final surveydata = <String, String>{
  "title": "投資に関するアンケート",
  "modifiled": timestamp
};
db.collection("survery").add(surverydata).then((documentSnapshot) =>
    print("Added Data with ID: ${documentSnapshot.id}"));
