import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/components/constants.dart';
import 'package:quiz_app/components/devoice_info.dart';
import 'package:quiz_app/models/db_handler.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/dashboard_screen.dart';
import 'package:quiz_app/widgets/next_button.dart';
import 'package:quiz_app/widgets/option_card.dart';
import 'package:quiz_app/widgets/question_widget.dart';
import 'package:quiz_app/widgets/result_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = DbHandler();
  late Future _questions;
  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  // final List<Question> _questions = [
  //   Question(
  //     id: '10',
  //     title: 'what is 2+2 ?',
  //     options: {'5': false, '30': false, '4': true, '10': false},
  //   ),
  //   Question(
  //       id: '11',
  //       title: "what is 10+20?",
  //       options: {'50': false, '30': true, '20': false, '25': false})
  // ];

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;
  int? selectedIndex;

  // get extractedData => null;
  void nextQuestion(int questionLength) {
    if (index >= questionLength - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score,
                questionLength: questionLength,
                onPressed: startOver,
                points: score,
              ));
      return;
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
          selectedIndex = null;
        });
        print('Next Question - Index: $index');
        print('Current Index: $index');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select any option'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void checkAnswerAndUpdate(
      List<Question> extractedData, bool isCorrect, int optionIndex) {
    if (isAlreadySelected) {
      return;
    }
    setState(() {
      isPressed = true;
      selectedIndex = optionIndex;
    });
    //show dialog with animation
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (widget, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: widget,
                      );
                    },
                    child: isCorrect
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 80,
                            key: ValueKey(1),
                          )
                        : Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 80,
                            key: ValueKey(2),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    isCorrect ? "Correct Answer!" : "Wrong Answer!",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? Colors.green : Colors.red),
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      nextQuestion(extractedData.length);
                    },
                    child: Text('Next')),
              ],
            ));
    // update score if correct
    if (isCorrect) {
      score++;
    }
  }

  // void checkAnswerAndUpdate(bool value, int optionIndex) {
  //   if (isPressed) return;

  //   if (value) score++;
  //   setState(() {
  //     isPressed = true;
  //     selectedIndex = optionIndex;
  //   });
  // }
  //   if (isAlreadySelected) {
  //     return;
  //   } else {
  //     if (value == true) {
  //       score++;
  //     }
  //     setState(() {
  //       isPressed = true;
  //     });
  //   }
  // }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      selectedIndex = null;
      //  isAlreadySelected = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashboardScreen()));
  }

  Future<void> updateUserPoints(String userId, int newPoints) async {
    try {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users/$userId');
      await userRef.update({
        'points': newPoints,
      });
      print('user points update successfully.');
    } catch (e) {
      print("Error updating user points:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            //   }
            // } else {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            return Scaffold(
              backgroundColor: background,
              appBar: AppBar(
                foregroundColor: Colors.white,
                backgroundColor: background,
                actions: [
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Score: $score',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
                title: Center(
                  child: Text(
                    'Quiz App',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              body: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      QuestionWidget(
                        indexAction:
                            '${(index + 1).toString().padLeft(2, '0')}/${extractedData.length}',
                        question: extractedData[index].title ?? 'No title',
                        totalQuestions: extractedData.length.toString(),
                      ),
                      Text(extractedData.length.toString()),
                      Divider(
                        color: neutral,
                      ),
                      SizedBox(
                        height: screenhHeight * 0.025,
                      ),
                      for (int i = 0;
                          i < extractedData[index].options.length;
                          i++)
                        GestureDetector(
                          onTap: () {
                            bool isCorrect =
                                extractedData[index].options.values.toList()[i];
                            checkAnswerAndUpdate(extractedData, isCorrect, i);
                          },
                          // onTap: () => checkAnswerAndUpdate(
                          //   extractedData[index].options.values.toList()[i],
                          //   i,
                          // ),
                          child: OptionCard(
                            option:
                                extractedData[index].options.keys.toList()[i],
                            color: isPressed
                                ? extractedData[index]
                                            .options
                                            .values
                                            .toList()[i] ==
                                        true
                                    ? correct
                                    : incorrect
                                : neutral,
                            icon: isPressed
                                ? (selectedIndex == i)
                                    ? (extractedData[index]
                                            .options
                                            .values
                                            .toList()[i]
                                        ? Icons.check
                                        : Icons.close)
                                    : null
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(
                      // nextQuestion: nextQuestion,
                      ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const Center(
          child: Text('No Data'),
        );
      },
    );
  }
}
