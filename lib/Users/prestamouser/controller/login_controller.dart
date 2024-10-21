import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// Método para iniciar sesión con cédula y contraseña.
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

      // Si el usuario existe
      if (userQuery.docs.isNotEmpty) {
        // Obtener el email y rol del usuario
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

Future<String?> authenticateWithBiometrics() async {
  try {
    bool authenticated = await _localAuth.authenticate(
      localizedReason: 'Use su huella digital o reconocimiento facial para autenticarse',
      options: const AuthenticationOptions(stickyAuth: true),
    );

    if (authenticated) {
      final prefs = await SharedPreferences.getInstance();
      String? cedula = prefs.getString('cedula');
      
      print('Cédula recuperada para biometría: $cedula');

      if (cedula == null) {
        throw Exception('No se pudo recuperar la cédula necesaria para la autenticación.');
      }

      final userQuery = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('Cédula no encontrada en la base de datos.');
      }

      final userDoc = userQuery.docs.first.data();
      String rol = userDoc['rol'];
      String email = userDoc['email'];

      print('Datos de usuario recuperados de Firebase: email=$email, rol=$rol');

      await _auth.signInWithEmailAndPassword(email: email, password: prefs.getString('password')!);

      return rol;
    } else {
      throw Exception('No se pudo autenticar usando biometría.');
    }
  } catch (e) {
    print('Error de autenticación biométrica: ${e.toString()}');
    throw Exception('Error de autenticación biométrica: ${e.toString()}');
  }
}


  /// Método para verificar si el dispositivo puede usar la autenticación biométrica.
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  /// Método para obtener la cédula del último usuario utilizado desde SharedPreferences.
  Future<String?> loadLastUserCedula() async {
    final prefs = await _prefs;
    return prefs.getString('cedula');
  }

  /// Método para cerrar sesión.
  Future<void> logout() async {
    await _auth.signOut();
    //final prefs = await _prefs;
    //await prefs.clear(); 
  }
}
