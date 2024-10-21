import 'dart:math';

import 'package:flutter/material.dart';
import 'package:software_ingenieriaeconomica/admin/controladmin/controllerincopuesto.dart';

class PrestamoCompuestoPage extends StatefulWidget {
  const PrestamoCompuestoPage({Key? key}) : super(key: key);

  @override
  _PrestamoCompuestoPageState createState() => _PrestamoCompuestoPageState();
}

class _PrestamoCompuestoPageState extends State<PrestamoCompuestoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  double _interest = 0.0;
  double _futureValue = 0.0;
  double _cuotaValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitud de Préstamo Compuesto')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildTextField('Cédula', _cedulaController),
              _buildTextField('Monto del Préstamo', _montoController, isNumeric: true),
              _buildTextField('Tasa de Interés (en porcentaje)', _tasaController, isNumeric: true),
              _buildTextField('Años', _yearsController, isNumeric: true),
              _buildTextField('Meses', _monthsController, isNumeric: true),
              _buildTextField('Días', _daysController, isNumeric: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitLoanRequest,
                child: const Text('Solicitar Préstamo'),
              ),
              const SizedBox(height: 20),
              _buildResult('Interés a Pagar', _interest),
              _buildResult('Monto Total a Pagar', _futureValue),
              _buildResult('Monto por Cuota', _cuotaValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: isNumeric ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa $label.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildResult(String label, double value) {
    return Text('$label: ${value.toStringAsFixed(2)}');
  }

  Future<void> _submitLoanRequest() async {
    if (_formKey.currentState!.validate()) {
      double principal = double.parse(_montoController.text);
      double rate = double.parse(_tasaController.text) / 100; // Convertimos el porcentaje a decimal
      int years = int.parse(_yearsController.text);
      int months = int.parse(_monthsController.text);
      int days = int.parse(_daysController.text);

      // Convertimos todo el periodo a años (incluyendo meses y días)
      double totalYears = years + (months / 12) + (days / 365);

      // Capitalización mensual
      int n = 12;

      // Cálculo del valor futuro con la fórmula de interés compuesto
      double futureValue = principal * pow((1 + rate / n), n * totalYears);

      // Cálculo del interés total
      double interest = futureValue - principal;

      // Cálculo del valor por cuota (asumiendo pagos mensuales)
      double cuotaMensual = futureValue / (totalYears * 12);

      setState(() {
        _interest = interest;
        _futureValue = futureValue;
        _cuotaValue = cuotaMensual;
      });
    }
  }
}
