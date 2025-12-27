import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream to listen to authentication changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current logged-in user
  User? get currentUser => _auth.currentUser;

  /// Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Register a new user with email and password
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw FirebaseAuthException(
        code: 'email-already-verified',
        message: 'Email is already verified or user is not signed in.',
      );
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    final user = currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload(); // Refresh the user object
    }
  }

  /// Update user photo URL
  Future<void> updatePhotoURL(String photoURL) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoURL);
      await user.reload();
    }
  }

  /// Update user email (requires recent login)
  Future<void> updateEmail(String email) async {
    final user = currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(email);
    }
  }

  /// Update user password (requires recent login)
  Future<void> updatePassword(String password) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePassword(password);
    }
  }

  /// Delete current user (requires recent login)
  Future<void> deleteUser() async {
    final user = currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  /// Re-authenticate user with email & password
  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    final user = currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  /// Private method to handle FirebaseAuthException with readable messages
  FirebaseAuthException _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return FirebaseAuthException(
          code: e.code,
          message: 'No user found for that email.',
        );
      case 'wrong-password':
        return FirebaseAuthException(
          code: e.code,
          message: 'Incorrect password provided.',
        );
      case 'email-already-in-use':
        return FirebaseAuthException(
          code: e.code,
          message: 'The account already exists for that email.',
        );
      case 'weak-password':
        return FirebaseAuthException(
          code: e.code,
          message: 'The password provided is too weak.',
        );
      default:
        return e;
    }
  }
}
