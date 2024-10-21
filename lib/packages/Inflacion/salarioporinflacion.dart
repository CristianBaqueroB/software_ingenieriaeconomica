import 'dart:math'; // Importar dart:math para usar pow
import 'package:flutter/material.dart';

class SalaryAdjustmentPage extends StatefulWidget {
  const SalaryAdjustmentPage({super.key});

  @override
  SalaryAdjustmentPageState createState() => SalaryAdjustmentPageState();
}

class SalaryAdjustmentPageState extends State<SalaryAdjustmentPage> {
  final _currentSalaryController = TextEditingController();
  final _inflationRateController = TextEditingController();
  final _yearsController = TextEditingController();
  double? _adjustedSalary;

  // Calcular el salario ajustado por inflación
  double _calculateAdjustedSalary(double currentSalary, double inflationRate, int years) {
    return currentSalary * pow(1 + inflationRate / 100, years);
  }

  void _calculateSalaryAdjustmentData() {
    final currentSalary = double.tryParse(_currentSalaryController.text);
    final inflationRate = double.tryParse(_inflationRateController.text);
    final years = int.tryParse(_yearsController.text);

    if (currentSalary != null && inflationRate != null && years != null) {
      // Calcular el salario ajustado
      final adjustedSalary = _calculateAdjustedSalary(currentSalary, inflationRate, years);
      setState(() {
        _adjustedSalary = adjustedSalary;
      });
    } else {
      setState(() {
        _adjustedSalary = null; // Reiniciar en caso de error
      });
    }
  }

  void _clearFields() {
    _currentSalaryController.clear();
    _inflationRateController.clear();
    _yearsController.clear();
    setState(() {
      _adjustedSalary = null; // Reiniciar en caso de limpiar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajuste Salarial por Inflación"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _currentSalaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Salario Actual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _inflationRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tasa de Inflación (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _yearsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de Años',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateSalaryAdjustmentData,
                  child: const Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_adjustedSalary != null) ...[
              const SizedBox(height: 20),
              Text(
                "Salario Ajustado: \$${_adjustedSalary!.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
