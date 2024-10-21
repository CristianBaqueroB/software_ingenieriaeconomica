import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RetiroScreen extends StatefulWidget {
  @override
  _RetiroScreenState createState() => _RetiroScreenState();
}

class _RetiroScreenState extends State<RetiroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _montoController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double _saldoNormal = 0.0;
  double _saldoPrestamo = 0.0;
  String? _cedulaUsuarioLogueado;
  String _saldoSeleccionado = 'Normal';

  @override
  void initState() {
    super.initState();
    _obtenerDatosUsuarioLogueado();
  }

  Future<void> _obtenerDatosUsuarioLogueado() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _cedulaUsuarioLogueado = userDoc.get('cedula');
          _saldoNormal = userDoc.get('saldo') ?? 0.0;
          _saldoPrestamo = userDoc.get('prestamo') ?? 0.0;
        });
      }
    }
  }

  Future<void> _verifyCedula(String cedula) async {
    if (cedula != _cedulaUsuarioLogueado) {
      throw Exception('La cédula no coincide con la del usuario autenticado.');
    }
  }

  String _enmascararCedula(String cedula) {
    if (cedula.length > 4) {
      return cedula.substring(0, cedula.length - 3) + '***';
    }
    return cedula;
  }

  Future<void> _guardarDetalleRetiro(double monto) async {
    if (_cedulaUsuarioLogueado != null) {
      String codigoDetalleRetiro = DateTime.now().millisecondsSinceEpoch.toString();
      String fechaRetiro = DateTime.now().toString();

      await FirebaseFirestore.instance.collection('Detalleretiro').add({
        'cedula': _enmascararCedula(_cedulaUsuarioLogueado!),
        'codigo': codigoDetalleRetiro,
        'fecha': fechaRetiro,
        'monto': monto,
        'tipoSaldo': _saldoSeleccionado,
      });

      _mostrarDetalleRetiro(codigoDetalleRetiro, monto, fechaRetiro);
    }
  }

  void _mostrarDetalleRetiro(String codigo, double monto, String fecha) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalle del Retiro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Código: $codigo'),
              Text('Monto: \$${monto.toStringAsFixed(2)}'),
              Text('Fecha: $fecha'),
              Text('Tipo de Saldo: $_saldoSeleccionado'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _retirarDinero() async {
    if (!_formKey.currentState!.validate()) return;

    final cedulaIngresada = _cedulaController.text.trim();
    final double monto = double.parse(_montoController.text);

    try {
      await _verifyCedula(cedulaIngresada);
    } catch (e) {
      _showNotification(e.toString());
      return;
    }

    double saldoActual = _saldoSeleccionado == 'Normal' ? _saldoNormal : _saldoPrestamo;
    if (monto < 10000 || monto > saldoActual) {
      _showNotification(monto < 10000 ? 'El monto mínimo es \$10,000.' : 'Saldo insuficiente.');
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).update({
      _saldoSeleccionado == 'Normal' ? 'saldo' : 'prestamo': saldoActual - monto,
    });

    _showNotification('Retiro exitoso: \$${monto.toStringAsFixed(2)}');
    _montoController.clear();
    //_cedulaController.clear();

    // Guardar el detalle del retiro
    await _guardarDetalleRetiro(monto);

    _obtenerDatosUsuarioLogueado();
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[700],
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Retirar Dinero'), backgroundColor: Colors.green),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSaldoCard(),
            DropdownButton<String>(
              value: _saldoSeleccionado,
              onChanged: (newValue) => setState(() => _saldoSeleccionado = newValue!),
              items: ['Normal', 'Prestamo'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
            ),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaldoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          Text('Saldos Actuales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Saldo Normal: \$${_saldoNormal.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
          Text('Saldo de Préstamo: \$${_saldoPrestamo.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_cedulaController, 'Número de Cédula', TextInputType.number),
              SizedBox(height: 10),
              _buildTextField(_montoController, 'Monto a Retirar', TextInputType.number),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _retirarDinero,
                child: Text('Retirar Dinero'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Por favor, ingresa $label.';
        if (label == 'Monto a Retirar' && double.tryParse(value) == null) return 'Ingresa un monto válido.';
        return null;
      },
    );
  }
}


