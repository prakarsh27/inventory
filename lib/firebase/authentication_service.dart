import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({OurUser user, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: password);
      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          Fluttertoast.showToast(
              msg: "Email already used. Go to login page.", fontSize: 20);
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          Fluttertoast.showToast(
              msg: "Wrong email/password combination.", fontSize: 20);
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          Fluttertoast.showToast(
              msg: "No user found with this email.", fontSize: 20);
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          Fluttertoast.showToast(msg: "User disabled.");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          Fluttertoast.showToast(
              msg: "Too many requests to log into this account.", fontSize: 20);
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          Fluttertoast.showToast(
              msg: "Server error, please try again later.", fontSize: 20);
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          Fluttertoast.showToast(
              msg: "Email address is invalid.", fontSize: 20);
          break;
        default:
          Fluttertoast.showToast(
              msg: "Login failed. Please try again.", fontSize: 20);
          break;
      }
      return 'Login Failed';
    }
  }

  Future<String> signUp({OurUser user, String password}) async {
    String retVal = 'error';
    OurUser _user = OurUser();
    try {
      UserCredential _userCred =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: password);
      _user.uid = _userCred.user.uid;
      _user.email = _userCred.user.email;
      _user.fullName = user.fullName;
      String _return = await UserDatabase().createUser(_user);
      if (_return == 'success') {
        retVal = 'success';
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message;
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          Fluttertoast.showToast(
              msg: "Email already used. Go to login page.", fontSize: 20);
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          Fluttertoast.showToast(
              msg: "Wrong email/password combination.", fontSize: 20);
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          Fluttertoast.showToast(
              msg: "No user found with this email.", fontSize: 20);
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          Fluttertoast.showToast(msg: "User disabled.", fontSize: 20);
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          Fluttertoast.showToast(
              msg: "Too many requests to log into this account.", fontSize: 20);
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          Fluttertoast.showToast(
              msg: "Server error, please try again later.", fontSize: 20);
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          Fluttertoast.showToast(
              msg: "Email address is invalid.", fontSize: 20);
          break;
        default:
          Fluttertoast.showToast(
              msg: "Login failed. Please try again.", fontSize: 20);
          break;
      }
      print(e);
    }
    return retVal;
  }
}
