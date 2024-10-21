import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/login_controller.dart';
import 'package:software_ingenieriaeconomica/Users/interfaz/home_page.dart';
import 'package:software_ingenieriaeconomica/screens/reset_password_page.dart';
import 'package:software_ingenieriaeconomica/screens/register_page.dart';
import 'package:software_ingenieriaeconomica/admin/homepageadmin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _controller = LoginController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _loadCachedData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cachedCedula = prefs.getString('cedula');

  print('Cédula en caché: $cachedCedula');

  if (cachedCedula != null) {
    _cedulaController.text = cachedCedula;
  }
}

  void _handleLogin() async {
  String cedula = _cedulaController.text.trim();
  String password = _passwordController.text;

  if (cedula.isEmpty || password.isEmpty) {
    _showSnackBar('Por favor, complete todos los campos.');
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    String? rol = await _controller.login(cedula, password);
    await _handleLoginSuccess(cedula, rol);

    // Verifica si los datos se guardan correctamente
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Cédula guardada: ${prefs.getString('cedula')}');
    print('Contraseña guardada: ${prefs.getString('password')}');
  } catch (e) {
    _showSnackBar(e.toString());
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

Future<void> _handleLoginSuccess(String cedula, String? rol) async {
  if (rol != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cedula', cedula);
    await prefs.setString('password', _passwordController.text);

    print('Cédula y contraseña guardadas en caché.');

    if (rol == 'admin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    } else if (rol == 'usuario') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      _showSnackBar('Rol desconocido: $rol');
    }
  }
}


  Future<void> _authenticateWithBiometrics() async {
    String cedula = _cedulaController.text.trim();

    // Verifica si la cédula está llena
    if (cedula.isEmpty) {
      _showSnackBar('Por favor, ingrese su cédula antes de autenticar con biometría.');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        _showSnackBar('Biometría no disponible.');
        return;
      }

      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Por favor, autentíquese para continuar',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        // Llama al método de inicio de sesión solo con cédula
        String? rol = await _controller.authenticateWithBiometrics();

        await _handleLoginSuccess(cedula, rol);
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
                  color: Colors.white,
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
                    // Campo de la cédula
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
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
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
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible, // Controlar la visibilidad de la contraseña
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
                    // Botón de autenticación biométrica
                    ElevatedButton(
                      onPressed: _isLoading ? null : _authenticateWithBiometrics,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color.fromARGB(255, 133, 238, 159),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('Iniciar sesión con biometría'),
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