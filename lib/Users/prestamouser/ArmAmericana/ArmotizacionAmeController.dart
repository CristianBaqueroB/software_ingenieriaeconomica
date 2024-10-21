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

    if (years > 0 || months > 0 || days > 0) {
      totalMonths = years  + months/12 + (days / 30); // Convertimos todo a meses
    } else {
      throw Exception('Debes llenar al menos uno de los campos de tiempo.');
    }
  }

  // Función para obtener la tasa de interés anual
  double getInterestRate() {
    return (double.tryParse(annualRateController.text) ?? 0.0) / 100;
  }

  // Función para calcular la amortización americana
  Future<void> calculateAmortization() async {
    double loanAmount = double.tryParse(loanAmountController.text) ?? 0.0;
    double annualRate = getInterestRate();
    convertTimeToMonths();

    if (totalMonths > 0 && loanAmount > 0 && annualRate > 0) {
      // Inicializar cálculos
      _initializeCalculations(loanAmount, annualRate);
      // Guardar la solicitud en Firestore
      await saveLoanRequest(loanAmount);
    } else {
      throw Exception('Datos inválidos para el cálculo de amortización.');
    }
  }

  // Inicializa cálculos y genera la tabla de amortización
  void _initializeCalculations(double loanAmount, double annualRate) {
    interestPayments.clear();
    totalInterestPaid = 0.0;

    fixedInterestPayment = loanAmount * annualRate; // Pago mensual de intereses
    finalPayment = loanAmount; // Pago final del capital

    for (int month = 1; month <= totalMonths; month++) {
      interestPayments.add({
        'month': month,
        'interest': fixedInterestPayment,
        'isFinal': month == totalMonths,
      });
      totalInterestPaid += fixedInterestPayment;
    }
  }

  // Función para guardar la solicitud en Firestore
  Future<void> saveLoanRequest(double loanAmount) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw Exception('Usuario no autenticado');

    String cedula = idController.text;
    String userCedula = await getCedulaFromFirestore(user.uid);

    if (userCedula != cedula) {
      throw Exception('La cédula no coincide con la del usuario logueado.');
    }

    DateTime dueDate = DateTime.now().add(Duration(days: (totalMonths * 30).round()));

    await FirebaseFirestore.instance.collection('solicitudes_prestamo').add({
      'cedula': cedula,
      'estado': 'pendiente', // Puedes ajustar este estado según tu lógica
      'fecha_solicitud': Timestamp.now(),
      'fecha_limite': Timestamp.fromDate(dueDate),
      'monto': loanAmount,
      'num_cuotas': totalMonths.toInt(), // Convertido a int
      'tasa': double.tryParse(annualRateController.text) ?? 0.0,
      'tipo_prestamo': 'Amortización Americana',
      'tipo_tasa': 'Anual',
      'interes': totalInterestPaid,
      'monto_por_cuota': fixedInterestPayment,
      'total_pago': totalInterestPaid + finalPayment,
    });

    // Guarda la tabla de amortización en la colección 'prestamos'
    await FirebaseFirestore.instance.collection('prestamos').add({
      'cedula': cedula,
      'tipo_prestamo': 'Amortización Americana',
      'tabla_amortizacion': interestPayments,
    });
  }

  // Función para obtener la cédula del usuario desde Firestore
  Future<String> getCedulaFromFirestore(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc['cedula'] ?? '';
  }
}
