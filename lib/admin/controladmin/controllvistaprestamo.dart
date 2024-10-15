// lib/controllers/loan_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/modelvistasprestamos.dart';


class LoanController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Loan>> fetchLoans(String filter) async {
    QuerySnapshot querySnapshot;
    if (filter == 'todos') {
      querySnapshot = await _firestore.collection('loans').get();
    } else {
      querySnapshot = await _firestore.collection('loans').where('estado', isEqualTo: filter).get();
    }
    
    return querySnapshot.docs.map((doc) => Loan.fromDocument(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<String> getUserCedula(String usuarioId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(usuarioId).get();
      return userDoc['cedula'] ?? 'Sin cédula';
    } catch (e) {
      print('Error al obtener la cédula del usuario: $e');
      return 'Error';
    }
  }

  Future<void> updateLoanStatus(String loanId, String newStatus) async {
    try {
      await _firestore.collection('loans').doc(loanId).update({'estado': newStatus});
    } catch (e) {
      print('Error al actualizar el estado del préstamo: $e');
      throw e; // Lanzar el error para manejarlo en la vista
    }
  }

  Future<void> editLoanDetails(String loanId, double interes, double totalAPagar, double cantidadPagada) async {
    try {
      await _firestore.collection('loans').doc(loanId).update({
        'interes': interes,
        'totalAPagar': totalAPagar,
        'cantidadPagada': cantidadPagada,
      });
    } catch (e) {
      print('Error al actualizar detalles del préstamo: $e');
      throw e; // Lanzar el error para manejarlo en la vista
    }
  }
}
