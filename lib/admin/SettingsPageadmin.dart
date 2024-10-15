import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/admin/SettingsPagecontrolleradmin.dart'; 

class SettingsPageAdmin extends StatefulWidget {
  const SettingsPageAdmin({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPageAdmin> {
  final SettingsControllerAdmin _controller = SettingsControllerAdmin();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar datos del usuario al iniciar
  }

  Future<void> _loadUserData() async {
    await _controller.fetchUserData(context); // Esperar la carga de datos
    setState(() {}); // Notificar a la UI que se han actualizado los datos
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
                      'Nombre: ${_controller.nombreController.text.isNotEmpty ? _controller.nombreController.text : 'No definido'}',
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Apellido: ${_controller.apellidoController.text.isNotEmpty ? _controller.apellidoController.text : 'No definido'}',
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Correo: ${_controller.correoController.text.isNotEmpty ? _controller.correoController.text : 'No definido'}',
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Cédula: ${_controller.cedula ?? 'No definido'}', // Muestra la cédula
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rol: ${_controller.rol ?? 'No definido'}', // Muestra el rol
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
                  ],
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
