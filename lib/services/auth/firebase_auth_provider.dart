import 'package:firebase_core/firebase_core.dart';
import 'package:heapp/firebase_options.dart';
import 'package:heapp/services/auth/auth_exceptions.dart';
import 'package:heapp/services/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show EmailAuthProvider, FirebaseAuth, FirebaseAuthException;
import 'package:heapp/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('沒有登入中的使用者');
    }

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw RequiresRecentLoginAuthException();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('沒有登入中的使用者');
    }

    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw WrongPasswordOrUserNotFoundAuthException();
      } else {
        throw GenericAuthException();
      }
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw WrongPasswordOrUserNotFoundAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Stream<AuthUser?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges().map((user) {
        return user != null ? AuthUser.fromFirebase(user) : null;
      });

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}
