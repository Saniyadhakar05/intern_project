import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User?> signIn(String email, String password) async{
  try{
    final result = await _auth.createUserWithEmailAndPassword(
    email: email, password: password);
    return result.user;
  }
  catch (e){
    rethrow;
  }
}

}
