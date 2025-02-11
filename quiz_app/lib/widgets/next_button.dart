import 'package:flutter/material.dart';
import 'package:quiz_app/components/constants.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
  });
  // final VoidCallback nextQuestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: neutral, borderRadius: BorderRadius.circular(10.0)),
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //   child: Container(
      //     width: double.infinity,
      //     decoration: BoxDecoration(
      //       color: neutral,
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: const Text(
        'Next Question',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }
}
