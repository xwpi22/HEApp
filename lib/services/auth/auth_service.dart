import 'package:heapp/services/auth/auth_user.dart';
import 'package:heapp/services/auth/auth_provider.dart';
import 'package:heapp/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  Future<void> deleteUser() => provider.deleteUser();

  @override
  Future<void> reauthenticate({
    required String email,
    required String password,
  }) =>
      provider.reauthenticate(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Stream<AuthUser?> get authStateChanges => provider.authStateChanges;

  @override
  Future<void> resetPassword({required String email}) =>
      provider.resetPassword(email: email);
}
