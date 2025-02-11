import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/components/constants.dart';
import 'package:quiz_app/components/devoice_info.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    super.key,
    required this.result,
    required this.questionLength,
    required this.onPressed,
    required this.points,
  });

  final int result;
  final int questionLength;
  final VoidCallback onPressed;
  final int points;

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("User is not logged in!");
    }
  }

  Future<void> updateUserPoints(String userId, int newPoints) async {
    try {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users/$userId');
      await userRef.update({
        'points': newPoints, // ✅ Old points overwrite honge
      });

      print("User points updated successfully.");
    } catch (e) {
      print("Error updating user points: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: background,
      content: Padding(
        padding: EdgeInsets.all(70.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Result',
              style: TextStyle(
                color: neutral,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            CircleAvatar(
              radius: 70,
              backgroundColor: result == questionLength
                  ? correct
                  : result < questionLength / 2
                      ? incorrect
                      : Colors.yellow,
              child: Text(
                '$result/$questionLength',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: neutral,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              result == questionLength / 2
                  ? 'Almost There'
                  : result < questionLength / 2
                      ? 'Try Again ?'
                      : 'Great!',
              style: const TextStyle(
                color: neutral,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenhHeight * 0.025),
            GestureDetector(
              onTap: onPressed,
              child: Text(
                'Start Over',
                style: TextStyle(
                  fontSize: screenWidth * 0.050,
                  letterSpacing: 1.0,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: screenhHeight * 0.025),
            GestureDetector(
              onTap: () async {
                String userId = getCurrentUserId(); // ✅ Get userId
                await updateUserPoints(userId, points); // ✅ Update points
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  'Submit Result',
                  style: TextStyle(
                    fontSize: screenWidth * 0.039,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
