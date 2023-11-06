import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addUserData(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e);
    });
  }

  getUserData() async {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future<Stream<QuerySnapshot>> getQuizData() async {
    return FirebaseFirestore.instance
        .collection("Quiz")
        .orderBy("quizTitle", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .snapshots();
  }
}
