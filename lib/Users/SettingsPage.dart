import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/settingpage_contoller.dart';
import 'package:software_ingenieriaeconomica/services/EditProfilePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController _controller = SettingsController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await _controller.fetchUserData(context);
    setState(() {});
  }

  Future<void> _showPasswordDialog() async {
    TextEditingController passwordController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese su contraseña'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Contraseña'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () async {
                bool isValid = await _controller.verifyPassword(passwordController.text);

                if (isValid) {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        firstName: _controller.nombreController.text,
                        lastName: _controller.apellidoController.text,
                        email: _controller.correoController.text,
                      ),
                    ),
                  );

                  if (result == true) {
                    _loadUserData();
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contraseña incorrecta')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSignOutConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cerrar sesión'),
              onPressed: () {
                Navigator.of(context).pop();
                _controller.signOut(context);
              },
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
        title: Text('Configuración'),
        backgroundColor: const Color.fromARGB(255, 101, 216, 105),
      ),
      body: Center( // Centrar todo el contenido
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente los elementos
            children: [
              // Imagen o icono de perfil
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),

              // Información del usuario
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Nombre: ${_controller.nombreController.text}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Apellido: ${_controller.apellidoController.text}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Correo: ${_controller.correoController.text}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Cédula: ${_controller.cedula}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Botón Editar Perfil con icono
              ElevatedButton.icon(
                onPressed: _showPasswordDialog,
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text('Editar Perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 120, 199, 122),
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  textStyle: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                ),
              ),
              SizedBox(height: 20),

              // Botón Cerrar Sesión con icono
              ElevatedButton.icon(
                onPressed: _showSignOutConfirmation,
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  textStyle: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
