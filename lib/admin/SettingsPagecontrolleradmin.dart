import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar para trabajar con SharedPreferences
import 'package:software_ingenieriaeconomica/screens/login_screen.dart';

class SettingsControllerAdmin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  
  String? cedula;
  String? rol; // Variable para el rol

  /// Método para cargar los datos del usuario, basado en la cédula almacenada en SharedPreferences.
  Future<void> fetchUserData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cedula = prefs.getString('cedula');
    rol = prefs.getString('rol'); // Recupera el rol desde el caché

    if (cedula == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró cédula en el caché.')),
      );
      return;
    }

    try {
      // Busca al usuario por cédula en Firestore.
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('cedula', isEqualTo: cedula)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first;

        nombreController.text = userData['firstName'] ?? '';
        apellidoController.text = userData['lastName'] ?? '';
        correoController.text = userData['email'] ?? '';
        cedula = userData['cedula'];
        rol = userData['rol']; // Carga el rol del usuario
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

  /// Método para cerrar sesión.
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();

    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.clear(); // Limpia el caché al cerrar sesión

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(), // Asegúrate de que la ruta es correcta
      ),
    );
  }
}
