// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/models.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── AUTH ───────────────────────────────────────────────────────────────────

  static User? get currentUser => _auth.currentUser;
  static String? get uid => _auth.currentUser?.uid;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential> signUp(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  static Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  static Future<void> signOut() => _auth.signOut();

  static Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId:
          '787763857853-78qh0neup1vho2os37nbrtl5iovpns5u.apps.googleusercontent.com',
    ).signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    // Auto-create profile in Firestore if new user
    if (userCredential.additionalUserInfo?.isNewUser == true) {
      final user = userCredential.user!;
      await saveUserProfile(
        UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          age: 0,
          weight: 0.0,
          height: 0.0,
          condition: 'None',
          createdAt: DateTime.now(),
        ),
      );
    }

    return userCredential;
  }

  // ─── USER PROFILE ───────────────────────────────────────────────────────────

  static Future<void> saveUserProfile(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  static Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) return UserModel.fromMap(doc.data()!);
    return null;
  }

  static Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // ─── PERIOD TRACKING ────────────────────────────────────────────────────────

  static Future<void> savePeriodEntry(PeriodEntry entry) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('periods')
        .doc(entry.id)
        .set(entry.toMap());
  }

  static Future<void> updatePeriodEntry(PeriodEntry entry) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('periods')
        .doc(entry.id)
        .update(entry.toMap());
  }

  static Stream<List<PeriodEntry>> getPeriodEntries() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('periods')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => PeriodEntry.fromMap(d.data())).toList(),
        );
  }

  static Future<void> deletePeriodEntry(String entryId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('periods')
        .doc(entryId)
        .delete();
  }

  // ─── SYMPTOMS ───────────────────────────────────────────────────────────────

  static Future<void> saveSymptomEntry(SymptomEntry entry) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('symptoms')
        .doc(entry.id)
        .set(entry.toMap());
  }

  static Stream<List<SymptomEntry>> getSymptomEntries() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('symptoms')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => SymptomEntry.fromMap(d.data())).toList(),
        );
  }

  // ─── WEIGHT ─────────────────────────────────────────────────────────────────

  static Future<void> saveWeightEntry(WeightEntry entry) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('weight')
        .doc(entry.id)
        .set(entry.toMap());
  }

  static Stream<List<WeightEntry>> getWeightEntries() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('weight')
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => WeightEntry.fromMap(d.data())).toList(),
        );
  }

  static Future<void> deleteWeightEntry(String entryId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('weight')
        .doc(entryId)
        .delete();
  }
}
