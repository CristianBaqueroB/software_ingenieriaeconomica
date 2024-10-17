import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/pagar_cuotacontroller.dart';

class PagarCuotaPrestamo extends StatefulWidget {
  final Pagcuota prestamo;

  PagarCuotaPrestamo({Key? key, required this.prestamo}) : super(key: key);

  @override
  _PagarCuotaPrestamoState createState() => _PagarCuotaPrestamoState();
}

class _PagarCuotaPrestamoState extends State<PagarCuotaPrestamo> {
  List<Pagcuota> _prestamos = [];
  Pagcuota? _prestamoSeleccionado;
  double _cuotasSeleccionadas = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarPrestamosAceptados();
  }

  Future<void> _cargarPrestamosAceptados() async {
    List<Pagcuota> prestamosAceptados = await obtenerPrestamosAceptados();
    setState(() {
      _prestamos = prestamosAceptados;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar Cuota del Préstamo'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Dropdown para seleccionar el préstamo
                      DropdownButtonFormField<Pagcuota>(
                        decoration: InputDecoration(
                          labelText: 'Selecciona un Préstamo',
                          border: OutlineInputBorder(),
                        ),
                        value: _prestamoSeleccionado,
                        onChanged: (Pagcuota? nuevoPrestamo) {
                          setState(() {
                            _prestamoSeleccionado = nuevoPrestamo;
                            _cuotasSeleccionadas = 1; // Reiniciar el slider al cambiar de préstamo
                          });
                        },
                        items: _prestamos.map((prestamo) {
                          return DropdownMenuItem<Pagcuota>(
                            value: prestamo,
                            child: Text(
                              'Cédula: ${prestamo.cedula} ',
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),

                      if (_prestamoSeleccionado != null) ...[
                        SizedBox(height: 20),

                        // Texto que muestra el monto total a pagar
                        Text(
                          '- Total a Pagar: \$${formatNumber(_prestamoSeleccionado!.totalPago)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),

                        // Texto que indica la selección de cuotas
                        Text(
                          'Selecciona cuántas cuotas deseas pagar:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),

                        // Slider para seleccionar la cantidad de cuotas a pagar
                        Slider(
                          value: _cuotasSeleccionadas,
                          min: 1,
                          max: _prestamoSeleccionado!.numCuotas.toDouble(),
                          divisions: _prestamoSeleccionado!.numCuotas,
                          label: '${_cuotasSeleccionadas.toInt()}',
                          onChanged: (double value) {
                            setState(() {
                              _cuotasSeleccionadas = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),

                        // Texto que muestra el monto total a pagar según las cuotas seleccionadas
                        Text(
                          'Monto total a pagar por ${_cuotasSeleccionadas.toInt()} cuota(s): '
                          '\$${formatNumber(_cuotasSeleccionadas * _prestamoSeleccionado!.montoPorCuota)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),

                        // Botón para confirmar el pago
                        ElevatedButton.icon(
                          onPressed: _confirmarPagoCuotas,
                          icon: Icon(Icons.payment),
                          label: Text('Confirmar Pago'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _confirmarPagoCuotas() {
    if (_prestamoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, selecciona un préstamo.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    int cuotasSeleccionadas = _cuotasSeleccionadas.toInt();
    double totalPagar = cuotasSeleccionadas * _prestamoSeleccionado!.montoPorCuota;

    // Diálogo de confirmación antes de procesar el pago
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Pago'),
          content: Text(
              '¿Estás seguro de realizar el pago de $cuotasSeleccionadas cuota(s) por un total de \$${formatNumber(totalPagar)}?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                _procesarPago(cuotasSeleccionadas, totalPagar);
              },
            ),
          ],
        );
      },
    );
  }

  void _procesarPago(int cuotasSeleccionadas, double totalPagar) {
    double nuevoTotalPago = _prestamoSeleccionado!.totalPago - totalPagar;
    int nuevasCuotas = _prestamoSeleccionado!.numCuotas - cuotasSeleccionadas;
    String nuevoEstado = (nuevoTotalPago <= 0) ? 'Pagado' : _prestamoSeleccionado!.estado;

    try {
      FirebaseFirestore.instance
          .collection('solicitudes_prestamo')
          .doc(_prestamoSeleccionado!.id)
          .update({
        'total_pago': nuevoTotalPago,
        'num_cuotas': nuevasCuotas,
        'estado': nuevoEstado,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Pago de $cuotasSeleccionadas cuota(s) realizado con éxito. Nueva deuda: \$${formatNumber(nuevoTotalPago)}'),
        ));

        _cargarPrestamosAceptados();
        setState(() {
          _prestamoSeleccionado = null;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al realizar el pago. Intente de nuevo.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<List<Pagcuota>> obtenerPrestamosAceptados() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('solicitudes_prestamo')
        .where('estado', isEqualTo: 'aceptado')
        .get();

    return snapshot.docs.map((doc) {
      return Pagcuota(
        id: doc.id,
        cedula: doc['cedula'] ?? 'Sin cédula',
        estado: doc['estado'],
        fechaLimite: (doc['fecha_limite'] as Timestamp).toDate(),
        fechaSolicitud: (doc['fecha_solicitud'] as Timestamp).toDate(),
        interes: doc['interes'],
        tasa: (doc['tasa']),
        tipoTasa: doc['tipo_tasa'] ?? 'Desconocido',
        tipoprestamo: doc['tipo_prestamo'] ?? 'Desconocido',
        monto: doc['monto'],
        montoPorCuota: doc['monto_por_cuota'],
        numCuotas: doc['num_cuotas'],
        totalPago: doc['total_pago'],
      );
    }).toList();
  }

  String formatNumber(double number) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'es_CO');
    return formatter.format(number);
  }
}
