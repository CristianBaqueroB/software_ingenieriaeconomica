import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AmericanLoanController {
  final TextEditingController loanAmountController;
  final TextEditingController annualRateController;
  final TextEditingController yearsController;
  final TextEditingController monthsController;
  final TextEditingController daysController;
  final TextEditingController idController;

  double totalMonths = 0; // Tiempo total en meses
  double fixedInterestPayment = 0.0; // Pago fijo de intereses
  double finalPayment = 0.0; // Pago final que incluye el capital
  double totalInterestPaid = 0.0; // Total de intereses pagados
  List<Map<String, dynamic>> interestPayments = [];

  AmericanLoanController({
    required this.loanAmountController,
    required this.annualRateController,
    required this.yearsController,
    required this.monthsController,
    required this.daysController,
    required this.idController,
  });

  // Función para convertir el tiempo a meses
  void convertTimeToMonths() {
    int years = int.tryParse(yearsController.text) ?? 0;
    int months = int.tryParse(monthsController.text) ?? 0;
    int days = int.tryParse(daysController.text) ?? 0;

    // Asegurarse de que al menos uno de los campos esté lleno
    if (years > 0 || months > 0 || days > 0) {
      // Convertir años a meses y días a meses
      totalMonths = years  + (months/12) + (days / 365); // Suponemos 30 días por mes
    } else {
      throw Exception('Debes llenar al menos uno de los campos de tiempo.');
    }
  }

  // Función para obtener la tasa de interés
  double getInterestRate() {
    double rate = double.tryParse(annualRateController.text) ?? 0.0;
    return rate / 100; // Mantener tasa anual
  }

  // Función para calcular la amortización americana
  Future<void> calculateAmortization() async {
    double loanAmount = double.tryParse(loanAmountController.text) ?? 0.0;
    double annualRate = getInterestRate();

    // Convertir tiempo a meses
    convertTimeToMonths();

    if (totalMonths > 0 && loanAmount > 0 && annualRate > 0) {
      // Limpiar resultados anteriores
      interestPayments.clear();
      totalInterestPaid = 0.0; // Reiniciar el total de intereses

      // Calcular los pagos periódicos de intereses
      fixedInterestPayment = loanAmount * annualRate; // Intereses mensuales

      // Calcular el pago final del capital
      finalPayment = loanAmount;

      // Generar pagos individuales de intereses por cada mes
      for (int month = 1; month <= totalMonths; month++) {
        interestPayments.add({
          'month': month,
          'interest': fixedInterestPayment,
          'isFinal': month == totalMonths,
        });

        // Sumar al total de intereses pagados
        totalInterestPaid += fixedInterestPayment;
      }

      // Guardar la solicitud en Firestore
      await saveLoanRequest(loanAmount);
    } else {
      throw Exception('Datos inválidos para el cálculo de amortización.');
    }
  }

  // Función para guardar la solicitud en Firestore
  Future<void> saveLoanRequest(double loanAmount) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user == null) {
      // Manejar el caso en el que el usuario no está autenticado
      throw Exception('Usuario no autenticado');
    }

    // Obtener la cédula del usuario logueado desde Firestore
    String uid = user.uid;
    String cedula = idController.text; // Obtén la cédula desde el controlador

    // Obtener la cédula del usuario logueado
    String userCedula = await getCedulaFromFirestore(uid);
    if (userCedula != cedula) {
      throw Exception('La cédula no coincide con la del usuario logueado.');
    }

    // Calcular la fecha límite
    DateTime dueDate = DateTime.now().add(Duration(days: (totalMonths * 30).round())); // Asumimos 30 días por mes

    // Guardar la solicitud en Firestore
    await FirebaseFirestore.instance.collection('solicitudes_prestamo').add({
      'cedula': cedula,
      'estado': 'pendiente',
      'fecha_solicitud': Timestamp.now(),
      'interes': totalInterestPaid,
      'monto': loanAmount,
      'num_cuotas': totalMonths,
      'tasa': double.tryParse(annualRateController.text) ?? 0.0,
      'tipo_prestamo': 'Amortización Americana',
      'monto_por_cuota': fixedInterestPayment, // Guardamos el pago periódico de intereses
      'total_pago': totalInterestPaid + finalPayment,
      'fecha_limite': Timestamp.fromDate(dueDate), // Guardamos la fecha límite
      'tipo_tasa': 'Anual',
    });

    // Guardar la tabla de amortización en Firestore
    await FirebaseFirestore.instance.collection('prestamos').add({
      'cedula': cedula,
      'tipo_prestamo': 'Amortización Americana',
      'tabla_amortizacion': interestPayments,
    });
  }

  // Función para obtener la cédula del usuario desde Firestore
  Future<String> getCedulaFromFirestore(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc['cedula'] ?? ''; // Devuelve la cédula del usuario, o vacío si no existe
  }
}
