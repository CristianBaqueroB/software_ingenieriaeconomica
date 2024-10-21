
import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/LogicaRecargardinero.dart';

class RecargaScreen extends StatefulWidget {
  @override
  _RecargaScreenState createState() => _RecargaScreenState();
}

class _RecargaScreenState extends State<RecargaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final RecargaService _recargaService = RecargaService();
  String? _cedulaUsuarioLogueado;
  double _totalRecargasHoy = 0.0;
  final double _limiteRecargas = 9907183.0;
  bool _isProcessing = false; // Para manejar el estado de procesamiento

  @override
  void initState() {
    super.initState();
    _obtenerCedulaUsuarioLogueado();
    _obtenerTotalRecargasHoy();
  }

  Future<void> _obtenerCedulaUsuarioLogueado() async {
    try {
      _cedulaUsuarioLogueado = await _recargaService.obtenerCedulaUsuarioLogueado();
    } catch (e) {
      _showNotification('Error al obtener la cédula del usuario logueado: $e');
    }
  }

  Future<void> _obtenerTotalRecargasHoy() async {
    try {
      _totalRecargasHoy = await _recargaService.obtenerTotalRecargasHoy();
    } catch (e) {
      _showNotification('Error al obtener el total de recargas de hoy: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recargar Dinero'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(35.0),
        child: Card(
          elevation: 20.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextField(
                      label: 'Número de Cédula',
                      controller: _cedulaController,
                      hint: 'Ejemplo: 123456789',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa tu cédula para continuar.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: '¿Cuánto desea recargar?',
                      controller: _montoController,
                      hint: 'Monto máximo: 9,000,000',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa un monto válido.';
                        }
                        double? monto = double.tryParse(value);
                        if (monto == null || monto <= 0 || monto > _limiteRecargas) {
                          return 'El monto debe ser mayor a 0 y no puede superar \$9,907,182.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Mensualmente puedes enviar, sacar y pagar un máximo de \$9.907.182 pesos...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isProcessing ? null : _confirmarRecarga, // Deshabilitar si está procesando
                      child: _isProcessing ? CircularProgressIndicator(color: Colors.white) : Text('Confirmar Recarga'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
          ),
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }

  void _confirmarRecarga() async {
    if (_formKey.currentState!.validate()) {
      String cedulaIngresada = _cedulaController.text;
      double monto = double.parse(_montoController.text);

      if (_cedulaUsuarioLogueado == null) {
        _showNotification('No hemos podido obtener tu cédula. Intenta de nuevo más tarde.');
        return;
      }

      if (cedulaIngresada != _cedulaUsuarioLogueado) {
        _showNotification('La cédula ingresada no coincide con tu cuenta.');
        return;
      }

      // Verifica que no exceda el límite total de recargas hoy
      if (_totalRecargasHoy + monto > _limiteRecargas) {
        _showNotification('El total de recargas hoy no puede exceder \$9,907.182.');
        return;
      }

      setState(() {
        _isProcessing = true; // Cambiar estado a procesando
      });

      // Realiza la recarga directamente
      await _realizarRecarga(cedulaIngresada, monto);
      
      setState(() {
        _isProcessing = false; // Regresar a estado normal
      });
    }
  }

  Future<void> _realizarRecarga(String cedula, double monto) async {
    try {
      // Guarda la recarga en Firestore
      await _recargaService.realizarRecarga(cedula, monto);

      _showNotification('¡Éxito! Tu recarga se ha realizado.');
    } catch (e) {
      _showNotification('Error al realizar la recarga: $e');
    }
  }

  void _showNotification(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green[700],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
