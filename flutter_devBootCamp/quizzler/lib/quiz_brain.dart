import 'question.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class QuizBrain {
  int _questionNumber = 0;
  final List<Question> _questionBank = [
    Question(
        questionText:
            '1)FALSE You can lead a cow down stairs but not up stairs.',
        questionAnswer: false),
    Question(
        questionText:
            '2)TRUE  Approximately one quarter of human bones are in the feet.',
        questionAnswer: true),
    Question(
        questionText: '3)TRUE  A slug\'s blood is green.',
        questionAnswer: true),
    // Question(questionText: '4)TRUE Some cats are actually allergic to humans', questionAnswer: true),
    // Question(
    //     questionText: '5)FALSE You can lead a cow down stairs but not up stairs.',
    //     questionAnswer: false),
    // Question(
    //     questionText: '6)TRUE Approximately one quarter of human bones are in the feet.',
    //     questionAnswer: true),
    // Question(questionText: 'A slug\'s blood is green.', questionAnswer: true),
    // Question(questionText: 'Buzz Aldrin\'s mother\'s maiden name was \"Moon\".', questionAnswer: true),
    // Question(questionText: 'It is illegal to pee in the Ocean in Portugal.', questionAnswer: true),
    // Question(
    //     questionText: 'No piece of square dry paper can be folded in half more than 7 times.',
    //     questionAnswer: false),
    // Question(
    //     questionText: 'In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.',
    //     questionAnswer: true),
    // Question(
    //     questionText: 'The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.',
    //     questionAnswer: false),
    // Question(
    //     questionText: 'The total surface area of two human lungs is approximately 70 square metres.',
    //     questionAnswer: true),
    // Question(questionText: 'Google was originally called \"Backrub\".', questionAnswer: true),
    // Question(
    //     questionText: 'Chocolate affects a dog\'s heart and nervous system; a few ounces are enough to kill a small dog.',
    //     questionAnswer: true),
    // Question(
    //     questionText: 'In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.',
    //     questionAnswer: true),
  ];

  String getQuestionText() {
    return _questionBank[_questionNumber].questionText;
  }

  bool getQuestionAnswer() {
    return _questionBank[_questionNumber].questionAnswer;
  }

  int getQuestionLength() {
    return _questionBank.length;
  }

  // int gotoNextQuestion() {
  //   int qlength = _questionBank.length;
  //   debugPrint('-> $_questionNumber $qlength');
  //   return (_questionNumber + 1 == _questionBank.length)
  //       ? _questionNumber = 0
  //       : _questionNumber++;
  // }

  bool isFinished() {
    return (_questionNumber + 1 == _questionBank.length) ? true : false;
  }

  int gotoNextQuestion(BuildContext context) {
    int qlength = _questionBank.length;
    debugPrint('-> $_questionNumber $qlength');

    if (isFinished()) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "quizBrain ALERT",
        desc: "You've reached the end of the quiz.",
        buttons: [
          DialogButton(
            color: Colors.lightBlue,
            child: Text(
              "COOL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }

    return (isFinished()) ? _questionNumber = 0 : _questionNumber++;
  }
}

//DONE: Step 3 Part A - Create a method called isFinished() here that checks to see if we have reached the last question. It should return (have an output) true if we've reached the last question and it should return false if we're not there yet.

//TODO: Step 3 Part B - Use a print statement to check that isFinished is returning true when you are indeed at the end of the quiz and when a restart should happen.

//TODO: Step 4 Part B - Create a reset() method here that sets the questionNumber back to 0.
