import 'package:flutter/material.dart';
import 'package:quiz_app/components/constants.dart';
import 'package:quiz_app/components/devoice_info.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget(
      {super.key,
      required this.question,
      required this.indexAction,
      required this.totalQuestions});

  final String question;
  final String indexAction;
  final String totalQuestions;

  @override
  Widget build(BuildContext context) {
    print(indexAction);
    return Container(
      child: Text(
        'Question ${indexAction.toString()}:$question',
        style: TextStyle(fontSize: screenWidth * 0.050, color: neutral),
      ),
    );
  }
}
