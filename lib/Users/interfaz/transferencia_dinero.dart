import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/Transferenciaservivio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransferenciaDineroPage extends StatefulWidget {
  @override
  _TransferenciaDineroPageState createState() => _TransferenciaDineroPageState();
}

class _TransferenciaDineroPageState extends State<TransferenciaDineroPage> {
  final _formKey = GlobalKey<FormState>();
  final TransferenciaService _transferenciaService = TransferenciaService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String cedulaReceptor = '';
  double monto = 0.0;
  String tipoSaldo = 'Saldo Normal';
  String contrasena = '';
  String? nombreReceptor, apellidoReceptor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferir Dinero'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Cédula del receptor', (value) => cedulaReceptor = value),
              SizedBox(height: 20), // Espaciado adicional
              _buildTextField('Monto a transferir', (value) => monto = double.tryParse(value) ?? 0.0, keyboardType: TextInputType.number),
              SizedBox(height: 20), // Espaciado adicional
              _buildDropdown(),
              SizedBox(height: 20), // Espaciado adicional
              _buildTextField('Contraseña', (value) => contrasena = value, obscureText: true),
              SizedBox(height: 30), // Espaciado adicional
              Center(
                child: ElevatedButton(
                  onPressed: _onConfirmTransfer,
                  child: Text('Confirmar Transferencia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(String label, ValueChanged<String> onChanged, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingrese $label' : null,
    );
  }

  DropdownButtonFormField<String> _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: tipoSaldo,
      items: <String>['Saldo Normal', 'Saldo de Préstamo']
          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
          .toList(),
      onChanged: (value) => setState(() => tipoSaldo = value!),
      decoration: InputDecoration(labelText: 'Tipo de Saldo', border: OutlineInputBorder()),
    );
  }

  Future<void> _onConfirmTransfer() async {
    if (_formKey.currentState!.validate()) {
      await _obtenerDetallesReceptor();
      _showConfirmationDialog();
    }
  }

  Future<void> _obtenerDetallesReceptor() async {
    try {
      final receptorDoc = await _firestore.collection('users').where('cedula', isEqualTo: cedulaReceptor).get().then((snapshot) => snapshot.docs.first);
      nombreReceptor = receptorDoc['firstName'];
      apellidoReceptor = receptorDoc['lastName'];
    } catch (e) {
      _showErrorSnackbar('Error al obtener detalles del receptor: $e');
    }
  }

  void _showConfirmationDialog() {
    final fecha = DateTime.now().toLocal().toString().split(' ')[0];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmación de Transferencia'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Detalles de la Transferencia:'),
                Text('Nombre: ${_ocultarCaracteres(nombreReceptor ?? '')}'),
                Text('Apellido: ${_ocultarCaracteres(apellidoReceptor ?? '')}'),
                Text('Cédula: ${_ocultarCedula(cedulaReceptor)}'),
                Text('Monto: \$${monto.toStringAsFixed(2)}'),
                Text('Fecha: $fecha'),
                SizedBox(height: 10),
                Text('¿Son correctos estos datos?'),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
            TextButton(
              onPressed: () {
                _transferirDinero();
                Navigator.of(context).pop();
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _ocultarCaracteres(String texto) => texto.length <= 3 ? texto : '${texto.substring(0, 3)}${'*' * (texto.length - 3)}';
  
  String _ocultarCedula(String cedula) => cedula.length <= 2 ? cedula : '${'*' * (cedula.length - 2)}${cedula.substring(cedula.length - 2)}';

  Future<void> _transferirDinero() async {
    String mensaje = await _transferenciaService.transferirDinero(cedulaReceptor, monto, contrasena, tipoSaldo);
    _showErrorSnackbar(mensaje);
  }
}
