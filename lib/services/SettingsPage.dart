// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:software_ingenieriaeconomica/screens/login_screen.dart'; // Asegúrate de que la ruta es correcta

class SettingsPage extends StatelessWidget {
  // ignore: use_super_parameters
  const SettingsPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(), // Asegúrate de que la ruta es correcta
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (user != null) ...[
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Correo: ${user.email ?? 'No disponible'}',
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No estás autenticado',
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                  ),
                ),
              ),
            ],
            const Spacer(),
            Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: ElevatedButton(
                onPressed: () => _signOut(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 127, 174, 212),
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ), // Llama al método _signOut
                child: Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}