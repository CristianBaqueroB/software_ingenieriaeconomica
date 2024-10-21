import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/home/Due/pagar_cuotacontroller.dart';

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
  double _montoAPagar = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarPrestamosAceptados();
  }

  Future<void> _cargarPrestamosAceptados() async {
    try {
      List<Pagcuota> prestamosAceptados = await obtenerPrestamosAceptados();
      setState(() {
        _prestamos = prestamosAceptados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al cargar los préstamos aceptados: $e'),
        backgroundColor: Colors.red,
      ));
    }
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
                            _montoAPagar = nuevoPrestamo?.totalPago ?? 0;
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

                        // Opciones de pago
                        Text(
                          'Selecciona qué deseas pagar:',
                          style: TextStyle(fontSize: 16),
                        ),
                        ListTile(
                          title: Text('Pagar Saldo Pendiente'),
                          leading: Radio<double>(
                            value: _prestamoSeleccionado!.totalPago,
                            groupValue: _montoAPagar,
                            onChanged: (double? value) {
                              setState(() {
                                _montoAPagar = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text('Pagar Monto por Cuota'),
                          leading: Radio<double>(
                            value: _prestamoSeleccionado!.montoPorCuota,
                            groupValue: _montoAPagar,
                            onChanged: (double? value) {
                              setState(() {
                                _montoAPagar = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // Mostrar el monto a pagar
                        Text(
                          'Monto total a pagar: \$${formatNumber(_montoAPagar)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),

                        // Botón para confirmar el pago
                        ElevatedButton.icon(
                          onPressed: _confirmarPago,
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

  void _confirmarPago() {
    if (_prestamoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, selecciona un préstamo.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Diálogo de confirmación antes de procesar el pago
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Pago'),
          content: Text(
              '¿Estás seguro de realizar el pago de \$${formatNumber(_montoAPagar)}?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                _procesarPago();
              },
            ),
          ],
        );
      },
    );
  }

  void _procesarPago() {
    double nuevoTotalPago = _prestamoSeleccionado!.totalPago - _montoAPagar;
    String nuevoEstado = (nuevoTotalPago <= 0) ? 'Pagado' : _prestamoSeleccionado!.estado;

    try {
      FirebaseFirestore.instance
          .collection('solicitudes_prestamo')
          .doc(_prestamoSeleccionado!.id)
          .update({
        'total_pago': nuevoTotalPago,
        'estado': nuevoEstado,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Pago de \$${formatNumber(_montoAPagar)} realizado con éxito. Nueva deuda: \$${formatNumber(nuevoTotalPago)}'),
        ));

        _cargarPrestamosAceptados();
        setState(() {
          _prestamoSeleccionado = null;
          _montoAPagar = 0;
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
    try {
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
          totalPago: doc['total_pago'],
          numCuotas: doc['num_cuotas']
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener préstamos aceptados: $e');
    }
  }

  String formatNumber(double number) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'es_CO');
    return formatter.format(number);
  }
}
