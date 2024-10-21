import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/home/Due/pagar_cuotacontroller.dart';

class PagarCuotaPrestamo extends StatefulWidget {
  @override
  _PagarCuotaPrestamoState createState() => _PagarCuotaPrestamoState();
}

class _PagarCuotaPrestamoState extends State<PagarCuotaPrestamo> {
  List<PagcuotaSimple> _prestamos = [];
  PagcuotaSimple? _prestamoSeleccionado;
  double _montoAPagar = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarPrestamosAceptados();
  }
Future<void> _cargarPrestamosAceptados() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Obtén la cédula del usuario logueado desde Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Suponiendo que estás usando el UID de Firebase como ID de documento
          .get();

      String cedula = userDoc['cedula'] ?? ''; // Obtén la cédula

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('solicitudes_prestamo')
          .where('estado', isEqualTo: 'aceptado')
          .where('cedula', isEqualTo: cedula) // Filtrar por cédula del usuario logueado
          .get();

      setState(() {
        _prestamos = snapshot.docs.map((doc) {
          return PagcuotaSimple(
            id: doc.id,
            cedula: doc['cedula'] ?? 'Sin cédula',
            estado: doc['estado'],
            fechaLimite: (doc['fecha_limite'] as Timestamp).toDate(),
            fechaSolicitud: (doc['fecha_solicitud'] as Timestamp).toDate(),
            interes: doc['interes'],
            tasa: doc['tasa'],
            tipoTasa: doc['tipo_tasa'] ?? 'Desconocido',
            tipoprestamo: doc['tipo_prestamo'] ?? 'Desconocido',
            monto: doc['monto'],
            montoPorCuota: doc['monto_por_cuota'],
            totalPago: doc['total_pago'],
            numCuotas: doc['num_cuotas'],
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al cargar los préstamos: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagar Cuota del Préstamo')),
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
                      DropdownButtonFormField<PagcuotaSimple>(
                        decoration: InputDecoration(
                          labelText: 'Selecciona un Préstamo',
                          border: OutlineInputBorder(),
                        ),
                        value: _prestamoSeleccionado,
                        onChanged: (PagcuotaSimple? nuevoPrestamo) {
                          setState(() {
                            _prestamoSeleccionado = nuevoPrestamo;
                            _montoAPagar = nuevoPrestamo?.totalPago ?? 0;
                          });
                        },
                        items: _prestamos.map((prestamo) {
                          return DropdownMenuItem<PagcuotaSimple>(
                            value: prestamo,
                            child: Text('Cédula: ${prestamo.cedula}'),
                          );
                        }).toList(),
                      ),

                      if (_prestamoSeleccionado != null) ...[
                        SizedBox(height: 20),
                        Text(
                          'Total a Pagar: \$${formatNumber(_prestamoSeleccionado!.totalPago)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Selecciona qué deseas pagar:',
                          style: TextStyle(fontSize: 16),
                        ),
                        ListTile(
                          title: Text('Pagar Saldo Pendiente'),
                          leading: Radio<double>(
                            value: _prestamoSeleccionado!.totalPago,
                            groupValue: _montoAPagar,
                            onChanged: (value) => setState(() => _montoAPagar = value!),
                          ),
                        ),
                        ListTile(
                          title: Text('Pagar Monto por Cuota'),
                          leading: Radio<double>(
                            value: _prestamoSeleccionado!.montoPorCuota,
                            groupValue: _montoAPagar,
                            onChanged: (value) => setState(() => _montoAPagar = value!),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Monto total a pagar: \$${formatNumber(_montoAPagar)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _confirmarPago,
                          icon: Icon(Icons.payment),
                          label: Text('Confirmar Pago'),
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Pago'),
          content: Text('¿Estás seguro de realizar el pago de \$${formatNumber(_montoAPagar)}?'),
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
          content: Text('Pago de \$${formatNumber(_montoAPagar)} realizado con éxito. Nueva deuda: \$${formatNumber(nuevoTotalPago)}'),
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

  String formatNumber(double number) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'es_CO');
    return formatter.format(number);
  }
}
