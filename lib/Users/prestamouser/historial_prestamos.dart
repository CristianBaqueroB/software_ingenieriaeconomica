import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/controller/historial_controller.dart';

class HistorialSolicitudesPrestamos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mis Solicitudes de Préstamos'),
        ),
        body: Center(child: Text('Por favor, inicie sesión para ver sus solicitudes.')),
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
                .orderBy('fecha_solicitud', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No hay solicitudes de préstamos disponibles.'));
              }

              final loans = snapshot.data!.docs.map((doc) {
                return Prestamo.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
              }).toList();

              return ListView.builder(
                itemCount: loans.length,
                itemBuilder: (context, index) {
                  final loan = loans[index];

                  Color cardColor;
                  switch (loan.estado.toLowerCase()) {
                    case "pendiente":
                      cardColor = Colors.amber[100]!;
                      break;
                    case "aceptado":
                      cardColor = Colors.green[100]!;
                      break;
                    case "rechazado":
                      cardColor = Colors.red[100]!;
                      break;
                    default:
                      cardColor = Colors.white;
                  }

                  final DateFormat formatter = DateFormat('dd/MM/yyyy');
                  String formattedSolicitud = formatter.format(loan.fechaSolicitud);
                  String formattedLimite = formatter.format(loan.fechaLimite);

                  return GestureDetector(
                    onTap: () {
                      // Lógica para navegar a una pantalla de detalles del préstamo
                      // Navigator.push(...);
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
                      elevation: 4,
                      color: cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tipo de Préstamo:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(loan.tipoprestamo),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Monto del Préstamo:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('\$${formatNumber(loan.monto)}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Interés:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('\$${formatNumber(loan.interes)}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total a Pagar:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('\$${formatNumber(loan.totalPago)}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Fecha de Solicitud:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(formattedSolicitud),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Fecha Límite:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(formattedLimite),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Estado:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(loan.estado),
                              ],
                            ),
                            SizedBox(height: 10), // Espacio entre información y mensaje de estado
                            Text(
                              loan.atrasado ? 'El pago está atrasado.' : 'El pago está al día.',
                              style: TextStyle(
                                color: loan.atrasado ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  String formatNumber(double number) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'es_CO');
    return formatter.format(number);
  }

  Future<String> obtenerCedulaUsuarioLogueado() async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(usuario.uid)
          .get();

      return usuarioDoc['cedula'] ?? 'Sin cédula';
    }

    return 'Sin cédula';
  }
}


