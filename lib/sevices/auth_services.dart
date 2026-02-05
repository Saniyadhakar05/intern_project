import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<User?> signIn(String email, String password) async{
  try{
    final result = await _auth.signInWithEmailAndPassword(
    email: email, password: password);
    return result.user;
  }
  catch (e){
    rethrow;
  }
}

Future<User?> signUp(String email, String password) async{
  try{
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;
  }
  catch(e){
    rethrow;
  }
}
Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential= await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

}


