// ignore_for_file: use_rethrow_when_possible

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/modelvistasprestamos.dart';

class LoanController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene una lista de solicitudes de préstamo, filtradas por estado.
  Future<List<Loan>> fetchLoanRequests(String filter) async {
    QuerySnapshot querySnapshot;

    // Consulta con filtro
    if (filter == 'todos') {
      querySnapshot = await _firestore.collection('solicitudes_prestamo').get();
    } else {
      querySnapshot = await _firestore.collection('solicitudes_prestamo').where('estado', isEqualTo: filter).get();
    }

    // Mapeo de documentos a objetos Loan
    return querySnapshot.docs.map((doc) {
      return Loan.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  /// Confirma la aceptación de una solicitud de préstamo.
  Future<void> confirmAcceptLoan(BuildContext context, String loanId, Function reloadLoans) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar aceptación'),
          content: Text('¿Estás seguro de que deseas aceptar este préstamo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      try {
        await updateLoanRequestStatus(loanId, 'aceptado');
        reloadLoans(); // Recargar préstamos
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estado actualizado a: aceptado')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al aceptar el préstamo: $e')),
        );
      }
    }
  }
  

  /// Confirma el rechazo de una solicitud de préstamo.
  Future<void> confirmRejectLoan(BuildContext context, String loanId, Function reloadLoans) async {
    TextEditingController reasonController = TextEditingController();

    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar rechazo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Estás seguro de que deseas rechazar este préstamo?'),
              SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'Razón del rechazo (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Rechazar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );

    if (confirm) {
      String reason = reasonController.text.trim();
      try {
        await rejectLoanRequest(loanId, reason: reason);
        reloadLoans(); // Recargar préstamos
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Solicitud de préstamo rechazada')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al rechazar el préstamo: $e')),
        );
      }
    }
  }
/// Actualiza el estado de una solicitud de préstamo.
Future<void> updateLoanRequestStatus(String loanId, String newStatus) async {
  try {
    // Verifica si el nuevo estado es válido
    if (isValidStatus(newStatus)) {
      // Actualiza el estado en la colección 'solicitudes_prestamo'
      await _firestore.collection('solicitudes_prestamo').doc(loanId).update({'estado': newStatus});
      
      // Si el préstamo es aceptado, actualiza el saldo del préstamo del usuario
      if (newStatus.toLowerCase() == 'aceptado') {
  // Obtén la solicitud de préstamo por ID
  Loan loan = await fetchLoanRequestById(loanId);
  
  // Verifica que se haya encontrado el préstamo
  // ignore: unnecessary_null_comparison
  if (loan != null) {
    // Actualiza el saldo del préstamo en la colección 'users' usando la cédula
    await _updateUserLoanBalance(loan.cedula, loan.monto); // Aquí `loan.monto` es el monto del préstamo
  } else {
    throw Exception('No se pudo encontrar el préstamo para actualizar el saldo.');
  }
}

    } else {
      throw Exception('Estado no válido');
    }
  } catch (e) {
    // Manejo de errores específico
    print('Error al actualizar el estado del préstamo: $e');
    throw e; // Lanza la excepción para manejarla en la parte superior
  }
}
Future<void> _updateUserLoanBalance(String cedula, double amount) async {
  try {
    // Realiza una consulta para obtener el documento del usuario por cédula
    QuerySnapshot userQuerySnapshot = await _firestore.collection('users').where('cedula', isEqualTo: cedula).get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      // Obtiene el primer documento que coincide
      DocumentSnapshot userDoc = userQuerySnapshot.docs.first;

      // Actualiza el saldo del préstamo
      await _firestore.collection('users').doc(userDoc.id).update({
        'prestamo': FieldValue.increment(amount), // Suma el nuevo monto al saldo existente
      });
    } else {
      throw Exception('Usuario no encontrado en la colección por cédula.');
    }
  } catch (e) {
    print('Error al actualizar el saldo del préstamo del usuario: $e');
    throw e; // Lanza la excepción para manejarla en la parte superior
  }
}

/// Elimina una solicitud de préstamo.
Future<void> deleteLoanRequest(String loanId) async {
  try {
    await _firestore.collection('solicitudes_prestamo').doc(loanId).delete();
  } catch (e) {
    throw Exception('Error al eliminar la solicitud de préstamo: $e');
  }
}




  /// Rechaza una solicitud de préstamo.
  Future<void> rejectLoanRequest(String loanId, {String? reason}) async {
    try {
      await _firestore.collection('solicitudes_prestamo').doc(loanId).update({
        'estado': 'rechazado', 
        'razon_rechazo': reason
      });
    } catch (e) {
      throw e;
    }
  }

  /// Verifica si el estado es válido.
  bool isValidStatus(String status) {
    return ['pendiente', 'aceptado', 'rechazado'].contains(status);
  }

  /// Obtiene una solicitud de préstamo por ID.
  Future<Loan> fetchLoanRequestById(String loanId) async {
   DocumentSnapshot doc = await _firestore.collection('solicitudes_prestamo').doc(loanId).get();
if (!doc.exists) {
    throw Exception('Solicitud de préstamo no encontrada.');
}
return Loan.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
  }

}
