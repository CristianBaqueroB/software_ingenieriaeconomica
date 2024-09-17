import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/screens/login_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _cedulaController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    final cedula = _cedulaController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Crear el usuario en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener el UID del usuario
      final uid = userCredential.user!.uid;

      // Guardar información adicional en Firestore usando la cédula como ID del documento
      await _firestore.collection('users').doc(cedula).set({
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso. Por favor, inicia sesión.')),
      );

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de autenticación: ${e.message}')),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        toolbarHeight: 30, // Reduce la altura del AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 24, // Tamaño de la flecha
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),),
      body: Column(
        children: [
        
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'Registro',
                style: TextStyle(
                  color: Color.fromARGB(255, 133, 238, 159),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: _cedulaController,
                      decoration: InputDecoration(
                        hintText: "Ingrese Número de Cédula",
                        labelText: "Número de Cédula",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: "Ingrese Primer Nombre",
                        labelText: "Primer Nombre",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: "Ingrese Apellido",
                        labelText: "Apellido",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Ingrese Correo Electrónico",
                        labelText: "Correo Electrónico",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _register,
                      child: Text(
                        'Registrarse',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 133, 238, 159),
                        minimumSize: Size(double.infinity, 30), // Botón de ancho completo
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
