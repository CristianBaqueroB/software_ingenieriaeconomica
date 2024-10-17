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
    _loadUserData(); // Cargar datos del usuario al iniciar
  }

  Future<void> _loadUserData() async {
    await _controller.fetchUserData(context); // Esperar la carga de datos
    setState(() {}); // Notificar a la UI que se han actualizado los datos
  }

  Future<void> _showPasswordDialog() async {
    TextEditingController passwordController = TextEditingController();
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // No se puede cerrar al tocar fuera
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
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () async {
                // Verificar la contraseña
                bool isValid = await _controller.verifyPassword(passwordController.text);
                
                if (isValid) {
                  // Si la contraseña es correcta, navega a la página de edición
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        firstName: _controller.nombreController.text,
                        lastName: _controller.apellidoController.text,
                        email: _controller.correoController.text,
                      ),
                    ),
                  );

                  // Si la actualización fue exitosa, recargar los datos
                  if (result == true) {
                    _loadUserData(); // Actualizar datos de usuario
                  }
                  Navigator.of(context).pop(); // Cerrar el diálogo
                } else {
                  // Mostrar un mensaje de error
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${_controller.nombreController.text}',
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Apellido: ${_controller.apellidoController.text}',
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Correo: ${_controller.correoController.text}',
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Cédula: ${_controller.cedula}', // Muestra la cédula
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPasswordDialog, // Cambiar aquí
              child: Text('Editar Perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const Spacer(),
            Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: ElevatedButton(
                onPressed: () => _controller.signOut(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                  ),
                ),
                child: Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
