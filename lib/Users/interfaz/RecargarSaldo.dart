import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/LogicaRecargardinero.dart';

class RecargaScreen extends StatefulWidget {
  @override
  _RecargaScreenState createState() => _RecargaScreenState();
}

class _RecargaScreenState extends State<RecargaScreen> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final RecargaService _recargaService = RecargaService();
  String? _cedulaUsuarioLogueado;
  double _totalRecargasHoy = 0.0;

  @override
  void initState() {
    super.initState();
    _obtenerCedulaUsuarioLogueado();
    _obtenerTotalRecargasHoy();
  }

  Future<void> _obtenerCedulaUsuarioLogueado() async {
    _cedulaUsuarioLogueado = await _recargaService.obtenerCedulaUsuarioLogueado();
  }

  Future<void> _obtenerTotalRecargasHoy() async {
    _totalRecargasHoy = await _recargaService.obtenerTotalRecargasHoy();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Número de Cédula',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _cedulaController,
                    decoration: InputDecoration(
                      hintText: 'Ejemplo: 123456789',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¿Cuánto desea recargar?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _montoController,
                    decoration: InputDecoration(
                      hintText: 'Monto máximo: 9,000,000',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Mensualmente puedes enviar, sacar y pagar un máximo de \$9.907.182 pesos. Si llegas al límite, no podrás hacer más movimientos de salida, los cuales solo se habilitarán de nuevo en el mes siguiente.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _confirmarRecarga,
                    child: Text('Confirmar Recarga'),
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
    );
  }

  void _confirmarRecarga() {
    String cedulaIngresada = _cedulaController.text;
    double? monto = double.tryParse(_montoController.text);

    if (_cedulaUsuarioLogueado == null) {
      _showNotification('No hemos podido obtener tu cédula. Intenta de nuevo más tarde.');
      return;
    }

    if (cedulaIngresada.isEmpty) {
      _showNotification('Por favor, ingresa tu cédula para continuar.');
      return;
    }

    if (cedulaIngresada != _cedulaUsuarioLogueado) {
      _showNotification('La cédula ingresada no coincide con tu cuenta. Verifica e intenta de nuevo.');
      return;
    }

    if (monto == null || monto <= 0 || monto > 9907183) {
      _showNotification('El monto debe ser mayor a 0 y no puede superar los 9,907.182 ¡Verifica e intenta de nuevo!');
      return;
    }

    if (_totalRecargasHoy + monto > 9907183) {
      _showNotification('El total de recargas hoy no puede exceder 9,907.182 Ajusta el monto.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de Recarga'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Concepto: Recarga TuBank'),
              Text('Cédula: $cedulaIngresada'),
              Text('Monto: \$${monto.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _realizarRecarga(cedulaIngresada, monto);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _realizarRecarga(String cedula, double monto) async {
    try {
      await _recargaService.realizarRecarga(cedula, monto);
      _showNotification('¡Éxito! Tu recarga se ha realizado con éxito. Tu saldo se actualizará pronto.');
    } catch (e) {
      _showNotification('Oops, ocurrió un error: $e. Por favor, inténtalo de nuevo más tarde.');
    }
  }

  void _showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
