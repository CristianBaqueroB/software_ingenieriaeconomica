import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:software_ingenieriaeconomica/Users/prestamouser/home/History/historial_controller.dart';

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
              // Se puede implementar un método para refrescar la vista.
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

                  // Determina el color de la tarjeta según el estado del préstamo
                  Color cardColor = _getCardColor(loan.estado);

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
                            _buildLoanDetailRow('Tipo de Préstamo:', loan.tipoprestamo),
                            _buildLoanDetailRow('Monto del Préstamo:', '\$${formatNumber(loan.monto)}'),
                            _buildLoanDetailRow('Interés:', '\$${formatNumber(loan.interes)}'),
                            _buildLoanDetailRow('Total a Pagar:', '\$${formatNumber(loan.totalPago)}'),
                            _buildLoanDetailRow('Fecha de Solicitud:', formattedSolicitud),
                            _buildLoanDetailRow('Fecha Límite:', formattedLimite),
                            _buildLoanDetailRow('Estado:', loan.estado),
                            SizedBox(height: 10),
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

  // Método para obtener el color de la tarjeta según el estado
  Color _getCardColor(String estado) {
    switch (estado.toLowerCase()) {
      case "pendiente":
        return Colors.amber[100]!;
      case "aceptado":
        return Colors.green[100]!;
      case "rechazado":
        return Colors.red[100]!;
      default:
        return Colors.white;
    }
  }

  // Método para construir filas de detalle del préstamo
  Widget _buildLoanDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
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
