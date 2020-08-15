import 'package:firebase_auth/firebase_auth.dart';
import 'package:resumereview/provider/user.dart';




class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  
  
  

  // create user obj based on firebase user
  User userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
      //.map((FirebaseUser user) => _userFromFirebaseUser(user));
      .map(userFromFirebaseUser);
  }

    Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}