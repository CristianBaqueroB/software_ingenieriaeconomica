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
  Pagcuota? _prestamoSeleccionado; // Préstamo seleccionado
  List<bool> _selectedCuotas = []; // Lista para mantener el estado de selección de cuotas

  @override
  void initState() {
    super.initState();
    _cargarPrestamosAceptados();
  }

  Future<void> _cargarPrestamosAceptados() async {
    List<Pagcuota> prestamosAceptados = await obtenerPrestamosAceptados();
    setState(() {
      _prestamos = prestamosAceptados;
      // Resetea la lista de cuotas al cargar los préstamos
      _prestamoSeleccionado = null;
      _selectedCuotas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagar Cuota del Préstamo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10.0), // Ajusta el margen
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Selector de Préstamo
                DropdownButton<Pagcuota>(
                  hint: Text('Selecciona un Préstamo'),
                  value: _prestamoSeleccionado,
                  onChanged: (Pagcuota? nuevoPrestamo) {
                    setState(() {
                      _prestamoSeleccionado = nuevoPrestamo;
                      _selectedCuotas = List<bool>.generate(
                          nuevoPrestamo != null ? nuevoPrestamo.numCuotas : 0,
                          (index) => false);
                    });
                  },
                  items: _prestamos.map((prestamo) {
                    return DropdownMenuItem<Pagcuota>(
                      value: prestamo,
                      child: Text(
                        'Cédula: ${prestamo.cedula}, Total a Pagar: \$${formatNumber(prestamo.totalPago)}',
                        style: TextStyle(fontSize: 11), // Ajusta el tamaño del texto
                      ),
                    );
                  }).toList(),
                ),

                // Mostrar cuotas si se selecciona un préstamo
                if (_prestamoSeleccionado != null) ...[
                  SizedBox(height: 16), // Espacio entre el Dropdown y las cuotas
                  ListView.builder(
                    shrinkWrap: true, // Importante para evitar overflow
                    physics: NeverScrollableScrollPhysics(), // Deshabilitar el scroll de ListView
                    itemCount: _prestamoSeleccionado!.numCuotas,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          'Cuota ${index + 1} - Monto: \$${formatNumber(_prestamoSeleccionado!.montoPorCuota)}',
                        ),
                        value: _selectedCuotas[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedCuotas[index] = value!;
                          });
                        },
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: _confirmarPagoCuotas,
                    child: Text('Confirmar Pago'),
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
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
      return;
    }

    List<int> cuotasSeleccionadas = [];
    for (int i = 0; i < _selectedCuotas.length; i++) {
      if (_selectedCuotas[i]) {
        cuotasSeleccionadas.add(i + 1);
      }
    }

    if (cuotasSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Seleccione al menos una cuota para pagar.'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
      return;
    }

    double nuevoTotalPago = _prestamoSeleccionado!.totalPago;
    int nuevasCuotas = _prestamoSeleccionado!.numCuotas;

    // ignore: unused_local_variable
    for (var index in cuotasSeleccionadas) {
      nuevoTotalPago -= _prestamoSeleccionado!.montoPorCuota;
      nuevasCuotas--;
    }

    String nuevoEstado = (nuevoTotalPago <= 0) ? 'Pagado' : _prestamoSeleccionado!.estado;

    // Actualizar en Firestore
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
              content: Text('Pago de cuotas realizado con éxito. Nueva deuda: \$${formatNumber(nuevoTotalPago)}'),
              duration: Duration(seconds: 3),
            ));

            _cargarPrestamosAceptados(); // Refrescar la lista de préstamos después del pago
            setState(() {
              _prestamoSeleccionado = null; // Limpiar la selección después del pago
            });
          });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al realizar el pago. Intente de nuevo.'),
        duration: Duration(seconds: 3),
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
