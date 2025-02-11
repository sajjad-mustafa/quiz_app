import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/question_model.dart';

class DbHandler {
  final url = Uri.parse(
      'https://quiz-app-ad290-default-rtdb.firebaseio.com/questions.json');

  Future<void> addQuestion(Question question) async {
    http.post(
      url,
      body: json.encode({
        'title': question.title,
        'options': question.options,
      }),
    );
  }

  Future<List<Question>> fetchQuestions() async {
    return await http.get(url).then((response) {
      // String id = DateTime.now().millisecondsSinceEpoch.toString();
      // the 'then' method return a response which is our data.
      // to whats inside we have to decode it first.
      var data = json.decode(response.body) as Map<String, dynamic>;
      print(data);
      List<Question> newQuestions = [];
      int questionCounter = 1;
      data.forEach((key, value) {
        print('key: $key, value: $value');
        if (value is Map<String, dynamic>) {
          value.forEach((nestedKey, nestedValue) {
            if (nestedValue is Map<String, dynamic> &&
                nestedValue.containsKey('title') &&
                nestedValue.containsKey('options')) {
              var newQuestion = Question(
                  id: questionCounter.toString(),
                  title: nestedValue['title'] ?? 'No Title',
                  options:
                      Map<String, bool>.from(nestedValue['options'] ?? {}));
              newQuestions.add(newQuestion);
              questionCounter++;
            }
          });
        } else if (value is Map<String, dynamic> &&
            value.containsKey('title') &&
            value.containsKey('options')) {
          var newQuestion = Question(
            id: questionCounter.toString(),
            title: value['title'] ?? 'No Title',
            options: Map<String, bool>.from(value['options'] ?? {}),
          );
          newQuestions.add(newQuestion);
          questionCounter++;
        }
      });
      print('Parsed Questions: $newQuestions');

      return newQuestions;
      //     var newQuestion = Question(
      //       id: key,
      //       title: value['title'] ?? 'No Title',
      //       options: Map<String, bool>.from(value['options'] ?? {}),
      //     );
      //     newQuestions.add(newQuestion);
      //   });
      //   return newQuestions;
      // });
    });
  }
}
