import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_assistant/models/login_user.dart';
import 'package:my_assistant/service/firestore_service.dart';

class FirebaseService {
  static Future<UserCredential> createUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      User? user = credential.user;

      if (user != null) {
        LoginUser loginUser = LoginUser(
          fullName: name,
          id: user.uid,
          emailId: user.email,
          password: password,
          role: "user",
          status: "created",
          isActive: "1",
          createdAt: DateTime.now().toString(),
        );

        await FirestoreService.addUser(loginUser);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
        throw ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email.');
      } else {
        throw "${e.message}";
      }
    } catch (e) {
      print(e);
      throw "$e";
    }
  }

  static Future<UserCredential> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
        throw ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email.');
      } else {
        throw "${e.message}";
      }
    } catch (e) {
      print(e);
      throw "$e";
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
