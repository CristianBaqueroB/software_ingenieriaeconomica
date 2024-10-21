import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransferenciaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> transferirDinero(String cedulaReceptor, double monto, String contrasena, String tipoSaldo) async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return 'Usuario no autenticado.';
    }

    try {
      // Obtener el documento del usuario emisor
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

      // Asegúrate de que la cédula está en el documento
      String cedulaEmisor = userDoc['cedula'];

      double saldoActual = userDoc['saldo']?.toDouble() ?? 0.0;

      if (saldoActual < monto) {
        return 'Saldo insuficiente.';
      }

      // Obtener el documento del receptor
      QuerySnapshot receptorSnapshot = await _firestore.collection('users').where('cedula', isEqualTo: cedulaReceptor).get();

      if (receptorSnapshot.docs.isEmpty) {
        return 'Receptor no encontrado.';
      }

      DocumentSnapshot receptorDoc = receptorSnapshot.docs.first;

      // Actualizar el saldo del receptor
      double nuevoSaldoReceptor = receptorDoc['saldo']?.toDouble() ?? 0.0 + monto;

      await _firestore.collection('users').doc(receptorDoc.id).update({
        'saldo': nuevoSaldoReceptor,
      });

      // Deducir el monto del saldo del usuario actual
      await _firestore.collection('users').doc(currentUser.uid).update({
        'saldo': saldoActual - monto,
      });

      // Guardar el detalle de la transferencia
      await _firestore.collection('transferencias').add({
        'cedulaEmisor': cedulaEmisor, // Usar la cédula del emisor desde el documento
        'cedulaReceptor': cedulaReceptor,
        'monto': monto,
        'fecha': FieldValue.serverTimestamp(),
        'tipoSaldo': tipoSaldo,
      });

      return 'Transferencia exitosa a la cédula $cedulaReceptor';
    } catch (e) {
      return 'Error en la transferencia: $e';
    }
  }
}
