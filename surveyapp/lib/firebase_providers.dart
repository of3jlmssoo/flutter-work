// dart run build_runner build

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

class AuthenticationManagement {
  AuthenticationManagement(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}

@Riverpod(keepAlive: true)
class firebaseAuth extends _$firebaseAuth {
  @override
  FirebaseAuth build() {
    return FirebaseAuth.instance;
  }
}

@Riverpod(keepAlive: true)
AuthenticationManagement authRepository(AuthRepositoryRef ref) {
  return AuthenticationManagement(ref.watch(firebaseAuthProvider));
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
