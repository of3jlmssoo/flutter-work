import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';

// import 'question.dart';

QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(const Quizzler());
}

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyQuizPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyQuizPage extends StatefulWidget {
  const MyQuizPage({super.key, required this.title});

  final String title;

  @override
  State<MyQuizPage> createState() => _MyQuizPageState();
}

class _MyQuizPageState extends State<MyQuizPage> {
  List<Icon> scoreKeeper = [
    // Icon(
    //   Icons.check,
    //   color: Colors.green,
    // ),
    // Icon(
    //   Icons.close,
    //   color: Colors.red,
    // ),
  ];

  // List<String> questions = [
  //   'FALSE You can lead a cow down stairs but not up stairs.',
  //   'TRUE  Approximately one quarter of human bones are in the feet.',
  //   'TRUE  A slug\'s blood is green.'
  // ];

  // int questionNumber = 0;

  // List<bool> answers = [false, true, true];

  // Question q1 = Question(
  //     q: 'FALSE You can lead a cow down stairs but not up stairs.', a: false);

  // List<Question> questionBank = [
  //   Question(
  //       q: '1)FALSE You can lead a cow down stairs but not up stairs.',
  //       a: false),
  //   Question(
  //       q: '2)TRUE  Approximately one quarter of human bones are in the feet.',
  //       a: true),
  //   Question(q: '3)TRUE  A slug\'s blood is green.', a: true),
  // ];
  // int updateQuestionNumber() {
  //   return (questionNumber + 1 == quizBrain.getQuestionLength())
  //       ? 0
  //       : ++questionNumber;
  // }

  Icon checkAnswer(bool answer) {
    return answer == quizBrain.getQuestionAnswer()
        ? const Icon(
            Icons.check,
            color: Colors.green,
          )
        : const Icon(
            Icons.close,
            color: Colors.red,
          );
  }
  // Icon checkAnswer(bool answer) {
  //   return answer == answers[questionNumber]
  //       ? Icon(
  //           Icons.check,
  //           color: Colors.green,
  //         )
  //       : Icon(
  //           Icons.close,
  //           color: Colors.red,
  //         );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   title: Text(widget.title),
        // ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          textStyle: const TextStyle(fontSize: 25.0),
                          foregroundColor: Colors.white),
                      child:
                          // const Text('This is where the question text will go'),
                          // Text(questionNumber.toString() +
                          //     ')' +
                          //     questions[questionNumber]),
                          Text(quizBrain.getQuestionText()),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Icon answerIcon = checkAnswer(true);
                        setState(
                          () {
                            scoreKeeper.add(
                              answerIcon,
                            );
                            quizBrain.gotoNextQuestion(context);
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 25.0),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('true'),
                    ),
                  ),
                ),
                // const SizedBox(height: 5.0),
                // TODO: remove SizedBox use Padding
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Icon answerIcon = checkAnswer(false);
                        setState(
                          () {
                            scoreKeeper.add(
                              answerIcon,
                            );
                            quizBrain.gotoNextQuestion(context);
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(fontSize: 25.0),
                          foregroundColor: Colors.white),
                      child: const Text('false'),
                    ),
                  ),
                ),
                Row(children: scoreKeeper),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//TODO: Step 2 - Import the rFlutter_Alert package here.
//TODO: Step 4 - Use IF/ELSE to check if we've reached the end of the quiz. If true, execute Part A, B, C, D.
//TODO: Step 4 Part A - show an alert using rFlutter_alert (remember to read the docs for the package!)
//TODO: Step 4 Part C - reset the questionNumber,
//TODO: Step 4 Part D - empty out the scoreKeeper.
//TODO: Step 5 - If we've not reached the end, ELSE do the answer checking steps below 👇

// TODO: remove SizedBox use Padding

//TODO: Step 3 Part A - Create a method called isFinished() here that checks to see if we have reached the last question. It should return (have an output) true if we've reached the last question and it should return false if we're not there yet.
//TODO: Step 3 Part B - Use a print statement to check that isFinished is returning true when you are indeed at the end of the quiz and when a restart should happen.
//TODO: Step 4 Part B - Create a reset() method here that sets the questionNumber back to 0.
