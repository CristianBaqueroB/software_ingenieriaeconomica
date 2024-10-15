import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/admin/homepageadmin.dart';
import 'package:software_ingenieriaeconomica/screens/home_page.dart';
import 'package:software_ingenieriaeconomica/screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Si el usuario está autenticado
    if (user != null) {
      // Verificar el rol del usuario en Firestore
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()), // Mostrar indicador de carga
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')), // Manejar error
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Scaffold(
              body: Center(child: Text('Documento de usuario no encontrado.')),
            );
          }

          // Obtener el rol del usuario
          final rol = snapshot.data!.get('rol'); // Asegúrate de que el campo 'rol' exista

          // Imprimir el rol para depuración
          print('Rol del usuario: $rol');

          // Redirigir según el rol
          if (rol == 'admin') {
            return AdminHomePage(); // Redirigir a la página de administración
          } else if (rol == 'usuario') {
            return HomePage(); // Redirigir a la página del usuario
          } else {
            return Scaffold(
              body: Center(child: Text('Rol desconocido: $rol')),
            );
          }
        },
      );
    } else {
      return LoginPage(); // Si no está autenticado, mostrar la página de login
    }
  }
}
