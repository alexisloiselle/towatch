import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:watchlist/api/google_api.dart';

class Auth {
  static final GoogleSignIn googleSignIn =
      GoogleSignIn.standard(scopes: [SheetsApi.DriveScope]);
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<GoogleSignInAccount> signInWithGoogle() async {
    final account = await googleSignIn.signIn();
    await GoogleApi.initialize(await account.authHeaders);
    return account;
  }
}
