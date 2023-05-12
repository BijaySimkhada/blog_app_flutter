import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  loginUser(String email, String password) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseException catch (e) {
      print("error ${e.message}");
      return false;
    }
  }

  logoutUser() async {
    try {
      final user = await firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      print("error ${e.message}");
    }
  }

  registerUser(String email, String password, String username) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = firebaseAuth.currentUser;
      if(user != null){
        await user.updateDisplayName(username);
      }
      return true;
    } on FirebaseException catch (e) {
      print("error ${e.message}");
      return false;
    }
  }
}
