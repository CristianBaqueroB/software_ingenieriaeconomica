import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa esta librería para usar TextInputFormatter
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/login_controller.dart';
import 'package:software_ingenieriaeconomica/Users/home_page.dart';
import 'package:software_ingenieriaeconomica/screens/reset_password_page.dart';
import 'package:software_ingenieriaeconomica/screens/register_page.dart';
import 'package:software_ingenieriaeconomica/admin/homepageadmin.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _controller = LoginController();

  // Variable para manejar la visibilidad de la contraseña
  bool _isPasswordVisible = false;

  // Variable para manejar el estado de carga
  bool _isLoading = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Función para manejar el inicio de sesión.
  void _handleLogin() async {
    String cedula = _cedulaController.text.trim();
    String password = _passwordController.text;

    // Validar que los campos no estén vacíos
    if (cedula.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    try {
      // Llamar al método login del controlador y obtener el rol
      String? rol = await _controller.login(cedula, password);

      if (rol != null) {
        if (rol == 'admin') {
          // Redirigir a la página de administrador
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminHomePage()),
          );
        } else if (rol == 'usuario') {
          // Redirigir a la página de usuario
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Manejar un rol desconocido
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rol desconocido: $rol')),
          );
        }
      }
    } catch (e) {
      // Manejar errores y mostrar el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });
    }
  }

  /// Función para manejar la autenticación biométrica.
  void _handleBiometricAuth() async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    try {
      String? rol = await _controller.authenticateWithBiometrics();

      if (rol != null) {
        if (rol == 'admin') {
          // Redirigir a la página de administrador
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminHomePage()),
          );
        } else if (rol == 'usuario') {
          // Redirigir a la página de usuario
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Manejar un rol desconocido
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rol desconocido: $rol')),
          );
        }
      }
    } catch (e) {
      // Manejar errores y mostrar el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Encabezado de la aplicación
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
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Título de la página
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
          // Formulario de login
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Campo de la cédula (solo números y máximo 11 caracteres)
                    TextField(
                      controller: _cedulaController,
                      decoration: InputDecoration(
                        hintText: "Ingrese Cédula Ciudadana",
                        labelText: "Cédula",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Solo permite dígitos
                        LengthLimitingTextInputFormatter(11), // Limitar a 11 caracteres
                      ],
                    ),
                    SizedBox(height: 30),
                    // Campo de la contraseña
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Ingrese su contraseña",
                        labelText: "Contraseña",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    SizedBox(height: 30),
                    // Botón de inicio de sesión
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color.fromARGB(255, 133, 238, 159),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text('Iniciar sesión'),
                    ),
                    SizedBox(height: 10),
                    // Botón para autenticación biométrica
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleBiometricAuth,
                      icon: Icon(
                        Icons.fingerprint,
                        size: 30, // Tamaño adecuado del ícono
                        color: Colors.white,
                      ),
                      label: Text('Autenticación Biométrica'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color.fromARGB(255, 133, 238, 159),
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Navegar a la página de registro
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        '¿No tienes una cuenta? Regístrate aquí',
                        style: TextStyle(color: Color.fromARGB(255, 133, 238, 159)),
                      ),
                    ),
                    // Navegar a la página de recuperación de contraseña
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Color.fromARGB(255, 133, 238, 159)),
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
