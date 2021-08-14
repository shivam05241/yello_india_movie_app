import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<User?> signInWithGoogle() async {
  final googleUser = await GoogleSignIn().signIn();
  if (googleUser != null) {
    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken != null) {
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      ));
      return userCredential.user;
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: 'MISSING_GOOGLE_ID_TOKEN',
      );
    }
  } else {
    throw FirebaseAuthException(
      code: 'ERROR_ABORTED_BY_USER',
      message: 'SIGN_ABORTED_BY_USER',
    );
  }
}

@override
Future<void> signOut() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
}
