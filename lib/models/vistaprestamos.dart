import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GestionPrestamosPage extends StatefulWidget {
  @override
  _GestionPrestamosPageState createState() => _GestionPrestamosPageState();
}

class _GestionPrestamosPageState extends State<GestionPrestamosPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _filtroEstado = 'todos'; // Estado por defecto

  Future<String> _getUserCedula(String usuarioId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(usuarioId).get();
      return userDoc['cedula'] ?? 'Sin cédula';
    } catch (e) {
      print('Error al obtener la cédula del usuario: $e');
      return 'Error';
    }
  }

  Future<void> _updateLoanStatus(String loanId, String newStatus) async {
    try {
      await _firestore.collection('loans').doc(loanId).update({'estado': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado actualizado a: $newStatus')),
      );
    } catch (e) {
      print('Error al actualizar el estado del préstamo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el estado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Préstamos'),
        backgroundColor: Color.fromARGB(255, 133, 238, 159),
      ),
      body: Column(
        children: [
          // Filtro de estado
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _filtroEstado,
              items: [
                DropdownMenuItem(value: 'todos', child: Text('Todos')),
                DropdownMenuItem(value: 'aceptado', child: Text('Aceptados')),
                DropdownMenuItem(value: 'rechazado', child: Text('Rechazados')),
              ],
              onChanged: (value) {
                setState(() {
                  _filtroEstado = value!;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('loans')
                  .where('estado', isEqualTo: _filtroEstado == 'todos' ? null : _filtroEstado)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar las solicitudes.'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final loanRequests = snapshot.data!.docs;

                if (loanRequests.isEmpty) {
                  return Center(child: Text('No hay solicitudes para mostrar.'));
                }

                return ListView.builder(
                  itemCount: loanRequests.length,
                  itemBuilder: (context, index) {
                    final request = loanRequests[index];

                    // Extraer solo los campos necesarios
                    final estado = request['estado'] ?? 'Sin estado';
                    final fechaSolicitud = request['fechaSolicitud']?.toDate() ?? DateTime.now();
                    final interes = request['interes']?.toDouble() ?? 0.0;
                    final montoPrestamo = request['montoPrestamo']?.toDouble() ?? 0.0;
                    final totalAPagar = request['totalAPagar']?.toDouble() ?? 0.0;
                    final usuarioId = request['usuarioId'] ?? 'Sin ID de usuario';
                    final loanId = request.id; // Obtener el ID del préstamo

                    // Usar FutureBuilder para obtener la cédula del usuario
                    return FutureBuilder<String>(
                      future: _getUserCedula(usuarioId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Cargando información del usuario...'),
                          );
                        }

                        final cedula = userSnapshot.data ?? 'Sin cédula';

                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text('Estado: $estado'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cédula: $cedula'),
                                Text('Fecha de Solicitud: ${fechaSolicitud.toLocal()}'),
                                Text('Interés: \$${interes.toStringAsFixed(2)}'),
                                Text('Monto del Préstamo: \$${montoPrestamo.toStringAsFixed(2)}'),
                                Text('Total a Pagar: \$${totalAPagar.toStringAsFixed(2)}'),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check, color: Colors.green),
                                  onPressed: () {
                                    _updateLoanStatus(loanId, 'aceptado'); // Aceptar préstamo
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    _updateLoanStatus(loanId, 'rechazado'); // Rechazar préstamo
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
