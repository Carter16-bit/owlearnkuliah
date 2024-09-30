import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirebaseAuthHandler {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Buat daftar
  Future<String?> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // kirim ke firebase datanya
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Simpen data user
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await _secureStorage.write(key: 'uid', value: user.uid);
        await _secureStorage.write(key: 'email', value: email);

        return null; // Oke berarti kau user owlearn sekarang dan kamu menyetujui bahwa data kamu akan diambil :D AWOKWOKWOKWOKWOK
      } else {
        return 'User tidak ditemukan!';
      }
    } on FirebaseAuthException catch (e) {
      // Comot eror
      if (e.code == 'weak-password') {
        return 'Password terlalu lemah!';
      } else if (e.code == 'email-already-in-use') {
        return 'Email sudah digunakan!';
      } else {
        return e.message;
      }
    } catch (e) {
      // Menangani error lainnya
      return e.toString();
    }
  }

  // Buat Login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Loginnya disimpen dengan hebatt (Pertama kali nyoba flutter_secure_storage)😎
        await _secureStorage.write(key: 'uid', value: user.uid);
        await _secureStorage.write(key: 'email', value: email);

        return null;
      } else {
        return 'User tidak ditemukan!';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User tidak ditemukan!';
      } else if (e.code == 'wrong-password') {
        return 'Password salah!';
      } else {
        return e.message;
      }
    } catch (e) {
      // sisanya jadiin string
      return e.toString();
    }
  }

  // Buat Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _secureStorage.deleteAll();
  }

  // Ini buat UID
  Future<String?> getUid() async {
    return await _secureStorage.read(key: 'uid');
  }

  // Ini buat Email
  Future<String?> getEmail() async {
    return await _secureStorage.read(key: 'email');
  }

  // ini buat splashscreen
  Future<bool> isLoggedIn() async {
    String? uid = await getUid();
    return uid != null;
  }

  //comot username
  Future<String?> getUsername() async {
    String? uid = await getUid();
    if (uid != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        return userDoc['username'];
      }
    }
    return null;
  }
}
