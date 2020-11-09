import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:watchlist/api/google_api.dart';

class Auth {
  static final GoogleSignIn _googleSignIn =
      GoogleSignIn.standard(scopes: [SheetsApi.DriveScope]);
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User> signInSilently() {
    return signInWithGoogle(silently: true);
  }

  static Future<User> signInWithGoogle({silently = false}) async {
    // Try sign in with previous user.
    var account = await _googleSignIn.signInSilently();

    if (!silently && account == null) {
      account = await _googleSignIn.signIn();
    }

    if (account == null) return null;

    await GoogleApi.initialize(await account.authHeaders);
    final authentication = await account.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      assert(user.uid == _auth.currentUser.uid);

      return user;
    }

    return null;
  }
}
