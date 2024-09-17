// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/screens/home_page.dart';
import 'package:software_ingenieriaeconomica/screens/register_page.dart'; // Asegúrate de tener este archivo
import 'package:software_ingenieriaeconomica/screens/reset_password_page.dart'; // Asegúrate de tener este archivo

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    final cedula = _cedulaController.text;
    final password = _passwordController.text;

    try {
      // Buscar la cédula en Firestore para obtener el correo electrónico asociado
      final userDoc = await _firestore.collection('users').doc(cedula).get();

      if (!userDoc.exists) {
        throw Exception('Cédula no encontrada.');
      }

      final email = userDoc.data()?['email'];

      if (email == null) {
        throw Exception('Correo electrónico no asociado con la cédula.');
      }

      // Iniciar sesión con el correo electrónico y contraseña
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inicio de sesión exitoso.')),
      );

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(), // Cambia a tu página principal
          ));
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Correo electrónico no encontrado.')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña incorrecta.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de autenticación: ${e.message}')),
        );
      }
    } on FirebaseException catch (e) {
    
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en Firestore: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _navigateToResetPasswordPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResetPasswordPage(),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 133, 238, 159),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
          child: Center(
            child: Text(
              'TuBank',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'Login',
              style: TextStyle(
                color: Color.fromARGB(255, 133, 238, 159),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _cedulaController,
                    decoration: InputDecoration(
                      hintText: "Ingrese Cedula Ciudadana",
                      labelText: "Cedula",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Ingrese Contraseña",
                      labelText: "Contraseña",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 133, 238, 159),
                          minimumSize: Size(150, 50), // Tamaño mínimo del botón
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 133, 238, 159),
                          minimumSize: Size(150, 50), // Tamaño mínimo del botón
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _navigateToResetPasswordPage,
                    child: Text(
                      'Olvidé mi Contraseña',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 133, 238, 159),
                      minimumSize: Size(double.infinity, 50), // Botón de ancho completo
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}
