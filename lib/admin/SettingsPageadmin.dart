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
        title: Text('Configuración', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles de la Cuenta',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo('Nombre:', _controller.nombreController.text),
                    _buildUserInfo('Apellido:', _controller.apellidoController.text),
                    _buildUserInfo('Correo:', _controller.correoController.text),
                    _buildUserInfo('Cédula:', _controller.cedula ?? 'No definido'),
                    _buildUserInfo('Rol:', _controller.rol ?? 'No definido'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Acciones',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
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
                    fontWeight: FontWeight.bold,
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

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              value.isNotEmpty ? value : 'No definido',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
