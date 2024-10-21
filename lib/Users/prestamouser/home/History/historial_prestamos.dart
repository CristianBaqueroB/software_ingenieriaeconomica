import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistorialSolicitudesPrestamos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mis Solicitudes de Préstamos'),
        ),
        body: Center(
          child: Text('Por favor, inicie sesión para ver sus solicitudes.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Solicitudes de Préstamos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Lógica para refrescar el historial, si es necesario
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: obtenerCedulaUsuarioLogueado(),
        builder: (context, snapshotCedula) {
          if (snapshotCedula.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshotCedula.hasError || !snapshotCedula.hasData) {
            return Center(child: Text('Error al obtener la cédula del usuario.'));
          }

          final cedulaUsuario = snapshotCedula.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('solicitudes_prestamo')
                .where('cedula', isEqualTo: cedulaUsuario)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error al cargar las solicitudes.'));
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No hay solicitudes de préstamos.'));
              }

              final solicitudes = snapshot.data!.docs;

              return ListView.builder(
                itemCount: solicitudes.length,
                itemBuilder: (context, index) {
                  final solicitud = solicitudes[index];
                  final fechaSolicitud = (solicitud['fecha_solicitud'] as Timestamp).toDate();
                  final fechaLimite = (solicitud['fecha_limite'] as Timestamp).toDate();
                  final estado = solicitud['estado'] ?? 'Sin estado';
                  final monto = solicitud['monto'] ?? 0.0;
                  final interes = solicitud['interes'] ?? 0.0;
                  final tipoPrestamo = solicitud['tipo_prestamo'] ?? 'Desconocido';
                  final totalPago = solicitud['total_pago'] ?? 0.0;

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Cédula: $cedulaUsuario'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tipo de Préstamo: $tipoPrestamo'),
                          Text('Estado: $estado'),
                          Text('Monto: \$${NumberFormat('#,##0.00').format(monto)}'),
                          Text('Interés: \$${NumberFormat('#,##0.00').format(interes)}'),
                          Text('Fecha Solicitud: ${DateFormat('dd/MM/yyyy').format(fechaSolicitud)}'),
                          Text('Fecha Límite: ${DateFormat('dd/MM/yyyy').format(fechaLimite)}'),
                          Text('Total a Pagar: \$${NumberFormat('#,##0.00').format(totalPago)}'),
                        ],
                      ),
                      onTap: () {
                        // Lógica para ver más detalles de la solicitud si es necesario
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<String> obtenerCedulaUsuarioLogueado() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuario no autenticado.');
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return userDoc['cedula'] ?? '';
  }
}
