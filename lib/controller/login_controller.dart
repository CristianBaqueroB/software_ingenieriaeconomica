import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Método para iniciar sesión.
  /// Retorna el rol del usuario ('admin' o 'usuario') si la autenticación es exitosa.
  Future<String?> login(String cedula, String password) async {
    if (cedula.isEmpty || password.isEmpty) {
      throw Exception('Por favor, complete todos los campos.');
    }

    try {
      // Busca al usuario por cédula en Firestore.
      final userQuery = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('Cédula no encontrada.');
      }

      final userDoc = userQuery.docs.first;
      final email = userDoc.data()['email'];
      final rol = userDoc.data()['rol']; // Asegúrate de que el campo 'rol' exista

      if (email == null) {
        throw Exception('Correo electrónico no asociado con la cédula.');
      }

      // Intenta autenticar al usuario con Firebase Auth.
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Guarda la cédula en SharedPreferences para uso futuro.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cedula', cedula);

      // Retorna el rol del usuario.
      print('Rol del usuario: $rol'); // Para depuración
      return rol;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Correo electrónico no encontrado.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta.');
      } else {
        throw Exception('Error de autenticación: ${e.message}');
      }
    } on FirebaseException catch (e) {
      throw Exception('Error en Firestore: ${e.message}');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Método para autenticar usando biometría.
  /// Retorna el rol del usuario si la autenticación es exitosa.
  Future<String?> authenticateWithBiometrics() async {
    bool authenticated = false;

    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Use su huella digital o reconocimiento facial para autenticarse',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } catch (e) {
      throw Exception('Error de autenticación biométrica: ${e.toString()}');
    }

    if (authenticated) {
      final prefs = await SharedPreferences.getInstance();
      final cedula = prefs.getString('cedula');

      if (cedula == null) {
        throw Exception('Cédula no encontrada en la caché.');
      }

      final userQuery = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('Cédula no encontrada en Firestore.');
      }

      final userDoc = userQuery.docs.first;
      final email = userDoc.data()['email'];
      final rol = userDoc.data()['rol']; // Asegúrate de que el campo 'rol' exista

      if (email == null) {
        throw Exception('Correo electrónico no asociado con la cédula.');
      }

      // Aquí deberías gestionar la contraseña de alguna manera segura.
      // Por ejemplo, podrías usar un token o una sesión persistente en lugar de una contraseña.
      String password = 'tu_contraseña_ficticia'; // Esto es solo un placeholder

      // Intenta autenticar al usuario con Firebase Auth.
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Retorna el rol del usuario.
      print('Rol del usuario: $rol'); // Para depuración
      return rol;
    } else {
      throw Exception('No se pudo autenticar usando biometría.');
    }
  }
}
