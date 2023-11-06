import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizapp2/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future signInEmailAndPass(String email, String password) async {
    var res;
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;
      res = _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (err) {
      res = err;
    }
    return res;
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    var res;
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = authResult.user;
      res = _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (signUpError) {
      if (signUpError.code == "account-exists-with-different-credential") {
        res = "account-exists-with-different-credential";
      } else if (signUpError.code == 'weak-password') {
        res = 'weak-password';
      } else if (signUpError.code == 'invalid-email') {
        res = 'invalid-email';
      }
    }
    return res;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
