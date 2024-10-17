// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/screens/login_screen.dart';

class SettingsController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  
  String? cedula;

  Future<void> fetchUserData(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot userSnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          var userData = userSnapshot.docs.first;

          nombreController.text = userData['firstName'] ?? '';
          apellidoController.text = userData['lastName'] ?? '';
          correoController.text = user.email ?? '';
          cedula = userData['cedula'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario no encontrado en Firestore.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los datos del usuario: $e')),
        );
      }
    }
  }

  Future<bool> verifyPassword(String password) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Re-autenticar al usuario con la contraseña
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        // Intentar reautenticar
        await user.reauthenticateWithCredential(credential);
        return true; // Contraseña correcta
      } catch (e) {
        return false; // Contraseña incorrecta
      }
    }
    return false; // Usuario no autenticado
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(), // Asegúrate de que la ruta es correcta
      ),
    );
  }
}
