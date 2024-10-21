import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/home_page.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/login_controller.dart';
import 'package:software_ingenieriaeconomica/admin/homepageadmin.dart';  // Página de usuario

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = LoginController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cedulaController,
              decoration: InputDecoration(labelText: 'Cédula'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
           ElevatedButton(
  onPressed: () async {
    try {
      // Intentar iniciar sesión con cédula y contraseña
      String? rol = await _loginController.login(
        _cedulaController.text,
        _passwordController.text,
      );

      // Comprobar el rol y redirigir según corresponda
      if (rol == 'admin') {
        Navigator.pushReplacementNamed(context, '/AdminHomePage');
      } else if (rol == 'usuario') {
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        _showSnackBar('Rol no reconocido');
      }
    } catch (e) {
      _showSnackBar('Error al iniciar sesión: $e');
    }
  },
  child: Text('Iniciar sesión'),
),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _loginController.registerFingerprint(
                    context: context,
                    cedulaController: _cedulaController,
                    passwordController: _passwordController,
                  );
                } catch (e) {
                  _showSnackBar('Error al registrar huella: $e');
                }
              },
              child: Text('Registrar huella'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool authenticated = await _loginController.authenticateWithBiometrics();
                if (authenticated) {
                  _showSnackBar('Autenticación exitosa');

                  // Obtener rol del usuario desde SharedPreferences (o Firestore)
                  String? rol = await _loginController.getUserRole();  // Método que obtendrá el rol desde Firestore o SharedPreferences

                  // Redirigir según el rol del usuario
                  if (rol == 'admin') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminHomePage()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                } else {
                  _showSnackBar('Autenticación fallida');
                }
              },
              child: Text('Iniciar sesión con huella'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
