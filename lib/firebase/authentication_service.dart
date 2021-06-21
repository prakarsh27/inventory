import 'package:firebase_auth/firebase_auth.dart';

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
      return e.message;
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
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}