import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  Future<void> loginWithUsernamePassword(
      String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Username tidak ditemukan');
      }

      final userDoc = querySnapshot.docs.first;
      final storedPassword = userDoc['password'];

      if (password != storedPassword) {
        throw Exception('Password salah');
      }

      _currentUser = User(
        uid: userDoc.id,
        displayName: userDoc['name'] ?? 'User',
      );

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}

class User {
  final String uid;
  final String displayName;

  User({
    required this.uid,
    required this.displayName,
  });
}