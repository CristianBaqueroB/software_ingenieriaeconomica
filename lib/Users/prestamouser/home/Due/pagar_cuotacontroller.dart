import 'package:cloud_firestore/cloud_firestore.dart';

class PagcuotaSimple {
  final String id;
  final String cedula;
  final String estado;
  final DateTime fechaLimite;
  final DateTime fechaSolicitud;
  final double interes;
  final double monto;
  final double montoPorCuota;
  final int numCuotas;
  final double tasa;
  final String tipoTasa;
  final double totalPago;
  final String tipoprestamo;

  // Nueva propiedad que indica si el pago está atrasado
  bool get atrasado => DateTime.now().isAfter(fechaLimite);

  PagcuotaSimple({
    required this.id,
    required this.cedula,
    required this.estado,
    required this.fechaLimite,
    required this.fechaSolicitud,
    required this.interes,
    required this.monto,
    required this.montoPorCuota,
    required this.numCuotas,
    required this.tasa,
    required this.tipoTasa,
    required this.totalPago,
    required this.tipoprestamo,
  });

  factory PagcuotaSimple.fromDocument(Map<String, dynamic> data, String id) {
    return PagcuotaSimple(
      id: id,
      estado: data['estado'] ?? 'Sin estado',
      fechaSolicitud: (data['fecha_solicitud']?.toDate() ?? DateTime.now()),
      fechaLimite: (data['fecha_limite']?.toDate() ?? DateTime.now()),
      interes: _toDouble(data['interes']),
      monto: _toDouble(data['monto']),
      totalPago: _toDouble(data['total_pago']),
      cedula: data['cedula'] ?? 'Sin cédula',
      montoPorCuota: _toDouble(data['monto_por_cuota']),
      numCuotas: data['num_cuotas'] ?? 0,
      tasa: _toDouble(data['tasa']),
      tipoTasa: data['tipo_tasa'] ?? 'Desconocido',
      tipoprestamo: data['tipo_prestamo'] ?? 'Desconocido',
    );
  }

  // Método para convertir PagcuotaSimple a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cedula': cedula,
      'estado': estado,
      'fecha_limite': fechaLimite,
      'fecha_solicitud': fechaSolicitud,
      'interes': interes,
      'monto': monto,
      'monto_por_cuota': montoPorCuota,
      'num_cuotas': numCuotas,
      'tasa': tasa,
      'tipo_tasa': tipoTasa,
      'total_pago': totalPago,
      'tipo_prestamo': tipoprestamo,
    };
  }

  static Future<List<PagcuotaSimple>> cargarDocumentos() async {
    List<PagcuotaSimple> prestamos = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('solicitudes_prestamo').get();
      for (var doc in snapshot.docs) {
        prestamos.add(PagcuotaSimple.fromDocument(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      // Manejar errores si la carga falla
      print('Error al cargar documentos: $e');
    }

    return prestamos;
  }

  // Método para obtener el saldo y préstamo del usuario
  static Future<Map<String, double>> obtenerSaldoYPrestamo(String cedula) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(cedula).get();
      if (snapshot.exists) {
         final data = snapshot.data() as Map<String, dynamic>; 
         double saldo = _toDouble(data['saldo']);
         double prestamo = _toDouble(data['prestamo']);
        return {'saldo': saldo, 'prestamo': prestamo};
      }
    } catch (e) {
      print('Error al obtener saldo y préstamo: $e');
    }
    return {'saldo': 0.0, 'prestamo': 0.0}; // Valores por defecto en caso de error
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
