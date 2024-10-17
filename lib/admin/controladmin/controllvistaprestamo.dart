import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/modelvistasprestamos.dart';

class LoanController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene una lista de solicitudes de préstamo, filtradas por estado.
  Future<List<Loan>> fetchLoanRequests(String filter) async {
    QuerySnapshot querySnapshot;

    // Query con filtro
    if (filter == 'todos') {
      querySnapshot = await _firestore.collection('solicitudes_prestamo').get();
    } else {
      querySnapshot = await _firestore.collection('solicitudes_prestamo').where('estado', isEqualTo: filter).get();
    }

    // Mapeo de documentos a objetos Loan
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Loan(
        id: doc.id,
        cedula: data['cedula'] ?? 'Sin cédula',
        estado: data['estado'] ?? 'Desconocido',
        fechaLimite: data['fecha_limite']?.toDate() ?? DateTime.now(),
        fechaSolicitud: data['fecha_solicitud']?.toDate() ?? DateTime.now(),
        interes: _getDouble(data['interes']),
        monto: _getDouble(data['monto']),
        montoPorCuota: _getDouble(data['monto_por_cuota']),
        numCuotas: data['num_cuotas'] ?? 0,
        tasa: _getDouble(data['tasa']),
        tipoTasa: data['tipo_tasa'] ?? 'Desconocido',
        totalPago: _getDouble(data['total_pago']),
         tipoprestamo: data['tipo_prestamo'] ?? 'Desconocido',
      );
    }).toList();
  }

  /// Convierte un valor dinámico a un double, manejando posibles errores.
  double _getDouble(Object? value) {
    if (value == null) return 0.0; // Manejo de nulos
    if (value is double) return value;
    if (value is String) {
      try {
        return double.parse(value); // Conversión
      } catch (e) {
        print('Error al convertir a double: $value'); // Manejo de errores
      }
    }
    return 0.0; // Valor por defecto
  }

  /// Obtiene una solicitud de préstamo por ID.
  Future<Loan> fetchLoanRequestById(String loanId) async {
    try {
      DocumentSnapshot loanDoc = await _firestore.collection('solicitudes_prestamo').doc(loanId).get();
      if (loanDoc.exists) {
        Map<String, dynamic> data = loanDoc.data() as Map<String, dynamic>;
        return Loan(
          id: loanDoc.id,
          cedula: data['cedula'] ?? 'Sin cédula',
          estado: data['estado'] ?? 'Desconocido',
          fechaLimite: data['fecha_limite']?.toDate() ?? DateTime.now(),
          fechaSolicitud: data['fecha_solicitud']?.toDate() ?? DateTime.now(),
          interes: _getDouble(data['interes']),
          monto: _getDouble(data['monto']),
          montoPorCuota: _getDouble(data['monto_por_cuota']),
          numCuotas: data['num_cuotas'] ?? 0,
          tasa: _getDouble(data['tasa']),
          tipoTasa: data['tipo_tasa'] ?? 'Desconocido',
          totalPago: _getDouble(data['total_pago']),
           tipoprestamo: data['tipo_prestamo'] ?? 'Desconocido',
        );
      } else {
        throw Exception('Solicitud no encontrada'); // Excepción específica
      }
    } catch (e) {
      print('Error al obtener la solicitud de préstamo: $e');
      throw e; // Lanza el error para manejo posterior
    }
  }

Future<void> updateLoanRequestStatus(String loanId, String newStatus) async {
  try {
    print('Intentando actualizar el estado a: $newStatus'); // Agrega esta línea
    if (isValidStatus(newStatus)) {
      await _firestore.collection('solicitudes_prestamo').doc(loanId).update({'estado': newStatus});
    } else {
      throw Exception('Estado no válido');
    }
  } catch (e) {
    print('Error al actualizar el estado de la solicitud: $e');
    throw e;
  }
}



  /// Elimina una solicitud de préstamo.
  Future<void> deleteLoanRequest(String loanId) async {
    try {
      await _firestore.collection('solicitudes_prestamo').doc(loanId).delete();
    } catch (e) {
      print('Error al eliminar la solicitud de préstamo: $e');
      throw e;
    }
  }

  /// Obtiene la cédula de un usuario por su ID.
  Future<String> getUserCedula(String usuarioId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(usuarioId).get();
      return userDoc['cedula'] ?? 'Sin cédula';
    } catch (e) {
      print('Error al obtener la cédula del usuario: $e');
      return 'Error';
    }
  }

/// Verifica si un estado es válido.
bool isValidStatus(String status) {
  const validStatuses = ['aceptado', 'rechazado', 'pendiente']; // Asegúrate de que 'aprobado' esté aquí
  return validStatuses.contains(status.toLowerCase()); // Usar toLowerCase para evitar problemas de mayúsculas
}

}
