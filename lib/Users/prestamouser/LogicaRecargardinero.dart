import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecargaService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const double montoMinimoRecarga = 10000.0; // Monto mínimo a recargar

  /// Obtiene la cédula del usuario actualmente logueado.
  Future<String?> obtenerCedulaUsuarioLogueado() async {
    User? usuario = _auth.currentUser;
    if (usuario != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(usuario.uid).get();
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;      
      return data?['cedula'];
    }
    return null;
  }

  /// Obtiene el total de recargas realizadas hoy para el usuario logueado.
  Future<double> obtenerTotalRecargasHoy() async {
    User? usuario = _auth.currentUser;
    if (usuario != null) {
      DateTime hoy = DateTime.now();
      String fechaHoy = '${hoy.year}-${hoy.month}-${hoy.day}';

      DocumentSnapshot recargasDoc = await _firestore.collection('recargas').doc(fechaHoy).get();
      if (recargasDoc.exists) {
        Map<String, dynamic>? data = recargasDoc.data() as Map<String, dynamic>?;        
        return data?['totalRecargas']?.toDouble() ?? 0.0;
      }
    }
    return 0.0;
  }

  /// Obtiene el total de recargas realizadas en el mes actual.
  Future<double> obtenerTotalRecargasDelMes() async {
    User? usuario = _auth.currentUser;
    if (usuario != null) {
      DateTime ahora = DateTime.now();
      String mesActual = '${ahora.year}-${ahora.month}';

      QuerySnapshot recargasMes = await _firestore.collection('recargas_diarias')
          .where('fecha', isGreaterThanOrEqualTo: mesActual)
          .get();

      double totalRecargas = 0.0;
      for (var doc in recargasMes.docs) {
        totalRecargas += (doc.data() as Map<String, dynamic>)['monto']?.toDouble() ?? 0.0;
      }
      return totalRecargas;
    }
    return 0.0;
  }

  /// Realiza una recarga de dinero para el usuario logueado.
  Future<void> realizarRecarga(String cedula, double monto) async {
    if (monto < montoMinimoRecarga) {
      throw Exception('El monto mínimo de recarga es \$${montoMinimoRecarga.toStringAsFixed(2)}.');
    }

    final userDocRef = _firestore.collection('users').doc(_auth.currentUser?.uid);
    DocumentSnapshot userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      throw Exception('Usuario no encontrado.');
    }

    Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

    // Obtiene el saldo actual y calcula el nuevo saldo
    double saldoActual = (data?['saldo'] is int) ? (data?['saldo'] as int).toDouble() : (data?['saldo'] as double);
    double nuevoSaldo = saldoActual + monto;

    if (nuevoSaldo >= 9907182) {
      throw Exception('El saldo total no puede exceder 9,907.182');
    }

    // Verifica si la recarga excederá el límite mensual
    double totalRecargasMes = await obtenerTotalRecargasDelMes();
    if (totalRecargasMes + monto > 9907182) {
      throw Exception('Has alcanzado el límite de recargas mensuales de 9,907,182. No podrás hacer más recargas este mes.');
    }

    // Actualiza el saldo del usuario en Firestore
    await userDocRef.update({'saldo': nuevoSaldo});

    // Obtiene la fecha y hora actuales
    DateTime ahora = DateTime.now();
    String fechaHoy = '${ahora.year}-${ahora.month}-${ahora.day}';
    String horaActual = '${ahora.hour}:${ahora.minute.toString().padLeft(2, '0')}';

    // Guarda la recarga diaria en la colección 'recargas_diarias'
    DocumentReference recargasDocRef = _firestore.collection('recargas_diarias').doc();

    await recargasDocRef.set({
      'fecha': fechaHoy,
      'hora': horaActual,
      'cedula': cedula,
      'monto': monto,
    });

    // Actualiza el total de recargas del día
    DocumentReference totalRecargasDocRef = _firestore.collection('recargas').doc(fechaHoy);

    await totalRecargasDocRef.set({
      'totalRecargas': FieldValue.increment(monto),
    }, SetOptions(merge: true));
  }
}
