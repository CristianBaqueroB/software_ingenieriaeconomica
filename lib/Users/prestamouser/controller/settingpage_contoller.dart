// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar para trabajar con SharedPreferences
import 'package:software_ingenieriaeconomica/screens/login_screen.dart';

class SettingsController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  String? cedula;
  String? rol; // Variable para el rol
  double montoPrestamo = 0.0; // Agregar propiedad para el monto del préstamo
  double saldo = 0.0; // Agregar propiedad para el saldo

  /// Método para cargar los datos del usuario, incluyendo el rol, monto del préstamo y saldo desde Firestore.
  Future<void> fetchUserData(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Consultar Firestore para obtener los datos del usuario basado en el correo electrónico
        QuerySnapshot userSnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          var userData = userSnapshot.docs.first;

          // Rellenar los controladores de texto con los datos del usuario
          nombreController.text = userData['firstName'] ?? '';
          apellidoController.text = userData['lastName'] ?? '';
          correoController.text = user.email ?? '';
          cedula = userData['cedula'];
          rol = userData['rol']; // Cargar el rol del usuario

          // Cargar el monto del préstamo y el saldo
          montoPrestamo = userData['prestamo']?.toDouble() ?? 0.0;
          saldo = userData['saldo']?.toDouble() ?? 0.0;

          // Almacenar la cédula y el rol en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('cedula', cedula!);
          await prefs.setString('rol', rol!);
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

  /// Método para verificar la contraseña del usuario
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

  /// Método para cerrar sesión y limpiar el caché
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();

    // Limpiar SharedPreferences al cerrar sesión
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(), // Asegúrate de que la ruta es correcta
      ),
    );
  }

  /// Método para obtener el rol del usuario desde el caché
  Future<String?> getUserRoleFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('rol'); // Recupera el rol desde el caché
  }
}
