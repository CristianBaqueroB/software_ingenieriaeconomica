import 'package:flutter/material.dart';
import 'dart:math';

class CompoundAmountCalculatorPage extends StatefulWidget {
  const CompoundAmountCalculatorPage({super.key});

  @override
  _CompoundAmountCalculatorPageState createState() =>
      _CompoundAmountCalculatorPageState();
}

class _CompoundAmountCalculatorPageState
    extends State<CompoundAmountCalculatorPage> {
  final _initialCapitalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _numberOfPeriodsController = TextEditingController();
  double? _compoundAmount;

  void _calculateCompoundAmount() {
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final interestRate = double.tryParse(_interestRateController.text);
    final numberOfPeriods = double.tryParse(_numberOfPeriodsController.text);

    if (initialCapital != null &&
        interestRate != null &&
        numberOfPeriods != null) {
      final rate = interestRate / 100; // Convertir la tasa a decimal

      // Calcular el Monto Compuesto usando la fórmula MC = C * (1 + i)^n
      final compoundAmount =
          initialCapital * pow(1 + rate, numberOfPeriods);

      setState(() {
        _compoundAmount = compoundAmount;
      });
    } else {
      setState(() {
        _compoundAmount = null;
      });
    }
  }

  void _clearFields() {
    _initialCapitalController.clear();
    _interestRateController.clear();
    _numberOfPeriodsController.clear();
    setState(() {
      _compoundAmount = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calcular Monto Compuesto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _initialCapitalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Capital Inicial (C)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _interestRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tasa de Interés (%)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _numberOfPeriodsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de Períodos (n)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _calculateCompoundAmount,
                  child: Text("Calcular"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                SizedBox(width: 80), // Espacio entre los botones
                ElevatedButton(
                  onPressed: _clearFields,
                  child: Text("Limpiar"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
            if (_compoundAmount != null) ...[
              SizedBox(height: 10),
              Text(
                "Monto Compuesto (MC): ${_compoundAmount!.toStringAsFixed(2)}",
                style: TextStyle(
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
