// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  const EditProfilePage({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Reautenticar al usuario si se intenta cambiar el email
        if (user.email != _emailController.text.trim()) {
          // Solicitar al usuario que ingrese su contraseña nuevamente
          await _showReauthenticateDialog();
        }

        // Actualizar Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
        });

        // Actualizar email en Firebase Auth
        if (user.email != _emailController.text.trim()) {
          await user.updateEmail(_emailController.text.trim());
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil actualizado correctamente.')),
        );

        Navigator.of(context).pop(true); // Indicar que la actualización fue exitosa
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'El correo electrónico ya está en uso.';
            break;
          case 'invalid-email':
            message = 'Correo electrónico inválido.';
            break;
          case 'requires-recent-login':
            message = 'Necesitas iniciar sesión nuevamente para actualizar tu correo electrónico.';
            break;
          default:
            message = 'Error de autenticación: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en Firestore: ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No estás autenticado.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showReauthenticateDialog() async {
    final TextEditingController _passwordController = TextEditingController();
    final User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No estás autenticado.')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reautenticarse"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Para actualizar tu correo electrónico, por favor ingresa tu contraseña."),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final credential = EmailAuthProvider.credential(
                  email: user.email!,
                  password: _passwordController.text,
                );

                try {
                  await user.reauthenticateWithCredential(credential);
                  Navigator.of(context).pop();
                } on FirebaseAuthException catch (e) {
                  String message;
                  switch (e.code) {
                    case 'wrong-password':
                      message = 'Contraseña incorrecta.';
                      break;
                    case 'user-mismatch':
                      message = 'El usuario no coincide.';
                      break;
                    case 'user-not-found':
                      message = 'Usuario no encontrado.';
                      break;
                    case 'invalid-credential':
                      message = 'Credenciales inválidas.';
                      break;
                    default:
                      message = 'Error de reautenticación: ${e.message}';
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              },
              child: Text("Reautenticarse"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Perfil'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Campo de Nombre
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, ingrese su nombre.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Campo de Apellido
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Apellido',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, ingrese su apellido.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Campo de Correo
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, ingrese su correo electrónico.';
                            }
                            // Validación básica de correo
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                              return 'Ingrese un correo electrónico válido.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        // Botón para actualizar datos
                        ElevatedButton(
                          onPressed: _updateProfile,
                          child: Text(
                            'Actualizar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 127, 174, 212),
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
