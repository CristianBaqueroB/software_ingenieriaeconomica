import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// Método para iniciar sesión con cédula y contraseña.
  Future<void> loginWithDocument({
    required String cedula,
    required String password,
  }) async {
    try {
      // Buscar en Firestore el correo asociado al número de documento
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .limit(1)
          .get();

      // Si el usuario existe
      if (userSnapshot.docs.isNotEmpty) {
        String email = userSnapshot.docs.first['email'];

        // Autenticar al usuario con Firebase usando el correo y la contraseña
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        // Guardar la cédula en SharedPreferences
        final prefs = await _prefs;
        await prefs.setString('cedula', cedula);
        print("Cédula guardada en SharedPreferences: $cedula");
      } else {
        throw Exception('Usuario no encontrado con ese número de cédula.');
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  Future<String?> login(String cedula, String password) async {
    if (cedula.isEmpty || password.isEmpty) {
      throw Exception('Por favor, complete todos los campos.');
    }

    try {
      // Buscar en Firestore el correo asociado a la cédula
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String email = userQuery.docs.first['email'];
        String rol = userQuery.docs.first['rol'];

        // Autenticar al usuario con Firebase usando el correo y la contraseña
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        // Guardar la cédula y rol en SharedPreferences
        final prefs = await _prefs;
        await prefs.setString('cedula', cedula);
        await prefs.setString('rol', rol);

        return rol; // Retornar el rol del usuario
      } else {
        throw Exception('Cédula no encontrada en la base de datos.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Correo electrónico no encontrado.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta.');
      } else {
        throw Exception('Error de autenticación: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Método para autenticar al usuario con huella digital
  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      final prefs = await _prefs;
      final lastUserDocument = prefs.getString('cedula');

      if (lastUserDocument == null) {
        throw Exception('No hay cédula almacenada. No se puede autenticar.');
      }

      authenticated = await _localAuth.authenticate(
        localizedReason: 'Use su huella digital para autenticarse',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        return true; // Retorna true si la autenticación fue exitosa
      }
    } catch (e) {
      throw Exception('Error con la autenticación biométrica: $e');
    }
    return false;
  }

  /// Verificar si el dispositivo soporta autenticación biométrica
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  /// Obtener la cédula del último usuario desde SharedPreferences.
  Future<String?> loadLastUserCedula() async {
    final prefs = await _prefs;
    return prefs.getString('cedula');
  }

  /// Método para cerrar sesión.
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await _prefs;
    await prefs.clear(); // Limpiar SharedPreferences
  }

  /// Mostrar SnackBar para mensajes
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Registrar huella dactilar
  Future<void> registerFingerprint({
    required BuildContext context,
    required TextEditingController cedulaController,
    required TextEditingController passwordController,
  }) async {
    String cedula = cedulaController.text.trim();
    String password = passwordController.text;

    if (cedula.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Por favor, complete todos los campos.');
      return;
    }

    try {
      bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      if (!canAuthenticateWithBiometrics) {
        _showSnackBar(context, 'Tu dispositivo no soporta autenticación biométrica.');
        return;
      }

      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Por favor, escanea tu huella para registrar tu sesión.',
        options: const AuthenticationOptions(stickyAuth: true),
      );

      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cedula', cedula);
        await prefs.setString('password', password);
        _showSnackBar(context, 'Huella y datos registrados con éxito.');
      } else {
        _showSnackBar(context, 'La autenticación con huella falló.');
      }
    } catch (e) {
      _showSnackBar(context, 'Error al registrar huella: $e');
    }
  }
  Future<String?> getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('rol');  // Si guardaste el rol en SharedPreferences, lo obtienes aquí.
}

}
