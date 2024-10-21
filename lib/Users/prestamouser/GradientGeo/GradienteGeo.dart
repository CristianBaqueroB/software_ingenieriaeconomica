import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math'; // Importar la biblioteca para usar pow

class GeometricGradientLoanController {
  final TextEditingController loanAmountController;
  final TextEditingController annualRateController;
  final TextEditingController gradientController; // Incremento del pago
  final TextEditingController yearsController;
  final TextEditingController monthsController;
  final TextEditingController daysController;
  final TextEditingController idController;

  String _selectedInterestRateType = 'Mensual'; // Tipo de tasa de interés seleccionada
  double _selectedInterestRate = 5.0; // Tasa de interés seleccionada

  double totalMonths = 0; // Tiempo total en meses
  List<Map<String, dynamic>> payments = [];
  double finalPayment = 0.0; // Pago final que incluye el capital

  GeometricGradientLoanController({
    required this.loanAmountController,
    required this.annualRateController,
    required this.gradientController,
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
      totalMonths = years * 12 + months + (days / 30); // Suponemos 30 días por mes
    } else {
      throw Exception('Debes llenar al menos uno de los campos de tiempo.');
    }
  }

  // Función para establecer la tasa de interés
  void setInterestRate(double rate) {
    _selectedInterestRate = rate; // Mantener tasa anual en porcentaje
  }

  // Función para establecer el tipo de tasa de interés
  void setInterestRateType(String type) {
    _selectedInterestRateType = type;
  }

  // Función para calcular la amortización en gradiente geométrico
  Future<void> calculateAmortization() async {
    double loanAmount = double.tryParse(loanAmountController.text) ?? 0.0;
    double gradient = double.tryParse(gradientController.text) ?? 0.0;

    // Convertir tiempo a meses
    convertTimeToMonths();

    // Convertir la tasa de interés según el tipo seleccionado
    double interestRate;
    switch (_selectedInterestRateType) {
      case 'Mensual':
        interestRate = _selectedInterestRate / 100; // Tasa mensual
        break;
      case 'Bimestral':
        interestRate = _selectedInterestRate / 100 / 6; // Convertir a bimestral
        break;
      case 'Trimestral':
        interestRate = _selectedInterestRate / 100 / 4; // Convertir a trimestral
        break;
      case 'Semestral':
        interestRate = _selectedInterestRate / 100 / 2; // Convertir a semestral
        break;
      case 'Anual':
      default:
        interestRate = _selectedInterestRate / 100 / 12; // Convertir a anual
        break;
    }

    if (totalMonths > 0 && loanAmount > 0 && interestRate > 0 && gradient >= 0) {
      // Limpiar resultados anteriores
      payments.clear();

      // Calcular el primer pago
      double firstPayment = (loanAmount * interestRate) / (1 - pow((1 + interestRate), -totalMonths));

      // Generar los pagos considerando el incremento
      for (int month = 1; month <= totalMonths; month++) {
        double payment = firstPayment * pow((1 + gradient / 100), month - 1); // Aplicar el gradiente
        payments.add({
          'month': month,
          'payment': payment,
        });
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
    String cedula = idController.text;

    // Guardar la solicitud en Firestore
    await FirebaseFirestore.instance.collection('solicitudes_prestamo').add({
      'cedula': cedula,
      'estado': 'pendiente',
      'fecha_solicitud': Timestamp.now(),
      'monto': loanAmount,
      'num_cuotas': totalMonths,
      'tasa': _selectedInterestRate, // Guardar como porcentaje
      'tipo_prestamo': 'Gradiente Geométrico',
    });

    // Guardar la tabla de amortización en Firestore
    await FirebaseFirestore.instance.collection('prestamos').add({
      'cedula': cedula,
      'tipo_prestamo': 'Gradiente Geométrico',
      'tabla_amortizacion': payments,
    });
  }
}
